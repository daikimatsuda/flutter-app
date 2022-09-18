import 'package:flutter/material.dart';

class PrivateChatPage extends StatelessWidget {

  PrivateChatPage();

  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pチャット'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 32.0),
                child: Column(
                  children: [
                    rightTalk(),
                  ],
                ),
              )
            ),
            textInputWidget(),
          ],
        ),
      ),
    );
  }

  Container textInputWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 5,bottom: 15),
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                )
            )
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Padding rightTalk() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
              color: Colors.green
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('サンプルレイアウト'),
          ),
        ),
      ),
    );
  }
}
