import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_plus/core/theme/app_theme.dart';
import 'package:planner_plus/presentation/bloc/settings/settings_bloc.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  /// Creates a new SettingsScreen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Theme section
          _buildSectionHeader(context, 'Appearance'),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_getThemeLabel(state.themePreference)),
                onTap: () => _showThemeDialog(context, state.themePreference),
              );
            },
          ),
          const Divider(),
          // Language section
          _buildSectionHeader(context, 'Language'),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(_getLanguageLabel(state.locale)),
                onTap: () => _showLanguageDialog(context, state.locale),
              );
            },
          ),
          const Divider(),
          // About section
          _buildSectionHeader(context, 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0+1'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('About Planner+'),
            subtitle: const Text('A production-quality task planner'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getThemeLabel(ThemePreference preference) {
    return switch (preference) {
      ThemePreference.system => 'System',
      ThemePreference.light => 'Light',
      ThemePreference.dark => 'Dark',
    };
  }

  String _getLanguageLabel(Locale locale) {
    return switch (locale.languageCode) {
      'en' => 'English',
      'ru' => 'Русский',
      _ => locale.languageCode,
    };
  }

  void _showThemeDialog(BuildContext context, ThemePreference current) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemePreference.values.map((preference) {
            return RadioListTile<ThemePreference>(
              title: Text(_getThemeLabel(preference)),
              value: preference,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(ChangeThemeEvent(value));
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, Locale current) {
    final locales = [
      const Locale('en'),
      const Locale('ru'),
    ];

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: locales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(_getLanguageLabel(locale)),
              value: locale,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(ChangeLocaleEvent(value));
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Planner+',
      applicationVersion: '1.0.0+1',
      applicationIcon: const FlutterLogo(size: 64),
      children: [
        const SizedBox(height: 16),
        const Text(
          'A production-quality task planner with offline mode and synchronization.',
        ),
        const SizedBox(height: 8),
        const Text('Features:'),
        const SizedBox(height: 4),
        const Text('• Task management with CRUD operations'),
        const Text('• Offline-first architecture'),
        const Text('• Automatic synchronization'),
        const Text('• Search and filtering'),
        const Text('• Multiple themes'),
        const Text('• Internationalization'),
      ],
    );
  }
}
