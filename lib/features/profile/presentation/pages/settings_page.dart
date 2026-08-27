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
            ],
          );
        },
      ),
    );
  }
}
