import 'dart:io';
import 'package:Messager/apis.dart';
import 'package:Messager/chatpage.dart';
import 'package:Messager/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Messager/user.dart';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  final ChatUser user;
  const Profile({super. key, required this.user});


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();
  String? _image;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Profile'),
          centerTitle: true,
        ),


        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      children: [
                        _image != null ?
                        Image.file(File(_image!),
                            )
                            :
                        ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) =>
                            const CircleAvatar(child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                        SizedBox(height: 20,),
                        CupertinoButton.filled(
                            onPressed: (){_showImagePickerBottomSheet();}, child: Text("Change Profile Pic"),
                        )
                      ]
                  ),
                  const SizedBox(height: 30),
                  Text(widget.user.email, style: const TextStyle(color: Colors.blue, fontSize: 20),),
                  const SizedBox(height: 30),
                  TextFormField(
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator:  (val) => val != null && val.isNotEmpty ? null: 'Required Field',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(CupertinoIcons.person_alt, color: Colors.blue,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: "Your Name",
                      label: const Text("Name"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator:  (val) => val != null && val.isNotEmpty ? null: 'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(CupertinoIcons.at_circle_fill, color: Colors.blue,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: "Status",
                      label: const Text("About"),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CupertinoButton.filled(
                    child: const Text("Update"),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Update Successful'),
                                content: Text('Your profile has been updated.'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    color: Colors.red,
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
            ),
          ),
        ),
      ),
    );
  }
  void _showImagePickerBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose an option'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery);
              },
              child: Text('Choose from Gallery'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera);
              },
              child: Text('Take a Photo'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
      await APIs.updateProfilePicture(File(_image!));
    }
  }
}
