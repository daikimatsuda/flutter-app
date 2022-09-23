import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  String messageId;
  String roomId;
  String sendUserId;
  String message;
  bool isMine;
  Timestamp? updatedTime;

  Message({
    this.messageId = '',
    this.roomId = '',
    this.sendUserId = '',
    this.message = '',
    this.isMine = false,
    this.updatedTime
  });
}