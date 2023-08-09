import 'package:Messager/HomePage.dart';
import 'package:Messager/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:Messager/MyCustomWidget.dart';
import 'package:Messager/apis.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blueAccent,
      debugShowCheckedModeBanner: false,
      title: 'Messager',
      home: MyCustomSplashScreen()
    );
  }
}

initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
