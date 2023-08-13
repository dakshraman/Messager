import 'package:Messager/Profile.dart';
import 'package:Messager/apis.dart';
import 'package:Messager/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messager/card.dart';
import 'package:Messager/user.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchList.clear();
    });
  }

  void _performSearch(String query) {
    _searchList.clear();
    if (query.isNotEmpty) {
      _list.forEach((user) {
        if (user.name.toLowerCase().contains(query.toLowerCase())) {
          _searchList.add(user);
        }
      });
    }
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
            icon: const Icon(
              CupertinoIcons.person_alt_circle,
              size: 30,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Profile(user: APIs.me)),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            // Implement your FAB functionality
          },
          child: const Icon(Icons.logout_rounded, size: 30),
        ),
      ),
      body:
      StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                  child:
                  CupertinoActivityIndicator(
                    radius: 25,
                    color: Colors.blue,
                  ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _list = data
                  ?.map((e) =>
                  ChatUser.fromJson(e.data() as Map<String, dynamic>))
                  .toList() ??
                  [];

              List<ChatUser> displayList =
              _isSearching ? _searchList : _list;

              if (displayList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      return CustomCard(user: displayList[index]);
                    },
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Connection Found!",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      CupertinoButton.filled(
                        child: const Text("Logout"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ), // Navigate to the login page
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

class LogoutButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      child: const Text("Logout"),
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

class RotatingCircularLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          gradient: LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF84CDFA), Color(0xFF5AD1CD)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: BlurCircle(radius: 5)),
            Positioned.fill(child: BlurCircle(radius: 10)),
            Positioned.fill(child: BlurCircle(radius: 25)),
            Positioned.fill(child: BlurCircle(radius: 50)),
            Center(
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(color: Colors.white, width: 5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlurCircle extends StatelessWidget {
  final double radius;

  const BlurCircle({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF9B59B6),
        backgroundBlendMode: BlendMode.overlay,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9B59B6),
            blurRadius: radius,
          ),
        ],
      ),
    );
  }
}
