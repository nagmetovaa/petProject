import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold (
        backgroundColor: Colors.white,
      child: SafeArea (
        child: Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 230.0),),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: CupertinoButton.filled(onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                      child: Text('Войти', style: TextStyle(fontSize: 20),)
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0),),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: CupertinoButton(
                    child: Text('Зарегистрироваться', style: TextStyle(fontSize: 20),),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
