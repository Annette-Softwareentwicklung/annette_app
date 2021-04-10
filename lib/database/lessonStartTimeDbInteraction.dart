/**
 * Diese Datei beinhaltet alle notwendigen Methoden um mit der Tabelle "times"
 * von der Datenbank interagieren zu können.
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';
import '../classes/lessonStartTime.dart';

/**
 * Diese Methode fügt eine neue Anfangszeit einer Schulstunde in die Datenbank ein.
 * Die einzufügende Zeit wird als Parameter übergeben.
 */
void databaseInsertTime(LessonStartTime pTime) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> insertTime(LessonStartTime time) async {
    final Database db = await database;
    await db.insert(
      'times',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertTime(pTime);
}

/**
 * Diese Methode gibt alle sich in der Tabelle befindlichen Anfangszeiten der Schulstunden zurück.
 * Die Rückgabe geschieht in Form einer Liste mit einzelnen Objekten der Klasse LessonStartTime.
 */
Future<List<LessonStartTime>> databaseGetAllTimes() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<List<LessonStartTime>> getAllTimes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('times');

    return List.generate(maps.length, (i) {
      return LessonStartTime(
        id: maps[i]['id'],
        time: maps[i]['time'],
      );
    });
  }

  return await getAllTimes();
}

/**
 * Diese Methode aktualisiert eine bestimmte Anfangszeit einer Schulstunde in die Datenbank.
 * Die Stelle, die aktualisiert wird, entspricht der Id der übergebenen Zeit.
 * Die zu aktualisierende Zeit wird als Parameter übergeben.
 */
void databaseUpdateTime(LessonStartTime pTime) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> updateTime(LessonStartTime time) async {
    final db = await database;

    await db.update(
      'times',
      time.toMap(),
      where: "id = ?",
      whereArgs: [time.id],
    );
  }

  await updateTime(pTime);
}

/**
 * Diese Methode löscht eine bestimmte Anfangszeit einer Schulstunde aus der Datenbank.
 * Die Id der zu löschenden Zeit wird als Parameter übergeben.
 */
void databaseDeleteTime(int pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> deleteTime(int id) async {
    final db = await database;

    await db.delete(
      'times',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  await deleteTime(pId);
}
