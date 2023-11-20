// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'groups.dart';
import 'home_screen.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  final bool _isBottomSheetVisible = false;
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          if (_isBottomSheetVisible)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                //app bar
                appBar: AppBar(
                    leading: CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: const Text(
                      'Profile Screen',
                    )),
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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mq.width * .05,
                                vertical: mq.height * .05),
                            child: Column(
                              children: [
                                //user profile picture
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Stack(
                                      children: [
                                        //profile picture
                                        _image != null
                                            ? //local image
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          mq.height * .2),
                                                  border: Border.all(
                                                    color: Colors
                                                        .deepPurpleAccent, // Choose your desired border color
                                                    width:
                                                        5.0, // Choose your desired border width
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            mq.height * .1),
                                                    child: Image.file(
                                                        File(_image!),
                                                        width: mq.height * .2,
                                                        height: mq.height * .2,
                                                        fit: BoxFit.cover)),
                                              )
                                            :

                                            //image from server
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          mq.height * .2),
                                                  border: Border.all(
                                                    color: Colors
                                                        .deepPurpleAccent, // Choose your desired border color
                                                    width:
                                                        5.0, // Choose your desired border width
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          mq.height * .1),
                                                  child: CachedNetworkImage(
                                                    width: mq.height * .2,
                                                    height: mq.height * .2,
                                                    fit: BoxFit.cover,
                                                    imageUrl: widget.user.image,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const CircleAvatar(
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .person)),
                                                  ),
                                                ),
                                              ),

                                        //edit image button
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: MaterialButton(
                                            elevation: 1,
                                            onPressed: () {
                                              _showBottomSheet();
                                            },
                                            shape: const CircleBorder(),
                                            color: Colors.deepPurpleAccent,
                                            child: const Icon(
                                                CupertinoIcons.pen,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ), // for adding some space
                                SizedBox(height: mq.height * .02),
                                // user email label
                                Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.user.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                SizedBox(height: mq.height * .02),
                                // name input field
                                const Text(
                                  "Name",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: mq.height * .01),
                                TextFormField(
                                  initialValue: widget.user.name,
                                  onSaved: (val) => APIs.me.name = val ?? '',
                                  validator: (val) =>
                                      val != null && val.isNotEmpty
                                          ? null
                                          : 'Required Field',
                                  decoration: InputDecoration(
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    prefixIcon: Icon(
                                      CupertinoIcons.person_crop_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'Your Name',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                ),
                                // for adding some space
                                SizedBox(height: mq.height * .02),
                                // about input field
                                const Text(
                                  "About",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: mq.height * .01),
                                TextFormField(
                                  initialValue: widget.user.about,
                                  onSaved: (val) => APIs.me.about = val ?? '',
                                  validator: (val) =>
                                      val != null && val.isNotEmpty
                                          ? null
                                          : 'Required Field',
                                  decoration: InputDecoration(
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    prefixIcon: Icon(
                                      CupertinoIcons.grid_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'eg. Feeling Happy',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                  ),
                                ),

                                // for adding some space
                                SizedBox(height: mq.height * .02),

                                // update profile button
                                CupertinoButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      APIs.updateUserInfo().then((value) {
                                        Dialogs.showSnackbar(context,
                                            'Profile Updated Successfully!');
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.pencil_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      Text(
                                        ' UPDATE',
                                        selectionColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }),
        ],
      ),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5), // Adjust the blur intensity as needed
                child: Container(
                  color: Colors
                      .transparent, // You can set a background color here if needed
                ),
              ),
            ),
            CupertinoActionSheet(
              title: const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: const Image(
                    height: 50,
                    width: 50,
                    image: AssetImage('images/add_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );

                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: const Image(
                    height: 50,
                    width: 50,
                    image: AssetImage(
                      'images/camera.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
