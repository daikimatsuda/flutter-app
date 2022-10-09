import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';
import 'package:flutter_dev/utils/firestore/rooms.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class TimeLinePage extends StatelessWidget {

  const TimeLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('つぶやき投稿'),
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/night.png'),
            fit: BoxFit.fill,
        )
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: PostFirestore.posts.orderBy('created_time',descending: true).snapshots(),
          builder: (context, postSnapshot) {
            if(postSnapshot.hasData) {
              List<String> postAccountIds = [];
              List<String> postIds = [];
              postSnapshot.data!.docs.forEach((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                postIds.add(doc.id);
                if(!postAccountIds.contains(data['post_account_id'])) {
                  postAccountIds.add(data['post_account_id']);
                }
              });
              return FutureBuilder<Map<String, bool>?>(
                future: PostFirestore.isLikedByPostId(postIds,Authentication.myAccount!.id),
                builder: (context, likedUserSnapshot) {
                  if(likedUserSnapshot.hasData && likedUserSnapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder<Map<String, Account>?>(
                      future: UserFirestore.getPostUserMap(postAccountIds),
                      builder: (context, userSnapshot) {
                        if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: postSnapshot.data!.docs.length,
                            itemBuilder: (context,index) {
                              Map<String, dynamic> data = postSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                              Post post = Post(
                                id: postSnapshot.data!.docs[index].id,
                                content: data['content'],
                                postAccountId: data['post_account_id'],
                                createdTime: data['created_time'],
                              );
                              bool isLiked = likedUserSnapshot.data![post.id]!;
                              Account postAccount = userSnapshot.data![post.postAccountId]!;
                              return Container(
                                decoration: BoxDecoration(
                                    border: index == 0 ? const Border(
                                      top: BorderSide(color: Colors.grey,width: 0),
                                      bottom: BorderSide(color: Colors.grey,width: 0),
                                    ) : const Border(
                                      bottom: BorderSide(color: Colors.grey,width: 0),
                                    ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      foregroundImage: NetworkImage(postAccount.imagePath),
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
                                                Row(
                                                  children: [
                                                    Text(postAccount.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                    Text('@${postAccount.userId}', style: const TextStyle(color: Colors.grey)),
                                                  ],
                                                ),
                                                Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                                              ],
                                            ),
                                            const SizedBox(height: 2.5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(post.content),
                                                ),
                                                FavoriteButton(post, Authentication.myAccount!.id,isLiked),
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
              );
            } else {
              return Container();
            }
          }
        ),
      ),
    );
  }
}

class FavoriteButton extends HookWidget {

  @override
  final Post post;
  final String accountId;
  bool isLiked;
  FavoriteButton(this.post,this.accountId,this.isLiked);
  Widget build(BuildContext context) {
    final favorite = useState<bool>(isLiked);

    return IconButton(
      onPressed: () async {
        if (!favorite.value) {
          var result = await PostFirestore.addLike(post.id, accountId);
          favorite.value = true;
          if (result == true) {
            await RoomFirestore.addRoom(post, accountId);
          }
        }
      },
      icon: Icon(
        Icons.favorite,
        color: (favorite.value) ? Colors.pink : Colors.black12,
      ),
    );
  }
}
