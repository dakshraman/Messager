// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.blue),
      titleTextStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
      backgroundColor: Colors.white,
    ),
    textTheme: const TextTheme(),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.white,
      primary: Colors.grey[200]!,
      secondary: Colors.blueAccent,
    ));
