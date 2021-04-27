import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/lessonStartTime.dart';

/**
 * Diese Methode wird aufgerufen, wenn die Datenbank noch nicht existieren sollte.
 * Diese Methode erstellt alle notwendigen Tabellen.
 */
void createDb(Database db) async {

  //Erstellen der Tabelle für den Zeitplan
  /*await db.execute(
    "CREATE TABLE times(id INTEGER PRIMARY KEY, time TEXT)",
  );*/

  //Erstellen der Tabelle für die Hausaufgaben
  await db.execute(
    "CREATE TABLE homeworkTasks(id INTEGER PRIMARY KEY, subject TEXT, notes TEXT, notificationTime TEXT, deadlineTime TEXT, isChecked INTEGER)",
  );

  //Erstellen der Tabelle für den Stundenplan
  await db.execute(
    "CREATE TABLE timetable(id INTEGER PRIMARY KEY, subject TEXT, room TEXT, dayNumber INTEGER, lessonNumber INTEGER)",
  );
}

/**
 * Diese Methode fügt den Zeitplan des "Annette" in die Datenbank ein.
 * Sie wird unmittelbar nach dem Erstellen der Datenbank ausgeführt.
 */
void databaseAnnetteTimes() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

 Future<void> insertAnnetteTimes() async{
    Future<void> insertTime(LessonStartTime time) async {
      final Database db = await database;
      await db.execute("DELETE FROM times");

      await db.insert(
        'times',
        time.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await insertTime(new LessonStartTime(time: '8:00:00.000000'));
    await insertTime(new LessonStartTime(time: '8:50:00.000000'));
    await insertTime(new LessonStartTime(time: '9:55:00.000000'));
    await insertTime(new LessonStartTime(time: '10:45:00.000000'));
    await insertTime(new LessonStartTime(time: '11:50:00.000000'));
    await insertTime(new LessonStartTime(time: '12:40:00.000000'));
    await insertTime(new LessonStartTime(time: '13:35:00.000000'));
    await insertTime(new LessonStartTime(time: '14:30:00.000000'));
    await insertTime(new LessonStartTime(time: '15:20:00.000000'));
    await insertTime(new LessonStartTime(time: '16:10:00.000000'));
    await insertTime(new LessonStartTime(time: '17:00:00.000000'));

  }

  insertAnnetteTimes();
}

