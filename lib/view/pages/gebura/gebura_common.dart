import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart' show File;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_ui/universal_ui.dart';

import '../../../bloc/gebura/gebura_bloc.dart';

class GeburaAppCoverImage extends StatelessWidget {
  const GeburaAppCoverImage({
    this.url,
    this.path,
    super.key,
  });

  final String? url;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeburaBloc, GeburaState>(
      builder: (context, state) {
        if (path != null && path!.isNotEmpty) {
          return ExtendedImage.file(
            File(path!),
          );
        } else if (url != null && url!.isNotEmpty) {
          return ExtendedImage.network(
            url!,
            height: 200,
            loadStateChanged: (ExtendedImageState state) {
              if (state.extendedImageLoadState == LoadState.failed) {
                return ExtendedImage.asset(
                  'assets/images/gebura_library_cover_placeholder.png',
                );
              }
              return null;
            },
          );
        } else {
          return ExtendedImage.asset(
            'assets/images/gebura_library_cover_placeholder.png',
          );
        }
      },
    );
  }
}

class GeburaAppIconImage extends StatelessWidget {
  const GeburaAppIconImage({
    this.url,
    this.path,
    super.key,
  });

  final String? url;
  final String? path;

  DecorationImage? _buildImage(BuildContext context) {
    if (path != null && path!.isNotEmpty) {
      return DecorationImage(
        image: ExtendedFileImageProvider(File(path!)),
        fit: BoxFit.scaleDown,
      );
    } else if (url != null && url!.isNotEmpty) {
      return DecorationImage(
        image: ExtendedNetworkImageProvider(url!),
        fit: BoxFit.scaleDown,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeburaBloc, GeburaState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: _buildImage(context),
          ),
          height: 20,
          width: 20,
        );
      },
    );
  }
}

class GeburaAppBackgroundImage extends StatelessWidget {
  const GeburaAppBackgroundImage({
    this.url,
    this.path,
    super.key,
  });

  final String? url;
  final String? path;

  DecorationImage? _buildImage(BuildContext context) {
    if (path != null && path!.isNotEmpty) {
      return DecorationImage(
        image: ExtendedFileImageProvider(File(path!)),
        fit: BoxFit.cover,
      );
    } else if (url != null && url!.isNotEmpty) {
      return DecorationImage(
        image: ExtendedNetworkImageProvider(url!),
        fit: BoxFit.cover,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeburaBloc, GeburaState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: UniversalUI.of(context).defaultBorderRadius,
            image: _buildImage(context),
          ),
          height: 400,
        );
      },
    );
  }
}
