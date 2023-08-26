import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.blue),
    titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 19),
    backgroundColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: CupertinoColors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
  ),
  buttonTheme: const ButtonThemeData(
    focusColor: Colors.blueAccent,
  ),
);