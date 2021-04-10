import 'package:annette_app/classicTimetable.dart';
import 'package:annette_app/setClass.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/reset.dart';
import 'package:annette_app/defaultScaffold.dart';

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
      applicationLegalese: 'Annete App neue Version\n\n©2021 Jan Wermeckes',
    );
  }

  /**
   * Ausgabe eines Widgets (Container) mit einer Liste mit folgenden Auswahlmöglichkeiten:
   *    - Stundenplan       Navigiert zu dem Scaffold Auswählen der Wochentage (zum anschließenden Einstellen des Stundenplans)
   *    - Zeitplan          Navigiert zu dem Scaffold zum Einstellen des Zeitplans
   *    - Fächer            Navigiert zu dem Scaffold Verwalten der Fächer
   *
   *    - Über diese App    Öffnet den AboutDialog (s.o.)
   *    - Zurücksetzen      Navigiert zu dem Scaffold zum Zurücksetzen der App
   */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text('Klassischer Stundenplan'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return DefaultScaffold(
                      title: 'Stundenplan', content: ClassicTimetable());
                }),
              )),
Divider(),ListTile(),
          Divider(),
          ListTile(
              title: Text('Klasse wählen'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Klasse wählen', content: SetClass());
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
          ListTile(
              title: Text('Zurücksetzen'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DefaultScaffold(
                          title: 'Zurücksetzen', content: Reset());
                    }),
                  )),
          Divider(),
        ],
      ),
    );
  }
}
