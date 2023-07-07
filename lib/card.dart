import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade900,
      child: CupertinoListTile.notched(
        leading: CircleAvatar(
          child: Icon(CupertinoIcons.person),
        ),
        title: Text(
          "User",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "last user message",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // trailing: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //     Icon(
        //       CupertinoIcons.person,
        //       color: Colors.lightBlue,
        //       size: 24,
        //     ),
        //     SizedBox(height: 4),
        //     Text(
        //       "time",
        //       style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
        //         fontSize: 12,
        //         color: CupertinoColors.systemGrey,
        //       ),
        //     ),
        //   ],
        // ),
        onTap: () {
          
        },
      ),
    );
  }
}
