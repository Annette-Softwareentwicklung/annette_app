import 'package:annette_app/miscellaneous-files/onlineFiles.dart';
import 'package:annette_app/timetable/groupsEF.dart';
import 'package:annette_app/timetable/groupsQ1.dart';
import 'package:annette_app/timetable/groupsQ2.dart';
import 'package:annette_app/timetable/timetableCrawler.dart';
import 'package:annette_app/custom_widgets/errorInternetContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

///
/// !!!
///
/// Folgende Abkürzungen werden in dieser Datei genutzt: US -> Unterstufe; OS -> Oberstufe
///
///
/// !!!
///


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
  bool errorInternet = false;
  OnlineFiles onlineFiles = new OnlineFiles();
  late DateTime newVersion;

  late bool q2Initialize;

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

  late List<int>? classesLanguage6;

  List<String> religionUS = ['Kath. Religion', 'Ev. Religion', 'Philosophie'];
  List<String> secondLanguageUS = ['Latein', 'Französisch'];
  List<String> diffUS = [
    'Informatik',
    'Physik-Technik',
    'Spanisch',
    'Kunst',
    'Geschichte'
  ];

  late List<List<String>> groupsEfList;
  late List<List<String>> groupsQ1List;
  late List<List<String>> groupsQ2List;

  List<String> lk1 = [
    'Freistunde',
  ];
  List<String> lk2 = ['Freistunde'];
  List<String> gk1 = ['Freistunde'];
  List<String> gk2 = ['Freistunde'];
  List<String> gk3 = ['Freistunde'];
  List<String> gk4 = ['Freistunde'];
  List<String> gk5 = ['Freistunde'];
  List<String> gk6 = ['Freistunde'];
  List<String> gk7 = ['Freistunde'];
  List<String> gk8 = ['Freistunde'];
  List<String> gk9 = ['Freistunde'];
  List<String> gk10 = ['Freistunde'];
  List<String> gk11 = ['Freistunde'];
  List<String> gk12 = ['Freistunde'];
  List<String> gk13 = ['Freistunde'];
  List<String> zk1 = ['Freistunde'];
  List<String> zk2 = ['Freistunde'];

  void setGroupsOS() async {
    final storage = GetStorage();
    storage.write('changingLkSubject', selectedLk1);
    storage.write('changingLkWeekNumber', 2);
    String tempConfiguration;

    if (selectedClass == 'Q1') {
      tempConfiguration =
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
    } else if (selectedClass == 'Q2') {
      tempConfiguration =
          'c:$selectedClass;lk1:$selectedLk1;lk2:$selectedLk2;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:$selectedZk1;zk2:$selectedZk2;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
    } else {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:$selectedGk1;gk2:$selectedGk2;gk3:$selectedGk3;gk4:$selectedGk4;gk5:$selectedGk5;gk6:$selectedGk6;gk7:$selectedGk7;gk8:$selectedGk8;gk9:$selectedGk9;gk10:$selectedGk10;gk11:$selectedGk11;gk12:$selectedGk12;gk13:$selectedGk13;zk1:Freistunde;zk2:Freistunde;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;';
    }

    await activateTimetableCrawler(tempConfiguration);
    GetStorage().write('configuration', tempConfiguration);
    setState(() {
      showFinishedConfiguration = true;
    });
  }

  void setGroupsUS() async {
    String tempConfiguration;

    if (selectedReligionUS == 'Kath. Religion') {
      selectedReligionUS = 'KR';
    } else if (selectedReligionUS == 'Ev. Religion') {
      selectedReligionUS = 'ER';
    } else {
      selectedReligionUS = 'PPL';
    }

    bool tempLanguage6 = false;

    if (classesLanguage6 != null) {
      classesLanguage6!.forEach((element) {
        if (selectedClass.contains(element.toString())) {
          tempLanguage6 = true;
        }
      });
    }

    if (tempLanguage6) {
      if (selectedSecondLanguageUS == 'Französisch') {
        selectedSecondLanguageUS = 'F6';
      } else {
        selectedSecondLanguageUS = 'L6';
      }
    } else {
      if (selectedSecondLanguageUS == 'Französisch') {
        selectedSecondLanguageUS = 'F7';
      } else {
        selectedSecondLanguageUS = 'L7';
      }
    }

    if (selectedDiffUS == 'Physik-Technik') {
      selectedDiffUS = 'PHd';
    } else if (selectedDiffUS == 'Kunst') {
      selectedDiffUS = 'KUd';
    } else if (selectedDiffUS == 'Spanisch') {
      ///Spanisch ab Klasse 9 muss hier berücksichtigt werden.
      selectedDiffUS = 'S8';
    } else if (selectedDiffUS == 'Geschichte') {
      selectedDiffUS = 'GEd';
    } else {
      selectedDiffUS = 'IFd';
    }

    if (selectedClass.contains('9') || selectedClass.contains('10')) {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:$selectedSecondLanguageUS;diffUS:$selectedDiffUS;';
    } else if (!selectedClass.contains('5') && !selectedClass.contains('6')) {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:$selectedSecondLanguageUS;diffUS:Freistunde;';
    } else {
      tempConfiguration =
          'c:$selectedClass;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:$selectedReligionUS;sLanguageUS:Freistunde;diffUS:Freistunde;';
    }
    await activateTimetableCrawler(tempConfiguration);
    GetStorage().write('configuration', tempConfiguration);
    setState(() {
      showFinishedConfiguration = true;
    });
  }

  Future<void> activateTimetableCrawler(pConfigurationString) async {
    TimetableCrawler ttc1 = new TimetableCrawler();
    await ttc1.setConfiguration(
        pConfigurationString, onlineFiles.difExport, newVersion);
  }

  void setClass() async {
    if (selectedClass == 'Q1' ||
        selectedClass == 'Q2' ||
        selectedClass == 'EF') {
      if (selectedClass == 'EF') {
        lk1.addAll(groupsEfList[0]);
        lk2.addAll(groupsEfList[1]);
        gk1.addAll(groupsEfList[2]);
        gk2.addAll(groupsEfList[3]);
        gk3.addAll(groupsEfList[4]);
        gk4.addAll(groupsEfList[5]);
        gk5.addAll(groupsEfList[6]);
        gk6.addAll(groupsEfList[7]);
        gk7.addAll(groupsEfList[8]);
        gk8.addAll(groupsEfList[9]);
        gk9.addAll(groupsEfList[10]);
        gk10.addAll(groupsEfList[11]);
        gk11.addAll(groupsEfList[12]);
        gk12.addAll(groupsEfList[13]);
        gk13.addAll(groupsEfList[14]);
        zk1.addAll(groupsEfList[15]);
        zk2.addAll(groupsEfList[16]);
      } else if (selectedClass == 'Q1') {
        lk1.addAll(groupsQ1List[0]);
        lk2.addAll(groupsQ1List[1]);
        gk1.addAll(groupsQ1List[2]);
        gk2.addAll(groupsQ1List[3]);
        gk3.addAll(groupsQ1List[4]);
        gk4.addAll(groupsQ1List[5]);
        gk5.addAll(groupsQ1List[6]);
        gk6.addAll(groupsQ1List[7]);
        gk7.addAll(groupsQ1List[8]);
        gk8.addAll(groupsQ1List[9]);
        gk9.addAll(groupsQ1List[10]);
        gk10.addAll(groupsQ1List[11]);
        gk11.addAll(groupsQ1List[12]);
        gk12.addAll(groupsQ1List[13]);
        gk13.addAll(groupsQ1List[14]);
        zk1.addAll(groupsQ1List[15]);
        zk2.addAll(groupsQ1List[16]);
      } else {
        lk1.addAll(groupsQ2List[0]);
        lk2.addAll(groupsQ2List[1]);
        gk1.addAll(groupsQ2List[2]);
        gk2.addAll(groupsQ2List[3]);
        gk3.addAll(groupsQ2List[4]);
        gk4.addAll(groupsQ2List[5]);
        gk5.addAll(groupsQ2List[6]);
        gk6.addAll(groupsQ2List[7]);
        gk7.addAll(groupsQ2List[8]);
        gk8.addAll(groupsQ2List[9]);
        gk9.addAll(groupsQ2List[10]);
        gk10.addAll(groupsQ2List[11]);
        gk11.addAll(groupsQ2List[12]);
        gk12.addAll(groupsQ2List[13]);
        gk13.addAll(groupsQ2List[14]);
        zk1.addAll(groupsQ2List[15]);
        zk2.addAll(groupsQ2List[16]);
      }

      setState(() {
        if (selectedClass == configurationList[0]) {
          selectedLk1 = (lk1.contains(configurationList[1]))
              ? configurationList[1]
              : 'Freistunde';
          selectedLk2 = (lk2.contains(configurationList[2]))
              ? configurationList[2]
              : 'Freistunde';
          selectedGk1 = (gk1.contains(configurationList[3]))
              ? configurationList[3]
              : 'Freistunde';
          selectedGk2 = (gk2.contains(configurationList[4]))
              ? configurationList[4]
              : 'Freistunde';
          selectedGk3 = (gk3.contains(configurationList[5]))
              ? configurationList[5]
              : 'Freistunde';
          selectedGk4 = (gk4.contains(configurationList[6]))
              ? configurationList[6]
              : 'Freistunde';
          selectedGk5 = (gk5.contains(configurationList[7]))
              ? configurationList[7]
              : 'Freistunde';
          selectedGk6 = (gk6.contains(configurationList[8]))
              ? configurationList[8]
              : 'Freistunde';
          selectedGk7 = (gk7.contains(configurationList[9]))
              ? configurationList[9]
              : 'Freistunde';
          selectedGk8 = (gk8.contains(configurationList[10]))
              ? configurationList[10]
              : 'Freistunde';
          selectedGk9 = (gk9.contains(configurationList[11]))
              ? configurationList[11]
              : 'Freistunde';
          selectedGk10 = (gk10.contains(configurationList[12]))
              ? configurationList[12]
              : 'Freistunde';
          selectedGk11 = (gk11.contains(configurationList[13]))
              ? configurationList[13]
              : 'Freistunde';
          selectedGk12 = (gk12.contains(configurationList[14]))
              ? configurationList[14]
              : 'Freistunde';
          selectedGk13 = (gk13.contains(configurationList[15]))
              ? configurationList[15]
              : 'Freistunde';
          selectedZk1 = (zk1.contains(configurationList[16]))
              ? configurationList[16]
              : 'Freistunde';
          selectedZk2 = (zk2.contains(configurationList[17]))
              ? configurationList[17]
              : 'Freistunde';

          if (selectedZk1 == selectedZk2) {
            selectedZk2 = 'Freistunde';
          }
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
    setState(() {
      finished = false;
      errorInternet = false;
    });
    GroupsEF gEF = new GroupsEF();
    GroupsQ1 gQ1 = new GroupsQ1();
    GroupsQ2 gQ2 = new GroupsQ2();

    if (await onlineFiles.initialize() == false ||
        await gEF.initialize() == false ||
        await gQ1.initialize() == false) {
      setState(() {
        errorInternet = true;
      });
    } else {
      q2Initialize = await gQ2.initialize();

      classesLanguage6 = onlineFiles.getLanguage6();

      groupsEfList = gEF.getGroupsEf();
      groupsQ1List = gQ1.getGroupsQ1();
      if (q2Initialize) {
        groupsQ2List = gQ2.getGroupsQ2();
      }
      classes = onlineFiles.allClasses();
      if (!q2Initialize) {
        classes.removeLast();
      }
      newVersion = onlineFiles.getNewVersion();

      Future<List<String>> _readData() async {
        List<String> tempContent = [];
        try {
          String contents = GetStorage().read('configuration');

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
          } else if (tempDiff == 'S9') {
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
      selectedClass = (classes.contains(configurationList[0]))
          ? configurationList[0]
          : '5A';

      setState(() {
        finished = true;
      });
    }
  }

  void showHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 500)
              ? ((MediaQuery.of(context).size.width - 500) / 2)
              : 0,
        ),
        child: Container(
          height: (MediaQuery.of(context).size.height < 758)
              ? 638
              : /*(MediaQuery.of(context).size.height > 1000)
                  ? 700
                  : */MediaQuery.of(context).size.height - 80,
          decoration: new BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Color.fromRGBO(40, 40, 40, 1)
                : Color.fromRGBO(248, 248, 253, 1),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Woher weiß ich, welchen Kurs ich habe?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            'Welchen Kurs du in welcher Schiene hast, kannst du am Besten auf zwei Arten herausfinden:',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1) ',
                              style: TextStyle(fontSize: 17),
                            ),
                            Expanded(
                                child: Text(
                              'Du schaust auf den "großen" Stundenplan (möglichst auf den mit den Lehrer-Abkürzungen, den du auf Moodle findest), und sucht dort deinen Kurs für die jeweilige Schiene heraus.',
                              style: TextStyle(fontSize: 17),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2) ',
                              style: TextStyle(fontSize: 17),
                            ),
                            Expanded(
                                child: Text(
                              'Du schaust auf den kleinen Zettel mit deinen individuellen Kursen, den du zu Anfang des Schuljahres bekommen haben solltest.',
                              style: TextStyle(fontSize: 17),
                            ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Aus datenschutzrechtlichen Gründen ist es nicht erlaubt, die Lehrer-Abkürzungen neben die Kursbezeichnung zu schreiben. Auch wenn dies die Kurswahl enorm erleichtern würde und technisch einfach umzusetzen wäre, so muss leider der oben beschriebene, umständlichere Weg gewählt werden.',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!widget.isInGuide) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
      ]);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (errorInternet)
            ? ErrorInternetContainer(
                onRefresh: () {
                  errorInternet = false;
                  load();
                },
              )
            : Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(children: [
                  Center(
                    child: (showFinishedConfiguration)
                        ? finishedConfigurationWidget()
                        : (showGroupsOS)
                            ? groupsOsWidget()
                            : (showGroupsUS)
                                ? groupsUsWidget()
                                : classesWidget(),
                  ),
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 70.0,
                      child: Column(children: [
                        Container(
                          child: Text(
                            'App konfigurieren',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(bottom: 15),
                          margin: EdgeInsets.only(left: 5),
                        ),
                        if(!showFinishedConfiguration)
                        Row(
                          children: [
                            if (!finished)
                              Expanded(
                                  flex: 2,
                                  child: LinearProgressIndicator(
                                    minHeight: 2,
                                    backgroundColor:
                                        (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Colors.grey
                                            : null,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Theme.of(context).accentColor
                                        : Colors.blue,
                                  )),
                            if (finished)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 2,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Theme.of(context).accentColor
                                      : Colors.blue,
                                ),
                              ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: (!finished)
                                          ? Colors.grey
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark)
                                              ? Theme.of(context).accentColor
                                              : Colors.blue,
                                      width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 2,
                                color: (!showGroupsOS && !showGroupsUS)
                                    ? Colors.grey
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Theme.of(context).accentColor
                                        : Colors.blue,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: (!showGroupsOS && !showGroupsUS)
                                          ? Colors.grey
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark)
                                              ? Theme.of(context).accentColor
                                              : Colors.blue,
                                      width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 2,
                                color: (!showFinishedConfiguration)
                                    ? Colors.grey
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Theme.of(context).accentColor
                                        : Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ]))
                ]),
              ),
      ),
    );
  }

  Widget classesWidget() {
    if (finished) {
      return SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height < 700) ? 30 : 0),
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
                  )),
                ],
              )));
    } else {
      return Center(
        child: Column(
          children: [
            CupertinoActivityIndicator(),
            Container(
              child: Text('Lade Auswahlmöglichkeiten.'),
              margin: EdgeInsets.only(top: 15),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }
  }

  Widget groupsOsWidget() {
    String infoText = 'Wähle hier deine individuellen Kurse. Dazu zählen die ';
    if (selectedClass == 'Q1' || selectedClass == 'Q2') {
      infoText = infoText + 'Leistungs- und ';
    }
    infoText = infoText + 'Grund';
    if (selectedClass == 'Q2') {
      infoText = infoText.replaceFirst(' und', ', ');
      infoText = infoText + '- und Zusatz';
    }
    infoText = infoText + 'kurse';

    if (selectedClass == 'Q1' || selectedClass == 'EF') {
      infoText = infoText + ' sowie dein Sportkurs';
    }

    infoText = infoText + '. ';

    return Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        margin: EdgeInsets.only(top: 170),
        child: Column(children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 750,
              ),
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    ///Text
                    SliverList(
                        delegate: SliverChildListDelegate.fixed([
                      GestureDetector(
                        onTap: () => showHelp(),
                        child: Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: infoText,
                                style: TextStyle(
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic),
                              ),
                              TextSpan(
                                text: 'Welche Kurse habe ich?',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic),
                              ),
                            ]),
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey)),
                          ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'LK $j:',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  DropdownButton<String>(
                                    items: tempSubjects
                                        .map<DropdownMenuItem<String>>(
                                            (String? value) {
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
                                  ((selectedClass == 'Q1' && j == 10) ||
                                          (selectedClass == 'EF' && j == 13))
                                      ? 'Sport:'
                                      : 'GK $j:',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                DropdownButton<String>(
                                  items: tempSubjects
                                      .map<DropdownMenuItem<String>>(
                                          (String? value) {
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
                        childCount: (selectedClass == 'Q2')
                            ? 9
                            : (selectedClass == 'Q1')
                                ? 10
                                : 13,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'ZK:',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  DropdownButton<String>(
                                    items: tempSubjects
                                        .map<DropdownMenuItem<String>>(
                                            (String? value) {
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
                ),
              ),
            ),
          ),

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

  Widget finishedConfigurationWidget() {
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
                      if (!widget.isInGuide) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              )));
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget groupsUsWidget() {
    String infoText = 'Wähle hier deine individuellen Kurse. Dazu zähl';

    if (selectedClass.contains('5') || selectedClass.contains('6')) {
      infoText = infoText + 't Religion.';
    } else if (!selectedClass.contains('9') && !selectedClass.contains('10')) {
      infoText = infoText + 'en Religion und die zweite Fremdsprache.';
    } else {
      infoText =
          infoText + 'en Religion, die zweite Fremdsprache und dein Diff-Fach.';
    }

    return Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        margin: EdgeInsets.only(top: 170),
        child: Column(children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                  // maxHeight: 600,
                  ),
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    ///Text
                    SliverList(
                        delegate: SliverChildListDelegate.fixed([
                      Container(
                        child: Text(
                          infoText,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)),
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
                              items: religionUS.map<DropdownMenuItem<String>>(
                                  (String? value) {
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
                    if (!selectedClass.contains('5') &&
                        !selectedClass.contains('6') &&
                        !selectedClass.contains('F'))
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
                                    .map<DropdownMenuItem<String>>(
                                        (String? value) {
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
                    if (selectedClass.contains('9') ||
                        selectedClass.contains('10'))
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
                                items: diffUS.map<DropdownMenuItem<String>>(
                                    (String? value) {
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
                ),
              ),
            ),
          ),

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
                            : Colors.white),
                  )),
            ),
          ),
        ]));
  }
}
