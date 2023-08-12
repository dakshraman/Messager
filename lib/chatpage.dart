import 'package:Messager/Profile.dart';
import 'package:Messager/apis.dart';
import 'package:Messager/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messager/card.dart';
import 'package:Messager/user.dart';
import 'package:flutter/services.dart';


class ChatPage1 extends StatefulWidget {
  const ChatPage1({Key? key}) : super(key: key);

  @override
  _ChatPage1State createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  List<ChatUser> list = [];
  @override
  void initState(){
    super.initState();
    APIs.getSelfInfo();
  }

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
            tooltip: 'Profile',
            enableFeedback: true,
            icon: Icon(
              CupertinoIcons.person_alt_circle,
            ),
            onPressed: () async{
              Navigator.push(context, MaterialPageRoute(builder: (_)=> Profile(user: APIs.me)));
            },
          ),
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
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
              else {return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Connection Found!",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text("Logout"),
                        onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the login page
                        );
                      },
                    ),
                  ],
                ),
              );
             }
          }
        },
      ),
    );
  }
}

class LogoutButton extends StatelessWidget{
  Widget build(BuildContext context){
    return CupertinoButton.filled(
      child: Text("Logout"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the login page
        );
      },
    );
  }
}