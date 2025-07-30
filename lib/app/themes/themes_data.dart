import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFD4AF37); 
  static const Color secondaryColor = Color(0xFF121212); 
  static const Color accentColor = Color(0xFFF5F5F5); 
  static const Color backgroundColor = Color(0xFF000000); 
  static const Color cardColor = Color(0xFF1E1E1E); 
  static const Color errorColor = Color(0xFFE57373); 

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: accentColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: accentColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: accentColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    color: Color(0xFFBDBDBD),
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 8,
    shadowColor: primaryColor.withOpacity(0.3),
  );

  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor, width: 2),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Playfair Display',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      iconTheme: IconThemeData(color: primaryColor),
    ),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      displayMedium: subheadingStyle,
      bodyLarge: bodyStyle,
      bodyMedium: bodyStyle,
      bodySmall: captionStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: outlinedButtonStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      side: const BorderSide(color: primaryColor, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
ThemeData getApplicationTheme() {
  return AppTheme.darkTheme;
}