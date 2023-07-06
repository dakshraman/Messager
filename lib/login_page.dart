import 'dart:developer';
import 'package:Messager/HomePage.dart';
import 'package:Messager/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signin() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    }
    catch(error){
      print(error);
    }
    Homepage();
  }
  @override
  Widget build(BuildContext context) {

    Future<UserCredential> _signInWithGoogle() async {


      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    void _handlegsignin() {
      _signInWithGoogle().then((user) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      });
    }

    _signOut() async{
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset("images/messager.png",color: Colors.blue,height: 100,width: 100,),
              const SizedBox(height: 50,),
              const Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20, bottom: 20),
                child: CupertinoTextField(
                  controller: emailController,
                  placeholder: "Email",
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20),
                child: CupertinoTextField(
                  controller: passwordController,
                  placeholder: "Password",
                  obscureText: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password ?",
                      style: TextStyle(color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CupertinoButton.filled(
                child: const Text("Sign In",),
                onPressed: (){
                    signin();
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey[500],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Orcontinue with",
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: "images/google.png",
                    onTap: () {
                      _handlegsignin();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

