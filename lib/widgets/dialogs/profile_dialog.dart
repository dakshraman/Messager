import 'dart:ui'; // Import this for the BackdropFilter

import 'package:Messager/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';
import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background blur effect for the entire page
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5, sigmaY: 5), // Adjust the blur intensity as needed
            child: Container(
              color: Colors
                  .transparent, // You can set a background color here if needed
            ),
          ),
        ),
        Center(
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User profile picture
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.height * .2),
                    border: Border.all(
                      color: Colors.blue, // Choose your desired border color
                      width: 5.0, // Choose your desired border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      imageUrl: user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // User name
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  // Close the dialog
                  Navigator.pop(context);

                  // Move to view profile screen
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                child: const Text(
                  'View Profile',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  // Close the dialog
                  Navigator.pop(context);
                },
                isDestructiveAction: true,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
