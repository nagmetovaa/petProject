import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/my_profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:myapp/pages/file_upload.dart';

class MyDocuments extends StatefulWidget {

  @override
  _MyDocumentsScreenState createState() => _MyDocumentsScreenState();


}
class _MyDocumentsScreenState extends State<MyDocuments> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Мои документы'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add_circled_solid,
              size: 30,),
            //minSize: 110.0,
            onPressed:() {
              showModalWindow(context);
              // Navigator.pushReplacementNamed(context, '/fileupload');
            }
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            DatalistWidget(),
          ],
        ),
      )
    );
  }

  void showModalWindow (BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Выберите опцию"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text("Создать список"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => AddListPage()),
                );
              },
            ),
            CupertinoActionSheetAction(
                child: Text("Загрузить список с excel файла"),
                onPressed: () {
                  addFromFile();
                }
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Отмена"),
            isDefaultAction: true,
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   CupertinoPageRoute(builder: (context) => MyDocuments()),
              // );
              Navigator.of(context).pop(false);
            },
          ),
        );
      },
    );
  }

  void addFromFile() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      List<Map<String, dynamic>> renameAllKeysInList(List<Map<String, dynamic>> originalList, String newKey) {
        List<Map<String, dynamic>> updatedList = [];

        for (var map in originalList) {
          Map<String, dynamic> updatedMap = {};
          map.forEach((oldKey, value) {
            updatedMap[newKey] = value;
          });
          updatedList.add(updatedMap);
        }

        return updatedList;
      }

      if (result != null) {
        final file = File(result.files.single.path!);
        final key = basenameWithoutExtension(file.path);
        final data = await readExcelData(file);

        List<Map<String, dynamic>> newData = renameAllKeysInList(data, 'Name');

        final firestore = FirebaseFirestore.instance;
        CollectionReference titleCollection = firestore.collection('titles');
        DocumentReference titleDocRef = await titleCollection.add({
          'title':key,
        });
        final listCollection = firestore.collection('lists');
        // CollectionReference subCollection = listCollection.doc(titleDocRef.id)

        if (data != null) {
          for (var record in newData) {
            record['titleId'] = titleDocRef.id;
            await listCollection.add(record);
          }
        }
        listAddedSuccess();
      }
    }
    else {
      permissionError();
    }
  }

  Future<List<Map<String, dynamic>>> readExcelData(File file) async {
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final table = excel.tables[excel.tables.keys.first];
      final data = <Map<String, dynamic>>[];

      if (table != null) {
        for (var i = 1; i < table.maxRows; i++) {
          final row = table.row(i);
          final rowData = <String, dynamic>{};
          for (var j = 0; j < row.length; j++) {
            final header = table.row(0)[j]?.value;
            final headerStr = header.toString();
            final cell = row[j]?.value;
            final stringValue = cell.toString();
            rowData[headerStr] = stringValue;
          }
          data.add(rowData);
        }
      }
      return data;
    } catch (e) {
      print('Ошибка чтения Excel файла: $e');
      return <Map<String, dynamic>>[];
    }
  }


  void listAddedSuccess() {
    showCupertinoModalPopup<void>(
      context: this.context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Добавление данных'),
          content: Text('Список успешно добавлен.'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(builder: (BuildContext context) => MyDocuments()),
                // );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void permissionError() {
    showCupertinoModalPopup<void>(
      context: this.context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Добавление данных'),
          content: Text(
              'Необходимо предоставить разрешение на обработку файлов!'),
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


class DatalistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchDocumentIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No documents available.');
        } else {
          final documentIds = snapshot.data!;
          return ListView.builder(
            itemCount: documentIds.length,
            itemBuilder: (context, index) {
              final documentTitle = documentIds[index]['title'];
              final documentId = documentIds[index]['docId'];
              return CupertinoListTile(
                  title: Text(documentTitle),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DetailPage(documentId: documentId),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchDocumentIds() async {
    final collection = FirebaseFirestore.instance.collection('titles');
    final querySnapshot = await collection.get();

    Map<String, dynamic> dataList = {};
    final List<Map<String, dynamic>> documentTitles = [];

    for (final doc in querySnapshot.docs) {
      dataList = doc.data();
      dataList['docId'] = doc.id;
      documentTitles.add(dataList);
    }
    return documentTitles;
  }
}

class DetailPage extends StatelessWidget {
  final String documentId;

  DetailPage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Detail Page'),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDataForDocument(documentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available for documentId: $documentId');
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return CupertinoListTile(
                    title: Text(item['Name'].toString())
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataForDocument(String documentId) async {


    final collection = FirebaseFirestore.instance.collection('lists');
    // final documentSnapshot = await collection.doc(documentId).collection('data').get();
    // final collection = FirebaseFirestore.instance.collection('titles');
    final documentSnapshot = await collection
        .where('titleId', isEqualTo: documentId)
        .get();


    final List<Map<String, dynamic>> data = [];
    for (final doc in documentSnapshot.docs) {
      data.add(doc.data() as Map<String, dynamic>);
    }

    return data;
  }

}





