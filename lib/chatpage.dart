import 'package:Messager/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messager/card.dart';
import 'package:Messager/user.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder(
        stream: APIs.firestore.collection("users").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => ChatUser.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return const CustomCard();
                  // return Text('Name: ${list[index].name}');
                },
              );
          }
        },
      ),
    );
  }
}
