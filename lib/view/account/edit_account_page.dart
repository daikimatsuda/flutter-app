import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/constant/jobs.dart';
import 'package:flutter_dev/constant/strings.dart';
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
  var selectedValue = "1";
  final jobs = Jobs.jobs;

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

  _myDialog() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const Text(Strings.updateCompleteMsg),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集',true),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 20),
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '職業',
                    ),
                    isExpanded: true,
                    menuMaxHeight: 400,
                    value: selectedValue,
                    items: Jobs.jobs.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value)
                      );
                    }).toList(),
                    onChanged: (String? aaa) {
                      setState(() {
                        selectedValue = aaa!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                        _myDialog();
                      }
                    }
                  },
                  child: Text('更新')
              ),
              SizedBox(height: 20),
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
