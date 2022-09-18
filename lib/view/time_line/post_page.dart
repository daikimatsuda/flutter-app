import 'package:flutter/material.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('新規登録', style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: contentController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if(contentController.text.isNotEmpty) {
                  Post newPost = Post(
                    content: contentController.text,
                    postAccountId: Authentication.myAccount!.id,
                  );
                  var result = await PostFirestore.addPost(newPost);
                  if(result == true) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('投稿')
            )
          ],
        ),
      ),
    );
  }
}
