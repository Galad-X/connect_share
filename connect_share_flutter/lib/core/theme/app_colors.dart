import 'package:flutter/material.dart';

/// ConnectShare App Color Palette
class AppColors {
  AppColors._();

  // Primary Colors
  /// Matcha Green - PMS 4179
  /// A soft, muted green reminiscent of matcha tea
  static const Color matcha = Color(0xFF96A480);

  /// Deep Army Green - Pantone 19-0414 TCX Forest Night
  /// A deep, sophisticated forest green
  static const Color deepArmy = Color(0xFF2C3E2D);

  /// Lemon Twist - SW 6909
  /// A bright, energetic yellow-green
  static const Color lemonTwist = Color(0xFFBFD641);

  // Color Variations
  /// Light matcha for backgrounds and subtle accents
  static const Color matchaLight = Color(0xFFB8C4A5);

  /// Darker matcha for text on light backgrounds
  static const Color matchaDark = Color(0xFF7A8A6B);

  /// Very light matcha for card backgrounds
  static const Color matchaVeryLight = Color(0xFFE8EDE2);

  static final Color glassBackgroundColor = AppColors.white.withAlpha(26);
  static final Color glassBorderColor = AppColors.white.withAlpha(52);
  static final textFieldFillColor = AppColors.white.withAlpha(13);
  static const textColor = AppColors.textTertiary;
  static final Color hintColor = AppColors.textTertiary;

  /// Light deep army for secondary elements
  static const Color deepArmyLight = Color(0xFF3A4F3C);

  /// Darker deep army for high contrast text
  static const Color deepArmyDark = Color(0xFF1A2B1C);

  /// Light lemon twist for backgrounds
  static const Color lemonTwistLight = Color(0xFFD4E36A);

  /// Darker lemon twist for text and emphasis
  static const Color lemonTwistDark = Color(0xFFA8B535);

  // Neutral Colors
  /// Primary text color (using deep army dark)
  static const Color textPrimary = deepArmyDark;

  /// Secondary text color (lighter for less important text)
  static const Color textSecondary = Color(0xFF5A6B5C);

  /// Tertiary text color (for hints and disabled text)
  static const Color textTertiary = Color(0xFF8A9B8C);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Off-white background
  static const Color background = Color(0xFFFAFBF9);

  /// Light gray for dividers and borders
  static const Color divider = Color(0xFFE5E8E2);

  /// Medium gray for inactive elements
  static const Color inactive = Color(0xFFB8C4A5);

  // Status Colors
  /// Success green (derived from matcha)
  static const Color success = Color(0xFF7A8A6B);

  /// Warning color (using lemon twist)
  static const Color warning = lemonTwist;

  /// Error red
  static const Color error = Color(0xFFD32F2F);

  /// Info blue
  static const Color info = Color(0xFF1976D2);

  // Gradients
  /// Primary gradient from matcha to deep army
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [matcha, deepArmy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient with lemon twist
  static const LinearGradient accentGradient = LinearGradient(
    colors: [lemonTwistLight, lemonTwist],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Subtle background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [white, matchaVeryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Material Color Swatches
  /// Primary color swatch based on matcha
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF96A480,
    <int, Color>{
      50: Color(0xFFF4F6F2),
      100: Color(0xFFE8EDE2),
      200: Color(0xFFD1DCC5),
      300: Color(0xFFB8C4A5),
      400: Color(0xFFA7B692),
      500: Color(0xFF96A480), // Main matcha color
      600: Color(0xFF8A9874),
      700: Color(0xFF7A8A6B),
      800: Color(0xFF6B7B5E),
      900: Color(0xFF5A6B50),
    },
  );

  /// Accent color swatch based on lemon twist
  static const MaterialColor accentSwatch = MaterialColor(
    0xFFBFD641,
    <int, Color>{
      50: Color(0xFFF8FBE8),
      100: Color(0xFFF0F5C6),
      200: Color(0xFFE7EFA0),
      300: Color(0xFFDDE97A),
      400: Color(0xFFD4E36A),
      500: Color(0xFFBFD641), // Main lemon twist color
      600: Color(0xFFB5CC3A),
      700: Color(0xFFA8B535),
      800: Color(0xFF9CA530),
      900: Color(0xFF8A9025),
    },
  );
}

/// Extension on BuildContext to easily access theme colors
extension AppColorsExtension on BuildContext {
  /// Get the current theme's color scheme with app colors
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;

  /// Quick access to app colors
  AppColors get colors => AppColors._();
}
// AppTheme.dart
// ... (keep existing AppColors and AppTheme structure) ...

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        primarySwatch: AppColors.primarySwatch,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.matcha,
          brightness: Brightness.light,
          primary: AppColors.matcha,
          secondary: AppColors.lemonTwist,
          tertiary: AppColors.deepArmy,
          surface: AppColors.background, // Used by BottomNav if not overridden
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.deepArmyDark,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
          onError: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.background, // Base background
        appBarTheme: AppBarTheme(
          // Default AppBar, can be overridden for glassmorphism
          backgroundColor: AppColors.matcha,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.matcha,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.deepArmy,
              textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.matcha, width: 2),
          ),
          filled: true,
          fillColor: AppColors.white, // Default fill for text fields
          hintStyle: TextStyle(color: AppColors.textTertiary),
          labelStyle: TextStyle(color: AppColors.textSecondary),
        ),
        cardTheme: CardThemeData(
          // Default card, not glassmorphic
          color: AppColors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              AppColors.white.withAlpha(229), // Semi-transparent white
          selectedItemColor: AppColors.matcha,
          unselectedItemColor: AppColors.textSecondary.withAlpha(204),
          elevation: 0, // Important for custom background/glass effect
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
        // Add other theme properties as needed
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        primarySwatch: AppColors.primarySwatch,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.matcha,
          brightness: Brightness.dark,
          primary: AppColors.matchaLight,
          secondary: AppColors.lemonTwistLight,
          tertiary: AppColors.deepArmyLight,
          surface: AppColors.deepArmy, // Used by BottomNav if not overridden
          background: AppColors.deepArmyDark,
          error: AppColors.error,
          onPrimary: AppColors.deepArmyDark,
          onSecondary: AppColors.deepArmyDark,
          onSurface: AppColors.white.withAlpha(221),
          onBackground: AppColors.white.withAlpha(221),
          onError: AppColors.deepArmyDark,
        ),
        scaffoldBackgroundColor: AppColors.deepArmyDark, // Base background
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.deepArmy,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.matchaLight,
              foregroundColor: AppColors.deepArmyDark,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.matchaLight,
              textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.deepArmyLight.withAlpha(128)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.matchaLight, width: 2),
          ),
          filled: true,
          fillColor: AppColors.deepArmy.withAlpha(128), // Darker fill
          hintStyle: TextStyle(color: AppColors.white.withAlpha(152)),
          labelStyle: TextStyle(color: AppColors.white.withAlpha(204)),
        ),
        cardTheme: CardThemeData(
          color: AppColors.deepArmy,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              AppColors.deepArmyDark.withAlpha(204), // Semi-transparent dark
          selectedItemColor: AppColors.matchaLight,
          unselectedItemColor: AppColors.white.withAlpha(178),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
      );
}
