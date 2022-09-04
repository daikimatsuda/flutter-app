import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String postAccountId;
  Timestamp? createdTime;
  bool isLiked;

  Post({this.id = '',this.content = '', this.postAccountId = '',this.createdTime,this.isLiked = false});
}