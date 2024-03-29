import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/view/screen.dart';
import 'package:flutter_dev/view/start_up/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter app',
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue[800],
    ),
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // スプラッシュ画面などに書き換えても良い
          return const SizedBox();
        }
        if (snapshot.hasData) {
          // ログイン済画面へ
          final user = UserFirestore.getUser(snapshot.data!.uid);
          user.then((value) => print('自動ログイン完了'));
          return Screen();
        }
        // ログイン画面へ
        return LoginPage();
      },
    ),
    debugShowCheckedModeBanner: false,
  );
}