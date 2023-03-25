import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/component/custom_text_form.dart';
import 'package:flutter_dev/component/error_dailog.dart';
import 'package:flutter_dev/constant/character.dart';
import 'package:flutter_dev/constant/jobs.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:flutter_dev/utils/widget.utils.dart';
import 'package:flutter_dev/view/account/account_icon_page.dart';
import 'package:flutter_dev/view/start_up/auth_error.dart';
import 'package:flutter_dev/view/start_up/check_email_page.dart';

import '../../component/webview_widget.dart';
import '../../validator/max_length_validator.dart';
import '../../validator/required_validator.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  /// 各フィールド定義
  String _name = '';
  String _userId = '';
  String _selfIntroduction = '';
  String _email = '';
  String _password = '';
  String? iconPath;
  String? _selectedJobValue;
  String? _selectedCharacterValue;
  bool _isCheck = false;

  /// 入力エラー有無
  bool _isValidName = false;
  bool _isValidUserId = false;
  bool _isValidSelfIntrodution = false;
  bool _isValidEmail = false;
  bool _isValidPassword = false;

  // @override
  // void initState() {
  //   _selectedJobValue = "";
  //   _selectedCharacterValue = "";
  // }

  void _handleCheckbox(bool? isCheck) {
    setState(() {
      _isCheck = isCheck!;
    });
  }

  /// フィールド状態管理
  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }
  void _setUserId(String userId) {
    setState(() {
      _userId = userId;
    });
  }

  void _setSelfIntroduction(String selfIntroduction) {
    setState(() {
      _selfIntroduction = selfIntroduction;
    });
  }

  void _setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

  void _setIsValidName(bool isValid) {
    setState(() {
      _isValidName = isValid;
    });
  }

  ///  年齢のバリデーションの結果をステートに保持する
  void _setIsValidUserId(bool isValid) {
    setState(() {
      _isValidUserId = isValid;
    });
  }

  ///  自己紹介のバリデーションの結果をステートに保持する
  void _setIsValidSelfIntroduction(bool isValid) {
    setState(() {
      _isValidSelfIntrodution = isValid;
    });
  }

  ///  メールアドレスのバリデーションの結果をステートに保持する
  void _setIsValidEmail(bool isValid) {
    setState(() {
      _isValidEmail = isValid;
    });
  }

  ///  パスワードのバリデーションの結果をステートに保持する
  void _setIsValidPassword(bool isValid) {
    setState(() {
      _isValidPassword = isValid;
    });
  }

  /// 入力エラー確認
  bool _isAllValid() {
    return _isValidName && _isValidUserId && _isValidSelfIntrodution &&
      _isValidEmail && _isValidPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('新規登録',true),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
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
                  foregroundImage: iconPath == null
                      ? null : AssetImage(iconPath!),
                  radius: 40,
                  child: const Icon(Icons.add),
                ),
              ),
              SizedBox(
                width: 300,
                child: CustomTextField(
                  label: '名前',
                  onChange: _setName,
                  validators: [
                    RequiredValidator(),
                    MaxLengthValidator(20),
                  ],
                  setIsValid: _setIsValidName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: CustomTextField(
                    label: 'ユーザーID',
                    onChange: _setUserId,
                    validators: [
                      RequiredValidator(),
                      MaxLengthValidator(20),
                    ],
                    setIsValid: _setIsValidUserId,
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: CustomTextField(
                  label: '自己紹介',
                  onChange: _setSelfIntroduction,
                  validators: [
                    RequiredValidator(),
                    MaxLengthValidator(200),
                  ],
                  setIsValid: _setIsValidSelfIntroduction,
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: CustomTextField(
                    label: 'メールアドレス',
                    onChange: _setEmail,
                    validators: [
                      RequiredValidator(),
                      MaxLengthValidator(64),
                    ],
                    setIsValid: _setIsValidEmail,
                  )
                ),
              ),
              SizedBox(
                width: 300,
                child: CustomTextField(
                  label: 'パスワード',
                  onChange: _setPassword,
                  validators: [
                    RequiredValidator(),
                    MaxLengthValidator(128),
                  ],
                  setIsValid: _setIsValidPassword,
                )
              ),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      label: Text('職業', style: TextStyle(color: Colors.grey)),
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
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    label: Text('性格', style: TextStyle(color: Colors.grey)),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.blueAccent,
                    value: _isCheck,
                    onChanged: _handleCheckbox,
                  ),
                  Text("利用規約に同意する"),
                  const Divider(height: 0)
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => WebViewWidget(
                      title: "利用規約",
                      url: "https://engineer-baton.com/?p=386",
                    )
                  ));
                },
                child: const Text(
                  "利用規約",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_isCheck ? Colors.blueAccent : Colors.grey)
                ),
                onPressed: !_isCheck ? null : () async {
                  if(_isAllValid() && iconPath != null) {
                    var result = await Authentication.signUp(email: _email, password: _password);
                    if(result is UserCredential) {
                      var _result = await createAccount(result.user!.uid);
                      if(_result == true) {
                        result.user!.sendEmailVerification();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckEmailPage(email: _email, pass: _password,)));
                      }
                    } else if(result != FirebaseAuthResultStatus.Successful) {
                      final errorMessage = FirebaseAuthExceptionHandler.exceptionMessage(result);
                      showDialog<void>(
                        context: context,
                        builder: (_) {
                          return ErrorDialog(message: errorMessage);
                        }
                      );
                    }
                  }
                },
                child: const Text('アカウントを作成')
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> createAccount(String uid) async{
    Account newAccount = Account(
      id: uid,
      name: _name,
      imagePath: FunctionUtils.getIconId(iconPath!),
      selfIntroduction: _selfIntroduction,
      userId: _userId,
      jobId: _selectedJobValue,
      characterId: _selectedCharacterValue,
    );
    var _result = await UserFirestore.setUser(newAccount);
    return _result;
  }
}
