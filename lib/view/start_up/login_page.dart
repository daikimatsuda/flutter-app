import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/component/error_dailog.dart';
import 'package:flutter_dev/constant/strings.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/view/account/create_account_page.dart';
import 'package:flutter_dev/view/screen.dart';
import 'package:flutter_dev/view/start_up/auth_error.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/正式背景2.jpg'),
              fit: BoxFit.fill,
            )
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                const Text('オルタナ', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス'
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'パスワード'
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white70),
                    children: [
                      const TextSpan(text: 'アカウントを作成していない方は'),
                      TextSpan(text: 'こちら',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountPage()));
                        }
                      ),
                    ]
                  )
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async{
                    var result = await Authentication.emailSignIn(email: emailController.text, password: passwordController.text);
                    if(result is UserCredential) {
                      if(result.user!.emailVerified == true) {
                        // ログイン成功した場合、ユーザー情報をFirebaseから取得
                        var _result = await UserFirestore.getUser(result.user!.uid);
                        if(_result == true) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                        }
                      } else {
                        showDialog<void>(
                            context: context,
                            builder: (_) {
                              return const ErrorDialog(message: Strings.emailVerificationMsg);
                            }
                        );
                      }
                    } else if (result != FirebaseAuthResultStatus.Successful) {
                      final errorMessage = FirebaseAuthExceptionHandler.exceptionMessage(result);
                      showDialog<void>(
                          context: context,
                          builder: (_) {
                            return ErrorDialog(message: errorMessage);
                          }
                      );
                    }
                  }, child: const Text('emailでログイン')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
