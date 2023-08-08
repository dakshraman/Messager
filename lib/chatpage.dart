import 'package:Messager/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messager/card.dart';
import 'package:Messager/user.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage1 extends StatefulWidget {
  const ChatPage1({Key? key}) : super(key: key);

  @override
  _ChatPage1State createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            enableFeedback: true,
            icon: Icon(
              CupertinoIcons.arrow_turn_down_right,
            ),
            onPressed: () async{
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
          ),
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: APIs.firestore.collection("users").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                  child: CupertinoActivityIndicator(radius: 25 ,color: Colors.blue,));
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => ChatUser.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];

              if (list.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CustomCard(user: list[index],);
                    // return Text('Name: ${list[index].name}');
                  },
                ),
              );
              }
              else {return const Center(child: const Text("No Connection Found!", style: TextStyle(fontSize: 25, color: Colors.black)));}
          }
        },
      ),
    );
  }
}
