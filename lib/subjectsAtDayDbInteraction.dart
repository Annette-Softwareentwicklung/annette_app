/**
 * Diese Datei beinhaltet alle notwendigen Methoden um mit der Tabelle "days"
 * von der Datenbank interagieren zu können.
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';
import 'subjectsAtDay.dart';

/**
 * Diese Methode fügt den Stundenplan eines neuen Tages in die Datenbank ein.
 * Die einzufügende Tag wird als Parameter übergeben.
 */
void databaseInsertDay(SubjectsAtDay pDay) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );
  Future<void> insertDay(SubjectsAtDay day) async {
    final Database db = await database;
    await db.insert(
      'days',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertDay(pDay);
}

/**
 * Diese Methode gibt alle Stundenpläne der sich in der Tabelle befindenen Tage zurück.
 * Die Rückgabe geschieht in Form einer Liste mit einzelnen Objekten der Klasse SubjectsAtDay.
 */
Future<List<SubjectsAtDay>> databaseGetAllDays() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      print('create db');
      createDb(db);
    },
    version: 1,
  );


  Future<List<SubjectsAtDay>> getAllDays() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('days');

    return List.generate(maps.length, (i) {
      return SubjectsAtDay(
        id: maps[i]['id'],
        dayName: maps[i]['dayName'],
        lesson1: maps[i]['lesson1'],
        lesson2: maps[i]['lesson2'],
        lesson3: maps[i]['lesson3'],
        lesson4: maps[i]['lesson4'],
        lesson5: maps[i]['lesson5'],
        lesson6: maps[i]['lesson6'],
        lesson7: maps[i]['lesson7'],
        lesson8: maps[i]['lesson8'],
        lesson9: maps[i]['lesson9'],
        lesson10: maps[i]['lesson10'],
        lesson11: maps[i]['lesson11'],
      );
    });
  }

  return await getAllDays();
}

/**
 * Diese Methode aktualisiert den Stundenplan eines bestimmten Tages in die Datenbank.
 * Die Stelle, die aktualisiert wird, entspricht der Id der übergebenen Aufgabe.
 * Der zu aktualisierende Tag samt Fächern wird als Parameter übergeben.
 */
void databaseUpdateDay(SubjectsAtDay pDay) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> updateDay(SubjectsAtDay day) async {
    final db = await database;

    await db.update(
      'days',
      day.toMap(),
      where: "id = ?",
      whereArgs: [day.id],
    );
  }

  await updateDay(pDay);
}

