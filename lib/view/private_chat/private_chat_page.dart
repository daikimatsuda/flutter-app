import 'package:flutter/material.dart';

class PrivateChatPage extends StatefulWidget {
  const PrivateChatPage({Key? key}) : super(key: key);

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pチャット'),
        elevation: 2,
      ),
    );
  }
}
