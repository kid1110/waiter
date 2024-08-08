import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_hero/local_hero.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/gebura.pb.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/tiphereth.pb.dart';
import 'package:tuihub_protos/librarian/v1/common.pb.dart';

import 'bloc/chesed/chesed_bloc.dart';
import 'bloc/gebura/gebura_bloc.dart';
import 'bloc/main_bloc.dart';
import 'bloc/netzach/netzach_bloc.dart';
import 'bloc/tiphereth/tiphereth_bloc.dart';
import 'bloc/yesod/yesod_bloc.dart';
import 'main_window.dart';
import 'repo/grpc/api_helper.dart';
import 'view/pages/chesed/chesed_home_page.dart';
import 'view/pages/frame_page.dart';
import 'view/pages/gebura/gebura_assign_app_panel.dart';
import 'view/pages/gebura/gebura_library_detail.dart';
import 'view/pages/gebura/gebura_library_overview.dart';
import 'view/pages/gebura/gebura_library_settings.dart';
import 'view/pages/gebura/gebura_nav.dart';
import 'view/pages/gebura/gebura_store.dart';
import 'view/pages/image_viewer.dart';
import 'view/pages/init_page.dart';
import 'view/pages/notification_page.dart';
import 'view/pages/settings/about_page.dart';
import 'view/pages/settings/app/app_add_panel.dart';
import 'view/pages/settings/app/app_edit_panel.dart';
import 'view/pages/settings/app/app_manage_page.dart';
import 'view/pages/settings/app_package/app_package_add_panel.dart';
import 'view/pages/settings/app_package/app_package_edit_panel.dart';
import 'view/pages/settings/app_package/app_package_manage_page.dart';
import 'view/pages/settings/client/client_setting_page.dart';
import 'view/pages/settings/notify/notify_flow_add_panel.dart';
import 'view/pages/settings/notify/notify_flow_edit_panel.dart';
import 'view/pages/settings/notify/notify_flow_page.dart';
import 'view/pages/settings/notify/notify_target_add_panel.dart';
import 'view/pages/settings/notify/notify_target_edit_panel.dart';
import 'view/pages/settings/notify/notify_target_page.dart';
import 'view/pages/settings/porter/porter_manage_page.dart';
import 'view/pages/settings/porter_context_page.dart';
import 'view/pages/settings/session/session_edit_panel.dart';
import 'view/pages/settings/session/session_manage_page.dart';
import 'view/pages/settings/settings_nav.dart';
import 'view/pages/settings/user/user_add_panel.dart';
import 'view/pages/settings/user/user_edit_panel.dart';
import 'view/pages/settings/user/user_manage_page.dart';
import 'view/pages/tiphereth/tiphereth_frame_page.dart';
import 'view/pages/web_landing_page.dart';
import 'view/pages/yesod/yesod_action_manage_page.dart';
import 'view/pages/yesod/yesod_feed_manage_page.dart';
import 'view/pages/yesod/yesod_nav.dart';
import 'view/pages/yesod/yesod_recent_page.dart';

part 'route.g.dart';

enum ModuleName {
  tiphereth._(_tiphereth),
  yesod._(_yesod),
  gebura._(_gebura),
  chesed._(_chesed),
  notification._(_notification),
  settings._(_settings);

  static const String _tiphereth = 'Tiphereth';
  static const String _yesod = 'Yesod';
  static const String _gebura = 'Gebura';
  static const String _chesed = 'Chesed';
  static const String _notification = 'Notification';
  static const String _settings = 'Settings';

  const ModuleName._(this.name);

  final String name;

  @override
  String toString() => name;
}

class YesodFunctions {
  static const String recent = 'recent';
  static const String timeline = 'timeline';
  static const String feedManage = 'feedManage';
  static const String actionManage = 'actionManage';
}

class GeburaFunctions {
  static const String store = 'store';
  static const String library = 'library';
  static const String librarySettings = 'librarySettings';
}

final GlobalKey<NavigatorState> _tipherethNavigateKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _yesodNavigateKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _geburaNavigateKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _chesedNavigateKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _notificationNavigateKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigateKey =
    GlobalKey<NavigatorState>();
final mainWindowKey = GlobalKey();

@TypedGoRoute<AppRoute>(
  path: '/',
  routes: [
    TypedGoRoute<InitRoute>(path: 'init'),
    TypedGoRoute<WebLandingRoute>(path: 'webLanding'),
    TypedGoRoute<ImageViewerRoute>(path: 'imageViewer/:index'),
    TypedStatefulShellRoute<ModuleRoute>(
      branches: [
        TypedStatefulShellBranch<TipherethRoute>(
          routes: [TypedGoRoute<TipherethRootRoute>(path: 'module/Tiphereth')],
        ),
        TypedStatefulShellBranch<YesodRoute>(
          routes: [
            TypedGoRoute<YesodRootRoute>(path: 'module/Yesod'),
            TypedGoRoute<YesodRecentRoute>(path: 'module/Yesod/recent'),
            TypedGoRoute<YesodFeedManageRoute>(path: 'module/Yesod/feedManage'),
            TypedGoRoute<YesodActionManageRoute>(
                path: 'module/Yesod/actionManage'),
          ],
        ),
        TypedStatefulShellBranch<GeburaRoute>(
          routes: [
            TypedGoRoute<GeburaRootRoute>(path: 'module/Gebura'),
            TypedGoRoute<GeburaStoreRoute>(path: 'module/Gebura/store'),
            TypedGoRoute<GeburaLibraryRoute>(path: 'module/Gebura/library'),
            TypedGoRoute<GeburaLibrarySettingsRoute>(
                path: 'module/Gebura/librarySettings'),
            TypedGoRoute<GeburaLibraryDetailRoute>(
                path: 'module/Gebura/library/:id'),
          ],
        ),
        TypedStatefulShellBranch<ChesedRoute>(
          routes: [TypedGoRoute<ChesedRootRoute>(path: 'module/Chesed')],
        ),
        TypedStatefulShellBranch<NotificationRoute>(
          routes: [
            TypedGoRoute<NotificationRootRoute>(path: 'module/Notification')
          ],
        ),
        TypedStatefulShellBranch<SettingsRoute>(
          routes: [
            TypedGoRoute<SettingsRootRoute>(path: 'module/Settings'),
            TypedGoRoute<SettingsFunctionRoute>(
                path: 'module/Settings/:function'),
          ],
        ),
      ],
    )
  ],
)
class AppRoute extends GoRouteData {
  const AppRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class InitRoute extends GoRouteData {
  const InitRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(
        child: MainWindow(
          key: mainWindowKey,
          child: const InitPage(),
        ),
      );
}

class WebLandingRoute extends GoRouteData {
  const WebLandingRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(
        child: MainWindow(
          key: mainWindowKey,
          child: const WebLandingPage(),
        ),
      );
}

class ImageViewerRoute extends GoRouteData {
  const ImageViewerRoute(this.index, this.$extra);

  final int index;
  final List<PicSwiperItem>? $extra;

  @override
  CustomTransitionPage<void> buildPage(
      BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      fullscreenDialog: true,
      opaque: false,
      transitionsBuilder: (_, __, ___, child) => child,
      child: PicSwiper(
        index: index,
        pics: $extra,
      ),
    );
  }
}

class ModuleRoute extends StatefulShellRouteData {
  const ModuleRoute();

  @override
  NoTransitionPage<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return NoTransitionPage(child: BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.currentUser != null ||
            context.read<MainBloc>().tipherethBloc != null) {
          return MainWindow(
            key: mainWindowKey,
            child: navigationShell,
          );
        }
        return MainWindow(
          key: mainWindowKey,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ));
  }
}

class TipherethRoute extends StatefulShellBranchData {
  const TipherethRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _tipherethNavigateKey;
}

class TipherethRootRoute extends GoRouteData {
  const TipherethRootRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    context.read<TipherethBloc>().add(TipherethGetAccountsEvent());
    return const NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.tiphereth,
        leftPart: TipherethFramePage(),
      ),
    );
  }
}

class YesodRoute extends StatefulShellBranchData {
  const YesodRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _yesodNavigateKey;
}

class YesodRootRoute extends GoRouteData {
  const YesodRootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return const YesodRecentRoute().location;
  }
}

enum YesodRecentActions { setting }

class YesodRecentRoute extends GoRouteData {
  const YesodRecentRoute({this.action});

  final YesodRecentActions? action;

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    final actions = {
      YesodRecentActions.setting: const YesodRecentSettingPanel(),
    };
    context.read<YesodBloc>().add(YesodInitEvent());
    return NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.yesod,
        leftPart: const YesodNav(
          function: YesodFunctions.recent,
        ),
        middlePart: const YesodRecentPage(),
        rightPart: actions[action] ?? Container(),
        gestureRight: false,
      ),
    );
  }
}

enum YesodFeedManageActions { edit, add }

class YesodFeedManageRoute extends GoRouteData {
  const YesodFeedManageRoute({this.action, this.id});

  final YesodFeedManageActions? action;
  final int? id;

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    final actions = {
      YesodFeedManageActions.edit: YesodFeedManageEditPanel(
        key: ValueKey(id),
        index: id,
      ),
      YesodFeedManageActions.add: const YesodFeedManageAddPanel(),
    };
    return NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.yesod,
        leftPart: const YesodNav(
          function: YesodFunctions.feedManage,
        ),
        middlePart: const YesodFeedManagePage(),
        rightPart: actions[action] ?? Container(),
        gestureRight: true,
      ),
    );
  }
}

enum YesodActionManageActions { edit, add }

class YesodActionManageRoute extends GoRouteData {
  const YesodActionManageRoute({this.action, this.id});

  final YesodActionManageActions? action;
  final int? id;

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    final actions = {
      YesodActionManageActions.edit: YesodActionManageEditPanel(
        key: ValueKey(id),
        index: id,
      ),
      YesodActionManageActions.add: const YesodActionManageAddPanel(),
    };
    return NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.yesod,
        leftPart: const YesodNav(
          function: YesodFunctions.actionManage,
        ),
        middlePart: const YesodActionManagePage(),
        rightPart: actions[action] ?? Container(),
        gestureRight: true,
      ),
    );
  }
}

class GeburaRoute extends StatefulShellBranchData {
  const GeburaRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _geburaNavigateKey;

  static Widget rootWidget({required Widget child}) {
    return LocalHeroScope(
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

class GeburaRootRoute extends GoRouteData {
  const GeburaRootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    context.read<GeburaBloc>().add(GeburaInitEvent());
    if (context.read<GeburaBloc>().state.selectedLibraryItem != null) {
      return GeburaLibraryDetailRoute(
              id: context.read<GeburaBloc>().state.selectedLibraryItem)
          .location;
    } else {
      return const GeburaLibraryRoute().location;
    }
  }
}

class GeburaStoreRoute extends GoRouteData {
  const GeburaStoreRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: GeburaRoute.rootWidget(
        child: const FramePage(
          selectedNav: ModuleName.gebura,
          leftPart: GeburaNav(
            function: GeburaFunctions.store,
          ),
          middlePart: GeburaStorePage(),
        ),
      ),
    );
  }
}

class GeburaLibraryRoute extends GoRouteData {
  const GeburaLibraryRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: GeburaRoute.rootWidget(
        child: const FramePage(
          selectedNav: ModuleName.gebura,
          leftPart: GeburaNav(
            function: GeburaFunctions.library,
          ),
          middlePart: GeburaLibraryOverview(),
        ),
      ),
    );
  }
}

class GeburaLibrarySettingsRoute extends GoRouteData {
  const GeburaLibrarySettingsRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: GeburaRoute.rootWidget(
        child: const FramePage(
          selectedNav: ModuleName.gebura,
          leftPart: GeburaNav(
            function: GeburaFunctions.librarySettings,
          ),
          middlePart: GeburaLibrarySettings(),
        ),
      ),
    );
  }
}

enum GeburaLibraryDetailActions { assignApp }

class GeburaLibraryDetailRoute extends GoRouteData {
  const GeburaLibraryDetailRoute({this.action, this.id});

  final GeburaLibraryDetailActions? action;
  final int? id;

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    final actions = {
      GeburaLibraryDetailActions.assignApp: const GeburaAssignAppPanel(),
    };
    return NoTransitionPage(
      child: GeburaRoute.rootWidget(
        child: FramePage(
          selectedNav: ModuleName.gebura,
          leftPart: const GeburaNav(
            function: GeburaFunctions.library,
          ),
          middlePart: GeburaLibraryDetailPage(id: id ?? 0),
          rightPart: actions[action],
        ),
      ),
    );
  }
}

class ChesedRoute extends StatefulShellBranchData {
  const ChesedRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _chesedNavigateKey;
}

class ChesedRootRoute extends GoRouteData {
  const ChesedRootRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    context.read<ChesedBloc>().add(ChesedSearchImagesEvent(''));
    return const NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.chesed,
        leftPart: ChesedHome(),
      ),
    );
  }
}

class NotificationRoute extends StatefulShellBranchData {
  const NotificationRoute();

  static final GlobalKey<NavigatorState> $navigatorKey =
      _notificationNavigateKey;
}

class NotificationRootRoute extends GoRouteData {
  const NotificationRootRoute();

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    context.read<NetzachBloc>().add(NetzachSystemNotificationLoadEvent(1));
    return const NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.notification,
        leftPart: NotificationPage(),
      ),
    );
  }
}

class SettingsRoute extends StatefulShellBranchData {
  const SettingsRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _settingsNavigateKey;
}

class SettingsRootRoute extends GoRouteData {
  const SettingsRootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return const SettingsFunctionRoute(SettingsFunctions.client).location;
  }
}

enum SettingsFunctions {
  client,
  notifyTarget,
  notifyFlow,
  session,
  porterContext,
  porter,
  user,
  app,
  appPackage,
  about
}

enum SettingsActions {
  notifyTargetAdd,
  notifyTargetEdit,
  notifyFlowAdd,
  notifyFlowEdit,
  sessionEdit,
  porterContextAdd,
  porterContextEdit,
  porterEdit,
  userEdit,
  userAdd,
  appEdit,
  appAdd,
  appPackageEdit,
  appPackageAdd
}

class SettingsFunctionRoute extends GoRouteData {
  const SettingsFunctionRoute(this.function, {this.action, this.$extra});

  final SettingsFunctions function;
  final SettingsActions? action;
  final dynamic $extra;

  @override
  NoTransitionPage<void> buildPage(BuildContext context, GoRouterState state) {
    final settingsPages = {
      SettingsFunctions.client: const ClientSettingPage(),
      SettingsFunctions.notifyTarget: const NotifyTargetPage(),
      SettingsFunctions.notifyFlow: const NotifyFlowPage(),
      SettingsFunctions.session: const SessionManagePage(),
      SettingsFunctions.porterContext: const PorterContextManagePage(),
      SettingsFunctions.porter: const PorterManagePage(),
      SettingsFunctions.user: const UserManagePage(),
      SettingsFunctions.app: const AppManagePage(),
      SettingsFunctions.appPackage: const AppPackageManagePage(),
      SettingsFunctions.about: const AboutPage(),
    };
    final settingsActions = {
      SettingsActions.notifyTargetAdd: const NotifyTargetAddPanel(),
      SettingsActions.notifyTargetEdit: const NotifyTargetEditPanel(),
      SettingsActions.notifyFlowAdd: const NotifyFlowAddPanel(),
      SettingsActions.notifyFlowEdit: const NotifyFlowEditPanel(),
      SettingsActions.sessionEdit: const SessionEditPanel(),
      SettingsActions.porterContextAdd: PorterContextAddPanel(
        key: ValueKey($extra),
        porterGroup:
            $extra is PorterGroup ? $extra! as PorterGroup : PorterGroup(),
      ),
      SettingsActions.porterContextEdit: PorterContextEditPanel(
        key: ValueKey($extra),
        porterContext: $extra is PorterContext
            ? $extra! as PorterContext
            : PorterContext(),
      ),
      SettingsActions.porterEdit: const PorterEditPanel(),
      SettingsActions.userAdd: const UserAddPanel(),
      SettingsActions.userEdit: UserEditPanel(
        key: ValueKey($extra),
        user: $extra is User ? $extra! as User : User(),
      ),
      SettingsActions.appAdd: const AppAddPanel(),
      SettingsActions.appEdit: AppEditPanel(
        key: ValueKey($extra),
        app: $extra is AppInfo ? $extra! as AppInfo : AppInfo(),
      ),
      SettingsActions.appPackageAdd: const AppPackageAddPanel(),
      SettingsActions.appPackageEdit: AppPackageEditPanel(
        key: ValueKey($extra),
        appPackage: $extra is App ? $extra! as App : App(),
      ),
    };
    switch (function) {
      case SettingsFunctions.notifyTarget:
      case SettingsFunctions.notifyFlow:
        context.read<NetzachBloc>().add(NetzachInitEvent());
        context.read<YesodBloc>().add(YesodInitEvent());
      case SettingsFunctions.session:
        context.read<TipherethBloc>().add(TipherethLoadSessionsEvent());
      case SettingsFunctions.porter:
        context.read<TipherethBloc>().add(TipherethLoadPortersEvent());
      case SettingsFunctions.porterContext:
        context.read<TipherethBloc>().add(TipherethLoadPorterContextsEvent());
      default:
    }
    return NoTransitionPage(
      child: FramePage(
        selectedNav: ModuleName.settings,
        leftPart: SettingsNav(
          function: function,
        ),
        middlePart: settingsPages[function] ?? Container(),
        rightPart: settingsActions[action] ?? Container(),
        gestureRight: false,
      ),
    );
  }
}

GoRouter getRouter(MainBloc mainBloc, ApiHelper apiHelper) {
  return GoRouter(
    initialLocation: const InitRoute().location,
    observers: [
      HeroController(),
      SentryNavigatorObserver(),
    ],
    debugLogDiagnostics: kDebugMode,
    routes: $appRoutes,
  );
}
