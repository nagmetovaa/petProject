import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/my_profile.dart';
import 'package:myapp/pages/my_page.dart';
import 'package:myapp/pages/my_docs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path/path.dart';

// class FileUpload extends StatefulWidget {
//
//
//   @override
//   _FileUploadScreenState createState() => _FileUploadScreenState();
// }
//
// class _FileUploadScreenState extends State<FileUpload> {
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       showModalWindow(context);
//     });
//     return Container();
//   }
//
//
//
//
// void showModalWindow (BuildContext context) {
//     showCupertinoModalPopup<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoActionSheet(
//           title: Text("Выберите опцию"),
//           actions: <Widget>[
//             CupertinoActionSheetAction(
//               child: Text("Создать список"),
//               onPressed: () {
//                 print('lets start');
//                 // openModal(context);
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(
//                   context,
//                   CupertinoPageRoute(builder: (context) => AddListPage()),
//                 );
//               },
//             ),
//             CupertinoActionSheetAction(
//                 child: Text("Загрузить список с excel файла"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   addFromFile();
//                 }
//             ),
//           ],
//           cancelButton: CupertinoActionSheetAction(
//             child: Text("Отмена"),
//             isDefaultAction: true,
//             onPressed: () {
//               // Navigator.pushReplacement(
//               //   context,
//               //   CupertinoPageRoute(builder: (context) => MyDocuments()),
//               // );
//               Navigator.of(context).pop(false);
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   // bool _isModalOpen = false;
//   // @override
//   // Widget build(BuildContext context) {
//   //   WidgetsBinding.instance!.addPostFrameCallback((_) {
//   //     if (!_isModalOpen) {
//   //       _isModalOpen = true;
//   //       showCupertinoModalPopup<void>(
//   //         context: context,
//   //         builder: (BuildContext context) {
//   //           return CupertinoActionSheet(
//   //             title: Text("Выберите опцию"),
//   //             actions: <Widget>[
//   //               CupertinoActionSheetAction(
//   //                 child: Text("Создать список"),
//   //                 onPressed: () {
//   //                   print('lets start');
//   //                   // openModal(context);
//   //                   Navigator.pop(context);
//   //                   Navigator.pushReplacement(
//   //                       context,
//   //                       CupertinoPageRoute(builder: (context) => AddListPage()),
//   //                   );
//   //                 },
//   //               ),
//   //               CupertinoActionSheetAction(
//   //                   child: Text("Загрузить список с excel файла"),
//   //                   onPressed: () {
//   //                     Navigator.pop(context);
//   //                     addFromFile();
//   //                   }
//   //               ),
//   //             ],
//   //             cancelButton: CupertinoActionSheetAction(
//   //               child: Text("Отмена"),
//   //               isDefaultAction: true,
//   //               onPressed: () {
//   //                 _isModalOpen = false;
//   //                 // Navigator.pushReplacement(
//   //                 //   context,
//   //                 //   CupertinoPageRoute(builder: (context) => MyDocuments()),
//   //                 // );
//   //                 Navigator.of(context).pop(false);
//   //               },
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     }
//   //   });
//   //   return MyDocuments();
//   // }
//
//
//   void addFromFile() async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['xlsx'],
//       );
//       List<Map<String, dynamic>> renameAllKeysInList(List<Map<String, dynamic>> originalList, String newKey) {
//         List<Map<String, dynamic>> updatedList = [];
//
//         for (var map in originalList) {
//           Map<String, dynamic> updatedMap = {};
//           map.forEach((oldKey, value) {
//             updatedMap[newKey] = value;
//           });
//           updatedList.add(updatedMap);
//         }
//
//         return updatedList;
//       }
//
//       if (result != null) {
//         final file = File(result.files.single.path!);
//         final key = basenameWithoutExtension(file.path);
//         final data = await readExcelData(file);
//
//         List<Map<String, dynamic>> newData = renameAllKeysInList(data, 'Name');
//
//         final firestore = FirebaseFirestore.instance;
//         CollectionReference titleCollection = firestore.collection('titles');
//         DocumentReference titleDocRef = await titleCollection.add({
//           'title':key,
//         });
//         final listCollection = firestore.collection('lists');
//         // CollectionReference subCollection = listCollection.doc(titleDocRef.id)
//
//         if (data != null) {
//           for (var record in newData) {
//             record['titleId'] = titleDocRef.id;
//             await listCollection.add(record);
//           }
//         }
//         listAddedSuccess();
//       }
//     }
//     else {
//       permissionError();
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> readExcelData(File file) async {
//     try {
//       final bytes = file.readAsBytesSync();
//       final excel = Excel.decodeBytes(bytes);
//       final table = excel.tables[excel.tables.keys.first];
//       final data = <Map<String, dynamic>>[];
//
//       if (table != null) {
//         for (var i = 1; i < table.maxRows; i++) {
//           final row = table.row(i);
//           final rowData = <String, dynamic>{};
//           for (var j = 0; j < row.length; j++) {
//             final header = table.row(0)[j]?.value;
//             final headerStr = header.toString();
//             final cell = row[j]?.value;
//             final stringValue = cell.toString();
//             rowData[headerStr] = stringValue;
//           }
//           data.add(rowData);
//         }
//       }
//       return data;
//     } catch (e) {
//       print('Ошибка чтения Excel файла: $e');
//       return <Map<String, dynamic>>[];
//     }
//   }
//
//   void listAddedSuccess() {
//     showCupertinoModalPopup<void>(
//       context: this.context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: Text('Добавление данных'),
//           content: Text('Список успешно добавлен.'),
//           actions: <Widget>[
//             CupertinoButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   CupertinoPageRoute(builder: (BuildContext context) => MyDocuments()),
//                 );
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void permissionError() {
//     showCupertinoModalPopup<void>(
//       context: this.context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: Text('Добавление данных'),
//           content: Text(
//               'Необходимо предоставить разрешение на обработку файлов!'),
//           actions: <Widget>[
//             CupertinoButton(
//               onPressed: () {
//                 // Navigator.of(context).pop();
//                 Navigator.of(context, rootNavigator: true).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


class AddListPage extends StatefulWidget {
  _AddListPageState createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {

  TextEditingController _topicController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> records = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Назад',
          onPressed: () {
            Navigator.of(context).pop(false);
            },
        ),
        middle: Text('Создать список'),
      ),
      child:
      Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: _topicController,
                obscureText: false,
                placeholder: 'Введите название списка',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0),),
              CupertinoTextField(
                controller: _nameController,
                obscureText: false,
                placeholder: 'Введите элемент списка',
              ),
              Padding(padding: EdgeInsets.only(top: 20.0),),
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return CupertinoListTile(
                      title: Text(records[index]['Name']),
                    );
                    },
                ),
              ),
              CupertinoButton(
                child: Text('Добавить запись'),
                onPressed: () {
                  setState(() {
                    String enteredText = _nameController.text;
                    Map<String, dynamic> person = {'Name' : enteredText};
                    records.add(person);
                    _nameController.clear();
                  });
                  },
              ),
              CupertinoButton.filled(
                child: Text('Сохранить список'),
                onPressed: () {
                  setState(() {
                    addRecordToSubcollection();
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(builder: (BuildContext context) => MyDocuments())
                    // );
                          // records.clear();
                          Future.delayed(Duration(seconds: 5), () {
                            _topicController.clear();
                            records.clear();
                          });
                    // _topicController.clear();
                  });
                  },
              ),
            ],
          )
      ),
    );

  }

  void addRecordToSubcollection() async {
    final firestore = FirebaseFirestore.instance;
    final mainCollection = firestore.collection('titles');
    final listCollection = firestore.collection('lists');
    // final subCollection = mainCollection.doc(_topicController.text).collection('data');
    UserProfileWidget userProfileWidget = UserProfileWidget();
    String? email = await userProfileWidget.getUserEmail();
    print(email);


    DocumentReference titleDocRef = await mainCollection.add({
      'title': _topicController.text,
      'email': email,
    });

    String titleId = titleDocRef.id;

    for (int i = 0; i < records.length; i++) {
      records[i]['titleId'] = titleId;
    }

    // record.forEach((Map<String, dynamic> item) {
    //   await listCollection.add(item);
    // });
    for (int i = 0; i < records.length; i++) {
      await listCollection.add(records[i]);
    }
    records.clear();
  }
}


