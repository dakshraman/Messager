import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Card(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: mq.width, height: mq.height * .03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.height * .2),
                    border: Border.all(
                      color: Colors.white, // Choose your desired border color
                      width: 5.0, // Choose your desired border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                SizedBox(height: mq.height * .03),
                Text(
                  widget.user.email,
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
                SizedBox(height: mq.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'About: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      widget.user.about,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
