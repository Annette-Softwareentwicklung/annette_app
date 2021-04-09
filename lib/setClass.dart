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
  late String buttonText;
  late String configurationString;
  bool finished = false;
  List<String> configurationList = [];

  late String selectedClass;
  late String selectedLk1;
  late String selectedLk2;
  late String selectedGk1;
  late String selectedGk2;
  late String selectedGk3;
  late String selectedGk4;
  late String selectedGk5;
  late String selectedGk6;
  late String selectedGk7;
  late String selectedGk8;
  late String selectedGk9;
  late String selectedGk10;
  late String selectedGk11;
  late String selectedGk12;
  late String selectedGk13;
  late String selectedZk1;
  late String selectedZk2;

  List<String> lk1 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> lk2 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk1 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk2 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk3 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk4 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk5 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk6 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk7 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk8 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk9 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk10 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk11 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk12 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk13 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> zk1 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> zk2 = ['Freistunde', 'Mathe', 'Physik'];

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
    'Q2',
  ];

  void setGroups() {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(String pData) async {
      final _path = await _getPath();
      final _myFile = File('$_path/configuration.txt');
      await _myFile.writeAsString(pData);
    }

    if (selectedClass == 'Q1') {
      _writeData(
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;');
    } else if (selectedClass == 'Q2') {
      _writeData(
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:$selectedZk1;zk2:$selectedZk1;');
    } else {
      _writeData(
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;');
    }
  }

  void setClass() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(String pData) async {
      final _path = await _getPath();
      final _myFile = File('$_path/configuration.txt');
      await _myFile.writeAsString(pData);
    }

    if (selectedClass == 'Q1' ||
        selectedClass == 'Q2' ||
        selectedClass == 'EF') {
      setState(() {
        if(selectedClass == configurationList[0]) {
          selectedLk1 = configurationList[1];
          selectedLk2 = configurationList[2];
          selectedGk1 = configurationList[3];
          selectedGk2 = configurationList[4];
          selectedGk3 = configurationList[5];
          selectedGk4 = configurationList[6];
          selectedGk5 = configurationList[7];
          selectedGk6 = configurationList[8];
          selectedGk7 = configurationList[9];
          selectedGk8 = configurationList[10];
          selectedGk9 = configurationList[11];
          selectedGk10 = configurationList[12];
          selectedGk11 = configurationList[13];
          selectedGk12 = configurationList[14];
          selectedGk13 = configurationList[15];
          selectedZk1 = configurationList[16];
          selectedZk2 = configurationList[17];
        } else {
          selectedLk1 = 'Freistunde';
          selectedLk2 = 'Freistunde';
          selectedGk1 = 'Freistunde';
          selectedGk2 = 'Freistunde';
          selectedGk3 = 'Freistunde';
          selectedGk4 = 'Freistunde';
          selectedGk5 = 'Freistunde';
          selectedGk6 = 'Freistunde';
          selectedGk7 = 'Freistunde';
          selectedGk8 = 'Freistunde';
          selectedGk9 = 'Freistunde';
          selectedGk10 = 'Freistunde';
          selectedGk11 = 'Freistunde';
          selectedGk12 = 'Freistunde';
          selectedGk13 = 'Freistunde';
          selectedZk1 = 'Freistunde';
          selectedZk2 = 'Freistunde';
        }


        showGroups = true;
      });
    } else {
      _writeData(
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;');
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

  void load() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<List<String>> _readData() async {
      List<String> tempContent = [];
      try {
        final _path = await _getPath();
        final _file = File('$_path/configuration.txt');

        String contents = await _file.readAsString();

        tempContent.add(contents.substring(contents.indexOf('c:') + 2,
            contents.indexOf(';', contents.indexOf('c:'))));
        tempContent.add(contents.substring(contents.indexOf('lk1:') + 4,
            contents.indexOf(';', contents.indexOf('lk1:'))));
        tempContent.add(contents.substring(contents.indexOf('lk2:') + 4,
            contents.indexOf(';', contents.indexOf('lk2:'))));

        for (int i = 0; i < 13; i++) {
          int j = i + 1;
          int tempStart = (j < 10) ? 4 : 5;
          print(tempStart);
          String tempString = contents.substring(
              contents.indexOf('gk$j:') + tempStart,
              contents.indexOf(';', contents.indexOf('gk$j:')));
          tempContent.add(tempString);
        }

        tempContent.add(contents.substring(contents.indexOf('zk1:') + 4,
            contents.indexOf(';', contents.indexOf('zk1:'))));
        tempContent.add(contents.substring(contents.indexOf('zk2:') + 4,
            contents.indexOf(';', contents.indexOf('zk2:'))));

        return tempContent;
      } catch (e) {
        print('No configuration');
        tempContent.clear();
        tempContent.add(classes[0]);
        tempContent.add(lk1[0]);
        tempContent.add(lk2[0]);
        tempContent.add(gk1[0]);
        tempContent.add(gk2[0]);
        tempContent.add(gk3[0]);
        tempContent.add(gk4[0]);
        tempContent.add(gk5[0]);
        tempContent.add(gk6[0]);
        tempContent.add(gk7[0]);
        tempContent.add(gk8[0]);
        tempContent.add(gk9[0]);
        tempContent.add(gk10[0]);
        tempContent.add(gk11[0]);
        tempContent.add(gk12[0]);
        tempContent.add(gk13[0]);
        tempContent.add(zk1[0]);
        tempContent.add(zk2[0]);
        return tempContent;
      }
    }

    configurationList = await _readData();
    print(configurationList);
    selectedClass = configurationList[0];

    setState(() {
      finished = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonText = 'Speichern';
    load();
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
    if (finished) {
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
                    scrollController: FixedExtentScrollController(
                        initialItem: classes.indexOf(selectedClass)),
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
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget Groups() {
    return Container(
        child: CustomScrollView(
      slivers: <Widget>[
        ///Leistungskurs
        if (selectedClass == 'Q1' || selectedClass == 'Q2')
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                int j = index + 1;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'LK $j:',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      DropdownButton<String>(
                        items:
                            lk1.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                          if (j == 1) {
                            selectedLk1 = newValue!;
                          } else {
                            selectedLk2 = newValue!;
                          } });
                        },
                        value: (j == 1) ? selectedLk1 : selectedLk2,
                        hint: Text('Fach'),
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                    ]);
              },
              childCount: 2,
            ),
          ),

        ///Grundkurs
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              int j = index + 1;
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'GK $j:',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    DropdownButton<String>(
                      items: gk1.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                        if(j == 1) {
                          selectedGk1 = newValue!;
                        } else if(j == 2) {
                          selectedGk2 = newValue!;
                        } else if(j == 3) {
                          selectedGk3 = newValue!;
                        } else if(j == 4) {
                          selectedGk4 = newValue!;
                        } else if(j == 5) {
                          selectedGk5 = newValue!;
                        } else if(j == 6) {
                          selectedGk6 = newValue!;
                        } else if(j == 7) {
                          selectedGk7 = newValue!;
                        } else if(j == 8) {
                          selectedGk8 = newValue!;
                        } else if(j == 9) {
                          selectedGk9 = newValue!;
                        } else if(j == 10) {
                          selectedGk10 = newValue!;
                        } else if(j == 11) {
                          selectedGk11 = newValue!;
                        } else if(j == 12) {
                          selectedGk12 = newValue!;
                        } else {
                          selectedGk13 = newValue!;
                        } });
                      },
                      value: (j == 1)
                          ? selectedGk1
                          : (j == 2)
                          ? selectedGk2
                          : (j == 3)
                          ? selectedGk3
                          : (j == 4)
                          ? selectedGk4
                          : (j == 5)
                          ? selectedGk5
                          : (j == 6)
                          ? selectedGk6
                          : (j == 7)
                          ? selectedGk7
                          : (j == 8)
                          ? selectedGk8
                          : (j == 9)
                          ? selectedGk9
                          : (j == 10)
                          ? selectedGk10
                          : (j == 11)
                          ? selectedGk11
                          : (j == 12)
                          ? selectedGk12
                          : selectedGk13,
                      hint: Text('Fach'),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ]);
            },
            childCount: 13,
          ),
        ),

        ///Zusatzkurs
        if (selectedClass == 'Q2')
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                int j = index + 1;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'ZK $j:',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      DropdownButton<String>(
                        items:
                            lk1.map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (j == 1) {
                              selectedZk1 = newValue!;
                            } else {
                              selectedZk2 = newValue!;
                            }
                          });
                        },
                        value: (j == 1) ? selectedZk1 : selectedZk2,
                        hint: Text('Fach'),
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                    ]);
              },
              childCount: 2,
            ),
          ),

        ///Button
        SliverList(
            delegate: SliverChildListDelegate.fixed([
          Container(
            margin: EdgeInsets.all(15),
            child: TextButton(
              onPressed: () {
                setGroups();
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
                    'Speichern',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            ),
          ),
        ])),
      ],
    ));
  }
}
