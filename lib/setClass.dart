import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SetClass extends StatefulWidget {
  @override
  _SetClassState createState() => _SetClassState();
}

class _SetClassState extends State<SetClass> {
  bool showGroups = false;
  late String selectedClass;
  late String buttonText;

  ///Liste aller Klassen bzw. Stufen
  List<String> classes = [
    '5A',
    '5B',
    '5C',
    '5D',
    '5F',
    '6A',
    '6B',
    '6C',
    '6D',
    '6F',
    '7A',
    '7B',
    '7C',
    '7D',
    '7E',
    '8A',
    '8B',
    '8C',
    '8D',
    '8E',
    '9A',
    '9B',
    '9C',
    '9D',
    '9F',
    'EF',
    'Q1',
    'Q2'
  ];

  Future<void> setClass() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    /* Future<String?> _readData() async {
      try {
        final _path = await _getPath();
        final _file = File('$_path/configuration.txt');

        String contents = await _file.readAsString();
        return contents;
      } catch (e) {
        return null;
      }
    }*/

    Future<void> _writeData(String pData) async {
      final _path = await _getPath();
      final _myFile = File('$_path/configuration.txt');
      await _myFile.writeAsString(pData);
    }

    // await _writeData('selectedClass:$selectedClass');
    print('Speichern: $selectedClass');
    if (selectedClass == 'Q1' ||
        selectedClass == 'Q2' ||
        selectedClass == 'EF') {
      setState(() {
        showGroups = true;
      });
    }
  }

  String getButtonText() {
    if (selectedClass == 'Q1' ||
        selectedClass == 'Q2' ||
        selectedClass == 'EF') {
      return 'Kurse wählen';
    } else {
      return 'Speichern';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonText = 'Speichern';
    selectedClass = '5A';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: (showGroups) ? Groups() : Classes());
  }

  Widget Classes() {
    return Center(
      child: IntrinsicHeight(
          child: Column(
        children: [
          Text('Klasse wählen:'),
          Container(
              height: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: CupertinoPicker(
                  itemExtent: 33,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedClass = classes[index];
                      buttonText = getButtonText();
                    });
                  },
                  children: new List<Text>.generate(
                      classes.length,
                      (index) => Text(
                            classes[index],
                            style: TextStyle(fontSize: 25),
                          )))),
          IntrinsicWidth(
              child: Container(
            margin: EdgeInsets.all(15),
            child: TextButton(
              onPressed: () {
                setClass();
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  //height: 50,
                  constraints: BoxConstraints(
                    minWidth: 150,
                    minHeight: 50,
                  ),
                  //width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            ),
          ))
        ],
      )),
    );
  }

  Widget Groups() {
    return Container(child: ListView());
  }
}
