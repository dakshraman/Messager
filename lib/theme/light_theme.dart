import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define custom colors if needed
const primaryLight =
    Colors.blueAccent; // Change this to your desired primary color
const backgroundLight =
    Colors.white; // Change this to your desired background color
const secondaryLight =
    Colors.blue; // Change this to your desired secondary color
const lightGrey = Color.fromARGB(255, 167, 167, 167);
const black = Colors.black;
const white = Colors.white;

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white), // Adjust icon color
    titleTextStyle: TextStyle(
      color: white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    backgroundColor: primaryLight, // Set the background color for app bar
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      color: white,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: lightGrey,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
  ),
  brightness: Brightness.light, // Set brightness to light

  colorScheme: ColorScheme.light(
    background: backgroundLight, // Use your background color
    primary: primaryLight, // Use your primary color
    secondary: secondaryLight,
    tertiary: Colors.white,
    onPrimary: Colors.blueAccent.shade100,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.blueAccent,
  ),
  cardTheme: const CardTheme(
    color: Colors.blueAccent,
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    textTheme: CupertinoTextThemeData(primaryColor: Colors.blueAccent),
    applyThemeToAll: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.blueAccent[200],
    filled: true,
  ),
  buttonTheme: const ButtonThemeData(
      colorScheme:
          ColorScheme.light(primary: primaryLight, secondary: Colors.white)),
);
//upadted
