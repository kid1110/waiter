part of 'tiphereth_bloc.dart';

@immutable
sealed class TipherethEvent {}

class TipherethAddUserEvent extends TipherethEvent {
  final User user;

  TipherethAddUserEvent(this.user);
}

class TipherethEditUserEvent extends TipherethEvent {
  final User user;
  final String? password;

  TipherethEditUserEvent(this.user, {this.password});
}

class TipherethGetAccountsEvent extends TipherethEvent {}

class TipherethLinkAccountEvent extends TipherethEvent {
  final AccountPlatform platform;
  final String platformAccountID;

  TipherethLinkAccountEvent(this.platform, this.platformAccountID);
}

class TipherethUnLinkAccountEvent extends TipherethEvent {
  final AccountPlatform platform;
  final String platformAccountID;

  TipherethUnLinkAccountEvent(this.platform, this.platformAccountID);
}
