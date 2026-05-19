import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.secondary;

  static ThemeData getTheme(bool isHindi) {
    final TextTheme baseTextTheme = isHindi
        ? GoogleFonts.notoSansDevanagariTextTheme()
        : GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.cardBg,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 14, color: AppColors.textDark),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: AppColors.textMedium),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: AppColors.textMuted),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
      ).apply(
        bodyColor: AppColors.textMedium,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBg,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark, size: 24),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textMedium, fontSize: 14),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBackground,
        labelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: const BorderSide(color: Colors.transparent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 24),
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        elevation: 16,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

