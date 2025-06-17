import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: false,
    fontFamily: "Poppins",
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: Colors.black,
      elevation: 4,
      shadowColor: Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}