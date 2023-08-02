import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Messager/user.dart';

class APIs{
  static FirebaseAuth auth  = FirebaseAuth.instance;

  static FirebaseFirestore firestore =FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async{
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async{
    final time= DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hello",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken:'',
    );
    return await firestore.collection("users").doc(user.uid).set(chatUser.toJson());
  }

}