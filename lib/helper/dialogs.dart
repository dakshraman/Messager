import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import this for the ImageFilter class

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Background with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color:
                    Colors.black.withOpacity(0.5), // Adjust opacity as needed
              ),
            ),
            CupertinoAlertDialog(
              title: Text(msg),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Stack(
          children: [
            // Background with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color:
                    Colors.black.withOpacity(0.5), // Adjust opacity as needed
              ),
            ),
            const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
