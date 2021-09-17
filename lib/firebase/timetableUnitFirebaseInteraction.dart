import 'dart:async';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../database/databaseCreate.dart';

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
