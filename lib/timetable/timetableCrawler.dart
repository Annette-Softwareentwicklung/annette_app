import 'package:annette_app/classesMap.dart';
import 'package:annette_app/subjectDbInteraction.dart';
import 'package:annette_app/timetableUnit.dart';
import 'package:annette_app/timetableUnitDbInteraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:annette_app/databaseCreate.dart';
import 'package:annette_app/subject.dart';


class TimetableCrawler extends StatefulWidget {
  final String configurationString;
  TimetableCrawler({required this.configurationString});
  @override
  _TimetableCrawlerState createState() => _TimetableCrawlerState();
}

class _TimetableCrawlerState extends State<TimetableCrawler> {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  late String configurationString;
  late String currentClass;

  Future<void> setSubjects () async {
    List<String> tempSubjects = [];
    ///Zuordnung: Abkürzung => Fachname
    List<String> classesAbbreviation = getClassesAbbreviation();
    List<String> classesFullName = getClassesFullName();

    List<TimeTableUnit> timetableUnits = await databaseGetAllTimeTableUnit();

    for(int i=0; i<timetableUnits.length; i++) {
      String tempSubjectAbbreviation = timetableUnits[i].subject!;
      int tempPositionInList = classesAbbreviation.indexOf(tempSubjectAbbreviation);
      late String tempSubjectFullName;

      if(tempPositionInList != -1) {
        tempSubjectFullName = classesFullName[tempPositionInList];
      } else {
        tempSubjectFullName = tempSubjectAbbreviation;
      }

      if(tempSubjectFullName == 'Kath. Religion' || tempSubjectFullName == 'Ev. Religion') {
        tempSubjectFullName = 'Religion';
      }

      if(!tempSubjects.contains(tempSubjectFullName)) {
        tempSubjects.add(tempSubjectFullName);
      }
    }

    ///Löscht alle vorhandenen Fächer
      WidgetsFlutterBinding.ensureInitialized();
      final Future<Database> database = openDatabase(
        join(await getDatabasesPath(), 'local_database.db'),
        onCreate: (db, version) {
          createDb(db);
        },
        version: 1,
      );
      Database db = await database;
      await db.execute("DELETE FROM subjects");

      for(int i=0; i<tempSubjects.length; i++) {
        databaseInsertSubject(new Subject(name: tempSubjects[i]));
      }
  }

  void setConfiguration() async {
    Future<String> _readData() async {
      try {
        return await rootBundle.loadString('assets/stundenplan.txt');
      } catch (e) {
        return 'error';
      }
    }
    pattern.allMatches(await _readData()).forEach((match) => print(match.group(0)));
    await setTimetable(await _readData());
    await setSubjects();
  }

  Future<void> setTimetable(String code) async {
    String timetableCode = code;
    //pattern.allMatches(timetableCode).forEach((match) => print(match.group(0)));

    while(timetableCode.indexOf(currentClass) != -1) {
      print(timetableCode.substring(timetableCode.indexOf(',,', timetableCode.indexOf(currentClass) - 10) + 2, timetableCode.indexOf(',,', timetableCode.indexOf(currentClass))));
      timetableCode = timetableCode.substring(timetableCode.indexOf(currentClass) + 10);
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurationString = widget.configurationString;
    currentClass = configurationString.substring(configurationString.indexOf('c:') + 2, configurationString.indexOf(';'));
    setConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}
