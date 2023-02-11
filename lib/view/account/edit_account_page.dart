import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/constant/character.dart';
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
  String? _selectedJobValue;
  String? _selectedCharacterValue;

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
    _selectedJobValue = myAccount.jobId;
    _selectedCharacterValue = myAccount.characterId;
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
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                  child: const Icon(Icons.add),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: '名前'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: const InputDecoration(hintText: 'ユーザーID'),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: const InputDecoration(hintText: '自己紹介'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '職業',
                    ),
                    isExpanded: true,
                    menuMaxHeight: 400,
                    value: _selectedJobValue,
                    items: Jobs.jobs.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value)
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedJobValue = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: '性格',
                  ),
                  isExpanded: true,
                  menuMaxHeight: 400,
                  value: _selectedCharacterValue,
                  items: Character.character.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value)
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCharacterValue = value!;
                    });
                  },
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
                        jobId: _selectedJobValue,
                        characterId: _selectedCharacterValue,
                        imagePath: imagePath,
                      );
                      Authentication.myAccount = updateAccount;
                      var result = await UserFirestore.updateUser(updateAccount);
                      if(result == true) {
                        _myDialog();
                      }
                    }
                  },
                  child: const Text('更新')
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Authentication.signOut();
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Text('ログアウト')
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  UserFirestore.deleteUser(myAccount.id);
                  Authentication.deleteAuth();
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Text('アカウント削除')
              )
            ],
          ),
        ),
      ),
    );
  }
}
