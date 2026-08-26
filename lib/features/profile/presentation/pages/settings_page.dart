import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Appearance',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                secondary: Icon(
                  Icons.brightness_4,
                  color: colorScheme.onSurface,
                ),
                activeColor: colorScheme.primary,
                value: state.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  context.read<SettingsCubit>().toggleTheme();
                },
              ),
              const Divider(),
              Text(
                'Language',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              ListTile(
                title: Text(
                  'Localization',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  state.locale.languageCode == 'en' ? 'English' : 'Arabic',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                leading: Icon(
                  Icons.language,
                  color: colorScheme.onSurface,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Select Language',
            style: TextStyle(color: colorScheme.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'English',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                onTap: () {
                  context.read<SettingsCubit>().setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Arabic',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                onTap: () {
                  context.read<SettingsCubit>().setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
