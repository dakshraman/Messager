import 'package:Messager/chatpage.dart';
import 'package:Messager/chatscreen.dart';
import 'package:Messager/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final ChatUser user;

  const CustomCard({Key? key, required this.user});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3), // changes the position of the shadow
              ),
            ],
          ),
          child: CupertinoListTile.notched(
            backgroundColor: Colors.white,
            backgroundColorActivated: Colors.grey[300],
            leading: ClipOval(
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            title: Text(
              widget.user.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.user.about,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
              );
            },
          ),
        ),
      ),
    );
  }
}
