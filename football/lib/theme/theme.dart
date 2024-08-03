import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
    fontFamily: 'Prompt',
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(255, 255, 119, 0),
    colorScheme: const ColorScheme.light(
        surface: Colors.white,
        primary: Color.fromARGB(255, 26, 26, 26),
        secondary: Color.fromARGB(255, 75, 75, 75)));

ThemeData darkmode = ThemeData(
    fontFamily: 'Prompt',
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 255, 119, 0),
    colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 45, 45, 45),
        primary: Color.fromARGB(255, 255, 255, 255),
        secondary: Color.fromARGB(255, 255, 255, 255)));
