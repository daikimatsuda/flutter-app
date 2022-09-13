import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/view/time_line/post_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

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
      body: FutureBuilder<List<Post?>>(
        future: PostFirestore.getPosts(Authentication.myAccount!.id),
        builder: (context, postSnapshot) {
          if(postSnapshot.hasData) {
            List<String> postAccountIds = [];
            postSnapshot.data!.forEach((e) => {
              if(!postAccountIds.contains(e!.postAccountId)) {
                postAccountIds.add(e.postAccountId)
              }
            });
            return FutureBuilder<Map<String, Account>?>(
              future: UserFirestore.getPostUserMap(postAccountIds),
              builder: (context, userSnapshot) {
                if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: postSnapshot.data!.length,
                    itemBuilder: (context,index) {
                      Post post = Post(
                          id: postSnapshot.data![index]!.id,
                          content: postSnapshot.data![index]!.content,
                          postAccountId: postSnapshot.data![index]!.postAccountId,
                          createdTime: postSnapshot.data![index]!.createdTime,
                          isLiked: postSnapshot.data![index]!.isLiked,
                      );
                      Account postAccount = userSnapshot.data![post.postAccountId]!;
                      return Container(
                        decoration: BoxDecoration(
                            border: index == 0 ? const Border(
                              top: BorderSide(color: Colors.grey,width: 0),
                              bottom: BorderSide(color: Colors.grey,width: 0),
                            ) : const Border(
                              bottom: BorderSide(color: Colors.grey,width: 0),
                            )
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              foregroundImage: NetworkImage(postAccount.imagePath),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                                    SizedBox(height: 2.5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(post.content),
                                        FavoriteButton(post.id, Authentication.myAccount!.id,post.isLiked),
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

class FavoriteButton extends HookWidget {

  @override
  final String postId;
  final String accountId;
  bool isLiked;
  FavoriteButton(this.postId,this.accountId,this.isLiked);
  Widget build(BuildContext context) {
    print(isLiked);
    final favorite = useState<bool>(isLiked);

    return IconButton(
      onPressed: () async {
        if (!favorite.value) {
          var result = await PostFirestore.addLike(postId, accountId);
          favorite.value = true;
        } else {
          favorite.value = false;
          var result = await PostFirestore.deleteLike(postId, accountId);
        }
      },
      icon: Icon(
        Icons.favorite,
        color: (favorite.value) ? Colors.pink : Colors.black12,
      ),
    );
  }
}
