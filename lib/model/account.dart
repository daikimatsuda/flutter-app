import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String imagePath;
  String selfIntroduction;
  String userId;
  String? jobId;
  String? characterId;
  Timestamp? createTime;
  Timestamp? updateTime;

  Account({
    this.id = '',
    this.name = '',
    this.imagePath = '',
    this.selfIntroduction = '',
    this.userId = '',
    this.jobId = '',
    this.characterId = '',
    this.createTime,
    this.updateTime,
  });
}