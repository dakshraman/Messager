import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import 'profile_screen.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
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
            //backgroundColor: Colors.transparent,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: const <Widget>[
                SizedBox(height: 100),
                Divider(
                  height: 2,
                ),
                CupertinoListTile.notched(
                  title: Text("Logout"),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                )
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

              //more features button
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me)));
                },
                icon: const Icon(
                  CupertinoIcons.person_alt_circle,
                  size: 30,
                ),
              ),
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
