// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/theme_bloc/themes_state.dart';
import 'package:zedbee_bms/utils/app_themes.dart';
import 'package:zedbee_bms/utils/local_storage.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorage _localStorage = LocalStorage();

  ThemeBloc()
      : super(
          ThemeState(
            themeData: appThemeData[AppTheme.light]!,
            theme: AppTheme.light,
          ),
        ) {
    on<ThemeChanged>((event, emit) async {
      await _localStorage.saveTheme(event.theme.name);

      emit(
        ThemeState(
          themeData: appThemeData[event.theme]!,
          theme: event.theme,
        ),
      );
    });

    _loadTheme();
  }

  void _loadTheme() async {
  final savedTheme = await _localStorage.getTheme();

  if (savedTheme != null) {
    try {
      final appTheme =
          AppTheme.values.firstWhere((e) => e.name == savedTheme);

      add(ThemeChanged(appTheme));
    } catch (e) {
      add(ThemeChanged(AppTheme.light));
    }
  }
}
}
