import 'package:flutter/material.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/view/account/account_page.dart';
import 'package:flutter_dev/view/account/edit_account_page.dart';
import 'package:flutter_dev/view/private_chat/private_chat_list_page.dart';
import 'package:flutter_dev/view/time_line/post_page.dart';
import 'package:flutter_dev/view/time_line/time_line_page.dart';
import 'private_chat/private_chat_page.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;
  List<Widget> pageList = [TimeLinePage(), PrivateChatListPage(), const EditAccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black54,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'つぶやき',
            backgroundColor:Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '個別チャット',
            backgroundColor:Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_outlined),
            label: 'マイページ',
            backgroundColor:Colors.black,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PostPage()));
        },
        child: const Icon(Icons.chat_bubble_outline,color: Colors.white,),
        backgroundColor: Colors.black,
      ),
    );
  }
}
