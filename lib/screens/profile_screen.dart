// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          //app bar
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  size: 30,
                ),
              ),
              title: const Text(
                'Profile Screen',
              )),

          //body
          body: Form(
            key: _formKey,
            child: Card(
              elevation: 5,
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .05, vertical: mq.height * .09),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //user profile picture
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              //profile picture
                              _image != null
                                  ?

                                  //local image
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: Image.file(File(_image!),
                                          width: mq.height * .2,
                                          height: mq.height * .2,
                                          fit: BoxFit.cover))
                                  :

                                  //image from server
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(mq.height * .2),
                                        border: Border.all(
                                          color: Colors
                                              .blue, // Choose your desired border color
                                          width:
                                              5.0, // Choose your desired border width
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(mq.height * .1),
                                        child: CachedNetworkImage(
                                          width: mq.height * .2,
                                          height: mq.height * .2,
                                          fit: BoxFit.cover,
                                          imageUrl: widget.user.image,
                                          errorWidget: (context, url, error) =>
                                              const CircleAvatar(
                                                  child: Icon(
                                                      CupertinoIcons.person)),
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
                                  color: Colors.blue,
                                  child:
                                      const Icon(Icons.edit, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // for adding some space
                      SizedBox(height: mq.height * .03),

                      // user email label
                      Text(widget.user.email,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),

                      // for adding some space
                      SizedBox(height: mq.height * .05),

                      // name input field
                      TextFormField(
                        initialValue: widget.user.name,
                        onSaved: (val) => APIs.me.name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            prefixIcon: Icon(
                              CupertinoIcons.person_fill,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Your Name',
                            label: const Text(
                              'Name',
                              style: TextStyle(fontSize: 25),
                            )),
                      ),

                      // for adding some space
                      SizedBox(height: mq.height * .02),

                      // about input field
                      TextFormField(
                        initialValue: widget.user.about,
                        onSaved: (val) => APIs.me.about = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            prefixIcon: Icon(
                              CupertinoIcons.at_circle_fill,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'eg. Feeling Happy',
                            label: const Text(
                              'About',
                              style: TextStyle(fontSize: 25),
                            )),
                      ),

                      // for adding some space
                      SizedBox(height: mq.height * .05),

                      // update profile button
                      FloatingActionButton.extended(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully!');
                            });
                          }
                        },
                        label: Text(
                          'UPDATE',
                          selectionColor:
                              Theme.of(context).colorScheme.tertiary,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        icon: const Icon(CupertinoIcons.pencil_circle_fill),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
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
            child: const Text('Cancel', style: TextStyle(color: Colors.red),),
          ),
        );
      },
    );
  }
}
