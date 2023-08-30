import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define custom colors if needed
const primaryDark = Colors.black;
const backgroundDark = Colors.grey;
const secondaryDark = Color.fromARGB(255, 52, 52, 52);
const lightGrey = Color.fromARGB(255, 167, 167, 167);
const black = Colors.black;
const white = Colors.white;

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.blueAccent), // Adjust icon color
    titleTextStyle: TextStyle(
      color: white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    backgroundColor: black, // Set the background color for app bar
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      color: white,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: lightGrey,
    ),
  ),
  brightness: Brightness.dark, // Set brightness to dark

  colorScheme: ColorScheme.dark(
    background: backgroundDark, // Use your background color
    primary: primaryDark, // Use your primary color
    secondary: secondaryDark,
    tertiary: Colors.blueAccent,
    onPrimary: Colors.grey.shade700,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.blueAccent,
  ),
  cardTheme: const CardTheme(
    color: Colors.black,
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    brightness: Brightness.dark,
    //primaryColor: Colors.black,
    applyThemeToAll: true,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.grey,
    filled: true,
  ),
);
