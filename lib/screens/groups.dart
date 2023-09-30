import 'package:Messager/models/chat_user.dart';
import 'package:flutter/cupertino.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key, required ChatUser user});

  @override
  // ignore: library_private_types_in_public_api
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoButton.filled(
            child: Text("Comming Soon"), onPressed: () {}),
      ),
    );
  }
}
