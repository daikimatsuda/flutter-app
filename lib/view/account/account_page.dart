import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/model/post.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/posts.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:flutter_dev/view/account/edit_account_page.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, left: 15,top: 20),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage: AssetImage(FunctionUtils.getIconImage(myAccount.imagePath)),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  Text('@${myAccount.userId}',style: const TextStyle(color: Colors.grey),)
                                ],
                              )
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () async{
                              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditAccountPage()));
                              if(result == true) {
                                setState(() {
                                  myAccount = Authentication.myAccount!;
                                });
                              }
                            }, child: const Text('編集'))
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(myAccount.selfIntroduction),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.grey, width: 3
                    ))
                  ),
                  child: const Text('投稿',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                Expanded(child: StreamBuilder<QuerySnapshot>(
                  stream: UserFirestore.users.doc(myAccount.id)
                      .collection('my_posts').orderBy('created_time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      List<String> myPostsIds = List.generate(snapshot.data!.docs.length, (index) {
                        return snapshot.data!.docs[index].id;
                      });
                      return FutureBuilder<List<Post>?>(
                        future: PostFirestore.getPostsFromIds(myPostsIds),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context,index) {
                                  Post post = snapshot.data![index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: index == 0 ? const Border(
                                          top: BorderSide(color: Colors.grey,width: 0),
                                          bottom: BorderSide(color: Colors.grey,width: 0),
                                        ) : const Border(
                                          bottom: BorderSide(color: Colors.grey,width: 0),
                                        )
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          foregroundImage: AssetImage(FunctionUtils.getIconImage(myAccount.imagePath)),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(myAccount.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                        Text('@${myAccount.userId}', style: const TextStyle(color: Colors.grey)),
                                                      ],
                                                    ),
                                                    Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                                                  ],
                                                ),
                                                Text(post.content)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        }
                      );
                    } else {
                      return Container();
                    }
                  }
                )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
