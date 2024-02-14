import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/my_profile.dart';
import 'package:myapp/pages/my_page.dart';
import 'package:myapp/pages/my_docs.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyContacts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Мои контакты'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add_circled_solid,
              size: 30,),
            //minSize: 110.0,
            onPressed:() {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => AddContact()),
              );
            }
        ),
      ),
      child: Center(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
          stream: FirebaseFirestore.instance.collection('myContacts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return CupertinoActivityIndicator();
            }

            var users = snapshot.data?.docs;

            return ListView.builder(
              itemCount: users?.length ?? 0,
              itemBuilder: (context, index) {
                var user = users?[index];
                var name = user?['username'];
                var email = user?['email'];

                return CupertinoListTile(
                  title: Text(name ?? ''),
                  subtitle: Text(email ?? ''),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AddContact extends StatefulWidget {

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _searchResults = [];
  String _selectedItem = '';
  String _initialItem = '';

  // void initValue() {
  //   _selectedItem = _searchResults[0]['email'];
  //   _searchController.text = _selectedItem ?? '';
  // }

  @override
    Widget build(BuildContext context) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Поиск и добавление контактов"),
        ),
        child: SafeArea (
          child: Column(
            children: [
              CupertinoSearchTextField(
                controller: _searchController,
                onChanged: (value) {
                  onSearchTextChanged(value);
                },
                placeholder: 'Введите email для поиска',
              ),
              SizedBox(height: 16.0),
              _searchResults.isNotEmpty
                ?Container(
                height: 200,
                child:
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _selectedItem = _searchResults[index]['email'];
                              _searchController.text = _selectedItem;
                            },
                            child: ListView.builder(
                              itemCount: _searchResults.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  var user = _searchResults?[index];
                                  var name = user?['username'];
                                  var email = user?['email'];

                                  return CupertinoListTile(
                                    title: Text(name ?? ''),
                                    subtitle: Text(email ?? ''),
                                  );
                                }
                              )
                          );
                        },
                        childCount: _searchResults.length,
                      ),
                    ),
                  ],
                )
              )
                  :Container(),
              SizedBox(height: 16.0),
              CupertinoButton.filled(
                onPressed: () {
                  searchAndAddData();
                  Navigator.pop(context);
                },
                child: Text('Добавить'),
              ),
              Text(_searchController.text)
            ],
          ),
      )
      );
  }

  void onSearchTextChanged(String value) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('user')
        .where('email', isGreaterThanOrEqualTo: value)
        .where('email', isLessThan: value + 'z')
        .get();
    setState(() {
      _searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> searchAndAddData() async {
    String searchData = _searchController.text;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('user')
        .where('email', isEqualTo: searchData)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = documentSnapshot.data();

      await FirebaseFirestore.instance
          .collection('myContacts')
          .add(data);
    }

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Операция успешно выполнена'),
          content: Text('Данные добавлены в ваши контакты.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _searchResults.map((result) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(result['email']),
        );
      }).toList(),
    );
  }
}