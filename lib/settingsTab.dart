import 'dart:io';
import 'dart:ui';
import 'package:annette_app/setClass.dart';
import 'package:annette_app/settingsPage.dart';
import 'package:annette_app/vertretung/classicVertretungsplan.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'examPlan.dart';
import 'package:url_launcher/url_launcher.dart';

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
      applicationVersion: 'Version 3.1.0+5',
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
                    isBottom: false,
                      title: 'Einstellungen',
                      content: SettingsPage());
                }),);
              }),

          Divider(),
          ListTile(
              title: Text('Klasse ändern'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),

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
