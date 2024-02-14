import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/my_page.dart';
import 'package:myapp/pages/my_docs.dart';
import 'package:myapp/pages/my_contacts.dart';
import 'package:myapp/pages/file_upload.dart';

class MyProfile extends StatefulWidget {

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();

}

class _MyProfileScreenState extends State<MyProfile> {


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
          child: CupertinoTabScaffold (
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled),
                  label: 'Мой профиль',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_2_fill),
                  label: 'Доступные мне',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Мои контакты',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.doc),
                  label: 'Мои документы',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              return MyTabContent(index: index);
            },
          ),
        ),
    );
  }
}

class MyTabContent extends StatefulWidget {
  final int index;

  const MyTabContent({Key? key, required this.index}) : super(key: key);

  @override
  _MyTabContentState createState() => _MyTabContentState();
}

class _MyTabContentState extends State<MyTabContent> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    switch (widget.index) {
      case 0:
        return MyPage();
      case 1:
        return MainContent();
      case 2:
        return MyContacts();
      case 3:
        return MyDocuments();
      default:
        return MyPage();
    }
  }

  @override
  bool get wantKeepAlive => true;
}




class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Main Content'),
    );
  }
}

