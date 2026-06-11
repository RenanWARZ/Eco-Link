import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF0F1711);
  static const inkSoft = Color(0xFF4A5C4E);
  static const inkMuted = Color(0xFF8FA593);
  static const line = Color(0xFFE4EBE5);
  static const surface = Color(0xFFF8FAF8);
  static const white = Color(0xFFFFFFFF);

  static const green = Color(0xFF2D7A3A);
  static const greenMid = Color(0xFF3D9B4A);
  static const greenPop = Color(0xFF4ABA59);
  static const greenBg = Color(0xFFEEF6EF);
  static const greenLine = Color(0xFFC5E0C9);
  static const greenDark = Color(0xFF1A4D24);

  static const amber = Color(0xFFD97706);
  static const amberBg = Color(0xFFFEF3C7);
  static const red = Color(0xFFC0392B);
  static const redBg = Color(0xFFFDECEA);
  static const blue = Color(0xFF2563EB);
  static const blueBg = Color(0xFFEFF6FF);

  static const headerGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [greenDark, green],
  );

  static const headerSchedule = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF064E3B), Color(0xFF059669)],
  );

  static const headerComplaint = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7F1D1D), red],
  );

  static const headerRanking = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        primary: AppColors.green,
        surface: AppColors.surface,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.inkMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.green,
          side: const BorderSide(color: AppColors.greenLine, width: 1.5),
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.inkMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
