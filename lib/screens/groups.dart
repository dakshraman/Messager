// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';

class groupsPage extends StatefulWidget {
  final ChatUser user;

  const groupsPage({super.key, required this.user});

  @override
  State<groupsPage> createState() => _groupsPageState();
}

class _groupsPageState extends State<groupsPage> {
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
          title: const Text("Groups"),
        ),
        body: Center(
          child: CupertinoButton.filled(
            onPressed: () {},
            child: const Text(
              "Comming Soon",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
