import 'dart:io';

import 'package:annette_app/showWebview.dart';
import 'package:annette_app/setClass.dart';
import 'package:annette_app/vertretung/classicVertretungsplan.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';

import 'examPlan.dart';

/**
 * Diese Klasse beinhaltet den Einstellungsbereich.
 * App => Menüleiste => Einstellungen
 */
class SettingsTab extends StatelessWidget {
  /**
   * AboutDialog.
   * Dialog, der Informationen über diese App, wie zB Versionsnummer, bereit hält.
   * Zusätzlich besitzt er ein von Flutter automatisch generiertes Verzeichnis der lizenzen der Packages.
   */
  void aboutDialog(context) {
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
          'Annette App für das Annette-von-Droste-Hülshoff Gymnasium Düsseldorf.\nInternet-Verbindung für bestimmte Funktionen erforderlich.\n\nDer Stundenplan wird automatisch bei jedem Neustart der App und beim Einstellen der Klasse aktualisiert.\n\nAlle Angaben ohne Gewähr!\n\nwww.annettegymnasium.de\n\nKontakt / Feedback: appentwicklung.jan@gmx.de\n\n©2021 Jan Wermeckes',
    );
  }

  /**
   * Ausgabe eines Widgets (Container) mit einer Liste mit folgenden Auswahlmöglichkeiten:
   *
   *
   *    - Über diese App    Öffnet den AboutDialog (s.o.)
   */
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
          /* Divider(),
          ListTile(
              title: Text('Klassischer Stundenplan'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return DefaultScaffold(
                      title: 'Stundenplan', content: ClassicTimetable());
                }),
              )),*/
          /*Divider(),ListTile(
              title: Text('Moodle'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return DefaultScaffold(
                      title: 'Moodle', content: ShowWebview(url: 'https://moodle.annettegymnasium.de/',));
                }),
              )),*/
          if(Platform.isIOS)
          Divider(),
          if(Platform.isIOS)
            ListTile(
              title: Text('Annette Homepage'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Annette Homepage',
                          content: ShowWebview(
                            url: 'https://www.annettegymnasium.de/',
                          ));
                    }),
                  )),
          if(Platform.isIOS)
            Divider(),
          if(Platform.isIOS)
            ListTile(
              title: Text('Kalender'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Kalender',
                          content: ShowWebview(
                            url:
                                'https://cloud.annettemoodle.de/index.php/apps/calendar/p/MTJwp7DKSZss9PXD/dayGridMonth/now',
                          ));
                    }),
                  )),
          Divider(),
            ListTile(),
          Divider(),
          ListTile(
              title: Text('Klasse ändern'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Klasse ändern',
                          content: SetClass(
                            isInGuide: false,
                            onButtonPressed: () {},
                          ));
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
