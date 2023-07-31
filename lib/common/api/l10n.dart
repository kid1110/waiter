import 'package:tuihub_protos/librarian/v1/common.pbenum.dart';
import 'package:waitress/l10n/l10n.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/tiphereth.pb.dart';

String userTypeString(UserType type) {
  switch (type) {
    case UserType.USER_TYPE_ADMIN:
      return S.current.USER_TYPE_ADMIN;
    case UserType.USER_TYPE_NORMAL:
      return S.current.USER_TYPE_NORMAL;
    case UserType.USER_TYPE_SENTINEL:
      return S.current.USER_TYPE_SENTINEL;
    default:
      return '';
  }
}

String userStatusString(UserStatus status) {
  switch (status) {
    case UserStatus.USER_STATUS_ACTIVE:
      return S.current.USER_STATUS_ACTIVE;
    case UserStatus.USER_STATUS_BLOCKED:
      return S.current.USER_STATUS_BLOCKED;
    default:
      return '';
  }
}

String appSourceString(AppSource source) {
  switch (source) {
    case AppSource.APP_SOURCE_UNSPECIFIED:
      return S.current.APP_SOURCE_UNSPECIFIED;
    case AppSource.APP_SOURCE_INTERNAL:
      return S.current.APP_SOURCE_INTERNAL;
    case AppSource.APP_SOURCE_STEAM:
      return S.current.APP_SOURCE_STEAM;
    default:
      return '';
  }
}

String appTypeString(AppType type) {
  switch (type) {
    case AppType.APP_TYPE_UNSPECIFIED:
      return S.current.APP_TYPE_UNSPECIFIED;
    case AppType.APP_TYPE_GAME:
      return S.current.APP_TYPE_GAME;
    default:
      return '';
  }
}

String appPackageSourceString(AppPackageSource source) {
  switch (source) {
    case AppPackageSource.APP_PACKAGE_SOURCE_UNSPECIFIED:
      return S.current.APP_PACKAGE_SOURCE_UNSPECIFIED;
    case AppPackageSource.APP_PACKAGE_SOURCE_MANUAL:
      return S.current.APP_PACKAGE_SOURCE_MANUAL;
    case AppPackageSource.APP_PACKAGE_SOURCE_SENTINEL:
      return S.current.APP_PACKAGE_SOURCE_SENTINEL;
    default:
      return '';
  }
}