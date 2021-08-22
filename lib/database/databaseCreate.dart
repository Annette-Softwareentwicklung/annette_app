import 'package:sqflite/sqflite.dart';

/// Diese Methode wird aufgerufen, wenn die Datenbank noch nicht existieren sollte.
/// Diese Methode erstellt alle notwendigen Tabellen.
void createDb(Database db) async {

  //Erstellen der Tabelle für die Hausaufgaben
  await db.execute(
    "CREATE TABLE homeworkTasks(id INTEGER PRIMARY KEY, subject TEXT, notes TEXT, notificationTime TEXT, deadlineTime TEXT, isChecked INTEGER)",
  );

  //Erstellen der Tabelle für den Stundenplan
  await db.execute(
    "CREATE TABLE timetable(id INTEGER PRIMARY KEY, subject TEXT, room TEXT, dayNumber INTEGER, lessonNumber INTEGER)",
  );
}


