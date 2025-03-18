import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.blue,
    secondary: Colors.grey[200]!,
    tertiary: Colors.grey[100]!,
    inversePrimary: Colors.black,
  ),
);
