import 'dart:io';
import 'package:annette_app/classesMap.dart';
import 'package:annette_app/timetable/timetableCrawler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SetClass extends StatefulWidget {
  final bool isInGuide;
  final VoidCallback onButtonPressed;
  SetClass({required this.isInGuide, required this.onButtonPressed});

  @override
  _SetClassState createState() => _SetClassState();
}

class _SetClassState extends State<SetClass> {
  bool showGroupsOS = false;
  bool showGroupsUS = false;
  bool showFinishedConfiguration = false;
  late String configurationString;
  bool finished = false;
  List<String> configurationList = [];
  late List<String> classes;

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

  late String selectedReligionUS;
  String selectedSecondLanguageUS = 'Freistunde';
  late String selectedDiffUS;

  List<String> religionUS = ['Kath. Religion', 'Ev. Religion', 'Philosophie'];
  List<String> secondLanguageUS = ['Latein', 'Französisch'];
  List<String> diffUS = [
    'Informatik',
    'Physik-Technik',
    'Spanisch',
    'Kunst',
    'Geschichte'
  ];

  List<String> lk1 = ['Freistunde', 'Mathe', 'PH LK'];
  List<String> lk2 = ['Freistunde', 'Mathe', 'Physik'];
  List<String> gk1 = ['Freistunde', 'Mathe', 'Physik', 'BI GK3', 'L GK1'];
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

  void setGroupsOS() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(String pData) async {
      final _path = await _getPath();
      final _myFile = File('$_path/configuration.txt');
      await _myFile.writeAsString(pData);
    }

    String tempConfiguration;

    if (selectedClass == 'Q1') {
      tempConfiguration =
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
      await _writeData(tempConfiguration);
    } else if (selectedClass == 'Q2') {
      tempConfiguration =
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:$selectedZk1;zk2:$selectedZk1;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
      await _writeData(tempConfiguration);
    } else {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
      await _writeData(tempConfiguration);
    }

    setState(() {
      showFinishedConfiguration = true;
      finished = false;
    });
    activateTimetableCrawler(tempConfiguration);
  }

  void setGroupsUS() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(String pData) async {
      final _path = await _getPath();
      final _myFile = File('$_path/configuration.txt');
      await _myFile.writeAsString(pData);
    }

    String tempConfiguration;

    if (selectedReligionUS == 'Kath. Religion') {
      selectedReligionUS = 'KR';
    } else if (selectedReligionUS == 'Ev. Religion') {
      selectedReligionUS = 'ER';
    } else {
      selectedReligionUS = 'PPL';
    }

    if (selectedSecondLanguageUS == 'Französisch') {
      selectedSecondLanguageUS = 'F6';
    } else {
      selectedSecondLanguageUS = 'L6';
    }

    if (selectedDiffUS == 'Physik-Technik') {
      selectedDiffUS = 'PHd';
    } else if (selectedDiffUS == 'Kunst') {
      selectedDiffUS = 'KUd';
    } else if (selectedDiffUS == 'Spanisch') {
      selectedDiffUS = 'S8';
    } else if (selectedDiffUS == 'Geschichte') {
      selectedDiffUS = 'GEd';
    } else {
      selectedDiffUS = 'IFd';
    }

    if (selectedClass.contains('8') || selectedClass.contains('9')) {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:$selectedSecondLanguageUS;diffUS:$selectedDiffUS;';
      await _writeData(tempConfiguration);
    } else if (!selectedClass.contains('5')) {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:$selectedSecondLanguageUS;diffUS:Freistunde;';
      await _writeData(tempConfiguration);
    } else {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:Freistunde;diffUS:Freistunde;';
      await _writeData(tempConfiguration);
    }

    setState(() {
      showFinishedConfiguration = true;
      finished = false;
    });
    activateTimetableCrawler(tempConfiguration);
  }

  void activateTimetableCrawler(pConfigurationString) async {
    TimetableCrawler ttc1 =
        new TimetableCrawler(configurationString: pConfigurationString);
    await ttc1.setConfiguration();
    setState(() {
      finished = true;
    });
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
        if (selectedClass == configurationList[0]) {
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

        showGroupsOS = true;
      });
    } else {
      setState(() {
        if (selectedClass == configurationList[0]) {
          selectedReligionUS = configurationList[18];
          selectedSecondLanguageUS = configurationList[19];
          selectedDiffUS = configurationList[20];
        } else {
          selectedReligionUS = 'Kath. Religion';
          selectedSecondLanguageUS = 'Latein';
          selectedDiffUS = 'Informatik';
        }
        showGroupsUS = true;
      });
    }
  }

  void load() async {
    classes = getAllClasses();

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
          String tempString = contents.substring(
              contents.indexOf('gk$j:') + tempStart,
              contents.indexOf(';', contents.indexOf('gk$j:')));
          tempContent.add(tempString);
        }

        tempContent.add(contents.substring(contents.indexOf('zk1:') + 4,
            contents.indexOf(';', contents.indexOf('zk1:'))));
        tempContent.add(contents.substring(contents.indexOf('zk2:') + 4,
            contents.indexOf(';', contents.indexOf('zk2:'))));

        String tempReligion = contents.substring(
            contents.indexOf('religionUS:') + 11,
            contents.indexOf(';', contents.indexOf('religionUS:')));
        String temp2Language = contents.substring(
            contents.indexOf('sLanguageUS:') + 12,
            contents.indexOf(';', contents.indexOf('sLanguageUS:')));
        String tempDiff = contents.substring(contents.indexOf('diffUS:') + 7,
            contents.indexOf(';', contents.indexOf('diffUS:')));

        if (tempReligion == 'KR') {
          tempContent.add('Kath. Religion');
        } else if (tempReligion == 'ER') {
          tempContent.add('Ev. Religion');
        } else {
          tempContent.add('Philosophie');
        }

        if (temp2Language == 'F6') {
          tempContent.add('Französisch');
        } else {
          tempContent.add('Latein');
        }

        if (tempDiff == 'PHd') {
          tempContent.add('Physik-Technik');
        } else if (tempDiff == 'KUd') {
          tempContent.add('Kunst');
        } else if (tempDiff == 'S8') {
          tempContent.add('Spanisch');
        } else if (tempDiff == 'GEd') {
          tempContent.add('Geschichte');
        } else {
          tempContent.add('Informatik');
        }

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
        tempContent.add(religionUS[0]);
        tempContent.add(secondLanguageUS[0]);
        tempContent.add(diffUS[0]);
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
    load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Center(
            child: (showFinishedConfiguration)
                ? FinishedConfiguration()
                : (showGroupsOS)
                    ? GroupsOS()
                    : (showGroupsUS)
                        ? GroupsUS()
                        : Classes()),
      ),
    );
  }

  Widget Classes() {
    if (finished) {
      return SingleChildScrollView(
          child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Klasse wählen:',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
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
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).accentColor
                                : Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            'Weiter',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )),
                    ),
                  ))
                ],
              )));
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget GroupsOS() {
    String infoText = 'Wähle hier deine individuellen Kurse. Dazu zählen die ';
    if(selectedClass == 'Q1' || selectedClass == 'Q2') {
       infoText = infoText + 'Leistungs- und ';
    }
    infoText = infoText + 'Grund';
    if(selectedClass == 'Q2') {
      infoText = infoText.replaceFirst(' und', ', ');
      infoText = infoText + '- und Zusatz';
    }
    infoText = infoText + 'kurse.';

    return Container(
        child: Column(children: [
      Expanded(
          child: CustomScrollView(
        slivers: <Widget>[
          ///Text
          SliverList(
              delegate: SliverChildListDelegate.fixed([
                Container(
                  child: Text(infoText,style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                  ),
                ),
              ])),
          ///Leistungskurs
          if (selectedClass == 'Q1' || selectedClass == 'Q2')
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  int j = index + 1;
                  List<String> tempSubjects = (j == 1) ? lk1 : lk2;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'LK $j:',
                          style: TextStyle(fontSize: 17.0),
                        ),
                        DropdownButton<String>(
                          items: tempSubjects
                              .map<DropdownMenuItem<String>>((String? value) {
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
                              }
                            });
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
                List<String> tempSubjects = (j == 1)
                    ? gk1
                    : (j == 2)
                        ? gk2
                        : (j == 3)
                            ? gk3
                            : (j == 4)
                                ? gk4
                                : (j == 5)
                                    ? gk5
                                    : (j == 6)
                                        ? gk6
                                        : (j == 7)
                                            ? gk7
                                            : (j == 8)
                                                ? gk8
                                                : (j == 9)
                                                    ? gk9
                                                    : (j == 10)
                                                        ? gk10
                                                        : (j == 11)
                                                            ? gk11
                                                            : (j == 12)
                                                                ? gk12
                                                                : gk13;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'GK $j:',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      DropdownButton<String>(
                        items: tempSubjects
                            .map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (j == 1) {
                              selectedGk1 = newValue!;
                            } else if (j == 2) {
                              selectedGk2 = newValue!;
                            } else if (j == 3) {
                              selectedGk3 = newValue!;
                            } else if (j == 4) {
                              selectedGk4 = newValue!;
                            } else if (j == 5) {
                              selectedGk5 = newValue!;
                            } else if (j == 6) {
                              selectedGk6 = newValue!;
                            } else if (j == 7) {
                              selectedGk7 = newValue!;
                            } else if (j == 8) {
                              selectedGk8 = newValue!;
                            } else if (j == 9) {
                              selectedGk9 = newValue!;
                            } else if (j == 10) {
                              selectedGk10 = newValue!;
                            } else if (j == 11) {
                              selectedGk11 = newValue!;
                            } else if (j == 12) {
                              selectedGk12 = newValue!;
                            } else {
                              selectedGk13 = newValue!;
                            }
                          });
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
                  List<String> tempSubjects = (j == 1) ? zk1 : zk2;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'ZK $j:',
                          style: TextStyle(fontSize: 17.0),
                        ),
                        DropdownButton<String>(
                          items: tempSubjects
                              .map<DropdownMenuItem<String>>((String? value) {
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
        ],
      )),

      ///Button

      Container(
        margin: EdgeInsets.all(15),
        child: TextButton(
          onPressed: () {
            setGroupsOS();
          },
          child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? Theme.of(context).accentColor
                    : Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                'Speichern',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.black
                      : Colors.white,
                ),
              )),
        ),
      ),
    ]));
  }

  Widget FinishedConfiguration() {
    if (finished) {
      return Container(
          padding: EdgeInsets.all(15),
          //alignment: Alignment.center,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: ScrollController(initialScrollOffset: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  //Spacer(flex: 1),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Fertig.',
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: (widget.isInGuide)
                        ? Text(
                            'Viel Spaß beim Benutzen der App!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          )
                        : Text(
                            'Deine Klasse wurde geändert!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                  ),
                  CupertinoButton(
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor
                        : Theme.of(context).accentColor,
                    child: (widget.isInGuide)
                        ? Text(
                            'Los geht\'s',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .floatingActionButtonTheme
                                    .foregroundColor),
                          )
                        : Text(
                            'Zurück zur App',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .floatingActionButtonTheme
                                    .foregroundColor),
                          ),
                    onPressed: () {
                      widget.onButtonPressed();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )));
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget GroupsUS() {
    String infoText = 'Wähle hier deine individuellen Kurse. Dazu zähl';

    if(selectedClass.contains('5')) {
      infoText = infoText + 't Religion.';
    } else     if(!selectedClass.contains('8') && !selectedClass.contains('9')) {
      infoText = infoText + 'en Religion und die zweite Fremdsprache.';

    } else {
      infoText = infoText + 'en Religion, die zweite Fremdsprache und dein Diff-Fach.';

    }


      return Container(
        child: Column(children: [
      Expanded(
          child: CustomScrollView(
        slivers: <Widget>[
          ///Text
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                child: Text(infoText,style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
            ])),

          ///Religion
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Religion:',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  DropdownButton<String>(
                    items: religionUS
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReligionUS = newValue!;
                      });
                    },
                    value: selectedReligionUS,
                    hint: Text('Fach'),
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ])
          ])),

          ///2. Fremdsprache
          if (!selectedClass.contains('5') && !selectedClass.contains('F'))
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '2. Sprache:',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    DropdownButton<String>(
                      items: secondLanguageUS
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSecondLanguageUS = newValue!;
                        });
                      },
                      value: selectedSecondLanguageUS,
                      hint: Text('Fach'),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ])
            ])),

          ///Diff
          if (selectedClass.contains('8') || selectedClass.contains('9'))
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Diff.-Fach:',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    DropdownButton<String>(
                      items:
                          diffUS.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDiffUS = newValue!;
                        });
                      },
                      value: selectedDiffUS,
                      hint: Text('Fach'),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ])
            ])),
        ],
      )),

      ///Button

      Container(
        margin: EdgeInsets.all(15),
        child: TextButton(
          onPressed: () {
            setGroupsUS();
          },
          child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 50,
              width: 180,
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
    ]));
  }
}
