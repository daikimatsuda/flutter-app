import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/component/error_dailog.dart';
import 'package:flutter_dev/constant/strings.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/widget.utils.dart';
import 'package:flutter_dev/view/screen.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String pass;
  CheckEmailPage({required this.email, required this.pass});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: WidgetUtils.createAppBar('メールアドレスを確認',false),
        body: Column(
          children: [
            Text('登録いただいたメールアドレス宛に確認のメールを送信しております。そちらに記載されているURLをクリックしてください。'),
            ElevatedButton(
              onPressed: () async{
                var result = await Authentication.emailSignIn(email: widget.email, password: widget.pass);
                if(result is UserCredential) {
                  if(result.user!.emailVerified == true) {
                    while(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    await UserFirestore.getUser(result.user!.uid);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                  } else {
                    showDialog<void>(
                        context: context,
                        builder: (_) {
                          return const ErrorDialog(message: Strings.emailVerificationMsg);
                        }
                    );
                    print('メール認証終わってません');
                  }
                }
              },
              child: Text('認証完了'))
          ],
        ),
      ),
    );
  }
}
