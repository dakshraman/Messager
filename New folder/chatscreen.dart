  import 'dart:convert';
  import 'dart:developer';

  import 'package:Messager/apis.dart';
  import 'package:Messager/user.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

  class ChatScreen extends StatefulWidget {
    final ChatUser user;

    const ChatScreen({Key? key, required this.user}) : super(key: key);

    @override
    _ChatScreenState createState() => _ChatScreenState();


  }

  class _ChatScreenState extends State<ChatScreen> {

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body:
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState){
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(child: CupertinoActivityIndicator(radius: 25 ,color: Colors.blue,));
                        case ConnectionState.active:
                        case ConnectionState.done:
                           final data = snapshot.data?.docs;
                           log('Data: ${jsonEncode(data![0].data())}');
                          // list = data?.map((e) => ChatUser.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
                          final _list = ['hii','hello'];
                          if (_list.isNotEmpty){
                            return Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  //return CustomCard(user: list[index],);
                                  return Text('Message: ${_list[index]}');
                                },
                              ),
                            );
                          }
                          else {return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Say Hi 👋",
                                  style: TextStyle(fontSize: 25, color: Colors.black),
                                ),
                              ],
                            ),
                          );
                       }
                      }
                    },
                  ),
                ),
                _chatinput()
              ],
            )
        ),
      );
    }

    Widget _appBar() {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.image),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Online", // You can replace this with the actual status
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(), // Adds flexible space to push the following widget to the right
          IconButton(
            onPressed: () {
              // Handle search button press
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      );
    }

    Widget _chatinput() {
      return Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.blueAccent,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.smiley,color: Colors.white,)),
                  const Expanded(
                    child: CupertinoTextField(
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                      placeholder: "Message",
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.photo,color: Colors.white,)),
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.camera,color: Colors.white,)),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: MaterialButton(onPressed: (){},
              minWidth: 30,
              shape: const CircleBorder(),
              color: Colors.blue,
              padding: const EdgeInsets.only(left: 10,right: 5,top: 10,bottom: 10),
              child: const Icon(Icons.send_sharp, size: 30,),),
          )
        ],
      );
    }

  }
