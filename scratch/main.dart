import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui.dart';
import 'sunday_flow.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SystemIQFitnessApp(),
    ),
  );
}

class SystemIQFitnessApp extends StatelessWidget {
  const SystemIQFitnessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SystemIQ Fitness',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000), // Amoled Black
        primaryColor: const Color(0xFF007AFF),
        fontFamily: 'Roboto',
      ),
      home: AmoledLoggingScreen(),
    );
  }
}
