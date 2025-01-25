use anyhow::{anyhow, Result};
use flutter_rust_bridge::frb;

pub fn get_images_from_exe(executable_path: &str, image_path: &str) -> Result<()> {
    let images = wrapper::get_images_from_exe(executable_path)?;
    if let Some(image) = images.first() {
        image.save(image_path)?;
        Ok(())
    } else {
        Err(anyhow!("No images found in the executable"))
    }
}

#[frb(ignore)]
#[cfg(not(target_os = "windows"))]
mod wrapper {
    use anyhow::Result;
    use image::RgbaImage;

    pub fn get_images_from_exe(_executable_path: &str) -> Result<Vec<RgbaImage>> {
        Ok(Vec::new())
    }
}

#[frb(ignore)]
#[cfg(target_os = "windows")]
mod wrapper {
    // https://stackoverflow.com/questions/78190248/extract-icons-from-exe-in-rust
    use anyhow::{anyhow, Result};
    use image::{ImageBuffer, RgbaImage};
    use itertools::Itertools;
    use widestring::U16CString;
    use windows::{
        core::PCWSTR,
        Win32::{
            Graphics::Gdi::{
                CreateCompatibleDC, DeleteDC, DeleteObject, GetDIBits, SelectObject, BITMAPINFO,
                BITMAPINFOHEADER, DIB_RGB_COLORS,
            },
            UI::{
                Shell::ExtractIconExW,
                WindowsAndMessaging::{DestroyIcon, GetIconInfoExW, HICON, ICONINFOEXW},
            },
        },
    };

    pub fn get_images_from_exe(executable_path: &str) -> Result<Vec<RgbaImage>> {
        unsafe {
            let path_cstr = U16CString::from_str(executable_path)?;
            let path_pcwstr = PCWSTR(path_cstr.as_ptr());
            let num_icons_total = ExtractIconExW(path_pcwstr, -1, None, None, 0);
            if num_icons_total == 0 {
                return Ok(Vec::new()); // No icons extracted
            }

            let mut large_icons = vec![HICON::default(); num_icons_total as usize];
            let mut small_icons = vec![HICON::default(); num_icons_total as usize];
            let num_icons_fetched = ExtractIconExW(
                path_pcwstr,
                0,
                Some(large_icons.as_mut_ptr()),
                Some(small_icons.as_mut_ptr()),
                num_icons_total,
            );

            if num_icons_fetched == 0 {
                return Ok(Vec::new()); // No icons extracted
            }

            let images = large_icons
                .iter()
                .chain(small_icons.iter())
                .map(convert_hicon_to_rgba_image)
                .filter_map(|r| match r {
                    Ok(img) => Some(img),
                    Err(e) => {
                        eprintln!("Failed to convert HICON to RgbaImage: {:?}", e);
                        None
                    }
                })
                .collect_vec();

            large_icons
                .iter()
                .chain(small_icons.iter())
                .filter(|icon| !icon.is_invalid())
                .map(|icon| DestroyIcon(*icon))
                .filter_map(|r| r.err())
                .for_each(|e| eprintln!("Failed to destroy icon: {:?}", e));

            Ok(images)
        }
    }

    pub fn convert_hicon_to_rgba_image(hicon: &HICON) -> Result<RgbaImage> {
        unsafe {
            let mut icon_info = ICONINFOEXW {
                cbSize: std::mem::size_of::<ICONINFOEXW>() as u32,
                ..Default::default()
            };

            if !GetIconInfoExW(*hicon, &mut icon_info).as_bool() {
                return Err(anyhow!(format!(
                    "icon • GetIconInfoExW: {} {}:{}",
                    file!(),
                    line!(),
                    column!()
                )));
            }
            let hdc_screen = CreateCompatibleDC(None);
            let hdc_mem = CreateCompatibleDC(hdc_screen);
            let hbm_old = SelectObject(hdc_mem, icon_info.hbmColor);

            let mut bmp_info = BITMAPINFO {
                bmiHeader: BITMAPINFOHEADER {
                    biSize: std::mem::size_of::<BITMAPINFOHEADER>() as u32,
                    biWidth: icon_info.xHotspot as i32 * 2,
                    biHeight: -(icon_info.yHotspot as i32 * 2),
                    biPlanes: 1,
                    biBitCount: 32,
                    biCompression: DIB_RGB_COLORS.0,
                    ..Default::default()
                },
                ..Default::default()
            };

            let mut buffer: Vec<u8> =
                vec![0; (icon_info.xHotspot * 2 * icon_info.yHotspot * 2 * 4) as usize];

            if GetDIBits(
                hdc_mem,
                icon_info.hbmColor,
                0,
                icon_info.yHotspot * 2,
                Some(buffer.as_mut_ptr() as *mut _),
                &mut bmp_info,
                DIB_RGB_COLORS,
            ) == 0
            {
                return Err(anyhow!(format!(
                    "GetDIBits: {} {}:{}",
                    file!(),
                    line!(),
                    column!()
                )));
            }
            // Clean up
            SelectObject(hdc_mem, hbm_old);
            DeleteDC(hdc_mem);
            DeleteDC(hdc_screen);
            DeleteObject(icon_info.hbmColor);
            DeleteObject(icon_info.hbmMask);

            bgra_to_rgba(buffer.as_mut_slice());

            let image =
                ImageBuffer::from_raw(icon_info.xHotspot * 2, icon_info.yHotspot * 2, buffer)
                    .ok_or_else(|| anyhow!("Image container not big enough"))?;
            Ok(image)
        }
    }

    pub fn bgra_to_rgba(data: &mut [u8]) {
        #[cfg(target_arch = "x86")]
        use std::arch::x86::_mm_shuffle_epi8;
        #[cfg(target_arch = "x86_64")]
        use std::arch::x86_64::_mm_shuffle_epi8;
        use std::arch::x86_64::{__m128i, _mm_loadu_si128, _mm_setr_epi8, _mm_storeu_si128};

        // The shuffle mask for converting BGRA -> RGBA
        let mask: __m128i = unsafe {
            _mm_setr_epi8(
                2, 1, 0, 3, // First pixel
                6, 5, 4, 7, // Second pixel
                10, 9, 8, 11, // Third pixel
                14, 13, 12, 15, // Fourth pixel
            )
        };
        // For each 16-byte chunk in your data
        for chunk in data.chunks_exact_mut(16) {
            let mut vector = unsafe { _mm_loadu_si128(chunk.as_ptr() as *const __m128i) };
            vector = unsafe { _mm_shuffle_epi8(vector, mask) };
            unsafe { _mm_storeu_si128(chunk.as_mut_ptr() as *mut __m128i, vector) };
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_get_images_from_exe() {
        let executable_path = "C:\\Windows\\System32\\notepad.exe";
        let image_path = ".\\icon.png";
        let result = get_images_from_exe(executable_path, image_path);
        assert!(result.is_ok());
    }
}
