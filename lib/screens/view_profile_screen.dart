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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.user.name),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 250, bottom: 250, left: 50, right: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:  Colors.grey//Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.height * .2),
                    border: Border.all(
                      color: Colors.deepPurpleAccent, // Choose your desired border color
                      width: 5.0, // Choose your desired border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .1,
                      height: mq.height * .1,
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
                  style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
                ),
                SizedBox(height: mq.height * .02),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Name: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'About: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.user.about,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
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
