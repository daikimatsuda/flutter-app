import 'package:flutter/material.dart';

class AccountIconPage extends StatelessWidget {

  List<String> images = [
    'images/icon_10.png',
    'images/icon_11.png',
    'images/icon_12.png',
    'images/icon_13.png',
    'images/icon_14.png',
    'images/icon_15.png',
    'images/icon_16.png',
    'images/icon_17.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("アイコン"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0
            ),
            itemBuilder: (BuildContext context, int index) {
              // return Image.asset(images[index], fit: BoxFit.cover);
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, images[index]);
                },
                child: Image.asset(images[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
      ),
    );
  }
}
