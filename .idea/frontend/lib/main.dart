import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'screens/demo/demo_home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TaskAppDemo(),
    ),
  );
}

class TaskAppDemo extends StatelessWidget {
  const TaskAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const DemoHomeScreen(),
    );
  }
}
