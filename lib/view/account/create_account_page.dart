import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/component/custom_text_form.dart';
import 'package:flutter_dev/component/error_dailog.dart';
import 'package:flutter_dev/model/account.dart';
import 'package:flutter_dev/utils/authentication.dart';
import 'package:flutter_dev/utils/firestore/users.dart';
import 'package:flutter_dev/utils/function_utils.dart';
import 'package:flutter_dev/utils/widget.utils.dart';
import 'package:flutter_dev/view/account/account_icon_page.dart';
import 'package:flutter_dev/view/start_up/auth_error.dart';
import 'package:flutter_dev/view/start_up/check_email_page.dart';

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
  /// 入力エラー有無
  bool _isValidName = false;
  bool _isValidUserId = false;
  bool _isValidSelfIntrodution = false;
  bool _isValidEmail = false;
  bool _isValidPassword = false;

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
        child: Container(
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
              Container(
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
                child: Container(
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
              Container(
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
                child: Container(
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
              Container(
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
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
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
              )
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
    );
    var _result = await UserFirestore.setUser(newAccount);
    return _result;
  }
}
