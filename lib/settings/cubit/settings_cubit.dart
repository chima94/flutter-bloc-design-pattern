import 'package:auth_repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const SettingsState());
  final AuthRepo _authRepo;
}
