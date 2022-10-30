import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/screen.dart';
import 'package:flutter_dev/view/start_up/login_page.dart';
import 'package:flutter_dev/view/time_line/time_line_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        // primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }

  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initialization,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return SizedBox(); //エラーページ
  //       }
  //
  //       // Once complete, show your application
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         //ここに、アプリの本体をおく
  //         return TimeLinePage();
  //       }
  //
  //       // Otherwise, show something whilst waiting for initialization to complete
  //       return LoginPage();
  //     }
  //   );
  // }
}