import 'package:auth_repo/auth_repo.dart';
import 'package:equatable/equatable.dart';

enum AppStatus {
  appStarted,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({required this.status, this.user = UserModel.empty});

  final AppStatus status;
  final UserModel user;

  const AppState.authenticated(UserModel user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.AppStarted() : this._(status: AppStatus.appStarted);

  @override
  List<Object> get props => [status, user];
}
