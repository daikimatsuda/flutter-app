import 'package:flutter/material.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({Key? key}) : super(key: key);

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();

}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライベートチャット'),
      ),
      body: const Center(
          child: Text('プライベートチャット', style: TextStyle(fontSize: 32.0))),
    );
  }
}