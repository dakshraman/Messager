import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Messager/user.dart';


class APIs{
  static FirebaseAuth auth  = FirebaseAuth.instance;

  static FirebaseFirestore firestore =FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static late ChatUser me;

  static Future<bool> userExists() async{
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async{
    await firestore.collection("users").doc(user.uid).get().then((user) async {
        if(user.exists){
          me=ChatUser.fromJson(user.data()!);
        }
        else{
         await createUser().then((value) => getSelfInfo());
        }

      },
    );
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

  static  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return APIs.firestore.collection("users").where('id', isEqualTo: user.uid).snapshots();
  }

  static Future<void> updateUserInfo() async{
    await firestore.collection("users").doc(user.uid).update({
      'name': me.name,
      'about': me.about,
      'image': me.image,
    });
  }
}