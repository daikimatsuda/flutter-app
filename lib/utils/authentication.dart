import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dev/model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String password}) async{
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e) {
      print('登録エラー: $e');
      return false;
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String password}) async{
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      currentFirebaseUser = _result.user;
      return _result;
    } on FirebaseAuthException catch(e) {
      print('authサインエラー: $e');
      return false;
    }
  }

  static Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async{
    await currentFirebaseUser!.delete();
  }

}
