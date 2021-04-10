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

class TimetableCrawler {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  final String configurationString;

  TimetableCrawler({required this.configurationString});

  late String currentClass;

  Future<void> setConfiguration() async {
    currentClass = configurationString.substring(
        configurationString.indexOf('c:') + 2,
        configurationString.indexOf(';'));

    Future<String> _readData() async {
      try {
        return await rootBundle.loadString('assets/stundenplan.txt');
      } catch (e) {
        return 'error';
      }
    }

    //pattern.allMatches(await _readData()).forEach((match) => print(match.group(0)));
    await setTimetable(await _readData());
    await setSubjects();
  }

  Future<void> setTimetable(String code) async {

    ///Löscht alle Stundenplan-Einträge
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) {
        createDb(db);
      },
      version: 1,
    );
    Database db = await database;
    await db.execute("DELETE FROM timetable");

    String timetableCode = code;
    //pattern.allMatches(timetableCode).forEach((match) => print(match.group(0)));

    while (timetableCode.indexOf(currentClass) != -1) {
      String tempRoom = '-';

      timetableCode =
          timetableCode.substring(timetableCode.indexOf(currentClass));

      timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 1);

      if (timetableCode.indexOf('Kobi') == 1) {
        tempRoom = 'Kobi';
      }

      timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 2);
      String tempSubject =
          timetableCode.substring(0, timetableCode.indexOf('"'));
      timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 1);

      if (timetableCode.indexOf(',') != 0) {
        tempRoom = timetableCode.substring(1, timetableCode.indexOf('",'));
      }
      timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 1);

      int tempDayNumber =
          int.tryParse(timetableCode.substring(0, timetableCode.indexOf(',')))!;
      int tempLessonNumber = int.tryParse(timetableCode.substring(
          timetableCode.indexOf(',,') - 1, timetableCode.indexOf(',,')))!;

      print('$tempSubject $tempRoom $tempDayNumber $tempLessonNumber');

      TimeTableUnit tempTimetableUnit = new TimeTableUnit(
          subject: tempSubject,
          dayNumber: tempDayNumber,
          lessonNumber: tempLessonNumber,
          room: tempRoom);
      if (currentClass == 'EF' ||
          currentClass == 'Q1' ||
          currentClass == 'Q2') {
        if (configurationString.contains(tempTimetableUnit.subject!)) {
          databaseInsertTimetableUnit(tempTimetableUnit);
          print('check');
        }
      } else {
        print('unterstufe');

        //Überprüfung Religion
        if(tempTimetableUnit.subject! == 'KR' || tempTimetableUnit.subject! == 'ER' ||tempTimetableUnit.subject! == 'PL' || tempTimetableUnit.subject! == 'PPL') {
          if(configurationString.contains(tempTimetableUnit.subject!))  {
            databaseInsertTimetableUnit(tempTimetableUnit);
          }
        }
        //2. Sprache
        else if(!currentClass.contains('5') && !currentClass.contains('F') && (tempTimetableUnit.subject! == 'L6' || tempTimetableUnit.subject! == 'F6')) {
          if(configurationString.contains(tempTimetableUnit.subject!))  {
            databaseInsertTimetableUnit(tempTimetableUnit);
          }
        }
        //Diff
        else if((currentClass.contains('8') || currentClass.contains('9')) && (tempTimetableUnit.subject! == 'GEd' || tempTimetableUnit.subject! == 'IFd'  || tempTimetableUnit.subject! == 'PHd' || tempTimetableUnit.subject! == 'S8' || tempTimetableUnit.subject! == 'KUd')) {
          if(configurationString.contains(tempTimetableUnit.subject!))  {
            databaseInsertTimetableUnit(tempTimetableUnit);
          }
        }
        else {
          databaseInsertTimetableUnit(tempTimetableUnit);
        }
      }
    }
  }

  Future<void> setSubjects() async {
    List<String> tempSubjects = [];

    ///Zuordnung: Abkürzung => Fachname
    List<String> classesAbbreviation = getClassesAbbreviation();
    List<String> classesFullName = getClassesFullName();

    List<TimeTableUnit> timetableUnits = await databaseGetAllTimeTableUnit();

    for (int i = 0; i < timetableUnits.length; i++) {
      String tempSubjectAbbreviation = timetableUnits[i].subject!;

      if (tempSubjectAbbreviation.contains('LK')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('LK') - 1);
      } else if (tempSubjectAbbreviation.contains('GK')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('GK') - 1);
      } else if (tempSubjectAbbreviation.contains('Z1')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('Z1') - 1);
      } else if (tempSubjectAbbreviation.contains('Z2')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('Z2') - 1);
      }

      int tempPositionInList =
          classesAbbreviation.indexOf(tempSubjectAbbreviation);
      late String tempSubjectFullName;

      if (tempPositionInList != -1) {
        tempSubjectFullName = classesFullName[tempPositionInList];
      } else {
        tempSubjectFullName = tempSubjectAbbreviation;
      }

      if (tempSubjectFullName == 'Kath. Religion' ||
          tempSubjectFullName == 'Ev. Religion') {
        tempSubjectFullName = 'Religion';
      }

      if (!tempSubjects.contains(tempSubjectFullName)) {
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

    for (int i = 0; i < tempSubjects.length; i++) {
      databaseInsertSubject(new Subject(name: tempSubjects[i]));
    }
  }
}
