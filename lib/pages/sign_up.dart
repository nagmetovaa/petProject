import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ),
        backgroundColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 10.0),),
                Text('Регистрация нового пользователя',
                  style: TextStyle(fontSize: 22, height: 3),),
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
                    controller: _usernameController,
                    obscureText: false,
                    placeholder:'Введите свое имя',
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
                Padding(padding: EdgeInsets.only(bottom: 30.0),),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: CupertinoButton(onPressed: () {
                    _registerUser();
                  },
                    child: Text(
                      'Зарегистрироваться', style: TextStyle(fontSize: 20),),
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );;
  }

  void showEmailAlreadyInUseDialog () {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Ошибка регистрации'),
          content: Text('Адрес электронной почты уже используется'),
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
          title: Text('Ошибка регистрации'),
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

  void _registerUser() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        String userId = user.uid;

        await FirebaseFirestore.instance.collection('user').doc(userId).set({
          'email': userCredential.user?.email,
          'username': username});
        FullScreenDialogAlert();

        Navigator.pushReplacementNamed(context, '/myprofile');
      }
      // showRegistrationSuccess ();
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          showEmailAlreadyInUseDialog ();
        } else  if (e.code == 'invalid-email') {
          showBadEmailDialog ();
        } else {
          print('${e.code}');
          print('${e.message}');
          showOtherErrorDialog ();
        }
      }
    }
  }
}

class FullScreenDialogAlert extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return CupertinoDialogAction(
      child: Container (
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Регистрация прошла успешно!'),
            CupertinoButton.filled(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
