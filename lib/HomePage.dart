import 'package:Messager/callspage.dart';
import 'package:Messager/chatpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const Homepage()));
  runApp(const Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoTabScaffold(
        controller: CupertinoTabController(
        ),
        backgroundColor: Colors.white,
        tabBar: CupertinoTabBar(
          height: 60,
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.phone),
              activeIcon: Icon(CupertinoIcons.phone_fill),
              label: 'Calls',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          Widget defaultPage;
          switch (index) {
            case 0:
              defaultPage = const ChatPage();
              break;
            case 1:
              defaultPage = const CallsPage();
              break;
            default:
              defaultPage = const ChatPage();
              break;
          }
          return CupertinoTabView(
            builder: (BuildContext context) => defaultPage,
          );
        },

      ),
    );
  }
}