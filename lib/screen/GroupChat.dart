import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();

}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループチャット'),
      ),
      body: const Center(
          child: Text('グループチャット画面' ,style: TextStyle(fontSize: 32.0),)),
    );
  }
}