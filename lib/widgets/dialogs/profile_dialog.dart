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
    return CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              imageUrl: user.image,
              errorWidget: (context, url, error) =>
              const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(height: 12),
          // User name
          Text(
            user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
          child: const Text('View Profile'),
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
    );
  }
}
