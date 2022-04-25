//
import 'package:flutter/material.dart';

ThemeData myThemeData() {
  return ThemeData(
    // primarySwatch: Colors.red,
    fontFamily: 'poppins',
    appBarTheme: const AppBarTheme(
      elevation: 0.1,
      centerTitle: true,
    ),
    // scaffoldBackgroundColor: Colors.yellow,
    scaffoldBackgroundColor: const Color(0xFFF6FBFF),
    inputDecorationTheme:
        const InputDecorationTheme(border: OutlineInputBorder()),
  );
}
