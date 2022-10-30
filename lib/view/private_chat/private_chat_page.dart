import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/message.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/rooms.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:intl/intl.dart';

class PrivateChatPage extends StatelessWidget {

  final String roomId;
  final String partnerId;

  PrivateChatPage({Key? key, required this.roomId,required this.partnerId}) : super(key: key);

  List<String> messages = [];
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Pチャット'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: RoomFirestore.rooms.doc(roomId)
                  .collection('messages')
                  .orderBy('updated_time',descending: false)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.hasData) {
                  List<String> accountIds = [Authentication.myAccount!.id ,partnerId];
                  return FutureBuilder<Map<String, Account>?>(
                    future: UserFirestore.getPostUserMap(accountIds),
                    builder: (context, userSnapshot) {
                      if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                        return Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 32.0),
                              child: ListView.builder(
                                itemCount: messageSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data = messageSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                                  /// 自身の投稿判定
                                  bool isMine = Authentication.myAccount!.id == data['send_user'];
                                  Message message = Message(
                                    messageId: messageSnapshot.data!.docs[index].id,
                                    roomId: data['room_id'],
                                    sendUserId: data['send_user'],
                                    message: data['message'],
                                    isMine: isMine,
                                    updatedTime: data['updated_time'],
                                  );
                                  /// ユーザー名とアイコン取得
                                  Account sendAccount = userSnapshot.data![message.sendUserId]!;
                                  return Column(
                                    children: [
                                      message.isMine ? _SentMessageWidget(msg:message) : leftTalk(message,sendAccount),
                                    ],
                                  );
                                }
                              ),
                            )
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  );
                } else {
                  return Container();
                }
              }
            ),
            textInputWidget(),
          ],
        ),
      ),
    );
  }

  Container textInputWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 5,bottom: 15),
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.black
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'メッセージを入力してください',
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                  controller: contentController,
                )
            )
          ),
          IconButton(
            onPressed: () async{
              if(contentController.text.isNotEmpty) {
                Message newMessage = Message(
                  roomId: roomId,
                  sendUserId: Authentication.myAccount!.id,
                  message: contentController.text,
                );
                var result = await RoomFirestore.addMessage(newMessage);
                if(result == true) {
                  contentController.clear();
                }
              }
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  // Padding rightTalk(Message msg) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10.0),
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: Container(
  //         decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(40),
  //               topLeft: Radius.circular(40),
  //               bottomLeft: Radius.circular(40),
  //             ),
  //             color: Colors.green
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text(msg.message,style: TextStyle(color: Colors.black),),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Container leftTalk(Message msg, Account account) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: ClipOval(
              child: Image.asset(FunctionUtils.getIconImage(account.imagePath)),
            ),
          ),
          const SizedBox(width: 10.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 200,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg.message, style: const TextStyle(color: Colors.white)
                    ),
                  ),
                ],
              ),
              Text(DateFormat('HH:MM').format(msg.updatedTime!.toDate()),style: const TextStyle(fontSize: 10),),
            ],
          )
        ],
      ),
    );
  }
}

class _SentMessageWidget extends StatelessWidget {
  // final String message;
  final Message msg;

  // _SentMessageWidget({this.msg});
  _SentMessageWidget({Key? key, required this.msg}) : super(key: key);
  final _formatter = DateFormat("HH:MM");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatter.format(msg.updatedTime!.toDate()),
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                  color: Colors.green,
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  msg.message,style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
