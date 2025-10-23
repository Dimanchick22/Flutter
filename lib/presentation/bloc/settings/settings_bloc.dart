import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_plus/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Events for settings
abstract class SettingsEvent {}

/// Event to change theme
class ChangeThemeEvent extends SettingsEvent {
  /// Creates a new ChangeThemeEvent
  ChangeThemeEvent(this.themePreference);

  /// Theme preference
  final ThemePreference themePreference;
}

/// Event to change locale
class ChangeLocaleEvent extends SettingsEvent {
  /// Creates a new ChangeLocaleEvent
  ChangeLocaleEvent(this.locale);

  /// Locale
  final Locale locale;
}

/// Event to load settings
class LoadSettingsEvent extends SettingsEvent {}

/// State for settings
class SettingsState {
  /// Creates a new SettingsState
  const SettingsState({
    this.themePreference = ThemePreference.system,
    this.locale = const Locale('en'),
  });

  /// Theme preference
  final ThemePreference themePreference;

  /// Locale
  final Locale locale;

  /// Creates a copy with updated fields
  SettingsState copyWith({
    ThemePreference? themePreference,
    Locale? locale,
  }) {
    return SettingsState(
      themePreference: themePreference ?? this.themePreference,
      locale: locale ?? this.locale,
    );
  }
}

/// BLoC for settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates a new SettingsBloc
  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  final SharedPreferences _prefs;

  static const String _themeKey = 'theme_preference';
  static const String _localeKey = 'locale';

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final themeIndex = _prefs.getInt(_themeKey) ?? 0;
    final localeCode = _prefs.getString(_localeKey) ?? 'en';

    emit(
      SettingsState(
        themePreference: ThemePreference.values[themeIndex],
        locale: Locale(localeCode),
      ),
    );
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setInt(_themeKey, event.themePreference.index);
    emit(state.copyWith(themePreference: event.themePreference));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setString(_localeKey, event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
