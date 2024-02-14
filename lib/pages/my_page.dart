import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/my_profile.dart';


class MyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.white,
            middle: Text('Мой профиль'),
          ),
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 10.0),),
                  Row(
                  children: [
                    Text('Добро пожаловать, '),
                    UserProfileWidget()
                  ],
                ),
                  Padding(padding: EdgeInsets.only(bottom: 70.0),),
                  SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCustomButton(
                            onPressed: () {
                              print('Нажата первая кнопка');
                            },
                            icon: Icon(
                              CupertinoIcons.square_arrow_down,
                              size: 24,
                              color: CupertinoColors.systemBlue,),
                            text: 'История загрузок',
                            size: 140,
                          ),
                          buildCustomButton(
                            onPressed: () {
                              print('Нажата вторая кнопка');
                            },
                            icon: Icon(
                              CupertinoIcons.bell,
                              size: 24,
                              color: CupertinoColors.systemBlue,),
                            text: 'Уведомления',
                            size: 177,
                          ),
                          buildCustomButton(
                            onPressed: () {
                              print('Нажата третья кнопка');
                            },
                            icon: Icon(
                              CupertinoIcons.person_add,
                              size: 24,
                              color: CupertinoColors.systemBlue,),
                            text: 'Пригласить друга',
                            size: 135,
                          ),
                          buildCustomButton(
                            onPressed: () {
                              print('Нажата четвертая кнопка');
                            },
                            icon: Icon(
                              CupertinoIcons.globe,
                              size: 24,
                              color: CupertinoColors.systemBlue,),
                            text: 'Язык интерфейса',
                            size: 135,
                          ),
                        ],
                      )
                  )
                ],
              )
          ),
        )
    );
  }

  Widget buildCustomButton({
    required VoidCallback onPressed,
    Widget? icon,
    String? text,
    double? size,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 380,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          color: CupertinoColors.systemGrey4,
          border: Border.all(color: CupertinoColors.extraLightBackgroundGray),
        ),
        child: Row(
          children: [
            if (icon != null) icon,
            SizedBox(width: 10.0),
            if (text != null) Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: CupertinoColors.black,),
              textAlign: TextAlign.left,),
          SizedBox(width: size),
          Icon(CupertinoIcons.right_chevron),
          ],
        ),
      ),
    );
  }
}





class UserProfileWidget extends StatelessWidget {

  Future<String?> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      final documentSnapshot = await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final userName = data['username'] as String? ?? 'Пользователь';
        return userName;
      } else {
        return 'Неизвестный войн';
      }
    } else {
      return 'Аноним';
    }
  }

  Future<String?> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      final documentSnapshot = await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final email = data['email'] as String? ?? 'Пользователь';
        return email;
      } else {
        return 'Неизвестный войн';
      }
    } else {
      return 'Аноним';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Отображение индикатора загрузки
        } else if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        } else {
          return Text(' ${snapshot.data}'); // Отображение имени пользователя
        }
      },
    );
  }
}