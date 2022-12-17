import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dev/model/post.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');

  // 投稿を保存する
  static Future<dynamic> addPost(Post newPost) async {
    try {
      // my_postsコレクション生成（my_postsにアクセス）
      final CollectionReference _userPosts = _firestoreInstance.collection('users')
          .doc(newPost.postAccountId).collection('my_posts');
      // 投稿テーブルへ登録
      var result = await posts.add({
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
      });
      // my_postsへの登録
      _userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now()
      });
      return true;
    } on FirebaseException catch(e) {
      print('投稿失敗:$e');
      return false;
    }
  }

  static Future<List<Post>?> getPostsFromIds(List<String> ids) async{
    List<Post> postList = [];
    try {
      await Future.forEach(ids, (String id) async{
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time']
        );
        postList.add(post);
      });
      return postList;
    } on FirebaseException catch(e) {
      print('自分の投稿取得エラー:$e');
      return null;
    }
  }

  static Future<dynamic> deletePosts(String accountId) async{
    final CollectionReference _usersPosts = _firestoreInstance.collection('users')
        .doc(accountId).collection('my_posts');
    var snapshot = await _usersPosts.get();
    snapshot.docs.forEach((doc) async{
      await posts.doc(doc.id).delete();
      _usersPosts.doc(doc.id).delete();
    });
    posts.doc(accountId).delete();
  }

  /// 投稿に対するいいねを保存
  static Future<dynamic> addLike(String postId,String accountId) async {
    try {
      // like_usersコレクション生成
      final CollectionReference _likeUsers = _firestoreInstance.collection('posts')
          .doc(postId).collection('liked_users');
      // liked_usersへの登録
      _likeUsers.doc(accountId).set({
        'account_id': accountId,
        'created_time': Timestamp.now()
      });
      return true;
    } on FirebaseException catch(e) {
      print('いいね失敗:$e');
      return false;
    }
  }

  /// 投稿に対するいいねを保存
  static Future<dynamic> deleteLike(String postId,String accountId) async {
    try {
      // like_usersコレクション生成
      final CollectionReference _likeUsers = _firestoreInstance.collection('posts')
          .doc(postId).collection('liked_users');
      // liked_usersへの登録
      var snapshot = await _likeUsers.doc(accountId).delete();
      return true;
    } on FirebaseException catch(e) {
      print('いいね削除失敗:$e');
      return false;
    }
  }

  static Future<Map<String, bool>?> isLikedByPostId(List<String> postIds,String accountId) async{
    Map<String, bool> map = {};
    try {
      await Future.forEach(postIds, (String postId) async{
        if(postId.isNotEmpty) {
          final CollectionReference _likeUsers = await posts.doc(postId).collection('liked_users');
          var snapshot = await _likeUsers.doc(accountId).get();
          bool isLiked = snapshot.exists;
          map[postId] = isLiked;
        }
      });
      return map;
    } on FirebaseException catch(e) {
      print('エラー:$e');
      return null;
    }
  }
}