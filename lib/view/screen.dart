import 'package:flutter/material.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/view/account/account_page.dart';
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
  List<Widget> pageList = [TimeLinePage(), PrivateChatListPage(), const AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_outlined),
              label: ''
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
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
