import 'dart:io';
import 'dart:ui';
import 'package:annette_app/setClass.dart';
import 'package:annette_app/settingsPage.dart';
import 'package:annette_app/vertretung/classicVertretungsplan.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database/databaseCreate.dart';
import 'examPlan.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manageNotifications.dart';

/// Diese Klasse beinhaltet den Einstellungsbereich.
/// App => Menüleiste => Einstellungen
class SettingsTab extends StatelessWidget {
  Future<DateTime?> getTimetableVersion() async {
    try {
      return DateTime.parse(GetStorage().read('timetableVersion'));
    } catch (e) {

      print(e);
      return null;
    }
  }

  /// AboutDialog.
  /// Dialog, der Informationen über diese App, wie zB Versionsnummer, bereit hält.
  /// Zusätzlich besitzt er ein von Flutter automatisch generiertes Verzeichnis der lizenzen der Packages.
  void aboutDialog(context) async {
    DateTime? version = await getTimetableVersion();
    showAboutDialog(
      context: context,
      applicationName: 'Annette App',
      applicationVersion: 'Version 3.1.0+4',
      applicationIcon: Container(
          height: 70,
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                  height: 36,
                  width: 36,
                  image: AssetImage('images/icon.png'),
                  fit: BoxFit.fill))),
      applicationLegalese:
          'Annette App für das Annette-von-Droste-Hülshoff Gymnasium Düsseldorf.\nEine Internet-Verbindung ist für bestimmte Funktionen erforderlich.\n\nDer Stundenplan wird automatisch bei jedem Neustart der App und beim Ändern der Klasse aktualisiert.\n\nDer aktuell verwendete Stundenplan ist von Stand:\n${(version != null) ? version.toString() : "Fehler"}\n\nAlle Angaben ohne Gewähr!\n\nwww.annettegymnasium.de\n\nKontakt / Feedback: appentwicklung.jan@gmx.de\n\n©2021 Jan Wermeckes',
    );
  }

  /// Ausgabe eines Widgets (Container) mit einer Liste mit folgenden Auswahlmöglichkeiten:
  ///    - Über diese App    Öffnet den AboutDialog (s.o.)
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text('Klausurplan'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Klausurplan', content: ExamPlan());
                    }),
                  )),
          Divider(),
          ListTile(
              title: Text('Klassischer Vertretungsplan'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Vertretungsplan',
                          content: ClassicVertretungsplan());
                    }),
                  )),
          if (Platform.isIOS) Divider(),
          if (Platform.isIOS)
            ListTile(
                title: Text('Annette Homepage'),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).accentColor),
                onTap: () async {
                  await launch('https://www.annettegymnasium.de/');
                }),
          if (Platform.isIOS) Divider(),
          if (Platform.isIOS)
            ListTile(
                title: Text('Kalender'),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).accentColor),
                onTap: () async {
                  await launch(
                      'https://cloud.annettemoodle.de/index.php/apps/calendar/p/MTJwp7DKSZss9PXD/dayGridMonth/now');
                }),
          Divider(),
          ListTile(),
          Divider(),
          ListTile(
              title: Text('Einstellungen'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return DefaultScaffold(
                      title: 'Einstellungen',
                      content: SettingsPage());
                }),);
              }),

          Divider(),
          ListTile(
              title: Text('Klasse ändern'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onLongPress: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setError) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 450,
                              ),
                              padding: EdgeInsets.only(
                                  top: 30, left: 30, right: 30, bottom: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Reset',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Willst du wirklich die gesamte App auf Werkseinstellungen zurücksetzten?',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.clear_rounded,
                                              size: 30,
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              ///Leitfaden wieder anzeigen
                                              GetStorage()
                                                  .write('introScreen', 'true');

                                              ///Datenbank löschen
                                              WidgetsFlutterBinding
                                                  .ensureInitialized();
                                              final Future<Database> database =
                                                  openDatabase(
                                                join(await getDatabasesPath(),
                                                    'local_database.db'),
                                                onCreate: (db, version) {
                                                  createDb(db);
                                                },
                                                version: 1,
                                              );
                                              Database db = await database;
                                              await db.execute(
                                                  "DELETE FROM homeworkTasks");
                                              await db.execute(
                                                  "DELETE FROM timetable");
                                              cancelAllNotifications();

                                              ///Dialogfenster schließen
                                              Navigator.of(context).pop();

                                              ///Dialog zur Information des Benutzers
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setError) {
                                                      return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: 450,
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 30,
                                                                    left: 30,
                                                                    right: 30,
                                                                    bottom: 10),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      'Reset erfolgreich',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10),
                                                                    child: Text(
                                                                      'Die App wurde zurückgesetzt. Bitte starte die App neu.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                    });
                                                  });
                                            },
                                            icon: Icon(
                                              Icons.check_rounded,
                                              size: 30,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ));
                      });
                    });
              },
              onTap: () {
                if (MediaQueryData.fromWindow(window).size.shortestSide < 500) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SetClass(
                      isInGuide: false,
                      onButtonPressed: () {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.portraitUp,
                        ]);
                      },
                    );
                  }),
                );
              }),
          Divider(),
          ListTile(
            title: Text('Über diese App'),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
            onTap: () => aboutDialog(context),
          ),
          Divider(),
        ],
      ),
    ));
  }
}
