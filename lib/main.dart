import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'ui.dart';
import 'sunday_flow.dart';
import 'presentation/splash/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'database.dart';
import 'seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (Assuming default options for now)
  // For web, options must be provided, but this works for android/ios with google-services.json
  try {
    await Firebase.initializeApp();
    await DatabaseService.initializeOfflinePersistence();
  } catch (e) {
    print("Firebase initialization error (might need firebase_options.dart): $e");
  }

  runApp(
    const ProviderScope(
      child: SystemIQFitnessApp(),
    ),
  );
}

class AppTheme {
  static const Color backgroundBase = Color(0xFF000000);
  static const Color surfaceElevation1 = Color(0xFF111111);
  static const Color surfaceElevation2 = Color(0xFF1A1A1A);
  static const Color surfaceElevation3 = Color(0xFF242424);
  static const Color borders = Color(0xFF2A2A2A);
  static const Color primaryAccent = Color(0xFFCCFF00); // High Voltage Lime
  static const Color secondaryAccent = Color(0xFF00E5FF); // Electric Cyan
  
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color destructive = Color(0xFFFF5252);
  static const Color warmupBadge = Color(0xFFFFB74D);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textTertiary = Color(0xFF555555);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBase,
      colorScheme: const ColorScheme.dark(
        background: backgroundBase,
        surface: surfaceElevation1,
        surfaceContainerLow: surfaceElevation1,
        surfaceContainer: surfaceElevation2,
        surfaceContainerHigh: surfaceElevation3,
        primary: primaryAccent,
        secondary: secondaryAccent,
        error: destructive,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
      ).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class SystemIQFitnessApp extends StatelessWidget {
  const SystemIQFitnessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F.I.T.',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
