import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF141414),
    primary: Colors.blueGrey,
    secondary: Colors.grey[800]!,
    tertiary: Colors.grey[700]!,
    inversePrimary: Colors.grey[300]!,
  ),
);
