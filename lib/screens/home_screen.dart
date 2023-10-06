import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Messager/screens/groups.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String? _image;

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
          backgroundColor: Theme.of(context).colorScheme.background,
          drawer: Drawer(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: [
                            //profile picture
                            _image != null
                                ?
                                //local image
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .2),
                                      border: Border.all(
                                        color: Colors
                                            .white, // Choose your desired border color
                                        width:
                                            5.0, // Choose your desired border width
                                      ),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            mq.height * .1),
                                        child: Image.file(File(_image!),
                                            width: mq.height * .1,
                                            height: mq.height * .1,
                                            fit: BoxFit.cover)),
                                  )
                                :
                                //image from server
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .2),
                                      border: Border.all(
                                        color: Colors
                                            .deepPurpleAccent, // Choose your desired border color
                                        width:
                                            5.0, // Choose your desired border width
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: CachedNetworkImage(
                                        width: mq.height * .1,
                                        height: mq.height * .1,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.user.image,
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                child: Icon(CupertinoIcons
                                                    .person_alt_circle)),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Center(
                    child: Text(
                      widget.user.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: CupertinoListTile.notched(
                    leading: const Icon(
                      CupertinoIcons.group_solid,
                      color: CupertinoColors.white,
                      size: 30,
                    ),
                    title: Text(
                      'Groups',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GroupsPage()));
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: CupertinoListTile.notched(
                    leading: const Icon(
                      CupertinoIcons.settings,
                      color: CupertinoColors.white,
                    ),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
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
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          ),

          //app bar
          appBar: AppBar(
            title: _isSearching
                ? CupertinoTextField(
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    placeholder: "  Search..",
                    showCursor: true,
                    autofocus: true,
                    style: Theme.of(context).textTheme.titleMedium,
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
                        ? CupertinoIcons.xmark_square_fill
                        : CupertinoIcons.search,
                  )),
            ],
          ),
          // ignore: sized_box_for_whitespace
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              _addChatUserDialog();
            },
            child: const Icon(CupertinoIcons.person_add_solid,
                color: Colors.white),
          ),

          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            activeColor: Colors.white,
            inactiveColor: Colors.grey.shade500,
            currentIndex:
                _currentIndex, // You need to maintain a currentIndex variable
            onTap: (int index) {
              // Handle navigation based on the tapped index
              setState(() {
                _currentIndex = index; // Update the currentIndex
              });
              switch (index) {
                case 0:
                  // Navigate to the Groups page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(user: APIs.me),
                    ),
                  );
                  break;
                case 1:
                  // Navigate to the Settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroupsPage(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: APIs.me),
                    ),
                  );
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chat_bubble_fill,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.group_solid,
                  size: 40,
                ),
                label: 'Groups',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings_solid),
                label: 'Settings',
              ),
            ],
          ),

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
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5, sigmaY: 5), // Adjust the blur intensity as needed
              child: Container(
                color: Colors
                    .transparent, // You can set a background color here if needed
              ),
            ),
          ),
          CupertinoAlertDialog(
            // No direct equivalent for contentPadding, use padding for content spacing
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.person_crop_circle_fill_badge_plus,
                  color: Colors.blueAccent,
                  //size: 28,
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
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
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
        ],
      ),
    );
  }
}
