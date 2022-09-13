import 'package:flutter/material.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';

class PrivateChatListPage extends StatelessWidget {
  const PrivateChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('プライベートチャット一覧'),
        elevation: 2,
      ),
    );
  }
}
