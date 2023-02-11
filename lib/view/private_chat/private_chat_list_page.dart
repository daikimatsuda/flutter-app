import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/room.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:flutter_dev/view/private_chat/private_chat_page.dart';
import 'package:intl/intl.dart';

import '../../utils/firestore/rooms.dart';

class PrivateChatListPage extends StatelessWidget {

  PrivateChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('個別チャット'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/正式背景2.jpg'),
              fit: BoxFit.fill,
            )
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: RoomFirestore.rooms
              .where('joined_users',arrayContains: Authentication.myAccount!.id)
              .orderBy('updated_time',descending: true).snapshots(),
          builder: (context, roomSnapshot) {
            if (roomSnapshot.hasData) {
              List<String> postAccountIds = [];
              roomSnapshot.data!.docs.forEach((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                var userIds = data['joined_users'];
                String likeUserId = userIds.where((e) => e != Authentication.myAccount!.id).first;
                if(!postAccountIds.contains(likeUserId)) {
                  postAccountIds.add(likeUserId);
                }
              });
              return FutureBuilder<Map<String, Account>?>(
                future: UserFirestore.getPostUserMap(postAccountIds),
                builder: (context, userSnapshot) {
                  if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: roomSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = roomSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                        String likeUserId = data['joined_users'].where((e) => e != Authentication.myAccount!.id).first;
                        Room room = Room(
                          id: roomSnapshot.data!.docs[index].id,
                          lastMessage: data['last_message'],
                          likeUserId: likeUserId,
                          updatedTime: data['updated_time'],
                        );
                        Account postAccount = userSnapshot.data![room.likeUserId]!;
                        return Container(
                          decoration: BoxDecoration(
                            border: index == 0 ? const Border(
                              top: BorderSide(color: Colors.grey,width: 0),
                              bottom: BorderSide(color: Colors.grey,width: 0),
                            ) : const Border(
                              bottom: BorderSide(color: Colors.grey, width: 0),
                            )
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 28,
                                foregroundImage: AssetImage(FunctionUtils.getIconImage(postAccount.imagePath)),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              child:
                                                // Text(postAccount.name, style: const TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                                                // Text('@${postAccount.userId}', style: const TextStyle(color: Colors.grey)),
                                                RichText(
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: postAccount.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white
                                                        )
                                                      ),
                                                      TextSpan(
                                                        text: '@${postAccount.userId}',
                                                        style: TextStyle(color: Colors.grey),
                                                      )
                                                    ]
                                                  )
                                                ),
                                            ),
                                          ),
                                          Container(child: Text(DateFormat('yy/M/d').format(room.updatedTime!.toDate()))),
                                        ],
                                      ),
                                      const SizedBox(height: 2.5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 9,
                                            child: Container(
                                              child: Text(room.lastMessage)
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              // iconSize: 18.0,
                                              onPressed: () async {
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => PrivateChatPage(roomId: room.id, partnerId: room.likeUserId,sendUserName: postAccount.name,)));
                                              },
                                              icon: const Icon(Icons.forum),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
