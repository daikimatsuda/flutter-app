import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async{
    try {
      await users.doc(newAccount.id).set({
        'name':newAccount.name,
        'user_id':newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path':newAccount.imagePath,
        'create_time':Timestamp.now(),
        'update_time':Timestamp.now(),
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch(e) {
        print('作成エラー:$e');
        return false;
    }
  }

  static Future<dynamic> getUser(String uid) async{
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        userId: data['user_id'],
        selfIntroduction: data['self_introduction'],
        imagePath: data['image_path'],
        createTime: data['create_time'],
        updateTime: data['update_time'],
      );
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザー取得エラー:$e');
      return false;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'image_path': updateAccount.imagePath,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'update_time': Timestamp.now(),
      });
      print('更新完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザー更新エラー:$e');
      return false;
    }
  }

  static Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async{
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async{
        // アカウントIDに紐づく一覧を取得
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['self_introduction'],
          createTime: data['create_time'],
          updateTime: data['update_time'],
        );
        map[accountId] = postAccount;
        print('投稿ユーザーの情報取得完了');
      });
      return map;
    } on FirebaseException catch(e) {
      print('投稿ユーザーの情報取得エラー:$e');
      return null;
    }
  }

  static Future<dynamic> deleteUser(String accountId) async{
    await users.doc(accountId).delete();
    PostFirestore.deletePosts(accountId);
  }


}
