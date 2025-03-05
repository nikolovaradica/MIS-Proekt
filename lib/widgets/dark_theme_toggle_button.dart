import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifelog/providers/theme_provider.dart';

class DarkThemeToggle extends StatelessWidget {
  const DarkThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
      color: Colors.grey[800],
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
