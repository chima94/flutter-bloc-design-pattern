import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/sharepreference.dart';
import 'package:todo/theme/theme_event.dart';
import 'package:todo/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: Preferences.getTheme())) {
    on<ThemeEvent>(_onAppThemeChanged);
  }

  Future<void> _onAppThemeChanged(
    ThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await Preferences.saveTheme(event.value);
    emit(ThemeState(themeData: Preferences.getTheme()));
  }
}
