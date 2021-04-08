import 'package:sqflite/sqflite.dart';
import 'subject.dart';
import 'subjectsAtDay.dart';
import 'lessonStartTime.dart';

/**
 * Diese Methode wird aufgerufen, wenn die Datenbank noch nicht existieren sollte.
 * Diese Methode erstellt alle notwendigen Tabellen.
 */
void createDb(Database db) async {

  //Erstellen der Tabelle für die Schulfächer
  await db.execute(
    "CREATE TABLE subjects(id INTEGER PRIMARY KEY, name TEXT)",
  );

  //Erstellen der Tabelle für den Zeitplan
  await db.execute(
    "CREATE TABLE times(id INTEGER PRIMARY KEY, time TEXT)",
  );

  //Erstellen der Tabelle für die Hausaufgaben
  await db.execute(
    "CREATE TABLE homeworkTasks(id INTEGER PRIMARY KEY, subject TEXT, notes TEXT, notificationTime TEXT, deadlineTime TEXT, isChecked INTEGER)",
  );

  //Erstellen der Tabelle für den Stundenplan
  await db.execute(
    "CREATE TABLE days(id INTEGER PRIMARY KEY, dayName TEXT, lesson1 TEXT, lesson2 TEXT, lesson3 TEXT, lesson4 TEXT, lesson5 TEXT, lesson6 TEXT, lesson7 TEXT, lesson8 TEXT, lesson9 TEXT, lesson10 TEXT, lesson11 TEXT)",
  );

  //Einfügen der Standart-Werte
  insertStandardSubjects(db);
  insertDays(db);
  insertAnnetteTimes(db);
}

/**
 * Diese Methode fügt den Zeitplan des "Annette" in die Datenbank ein.
 * Sie wird unmittelbar nach dem Erstellen der Datenbank ausgeführt.
 */
void insertAnnetteTimes(Database database) async{
  Future<void> insertTime(LessonStartTime time) async {
    final Database db = await database;
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

/**
 * Diese Methode fügt bereits eine Auswahl an Schulfächern in die Datenbank ein.
 * Sie wird unmittelbar nach dem Erstellen der Datenbank ausgeführt.
 */
void insertStandardSubjects(Database database) async {
  Future<void> insertSubject(Subject subject) async {
    final Database db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertSubject(new Subject(name: 'Mathe'));
  await insertSubject(new Subject(name: 'Deutsch'));
  await insertSubject(new Subject(name: 'Englisch'));
  await insertSubject(new Subject(name: 'Biologie'));
  await insertSubject(new Subject(name: 'Erdkunde'));
  await insertSubject(new Subject(name: 'Sport'));
}

/**
 * Diese Methode fügt den Stundenplan für jeden Wochentag in die Datenbank ein.
 * Zunächst werden alle Fächer als Freistunde eingetragen, damit es zu keinen Fehlern beim Laden des Stundelans kommt.
 * Diese Methode wird unmittelbar nach dem Erstellen der Datenbank ausgeführt.
 */
void insertDays(Database database) async {
  Future<void> insertDay(SubjectsAtDay day) async {
    final Database db = await database;
    await db.insert(
      'days',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertDay(new SubjectsAtDay(
      dayName: 'Montag',
      lesson1: 'Freistunde',
      lesson2: 'Freistunde',
      lesson3: 'Freistunde',
      lesson4: 'Freistunde',
      lesson5: 'Freistunde',
      lesson6: 'Freistunde',
      lesson7: 'Freistunde',
      lesson8: 'Freistunde',
      lesson9: 'Freistunde',
      lesson10: 'Freistunde',
      lesson11: 'Freistunde'));
  await insertDay(new SubjectsAtDay(
      dayName: 'Dienstag',
      lesson1: 'Freistunde',
      lesson2: 'Freistunde',
      lesson3: 'Freistunde',
      lesson4: 'Freistunde',
      lesson5: 'Freistunde',
      lesson6: 'Freistunde',
      lesson7: 'Freistunde',
      lesson8: 'Freistunde',
      lesson9: 'Freistunde',
      lesson10: 'Freistunde',
      lesson11: 'Freistunde'));
  await insertDay(new SubjectsAtDay(
      dayName: 'Mittwoch',
      lesson1: 'Freistunde',
      lesson2: 'Freistunde',
      lesson3: 'Freistunde',
      lesson4: 'Freistunde',
      lesson5: 'Freistunde',
      lesson6: 'Freistunde',
      lesson7: 'Freistunde',
      lesson8: 'Freistunde',
      lesson9: 'Freistunde',
      lesson10: 'Freistunde',
      lesson11: 'Freistunde'));
  await insertDay(new SubjectsAtDay(
      dayName: 'Donnerstag',
      lesson1: 'Freistunde',
      lesson2: 'Freistunde',
      lesson3: 'Freistunde',
      lesson4: 'Freistunde',
      lesson5: 'Freistunde',
      lesson6: 'Freistunde',
      lesson7: 'Freistunde',
      lesson8: 'Freistunde',
      lesson9: 'Freistunde',
      lesson10: 'Freistunde',
      lesson11: 'Freistunde'));
  await insertDay(new SubjectsAtDay(
      dayName: 'Freitag',
      lesson1: 'Freistunde',
      lesson2: 'Freistunde',
      lesson3: 'Freistunde',
      lesson4: 'Freistunde',
      lesson5: 'Freistunde',
      lesson6: 'Freistunde',
      lesson7: 'Freistunde',
      lesson8: 'Freistunde',
      lesson9: 'Freistunde',
      lesson10: 'Freistunde',
      lesson11: 'Freistunde'));
}
