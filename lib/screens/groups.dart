import 'package:Messager/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import 'home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: GroupsPage(),
      ),
    );
  }
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<String> tasks = [];
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Groups"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => HomeScreen(user: APIs.me)));
          },
        ),
      ),
      body: Center(
        child: CupertinoButton.filled(
            child: Text(
              "Comming Soon",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {}),
      ),
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
    );
  }
}
