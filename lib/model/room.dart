import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String lastMessage;
  String likeUserId;
  Timestamp? updatedTime;

  Room({this.id = '',this.lastMessage = '',this.likeUserId = '', this.updatedTime});
}