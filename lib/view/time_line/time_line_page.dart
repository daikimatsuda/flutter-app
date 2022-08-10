import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/view/time_line/post_page.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('つぶやき投稿'),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: PostFirestore.posts.orderBy('created_time', descending: true)
              .snapshots(),
          builder: (context, postSnapshot) {
            if (postSnapshot.hasData) {
              List<String> postAccountIds = [];
              postSnapshot.data!.docs.forEach((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                if (!postAccountIds.contains(data['post_account_id'])) {
                  postAccountIds.add(data['post_account_id']);
                }
              });
              return FutureBuilder<Map<String, Account>?>(
                  future: UserFirestore.getPostUserMap(postAccountIds),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData &&
                        userSnapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount: postSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            bool isLiked = false;
                            Map<String, dynamic> data = postSnapshot.data!
                                .docs[index].data() as Map<String, dynamic>;
                            Post post = Post(
                                id: postSnapshot.data!.docs[index].id,
                                content: data['content'],
                                postAccountId: data['post_account_id'],
                                createdTime: data['created_time']
                            );
                            Account postAccount = userSnapshot.data![post
                                .postAccountId]!;
                            return Container(
                              decoration: BoxDecoration(
                                  border: index == 0 ? const Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0),
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ) : const Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0),
                                  )
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    foregroundImage: NetworkImage(
                                        postAccount.imagePath),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(postAccount.name,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold)),
                                                  Text('@${postAccount.userId}',
                                                      style: const TextStyle(
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                              Text(DateFormat('M/d/yy').format(
                                                  post.createdTime!.toDate()))
                                            ],
                                          ),
                                          SizedBox(height: 2.5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(post.content),
                                              LikeButton(
                                                likeCount: null,
                                                isLiked: isLiked,
                                                size: 25,
                                                bubblesSize: 1,
                                                circleColor: const CircleColor(
                                                    start: Colors.grey,
                                                    end: Colors.pinkAccent),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
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
    );
  }
}
