import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final ChatUser user; // Add this line to accept a ChatUser object

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          drawer: Drawer(
            elevation: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Center(
                    child: Text(
                  "Messager",
                  style: Theme.of(context).textTheme.titleLarge,
                )),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     border: Border.all(
                //       color: Colors.blue, // Choose your desired border color
                //       width: 5.0, // Choose your desired border width
                //     ),
                //   ),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(15),
                //     child: CachedNetworkImage(
                //       width: mq.height * .2,
                //       height: mq.height * .2,
                //       fit: BoxFit.cover,
                //       imageUrl: widget.user.image,
                //       errorWidget: (context, url, error) => const CircleAvatar(
                //           child: Icon(CupertinoIcons.person)),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 50,
                ),
                Card(
                  child: CupertinoListTile.notched(
                    leading: const Icon(
                      CupertinoIcons.group_solid,
                      color: CupertinoColors.white,
                    ),
                    title: Text(
                      'Groups',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      // Navigate to the chats screen or perform any desired action
                    },
                  ),
                ),
                // Add more ListTile items for other options
                const Divider(),
                Card(
                  child: CupertinoListTile.notched(
                    leading: const Icon(
                      CupertinoIcons.settings,
                      color: CupertinoColors.white,
                    ),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                  ),
                ),
                const Divider(),
                Card(
                  child: CupertinoListTile.notched(
                    leading: const Icon(
                      CupertinoIcons.square_arrow_left,
                      color: CupertinoColors.systemRed,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                      ),
                    ),
                    onTap: () async {
                      //for showing progress dialog
                      Dialogs.showProgressBar(context);

                      await APIs.updateActiveStatus(false);

                      //sign out from app
                      await APIs.auth.signOut().then((value) async {
                        await GoogleSignIn().signOut().then((value) {
                          //for hiding progress dialog
                          Navigator.pop(context);

                          //for moving to home screen
                          Navigator.pop(context);

                          APIs.auth = FirebaseAuth.instance;

                          //replacing home screen with login screen
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //app bar
          appBar: AppBar(
            title: _isSearching
                ? CupertinoTextField.borderless(
                    placeholder: "Search..",
                    // decoration: const InputDecoration(
                    //     border: InputBorder.none, hintText: 'Search...'),
                    autofocus: true,
                    style: Theme.of(context).textTheme.titleMedium,
                    //when search text changes then updated search list
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                : const Text('Chats'),
            actions: [
              //search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search,
                    size: 30,
                  )),
            ],
          ),
          // ignore: sized_box_for_whitespace
          bottomNavigationBar: Container(
              color:
                  Colors.transparent, //Theme.of(context).colorScheme.primary,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.person_add_solid, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Add User",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),

          //body
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                      child: CupertinoActivityIndicator(
                    radius: 25,
                    color: Colors.grey,
                  ));

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return LiquidPullToRefresh(
                              onRefresh: _handleRefresh,
                              color: Theme.of(context).colorScheme.primary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              height: 100,
                              animSpeedFactor: 10,
                              showChildOpacityTransition: false,
                              springAnimationDurationInMilliseconds: 300,
                              child: ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                        user: _isSearching
                                            ? _searchList[index]
                                            : _list[index]);
                                  }),
                            );
                          } else {
                            return const Center(
                              child: Text('  ', style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        // No direct equivalent for contentPadding, use padding for content spacing
        title: const Row(
          children: [
            Icon(
              CupertinoIcons.person_add_solid,
              color: Colors.blueAccent,
              size: 28,
            ),
            Text(
              '  Add User',
              style: TextStyle(color: Colors.blueAccent),
            )
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
          child: CupertinoTextField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CupertinoColors.systemGrey),
            ),
            placeholder: 'Email Id',
            prefix: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                CupertinoIcons.mail_solid,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              // Hide alert dialog
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              // Hide alert dialog
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(context, 'User does not exist!');
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
