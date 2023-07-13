import 'dart:convert';
import 'dart:math';
import 'package:Messager/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Messager/card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection("users").snapshots(),
        builder: (context, snapshot) {
          final list = [10];
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              print("Data: ${jsonEncode(i.data())}" as num);
              list.add(i.data()['name']);
            }
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return CustomCard();
              // return Text('Name: ${list[index]}');
            },
          );
        },
      ),
    );
  }
}
