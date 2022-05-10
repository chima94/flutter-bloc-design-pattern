import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/app/bloc/app_event.dart';
import 'package:todo/app/bloc/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(
          const AppState.AppStarted(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppStartedEvent>(_onAppStarted);

    _userSubscription = _authRepo.user.listen((user) {
      if (state.status == AppStatus.appStarted) {
        add(AppStartedEvent());
      } else {
        add(AppUserChanged(user));
      }
    });
  }

  final AuthRepo _authRepo;
  late final StreamSubscription<UserModel> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onAppStarted(AppStartedEvent event, Emitter<AppState> emit) async {
    emit(const AppState.AppStarted());
    await Future.delayed(const Duration(seconds: 4), () {
      emit(_authRepo.currentUser.isNotEmpty
          ? AppState.authenticated(_authRepo.currentUser)
          : const AppState.unauthenticated());
    });
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authRepo.logout());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
