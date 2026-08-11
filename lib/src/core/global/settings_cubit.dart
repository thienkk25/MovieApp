import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode') ?? 'auto';
    final langInt = prefs.getInt('language') ?? 0;
    final notifEnabled = prefs.getBool('notification_enabled') ?? true;

    ThemeMode mode = ThemeMode.system;
    if (themeStr == 'light') mode = ThemeMode.light;
    if (themeStr == 'dark') mode = ThemeMode.dark;

    Locale loc = (langInt == 0) ? const Locale('vi', '') : const Locale('en', '');

    emit(state.copyWith(
      themeMode: mode,
      locale: loc,
      isNotificationEnabled: notifEnabled,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String str = 'auto';
    if (mode == ThemeMode.light) str = 'light';
    if (mode == ThemeMode.dark) str = 'dark';
    await prefs.setString('themeMode', str);

    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale loc) async {
    final prefs = await SharedPreferences.getInstance();
    int val = (loc.languageCode == 'vi') ? 0 : 1;
    await prefs.setInt('language', val);

    emit(state.copyWith(locale: loc));
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', enabled);

    emit(state.copyWith(isNotificationEnabled: enabled));
  }
}
