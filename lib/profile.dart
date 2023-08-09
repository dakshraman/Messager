import 'package:Messager/apis.dart';
import 'package:Messager/chatpage.dart';
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
  String newImageUrl = '';

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
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                        ClipRRect(borderRadius: BorderRadius.circular(300),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            height: 200,
                            width: 200,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error)=> const CircleAvatar(child: Icon(CupertinoIcons.person),),
                          ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child:
                          MaterialButton(
                            elevation: 1,
                            shape: const CircleBorder(),
                            color: Colors.blue,
                            child: IconButton(onPressed: (){_showImagePickerBottomSheet();}, icon: const Icon(Icons.edit,color: Colors.white,)), onPressed: (){_showImagePickerBottomSheet();}
                          ),
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Text(widget.user.email, style: const TextStyle(color: Colors.blue, fontSize: 20),),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  LogoutButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        newImageUrl = pickedFile.path; // Use the picked file path as the new image URL
      });
    }
  }
}


