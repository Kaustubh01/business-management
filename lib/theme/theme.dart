import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(248, 249, 250,1),
    primary: Color.fromRGBO(221, 231, 241, 1),
    tertiary: Colors.white,
    secondary: Color.fromRGBO(255, 113, 113,1),
    onSecondaryFixedVariant: Color.fromRGBO(198, 235, 197,1),
    inversePrimary: Color.fromRGBO(33, 37, 41,1)
  )
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromRGBO(34, 40, 49,1),
    primary: Color.fromRGBO(57, 62, 70,1),
    tertiary: Colors.black,
    secondary: Color.fromRGBO(255, 211, 105,1),
    inversePrimary: Color.fromRGBO(238, 238, 238,1)
  )
);