import 'dart:developer';
import 'package:Messager/HomePage.dart';
import 'package:Messager/apis.dart';
import 'package:Messager/card.dart';
import 'package:Messager/chatpage.dart';
import 'package:Messager/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:particles_flutter/particles_flutter.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false; // Variable to track loading state

  Future<void> signin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (error) {
      print(error);
    }
    Homepage();
  }

  // Function to handle Google sign-in
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
    setState(() {
      loading = true; // Set loading to true when the sign-in process starts
    });

    _signInWithGoogle().then((user) async{
      if (user !=null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if((await APIs.userExists())){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatPage1()),);
        }
        else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatPage1()),);
            }
          );
        }

      }
    }).catchError((error) {
      print(error);
    }).whenComplete(() {
      setState(() {
        loading = false; // Set loading to false when the sign-in process completes
      });
    });
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        background(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                  // const SizedBox(height: 30,),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  //   child: CupertinoTextField(
                  //     controller: emailController,
                  //     placeholder: "Email",
                  //     obscureText: false,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                  //   child: CupertinoTextField(
                  //     controller: passwordController,
                  //     placeholder: "Password",
                  //     obscureText: true,
                  //   ),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Forgot Password?",
                  //         style: TextStyle(
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 25),
                  // // Wrap the Google sign-in button with a Stack to show the loading indicator
                  Stack(
                    children: [
                       if (loading)
                        Positioned.fill(
                          child: Center(
                            child: Container(color: Colors.white,
                                child: CupertinoActivityIndicator(radius: 20.0, color: CupertinoColors.white,)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 5,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "continue with",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 5,
                            color: Colors.black,
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
                      const SizedBox(width: 25,),
                      SquareTile(
                        imagePath: "images/facebook.png",
                        onTap: () {
                          _handlegsignin();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}


class background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CircularParticle(
        width: w,
        height: h,
        awayRadius: w / 5,
        numberOfParticles: 150,
        speedOfParticles: 5,
        maxParticleSize: 5,
        particleColor: Colors.white.withOpacity(.7),
        awayAnimationDuration: Duration(milliseconds: 600),
        awayAnimationCurve: Curves.easeInOutCubic,
        onTapAnimation: true,
        isRandSize: true,
        isRandomColor: false,
        connectDots: true,
        enableHover: false,
        //hoverColor: Colors.black,
        //hoverRadius: 90,
      ),
    );
  }
}
