import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notifEnabled = prefs.getBool('notification_enabled') ?? true;

    emit(state.copyWith(
      themeMode: ThemeMode.dark,
      locale: const Locale('vi', ''),
      isNotificationEnabled: notifEnabled,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', 'dark');

    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  Future<void> setLocale(Locale loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', 0);

    emit(state.copyWith(locale: const Locale('vi', '')));
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', enabled);

    emit(state.copyWith(isNotificationEnabled: enabled));
  }
}
