import 'package:flutter/material.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';

import '../../component/custom_text_form.dart';
import '../../validator/max_length_validator.dart';
import '../../validator/required_validator.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  /// 各フィールド定義
  String _content = '';
  /// 入力チェックエラー有無
  bool _isValidContent = false;
  /// フィールド状態管理
  void _setContent(String content) {
    setState(() {
      _content = content;
    });
  }

  void _setIsValidContent(bool isValid) {
    setState(() {
      _isValidContent = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('投稿', style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              label: "",
              onChange: _setContent,
              validators: [
                RequiredValidator(),
                MaxLengthValidator(100),
              ],
              setIsValid: _setIsValidContent,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if(_isValidContent) {
                  Post newPost = Post(
                    content: _content,
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
