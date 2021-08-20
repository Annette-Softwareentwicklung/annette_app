import 'dart:io';
import 'package:annette_app/subjectsList.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:annette_app/database/databaseCreate.dart';

class TimetableCrawler {
  late String currentClass;

  Future<void> setConfiguration(String configurationString, String difExport,
      DateTime newVersion) async {
    currentClass = configurationString.substring(
        configurationString.indexOf('c:') + 2,
        configurationString.indexOf(';'));

    await setTimetable(difExport, configurationString);
    await setSubjects();


    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(DateTime newVersion) async {
      final _path = await _getPath();
      final _myFile = File('$_path/version.txt');
      await _myFile.writeAsString(newVersion.toString());
    }

    await _writeData(newVersion);
  }

  Future<void> setTimetable(String code, String configurationString) async {
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

    while (timetableCode.indexOf(currentClass) != -1) {
      String tempRoom = '-';

      timetableCode =
          timetableCode.substring(timetableCode.indexOf(currentClass));

      timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 1);


      if (timetableCode.indexOf(',') != 0) {
        if (timetableCode.indexOf('Kobi') == 1) {
          tempRoom = 'Kobi';
        }

        timetableCode = timetableCode.substring(timetableCode.indexOf(',') + 2);

        ///if-Abfrage zur Überprüfung ob es ein Fach gibt oder ob das "Feld" leer ist.
        if (timetableCode.indexOf(',') != 0) {
          String tempSubject =
          timetableCode.substring(0, timetableCode.indexOf('"'));
          timetableCode =
              timetableCode.substring(timetableCode.indexOf(',') + 1);

          if (timetableCode.indexOf(',') != 0) {
            tempRoom = timetableCode.substring(1, timetableCode.indexOf('",'));
          }
          timetableCode =
              timetableCode.substring(timetableCode.indexOf(',') + 1);

          int tempDayNumber = int.tryParse(
              timetableCode.substring(0, timetableCode.indexOf(',')))!;
          timetableCode =
              timetableCode.substring(timetableCode.indexOf(',') + 1);

          int tempLessonNumber = int.tryParse(
              timetableCode.substring(0, timetableCode.indexOf(',,')))!;

          TimeTableUnit tempTimetableUnit = new TimeTableUnit(
              subject: tempSubject,
              dayNumber: tempDayNumber,
              lessonNumber: tempLessonNumber,
              room: tempRoom);
          if (currentClass == 'EF' ||
              currentClass == 'Q1' ||
              currentClass == 'Q2') {
            int tempPosition =
            configurationString.indexOf(tempTimetableUnit.subject!);
            if (tempPosition != -1) {
              String tempString = configurationString.substring(
                  tempPosition - 1);

              if (tempString.indexOf(':') == 0) {
                databaseInsertTimetableUnit(tempTimetableUnit);
              }
            }
          } else {
            ///Überprüfung Religion
            if (tempTimetableUnit.subject! == 'KR' ||
                tempTimetableUnit.subject! == 'ER' ||
                tempTimetableUnit.subject! == 'PL' ||
                tempTimetableUnit.subject! == 'PPL') {
              if (configurationString.contains(tempTimetableUnit.subject!)) {
                databaseInsertTimetableUnit(tempTimetableUnit);
              }
            }
            ///2. Sprache
            else if (!currentClass.contains('5') &&
                !currentClass.contains('6') &&
                !currentClass.contains('F') &&
                (tempTimetableUnit.subject! == 'L6' ||
                    tempTimetableUnit.subject! == 'F6' ||
                    tempTimetableUnit.subject! == 'L7' ||
                    tempTimetableUnit.subject! == 'F7')) {
              if (configurationString.contains(tempTimetableUnit.subject!)) {
                databaseInsertTimetableUnit(tempTimetableUnit);
              }
            }
            ///Diff
            else
            if ((currentClass.contains('9') || currentClass.contains('10')) &&
                (tempTimetableUnit.subject! == 'GEd' ||
                    tempTimetableUnit.subject! == 'IFd' ||
                    tempTimetableUnit.subject! == 'PHd' ||
                    tempTimetableUnit.subject! == 'S8' ||
                    tempTimetableUnit.subject! == 'S9' ||
                    tempTimetableUnit.subject! == 'KUd')) {
              if (configurationString.contains(tempTimetableUnit.subject!)) {
                databaseInsertTimetableUnit(tempTimetableUnit);
              }
            } else {
              databaseInsertTimetableUnit(tempTimetableUnit);
            }
          }
    }} else {
    print('Fehler $timetableCode');
    }
  }
  }

  Future<void> setSubjects() async {
    List<String> tempSubjects = [];

    ///Zuordnung: Abkürzung => Fachname
    List<String> classesAbbreviation = getSubjectsAbbreviation();
    List<String> classesFullName = getSubjectsFullName();

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
  }
}