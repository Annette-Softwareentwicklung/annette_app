import 'dart:io';
import 'package:annette_app/setClass.dart';
import 'package:annette_app/vertretung/classicVertretungsplan.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'examPlan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Diese Klasse beinhaltet den Einstellungsbereich.
/// App => Menüleiste => Einstellungen
class SettingsTab extends StatelessWidget {
  Future<DateTime?> getTimetableVersion() async {
    try {
      Future<String> _getPath() async {
        final _dir = await getApplicationDocumentsDirectory();
        return _dir.path;
      }

      Future<DateTime?> _readData() async {
        try {
          final _path = await _getPath();
          final _file = File('$_path/version.txt');

          String contents = await _file.readAsString();
          return DateTime.parse(contents);
        } catch (e) {
          return null;
        }
      }

      return await _readData();

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
      applicationVersion: 'Version 3.0.0+1',
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
          'Annette App für das Annette-von-Droste-Hülshoff Gymnasium Düsseldorf.\nEine Internet-Verbindung ist für bestimmte Funktionen erforderlich.\nDu nutzt die ${(Platform.isIOS) ? 'iOS-Version der App mit dem vollen' : 'Android-Version der App mit eingeschränktem'} Funktionsumfang.\n\nDer Stundenplan wird automatisch bei jedem Neustart der App und beim Einstellen der Klasse aktualisiert.\n\nDer aktuell verwendete Stundenplan ist von Stand:\n${(version != null) ? version.toString() : "Fehler"}\n\nAlle Angaben ohne Gewähr!\n\nwww.annettegymnasium.de\n\nKontakt / Feedback: appentwicklung.jan@gmx.de\n\n©2021 Jan Wermeckes',
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

          if(Platform.isIOS)
          Divider(),
          if(Platform.isIOS)
            ListTile(
              title: Text('Annette Homepage'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () async {
                  await launch('https://www.annettegymnasium.de/');
              }


            ),
          if(Platform.isIOS)
            Divider(),
          if(Platform.isIOS)
            ListTile(
              title: Text('Kalender'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () async {
              await launch('https://cloud.annettemoodle.de/index.php/apps/calendar/p/MTJwp7DKSZss9PXD/dayGridMonth/now');
              }
              ),
          Divider(),
            ListTile(),
          Divider(),
          ListTile(
              title: Text('Klasse ändern'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return SetClass(isInGuide: false,onButtonPressed: () {},);
                      /*DefaultScaffold(
                          title: 'Klasse ändern',
                          content: SetClass(
                            isInGuide: false,
                            onButtonPressed: () {},
                          ));*/
                    }),
                  )),
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
