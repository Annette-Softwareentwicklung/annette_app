import 'package:annette_app/data/subjects.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:annette_app/database/databaseCreate.dart';

class TimetableCrawler {
  late String currentClass;

  Future<void> setConfiguration(
      String configurationString, String difExport, DateTime newVersion) async {
    currentClass = configurationString.substring(
        configurationString.indexOf('c:') + 2,
        configurationString.indexOf(';'));

    await setTimetable(difExport, configurationString);
    await setSubjects();

    GetStorage().write('timetableVersion', newVersion.toString());
  }

  Future<void> setTimetable(String code, String configurationString) async {
    List<TimeTableUnit> timetableUnitsToInsert = [];

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

          ///if-Abfrage zur Überprüfung ob es einen Raum gibt oder ob das "Feld" leer ist. (Aktion wird nicht abgebrochen, Raum ist sonst '-' (s.o.)
          if (timetableCode.indexOf(',') != 0) {
            tempRoom = timetableCode.substring(1, timetableCode.indexOf('",'));
          }
          timetableCode =
              timetableCode.substring(timetableCode.indexOf(',') + 1);

          ///if-Abfrage zur Überprüfung ob es eine Tagnummer gibt oder ob das "Feld" leer ist.
          if (timetableCode.indexOf(',') != 0) {
            int tempDayNumber = int.tryParse(
                timetableCode.substring(0, timetableCode.indexOf(',')))!;
            timetableCode =
                timetableCode.substring(timetableCode.indexOf(',') + 1);

            ///if-Abfrage zur Überprüfung ob es eine Stundennummer gibt oder ob das "Feld" leer ist.
            if (timetableCode.indexOf(',') != 0) {
              int tempLessonNumber = int.tryParse(
                  timetableCode.substring(0, timetableCode.indexOf(',,')))!;

              ///Lernzeit wird als normales Fach angesehen
              tempSubject = tempSubject.replaceAll(' LZ', '');

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
                  String tempString =
                      configurationString.substring(tempPosition - 1);

                  ///Wenn Fach nicht gefunden wurde, zweite Überprüfung an späterer Stelle im configuration String,
                  ///falls zB Fach = E (auch gewählt) aber Fach GE als erstes im configuration String gefunden und Fach E erst an späterer Stelle.
                  ///Sonst würde E fälschlicherweise bei nur einer Überprüfung aussortiert werden.

                  if (tempString.indexOf(':') != 0) {
                    tempPosition =
                        tempString.indexOf(tempTimetableUnit.subject!, 2);
                    if (tempPosition != -1) {
                      tempString = tempString.substring(tempPosition - 1);
                    }
                  }

                  if (tempString.indexOf(':') == 0) {
                    ///Umgehen des Fehlers auf dem Stundenplan, dass es zwei GE Z1 gibt.
                    ///Fall: es gibt GE Z1 und ein anderes Fach soll eingetragen werden.
                    if (!tempTimetableUnit.subject!.contains('GE Z1')) {
                      timetableUnitsToInsert.removeWhere((element) {
                        if (element.lessonNumber ==
                                tempTimetableUnit.lessonNumber &&
                            element.dayNumber == tempTimetableUnit.dayNumber &&
                            element.subject!.contains('GE Z1')) {
                          return true;
                        }
                        return false;
                      });
                      timetableUnitsToInsert.add(tempTimetableUnit);
                    }

                    ///Fall: es gibt ein anderes Fach und ein GE Z1 soll eingetragen werden.
                    else {
                      if (timetableUnitsToInsert.indexWhere((element) =>
                              (element.dayNumber ==
                                      tempTimetableUnit.dayNumber &&
                                  element.lessonNumber ==
                                      tempTimetableUnit.lessonNumber)) ==
                          -1) {
                        timetableUnitsToInsert.add(tempTimetableUnit);
                      }
                    }
                  }
                }
              } else {
                ///Überprüfung Religion
                if (tempTimetableUnit.subject! == 'KR' ||
                    tempTimetableUnit.subject! == 'ER' ||
                    tempTimetableUnit.subject! == 'PL' ||
                    tempTimetableUnit.subject! == 'PPL') {
                  if (configurationString
                      .contains(tempTimetableUnit.subject!)) {
                    timetableUnitsToInsert.add(tempTimetableUnit);
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
                  if (configurationString
                      .contains(tempTimetableUnit.subject!)) {
                    timetableUnitsToInsert.add(tempTimetableUnit);
                  }
                }

                ///Diff
                else if ((currentClass.contains('9') ||
                        currentClass.contains('10')) &&
                    (tempTimetableUnit.subject! == 'GEd' ||
                        tempTimetableUnit.subject! == 'IFd' ||
                        tempTimetableUnit.subject! == 'PHd' ||
                        tempTimetableUnit.subject! == 'S8' ||
                        tempTimetableUnit.subject! == 'S9' ||
                        tempTimetableUnit.subject! == 'KUd')) {
                  if (configurationString
                      .contains(tempTimetableUnit.subject!)) {
                    timetableUnitsToInsert.add(tempTimetableUnit);
                  }
                } else {
                  timetableUnitsToInsert.add(tempTimetableUnit);
                }
              }
            }
          }
        }
      } else {
        print('Fehler $timetableCode');
      }
    }

    ///Fehler bei der Benennung der LKs im Stundenplan umgehen. Wenn zwei LKs in unterschiedlichen Schienen gleich heißen.
    if (currentClass == 'Q1' || currentClass == 'Q2') {
      Iterable<TimeTableUnit> listAllLk = timetableUnitsToInsert
          .where((element) => element.subject!.contains('LK'));
      List<TimeTableUnit> conflictsFound = [];
      List<TimeTableUnit> noConflictsFound = [];
      listAllLk.forEach((element1) {
        if (listAllLk
                .where((element2) =>
                    element1.lessonNumber == element2.lessonNumber &&
                    element1.dayNumber == element2.dayNumber &&
                    element1.subject != element2.subject)
                .length !=
            0) {
          conflictsFound.add(element1);
        } else {
          noConflictsFound.add(element1);
        }
      });

      conflictsFound.forEach((element1) {
        if (noConflictsFound.indexWhere((element2) =>
                element1.subject == element2.subject &&
                element1.room != element2.room) !=
            -1) {
          timetableUnitsToInsert.remove(element1);
        }
      });

      ///Fehlende wechsel LKs auffüllen
      ///Q1: Mo. 1 + 2
      ///Q2: Mi 1 + 2
      String? subjectLk1;
      if (timetableUnitsToInsert
              .indexWhere((element) => element.subject!.contains('LK')) !=
          -1) {
        subjectLk1 = timetableUnitsToInsert
            .firstWhere((element) => element.subject!.contains('LK'))
            .subject;
      }
      if (subjectLk1 != null) {
        if (currentClass == 'Q1') {
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk1 &&
                  element.dayNumber == 1 &&
                  element.lessonNumber == 1) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 1,
                lessonNumber: 1,
                subject: subjectLk1,
                room: '???'));
          }
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk1 &&
                  element.dayNumber == 1 &&
                  element.lessonNumber == 2) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 1,
                lessonNumber: 2,
                subject: subjectLk1,
                room: '???'));
          }
        } else if (currentClass == 'Q2') {
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk1 &&
                  element.dayNumber == 3 &&
                  element.lessonNumber == 1) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 3,
                lessonNumber: 1,
                subject: subjectLk1,
                room: '???'));
          }
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk1 &&
                  element.dayNumber == 3 &&
                  element.lessonNumber == 2) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 3,
                lessonNumber: 2,
                subject: subjectLk1,
                room: '???'));
          }
        }

        String? subjectLk2;
        if (timetableUnitsToInsert.indexWhere((element) =>
                element.subject!.contains('LK') &&
                !element.subject!.contains(subjectLk1!)) !=
            -1) {
          subjectLk2 = timetableUnitsToInsert
              .firstWhere((element) =>
                  element.subject!.contains('LK') &&
                  !element.subject!.contains(subjectLk1!))
              .subject;
        }
        if (currentClass == 'Q1' && subjectLk2 != null) {
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk2 &&
                  element.dayNumber == 1 &&
                  element.lessonNumber == 1) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 1,
                lessonNumber: 1,
                subject: subjectLk2,
                room: '???'));
          }
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk2 &&
                  element.dayNumber == 1 &&
                  element.lessonNumber == 2) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 1,
                lessonNumber: 2,
                subject: subjectLk2,
                room: '???'));
          }
        } else if (currentClass == 'Q2' && subjectLk2 != null) {
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk2 &&
                  element.dayNumber == 3 &&
                  element.lessonNumber == 1) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 3,
                lessonNumber: 1,
                subject: subjectLk2,
                room: '???'));
          }
          if (timetableUnitsToInsert.indexWhere((element) =>
                  element.subject == subjectLk2 &&
                  element.dayNumber == 3 &&
                  element.lessonNumber == 2) ==
              -1) {
            timetableUnitsToInsert.add(TimeTableUnit(
                dayNumber: 3,
                lessonNumber: 2,
                subject: subjectLk2,
                room: '???'));
          }
        }
      }
    }

    timetableUnitsToInsert.forEach((element) {
      databaseInsertTimetableUnit(element);
      print(
          '${element.subject} ${element.room} ${element.dayNumber} ${element.lessonNumber}');
    });
  }

  Future<void> setSubjects() async {
    List<String> tempSubjects = [];

    ///Zuordnung: Abkürzung => Fachname
    Map<String, String> allSubjects = getSubjects();

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

      late String tempSubjectFullName;

      if (allSubjects.containsKey(tempSubjectAbbreviation)) {
        tempSubjectFullName = allSubjects[tempSubjectAbbreviation]!;
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
