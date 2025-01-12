import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/tiphereth.pb.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../../bloc/tiphereth/tiphereth_bloc.dart';
import '../../../../common/platform.dart';
import '../../../../l10n/l10n.dart';
import '../../../../model/common_model.dart';
import '../../../../route.dart';
import '../../../helper/duration_format.dart';
import '../../../universal/universal.dart';
import '../../frame_page.dart';

class SessionManagePage extends StatelessWidget {
  const SessionManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipherethBloc, TipherethState>(
        builder: (context, state) {
      final listData = state.sessions ?? [];
      final deviceInfo =
          PlatformHelper.clientDeviceInfo() ?? const ClientDeviceInfo('', '');
      final currentDeviceId =
          context.read<MainBloc>().state.serverConfig?.deviceId;
      return Scaffold(
        body: Stack(children: [
          if (state is TipherethLoadSessionsState && state.processing)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (state is TipherethLoadSessionsState && state.failed)
            Center(
              child: Text(S.of(context).loadFailed(state.msg.toString())),
            )
          else
            ListView(children: [
              UniversalCard(
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 36, 8, 36),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).currentDevice,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onPrimary),
                          maxLines: 2,
                        ),
                        Text(
                          deviceInfo.deviceName.isNotEmpty ||
                                  deviceInfo.systemVersion.isNotEmpty
                              ? '${deviceInfo.deviceName} ${deviceInfo.systemVersion}'
                              : S.of(context).unknownDevice,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Theme.of(context).colorScheme.onPrimary),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: listData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = listData.elementAt(index);

                  void openEditPage() {
                    context
                        .read<TipherethBloc>()
                        .add(TipherethSetSessionEditIndexEvent(index));
                    const SettingsFunctionRoute(SettingsFunctions.session,
                            action: SettingsActions.sessionEdit)
                        .go(context);
                    ModuleFramePage.of(context)?.openDrawer();
                  }

                  if (item.deviceInfo.deviceId.id.toInt() == currentDeviceId) {
                    return const SizedBox();
                  }

                  return UniversalListTile(
                    title: Text(
                      item.id.id.toHexString(),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 10,
                          color: Theme.of(context).disabledColor),
                      maxLines: 2,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.deviceInfo.deviceName.isNotEmpty ||
                                  item.deviceInfo.systemVersion.isNotEmpty
                              ? '${item.deviceInfo.deviceName} ${item.deviceInfo.systemVersion}'
                              : S.of(context).unknownDevice,
                        ),
                        Text(
                          item.deviceInfo.clientName.isNotEmpty ||
                                  item.deviceInfo.clientVersion.isNotEmpty
                              ? '${item.deviceInfo.clientName} ${item.deviceInfo.clientVersion}'
                              : S.of(context).unknownClient,
                        ),
                        Text(
                          '${DurationHelper.recentString(
                            item.createTime.toDateTime(toLocal: true),
                          )}${item.expireTime.toDateTime(
                                toLocal: true,
                              ).isBefore(
                                DateTime.now(),
                              ) ? ' · ${S.of(context).loginExpired}' : ''}',
                        ),
                      ],
                    ),
                    leading: _systemIcon(item.deviceInfo.systemType),
                    trailing: UniversalIconButton(
                      onPressed: openEditPage,
                      icon: Icon(UniversalUI.of(context).icons.edit),
                    ),
                    onTap: openEditPage,
                  );
                },
              ),
            ]),
        ]),
      );
    });
  }
}

Widget _systemIcon(SystemType type) {
  switch (type) {
    case SystemType.SYSTEM_TYPE_UNSPECIFIED:
      return Icon(const FaIcon(FontAwesomeIcons.question).icon);
    case SystemType.SYSTEM_TYPE_ANDROID:
      return Icon(const FaIcon(FontAwesomeIcons.android).icon);
    case SystemType.SYSTEM_TYPE_IOS:
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(const FaIcon(FontAwesomeIcons.apple).icon, size: 12),
          Icon(const FaIcon(FontAwesomeIcons.mobileScreenButton).icon,
              size: 32),
        ],
      );
    case SystemType.SYSTEM_TYPE_WINDOWS:
      return Icon(const FaIcon(FontAwesomeIcons.windows).icon);
    case SystemType.SYSTEM_TYPE_MACOS:
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(const FaIcon(FontAwesomeIcons.apple).icon, size: 12),
          Icon(const FaIcon(FontAwesomeIcons.laptop).icon),
        ],
      );
    case SystemType.SYSTEM_TYPE_LINUX:
      return Icon(const FaIcon(FontAwesomeIcons.linux).icon);
    case SystemType.SYSTEM_TYPE_WEB:
      return Icon(const FaIcon(FontAwesomeIcons.chrome).icon);
  }
  return Icon(const FaIcon(FontAwesomeIcons.question).icon);
}
