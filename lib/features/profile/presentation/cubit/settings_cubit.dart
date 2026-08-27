import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit(this.sharedPreferences)
      : super(SettingsState(
          themeMode: ThemeMode.values[sharedPreferences.getInt('themeMode') ?? 0],
        ));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setInt('themeMode', newMode.index);
    emit(state.copyWith(themeMode: newMode));
  }
}
