import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {

  int _selectedIndex = 0;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  // アイコン情報
  static const _footerIcons = [
    Icons.chat,
    Icons.settings
  ];

  // アイコン文字列
  static const _footerItemNames = [
    'トーク',
    '設定'
  ];

  @override
  void initState() {
    super.initState();
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    // for (var footerItem in _footerItemNames) {
    //   _bottomNavigationBarItems.add(_UpdateDeactiveState(footerItem));
    // }
  }

  // インデックスのアイテムをアクティベートにする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],

      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'chat',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}