part of 'gebura_bloc.dart';

class GeburaState {
  late List<AppMixed>? purchasedApps;
  late int? selectedPurchasedAppIndex;

  late Map<InternalID, AppMixed>? storeApps;
  late Map<InternalID, AppRunState>? runState;

  late String? localLibraryState;

  GeburaState({
    this.purchasedApps,
    this.selectedPurchasedAppIndex,
    this.storeApps,
    this.runState,
    this.localLibraryState,
  });

  GeburaState copyWith({
    List<AppMixed>? purchasedApps,
    int? selectedPurchasedAppIndex,
    Map<InternalID, AppMixed>? storeApps,
    Map<InternalID, AppRunState>? runState,
    String? localLibraryState,
  }) {
    return GeburaState(
      purchasedApps: purchasedApps ?? this.purchasedApps,
      selectedPurchasedAppIndex:
          selectedPurchasedAppIndex ?? this.selectedPurchasedAppIndex,
      storeApps: storeApps ?? this.storeApps,
      runState: runState ?? this.runState,
      localLibraryState: localLibraryState ?? this.localLibraryState,
    );
  }

  void _from(GeburaState other) {
    purchasedApps = other.purchasedApps;
    selectedPurchasedAppIndex = other.selectedPurchasedAppIndex;
    storeApps = other.storeApps;
    runState = other.runState;
    localLibraryState = other.localLibraryState;
  }
}

class GeburaPurchasedAppsLoadState extends GeburaState with EventStatusMixin {
  GeburaPurchasedAppsLoadState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaSearchAppsState extends GeburaState with EventStatusMixin {
  GeburaSearchAppsState(GeburaState state, this.statusCode,
      {this.msg, this.apps})
      : super() {
    _from(state);
  }

  final List<AppMixed>? apps;

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaPurchaseState extends GeburaState with EventStatusMixin {
  GeburaPurchaseState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaSetAppLauncherSettingState extends GeburaState
    with EventStatusMixin {
  GeburaSetAppLauncherSettingState(GeburaState state, this.statusCode,
      {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaAddAppState extends GeburaState with EventStatusMixin {
  GeburaAddAppState(GeburaState state, this.statusCode, {this.msg}) : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaEditAppState extends GeburaState with EventStatusMixin {
  GeburaEditAppState(GeburaState state, this.statusCode, {this.msg}) : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaAddAppPackageState extends GeburaState with EventStatusMixin {
  GeburaAddAppPackageState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaEditAppPackageState extends GeburaState with EventStatusMixin {
  GeburaEditAppPackageState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaAssignAppPackageState extends GeburaState with EventStatusMixin {
  GeburaAssignAppPackageState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaRunAppState extends GeburaState with EventStatusMixin {
  GeburaRunAppState(GeburaState state, this.appID, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  final InternalID appID;

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}
