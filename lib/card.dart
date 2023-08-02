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
            leading: CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
            title: Text(
              "User",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "last user message",
              style: TextStyle(
                color: Colors.grey,
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> ChatPage()));
            },
          ),
        ),
      ),
    );
  }
}


//


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = [];

  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true,
      ));
      // Simulate receiving a reply after a short delay
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChatMessage(
            text: "Hello! This is a reply.",
            isMe: false,
          ));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          _InputField(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final Function(String) sendMessage;
  final TextEditingController _textController = TextEditingController();

  _InputField({required this.sendMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              String message = _textController.text;
              if (message.isNotEmpty) {
                sendMessage(message);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

