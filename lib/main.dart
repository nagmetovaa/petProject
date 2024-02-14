import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/welcome_page.dart';
import 'package:myapp/pages/sign_in.dart';
import 'package:myapp/pages/sign_up.dart';
import 'package:myapp/pages/my_profile.dart';
import 'package:myapp/pages/my_page.dart';
import 'package:myapp/pages/my_docs.dart';
import 'package:myapp/pages/file_upload.dart';
import 'package:myapp/pages/my_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
   runApp(MyApp());
}

class MyApp extends StatefulWidget {
   @override
   _MyApp createState() => _MyApp();
 }

 class _MyApp extends State<MyApp> {
   @override
   void initState() {
     super.initState();
   }

   @override
   Widget build(BuildContext context) {
     return CupertinoApp(

       initialRoute: '/myprofile',
       routes: {
        '/': (context) => WelcomePage(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
         '/myprofile': (context) => MyProfile(),
         '/mypage': (context) => MyPage(),
         '/mydocs': (context) => MyDocuments(),
         '/fileupload': (context) => AddListPage(),
         '/mycontacts': (context) => MyContacts(),
      },
     );
   }
 }

class MyProfile extends StatelessWidget {

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
