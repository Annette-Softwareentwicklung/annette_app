/**
 * Diese Datei beinhaltet alle notwendigen Methoden um mit der Tabelle "homeworkTasks"
 * von der Datenbank interagieren zu können.
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';
import 'package:annette_app/fundamentals/task.dart';

/**
 * Diese Methode fügt eine neue Hausaufgabe in die Datenbank ein.
 * Die einzufügende Hausaufgabe wird als Parameter übergeben.
 */
void databaseInsertTask(Task pTask) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> insertTask(Task task) async {
    final Database db = await database;
    await db.insert(
      'homeworkTasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertTask(pTask);
}

/**
 * Diese Methode aktualisiert eine bestimmte Hausaufgabe in die Datenbank.
 * Die Stelle, die aktualisiert wird, entspricht der Id der übergebenen Aufgabe.
 * Die zu aktualisierende Hausaufgabe wird als Parameter übergeben.
 */
void databaseUpdateTask(Task pTask) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> updateTask(Task task) async {
    final db = await database;
    print('update');
    await db.update(
      'homeworkTasks',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  await updateTask(pTask);
}

/**
 * Diese Methode gibt eine bestimmte Aufgabe aus der Datenbank zurück.
 * Die Id dieser gefragten Aufgabe wird als Parameter übergeben.
 */
Future<Task> databaseGetSpecificTask(int pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<Task> getSpecificTask(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('homeworkTasks', where: "id = ?", whereArgs: [id]);

    final List<Task> list = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        notes: maps[i]['notes'],
        notificationTime: maps[i]['notificationTime'],
        isChecked: maps[i]['isChecked'], deadlineTime: maps[i]['deadlineTime'],
      );
    });

    final Task task = new Task(
        subject: list[0].subject,
        deadlineTime: list[0].deadlineTime,
        notificationTime: list[0].notificationTime,
        notes: list[0].notes,
        isChecked: list[0].isChecked,
        id: list[0].id);

    return task;
  }

  return await getSpecificTask(pId);
}

/**
 * Diese Methode löscht eine bestimmte Hausaufgabe aus der Datenbank.
 * Die Id der zu löschenden Hausaufgabe wird als Parameter übergeben.
 */
void databaseDeleteTask(int? pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> deleteTask(int? id) async {
    final db = await database;

    await db.delete(
      'homeworkTasks',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  await deleteTask(pId);
}

/**
 * Diese Methode gibt alle sich in der Tabelle befindlichen Hausaufgaben zurück.
 * Die Rückgabe geschieht in Form einer Liste mit einzelnen Objekten der Klasse Task.
 */
Future<List<Task>> databaseGetAllTasks(int? orderValue) async {
  String orderListBy = 'id ASC';

    switch (orderValue) {
      case 1:
        orderListBy = 'subject ASC';
        break;
      case 2:
        orderListBy = 'subject DESC';
        break;
      case 3:
        orderListBy = 'deadlineTime ASC';
        break;
      case 4:
        orderListBy = 'deadlineTime DESC';
        break;
      case 5:
        orderListBy = 'id ASC';
        break;
      case 6:
        orderListBy = 'id DESC';
        break;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<List<Task>> getAllTasks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'homeworkTasks',
      orderBy: orderListBy,
    );

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        notes: maps[i]['notes'],
        notificationTime: maps[i]['notificationTime'],
        deadlineTime: maps[i]['deadlineTime'],
        isChecked: maps[i]['isChecked'],
      );
    });
  }

  return await getAllTasks();
}
