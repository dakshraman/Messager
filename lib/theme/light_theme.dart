import 'package:flutter/material.dart';

// Define custom colors if needed
const primaryColor = Colors.blueAccent;
const backgroundColor = Colors.white;
const secondaryColor = Color.fromARGB(255, 163, 207, 243);
const lightGrey = Colors.grey;
const black = Colors.black;
const white = Colors.white;

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: backgroundColor),
    titleTextStyle: TextStyle(
      color: backgroundColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    backgroundColor: primaryColor,
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      color: black,
    ),
    titleSmall: TextStyle(
      color: lightGrey,
    ),
  ),
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: backgroundColor,
    primary: lightGrey,
    secondary: secondaryColor,
  ),
);
