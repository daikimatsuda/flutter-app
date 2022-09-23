import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dev/model/message.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/model/room.dart';

class RoomFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference rooms = _firestoreInstance.collection('rooms');

  /// チャットルーム作成
  static Future<dynamic> addRoom(Post post, String accountId) async {
    try {
      if(post.postAccountId == accountId) {
        return false;
      }
      List<String> joinedUsers = [post.postAccountId,accountId];
      /// 投稿テーブルへ登録
      var result = await rooms.add({
        'joined_users': joinedUsers,
        'last_message': post.content,
        'updated_time': Timestamp.now(),
      });
      /// チャットルームに紐づくメッセージ一覧作成
      final CollectionReference _roomMessage = rooms.doc(result.id).collection('messages');
      /// messagesへの登録
      /// 初期メッセージは投稿メッセージ
      await _roomMessage.add({
        'room_id': result.id,
        'send_user': post.postAccountId,
        'message': post.content,
        'updated_time': Timestamp.now(),
      });

      return true;
    } on FirebaseException catch(e) {
      print('作成失敗:$e');
      return false;
    }
  }

  static Future<List<Room?>> getRooms(String accountId) async {
    List<Room> roomList = [];
    try {
      QuerySnapshot snapshot = await rooms.where('joined_users',arrayContains: accountId).orderBy('updated_time',descending: true).get();
      var list = snapshot.docs;
      await Future.forEach(list, (QueryDocumentSnapshot item) async{
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        var userIds = data['joined_users'];
        String likeUserId = userIds.where((e) => e != accountId).first;
        Room room = Room(
          id: item.id,
          lastMessage: data['last_message'],
          likeUserId: likeUserId,
          updatedTime: data['updated_time'],
        );
        roomList.add(room);
      });
      return roomList;
    }on FirebaseException catch(e) {
      return roomList;
    }
  }

  static Future<dynamic> addMessage(Message msg) async {
    try {
      /// チャットルームに紐づくメッセージ一覧作成
      final CollectionReference _roomMessage = rooms.doc(msg.roomId).collection('messages');
      await _roomMessage.add({
        'room_id': msg.roomId,
        'send_user': msg.sendUserId,
        'message': msg.message,
        'updated_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch(e) {
      print('作成失敗:$e');
      return false;
    }
  }
}
