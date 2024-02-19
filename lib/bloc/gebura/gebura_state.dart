part of 'gebura_bloc.dart';

class GeburaState {
  late Map<Int64, List<AppInfo>>? appInfoMap;
  late List<AppInfoMixed>? purchasedAppInfos;
  late List<App>? ownedApps;
  late List<AppInfoMixed>? libraryItems;
  late LibrarySettings? librarySettings;
  late int? selectedLibraryItem;

  late Map<InternalID, AppRunState>? runState;

  late String? localLibraryState;
  late SteamScanResult? localSteamScanResult;
  late List<InstalledSteamApps>? localSteamApps;
  late List<ImportedSteamApp>? importedSteamApps;
  late List<String>? localSteamLibraryFolders;

  GeburaState({
    this.appInfoMap,
    this.purchasedAppInfos,
    this.ownedApps,
    this.libraryItems,
    this.librarySettings,
    this.selectedLibraryItem,
    this.runState,
    this.localLibraryState,
    this.localSteamScanResult,
    this.localSteamApps,
    this.importedSteamApps,
    this.localSteamLibraryFolders,
  });

  GeburaState copyWith({
    Map<Int64, List<AppInfo>>? appInfoMap,
    List<AppInfoMixed>? purchasedAppInfos,
    List<App>? ownedApps,
    List<AppInfoMixed>? libraryItems,
    LibrarySettings? librarySettings,
    int? selectedLibraryItem,
    Map<InternalID, AppRunState>? runState,
    String? localLibraryState,
    SteamScanResult? localSteamScanResult,
    List<InstalledSteamApps>? localSteamApps,
    List<ImportedSteamApp>? importedSteamApps,
    List<String>? localSteamLibraryFolders,
  }) {
    return GeburaState(
      appInfoMap: appInfoMap ?? this.appInfoMap,
      purchasedAppInfos: purchasedAppInfos ?? this.purchasedAppInfos,
      ownedApps: ownedApps ?? this.ownedApps,
      libraryItems: libraryItems ?? this.libraryItems,
      librarySettings: librarySettings ?? this.librarySettings,
      selectedLibraryItem: selectedLibraryItem ?? this.selectedLibraryItem,
      runState: runState ?? this.runState,
      localLibraryState: localLibraryState ?? this.localLibraryState,
      localSteamScanResult: localSteamScanResult ?? this.localSteamScanResult,
      localSteamApps: localSteamApps ?? this.localSteamApps,
      importedSteamApps: importedSteamApps ?? this.importedSteamApps,
      localSteamLibraryFolders:
          localSteamLibraryFolders ?? this.localSteamLibraryFolders,
    );
  }

  void _from(GeburaState other) {
    appInfoMap = other.appInfoMap;
    purchasedAppInfos = other.purchasedAppInfos;
    ownedApps = other.ownedApps;
    libraryItems = other.libraryItems;
    librarySettings = other.librarySettings;
    selectedLibraryItem = other.selectedLibraryItem;
    runState = other.runState;
    localLibraryState = other.localLibraryState;
    localSteamScanResult = other.localSteamScanResult;
    localSteamApps = other.localSteamApps;
    importedSteamApps = other.importedSteamApps;
    localSteamLibraryFolders = other.localSteamLibraryFolders;
  }
}

class GeburaRefreshLibraryState extends GeburaState with EventStatusMixin {
  GeburaRefreshLibraryState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaSearchAppInfosState extends GeburaState with EventStatusMixin {
  GeburaSearchAppInfosState(GeburaState state, this.statusCode,
      {this.msg, this.apps})
      : super() {
    _from(state);
  }

  final List<AppInfoMixed>? apps;

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

class GeburaImportSteamAppsState extends GeburaState with EventStatusMixin {
  GeburaImportSteamAppsState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}

class GeburaFetchBoundAppsState extends GeburaState with EventStatusMixin {
  GeburaFetchBoundAppsState(GeburaState state, this.statusCode, {this.msg})
      : super() {
    _from(state);
  }

  @override
  final EventStatus? statusCode;
  @override
  final String? msg;
}
