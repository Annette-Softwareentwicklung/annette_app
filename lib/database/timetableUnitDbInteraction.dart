import 'dart:async';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';

void databaseInsertTimetableUnit(TimeTableUnit pTimeTableUnit) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> insertTimeTableUnit(TimeTableUnit timeTableUnit) async {
    final Database db = await database;
    await db.insert(
      'timetable',
      timeTableUnit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await insertTimeTableUnit(pTimeTableUnit);
}

void databaseUpdateTimeTableUnit(TimeTableUnit pTimeTableUnit) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> updateTimeTableUnit(TimeTableUnit timeTableUnit) async {
    final db = await database;
    await db.update(
      'timetable',
      timeTableUnit.toMap(),
      where: "id = ?",
      whereArgs: [timeTableUnit.id],
    );
  }

  await updateTimeTableUnit(pTimeTableUnit);
}


Future<TimeTableUnit> databaseGetSpecificTimeTableUnit(int pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<TimeTableUnit> getSpecificTimeTableUnit(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('timetable', where: "id = ?", whereArgs: [id]);

    final List<TimeTableUnit> list = List.generate(maps.length, (i) {
      return TimeTableUnit(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        room: maps[i]['room'],
        lessonNumber: maps[i]['lessonNumber'],
        dayNumber: maps[i]['dayNumber'],
      );
    });

    final TimeTableUnit timeTableUnit = new TimeTableUnit(
        subject: list[0].subject,
        room: list[0].room,
        dayNumber: list[0].dayNumber,
        lessonNumber: list[0].lessonNumber,
        id: list[0].id);

    return timeTableUnit;
  }

  return await getSpecificTimeTableUnit(pId);
}


void databaseDeleteTimeTableUnit(int? pId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<void> deleteTimeTableUnit(int? id) async {
    final db = await database;

    await db.delete(
      'timetable',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  await deleteTimeTableUnit(pId);
}


Future<List<TimeTableUnit>> databaseGetAllTimeTableUnit() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'local_database.db'),
    onCreate: (db, version) {
      createDb(db);
    },
    version: 1,
  );

  Future<List<TimeTableUnit>> getAllTimeTableUnit() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'timetable'
    );

    return List.generate(maps.length, (i) {
      return TimeTableUnit(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        room: maps[i]['room'],
        dayNumber: maps[i]['dayNumber'],
        lessonNumber: maps[i]['lessonNumber'],
      );
    });
  }

  return await getAllTimeTableUnit();
}
