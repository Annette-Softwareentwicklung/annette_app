/**
 * Diese Datei beinhaltet die Optionen zum zurücksetzen der App.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseCreate.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'manageNotifications.dart';

class Reset extends StatelessWidget {


  /**
   * Diese Methode öffnet ein Dialog Fenster, welches eine Abfrage zum Zurücksetzen des Zeitplans  enthält.
   * Sollte der Benutzer dies bestätigen,
   * wird die Methode newTimesDatabase() aufgerufen und eine entsprechende Nachricht,
   * dass der Zeitplan auf die "Annette"-Zeiten zurückgesetzt wurde, angezeigt.
   */
  void resetTimes(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text('Zeitplan zurücksetzen'),
              content: Text(
                  'Willst du wirklich den Zeitplan auf die Zeiten des Annette zurücksetzen?'),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    newTimesDatabase();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text('Zeitplan zurückgesetzt'),
                              content: Text(
                                  'Der Zeitplan wurde auf die Zeiten des Annette zurückgesetzt.'),
                              actions: [
                                RaisedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Fertig'),
                                ),
                              ],
                            ));
                  },
                  child: Text('Zurücksetzen'),
                ),
              ],
            ));
  }

  /**
   * Diese Methode öffnet ein Dialog Fenster, welches eine Abfrage zum Löschen aller Aufgaben enthält.
   * Sollte der Benutzer dies bestätigen,
   * wird die Methode deleteHomeworkDatabase() aufgerufen und eine entsprechende Nachricht,
   * dass alle Aufgaben gelöscht wurden, angezeigt.
   */
  void resetHomework(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text('Hausaufgaben löschen'),
              content: Text(
                  'Willst du wirklich alle Hausaufgaben unwiederruflich löschen?'),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteHomeworkDatabase();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text('Hausaufgaben gelöscht'),
                              content: Text(
                                  'Alle Hausaufgaben wurden unwiederruflich gelöscht.'),
                              actions: [
                                RaisedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Fertig'),
                                ),
                              ],
                            ));
                  },
                  child: Text('Löschen'),
                ),
              ],
            ));
  }

  /**
   * Diese Methode öffnet ein Dialog Fenster, welches eine Abfrage zum Zurücksetzen der gesamten App enthält.
   * Sollte der Benutzer dies bestätigen,
   * werden die Methoden enableShowDialog() und resetAllDatabase() aufgerufen und eine entsprechende Nachricht,
   * dass die gesamte App zurückgesetzt wurde, angezeigt.
   */
  void resetAll(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text('Zurücksetzen'),
              content: Text(
                  'Willst du wirklich die gesamte App auf Werkseinstellungen zurücksetzen?'),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetAllDatabase();
                    enableShowDialog();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text('App zurückgesetzt'),
                              content: Text(
                                  'Die gesamte App wurde auf Werkseinstellungen zurückgesetzt. Bitte trage deinen Stundenplan ein.'),
                              actions: [
                                RaisedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Fertig'),
                                ),
                              ],
                            ));
                  },
                  child: Text('Zurücksetzen'),
                ),
              ],
            ));
  }

  /**
   * Diese Methode schreibt in die Text-Datei, ob der leitfaden bereits angezeigt wurde, eine 0,
   * sodass bei einem erneuten Start der App der Leitfaden wieder angezeigt wird.
   *
   * Quellen:
   * https://flutter.dev/docs/cookbook/persistence/reading-writing-files
   * https://www.kindacode.com/article/flutter-how-to-read-and-write-text-files/
   */
  void enableShowDialog() async {
    //find Path
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    //write
    Future<void> _writeData() async {
      final _path = await _getPath();
      final _myFile = File('$_path/data.txt');
      // If data.txt doesn't exist, it will be created automatically
      await _myFile.writeAsString(0.toString());
    }

    await _writeData();
  }

  /**
   * Diese Methode setzt den Zeitplan in der Datenbank wieder auf die "Annette"-Zeiten zurück.
   */
  void newTimesDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) {
        createDb(db);
      },
      version: 1,
    );
    Database db = await database;
    await db.execute("DELETE FROM times");
    insertAnnetteTimes(db);
  }

  /**
   * Diese Methode löscht alle Hausaufgaben inklusive der geplanten Benachrichtungen aus der Datenbank.
   */
  void deleteHomeworkDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) {
        createDb(db);
      },
      version: 1,
    );
    Database db = await database;
    await db.execute("DELETE FROM homeworkTasks");
    cancelAllNotifications();
  }

  /**
   * Es wir die Methode deleteHomeworkDatabase() aufgerufen,
   * welche alle Hausaufgaben inklusive der geplanten Benachrichtungen aus der Datenbank löscht.
   * Außerdem wird die Methode newTimesDatabse() aufgerufen,
   * welche den Zeitplan in der Datenbank wieder auf die "Annette"-Zeiten zurücksetzt.
   */
  void resetAllDatabase() async {
    newTimesDatabase();
    deleteHomeworkDatabase();

    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) {
        createDb(db);
      },
      version: 1,
    );
    Database db = await database;
    await db.execute("DELETE FROM subjects");
    await db.execute("DELETE FROM days");
    insertStandardSubjects(db);
    insertDays(db);
  }

  /**
   * Widget mit der Liste mit verschiedenen Optionen zum Zurücksetzen der App.
   */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
          child: ListView(
        children: <Widget>[
          ListTile(
              title: Text('Zeitplan zurücksetzen'),
              subtitle: Text(
                  'Der Zeitplan wird wieder auf die Zeiten vom Annette gesetzt.'),
              trailing: Icon(CupertinoIcons.arrow_counterclockwise_circle,  color: Theme.of(context).accentColor),
              onTap: () {
                resetTimes(context);
              }),
          Divider(),
          ListTile(
              title: Text('Hausaufgaben löschen'),
              subtitle: Text(
                  'Alle deine Hausaufgaben sowie die entsprechenden Benachrichtigungen werden gelöscht.'),
              trailing: Icon(CupertinoIcons.arrow_counterclockwise_circle,  color: Theme.of(context).accentColor),
              onTap: () {
                resetHomework(context);
              }),
          Divider(),
          ListTile(
              title: Text('Alles zurücksetzen'),
              subtitle: Text(
                  'Die gesamte App wird zurückgesetzt. Dazu zählen der Stunden- und Zeitplan, deine Fächer sowie das Löschen aller Aufgaben. Die Standardeinstellungen werden wiederhergestellt.'),
              trailing: Icon(CupertinoIcons.arrow_counterclockwise_circle,  color: Theme.of(context).accentColor),
              onTap: () {
                resetAll(context);
              }),
          Divider(),
        ],
      )),
    );
  }
}
