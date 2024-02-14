import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignIn> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold (
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ),
        backgroundColor: Colors.white,
        child: Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 10.0),),
                Text('Войдите в свой аккаунт', style: TextStyle(fontSize: 22, height: 3),),
                Padding(padding: EdgeInsets.only(top: 90.0),),
                SizedBox(
                  width: 350,
                  height: 45,
                  child: CupertinoTextField(
                    controller: _emailController,
                    obscureText: false,
                    placeholder: 'Введите e-mail',
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: CupertinoColors.systemGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30.0),),
                SizedBox(
                  width: 350,
                  height: 45,
                  child: CupertinoTextField(
                    controller: _passwordController,
                    obscureText: true,
                    placeholder: 'Введите пароль',
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: CupertinoColors.systemGrey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10.0),),
                Row(
                  children: [
                    Text('Еще нет аккаунта?',
                      style: TextStyle(fontSize: 15),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text('Зарегистрируйтесь',
                        style:
                        TextStyle(fontSize: 15),
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0),),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: CupertinoButton.filled(onPressed: () {
                    _loginUser();
                  },
                      child: Text('Войти', style: TextStyle(fontSize: 20),)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showEmailOrPassNotFound () {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Ошибка авторизации'),
          content: Text('Неправильно введен адрес электронной почты и(или) пароль'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showBadEmailDialog () {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Ошибка авторизации'),
          content: Text('Неверный формат адреса электронный почты'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showOtherErrorDialog () {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Ошибка авторизации'),
          content: Text('Возникла ошибка при регистрации. Обратитесь к администратору для помощи'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      Navigator.pushReplacementNamed(context, '/myprofile');
      // print('Login success');
    }  catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          showEmailOrPassNotFound ();
        } else  if (e.code == 'invalid-email') {
          showBadEmailDialog ();
        } else {
          showEmailOrPassNotFound ();
        }
      }
    }
  }
}
