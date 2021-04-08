/**
 * Diese Datei beinhaltet alle notwendigen Methoden um mit der Tabelle "subjects"
 * von der Datenbank interagieren zu können.
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';
import 'subject.dart';

/**
 * Diese Methode fügt ein neues Fach in die Datenbank ein.
 * Das einzufügende Fach wird als Parameter übergeben.
 */
void databaseInsertSubject(Subject pSubject) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> insertSubject(Subject subject) async {
    final Database db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertSubject(pSubject);
}

/**
 * Diese Methode gibt alle sich in der Tabelle befindlichen Fächer zurück.
 * Die Rückgabe geschieht in Form einer Liste mit einzelnen Objekten der Klasse Subject.
 */
Future<List<Subject>> databaseGetAllSubjects() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<List<Subject>> getAllSubjects() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('subjects', orderBy: 'name');

    return List.generate(maps.length, (i) {
      return Subject(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  return await getAllSubjects();
}

/**
 * Diese Methode aktualisiert ein bestimmtes Fach in die Datenbank.
 * Die Stelle, die aktualisiert wird, entspricht der Id des übergebenen Fachs.
 * Das zu aktualisierende Fach wird als Parameter übergeben.
 */
void databaseUpdateSubject(Subject pSubject) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> updateSubject(Subject subject) async {
    final db = await database;

    await db.update(
      'subjects',
      subject.toMap(),
      where: "id = ?",
      whereArgs: [subject.id],
    );
  }

  await updateSubject(pSubject);
}

/**
 * Diese Methode löscht ein bestimmtes Fach aus der Datenbank.
 * Die Id des zu löschenden Fachs wird als Parameter übergeben.
 */
void databaseDeleteSubject(int? pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> deleteSubject(int? id) async {
    final db = await database;

    await db.delete(
      'subjects',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  await deleteSubject(pId);
}
