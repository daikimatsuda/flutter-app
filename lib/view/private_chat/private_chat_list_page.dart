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
      body: FutureBuilder<Map<String, Post>?>(
        future: PostFirestore.getPost(Authentication.myAccount!.id),
        builder: (context, postSnapshot) {
          if (postSnapshot.hasData &&
              postSnapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: postSnapshot.data!.length,
              itemBuilder: (context,index) {
                return Container(
                  child: ListTile(
                    title: Text('いいねしたよ'),
                  ),
                );
              }
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }
}
