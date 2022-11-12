import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:flutter_dev/utils/widget.utils.dart';
import 'package:flutter_dev/view/account/account_icon_page.dart';
import 'package:flutter_dev/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  String? iconPath;
  var selectedValue = "営業";
  final lists = <String>["営業", "エンジニア", "総務", "経理", "建設業"];

  String getImage() {
    if(iconPath == null) {
      return FunctionUtils.getIconImage(myAccount.imagePath);
    } else {
      return iconPath!;
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text:  myAccount.selfIntroduction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async{
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountIconPage(),
                    ),
                  );
                  if(result != null) {
                    setState(() {
                      iconPath = result;
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundImage: AssetImage(getImage()),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: '名前'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(hintText: 'ユーザーID'),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: InputDecoration(hintText: '自己紹介'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items: lists.map((String list) =>
                      DropdownMenuItem(value: list, child: Text(list)))
                        .toList(),
                    onChanged: (String? value) {
                      setState((){
                        selectedValue = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && selfIntroductionController.text.isNotEmpty
                    )
                    {
                      String imagePath = '';
                      if(iconPath == null) {
                        imagePath = FunctionUtils.getIconId(myAccount.imagePath);
                      } else {
                        imagePath = FunctionUtils.getIconId(iconPath!);
                      }
                      Account updateAccount = Account(
                        id: myAccount.id,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath,
                      );
                      Authentication.myAccount = updateAccount;
                      var result = await UserFirestore.updateUser(updateAccount);
                      if(result == true) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: Text('更新')
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Authentication.signOut();
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: Text('ログアウト')
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  UserFirestore.deleteUser(myAccount.id);
                  Authentication.deleteAuth();
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: Text('アカウント削除')
              )
            ],
          ),
        ),
      ),
    );
  }
}
