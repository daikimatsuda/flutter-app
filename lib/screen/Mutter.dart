import 'package:flutter/material.dart';

class MutterScreen extends StatefulWidget {
  const MutterScreen({Key? key}) : super(key: key);

  @override
  _MutterScreenState createState() => _MutterScreenState();

}

class _MutterScreenState extends State<MutterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: const Text('みんなのつぶやき'),
      ),
      body: const Center(
          child: Text('アカウント画面' ,style: TextStyle(fontSize: 32.0),)),
    );
  }
}