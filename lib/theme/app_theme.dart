import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoudeyaTheme {
  static const Color accent    = Color(0xFF00E5A0);
  static const Color blue      = Color(0xFF38B6FF);
  static const Color danger    = Color(0xFFFF4D4D);
  static const Color warning   = Color(0xFFFFB800);
  static const Color accent2   = Color(0xFFB388FF);
  static const Color accent3   = Color(0xFF00BCD4);
  static const Color bg        = Color(0xFF0B0F0C);
  static const Color surface   = Color(0xFF131A15);
  static const Color surface2  = Color(0xFF1A241C);
  static const Color surface3  = Color(0xFF1E2920);
  static const Color border    = Color(0xFF243027);
  static const Color text      = Color(0xFFE8F5EE);
  static const Color muted     = Color(0xFF6B8F72);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: blue,
      error: danger,
      surface: surface,
      onPrimary: Color(0xFF0B0F0C),
      onSurface: text,
    ),
    textTheme: GoogleFonts.syneTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: text),
        displayMedium: TextStyle(color: text),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
        labelLarge: TextStyle(color: text),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: text,
      elevation: 0,
      titleTextStyle: GoogleFonts.syne(
        color: text, fontSize: 18, fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: text),
    ),
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: border),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: accent.withOpacity(0.15),
      iconThemeData: const MaterialStatePropertyAll(
        IconThemeData(color: muted),
      ),
      labelTextStyle: MaterialStatePropertyAll(
        GoogleFonts.syne(color: muted, fontSize: 11),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Color(0xFF0B0F0C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.syne(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface3,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: muted),
      hintStyle: const TextStyle(color: muted),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: Color(0xFF0B0F0C),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface3,
      labelStyle: const TextStyle(color: text),
      side: const BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
