import 'dart:ui';
import 'package:annette_app/data/design.dart';
import 'package:annette_app/data/links.dart';
import 'package:annette_app/miscellaneous-files/setClass.dart';
import 'package:annette_app/misc-pages/settingsPage.dart';
import 'package:annette_app/vertretung/classicVertretungsplan.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/custom_widgets/defaultScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'aboutPage.dart';
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

  /// Ausgabe eines Widgets (Container) mit einer Liste mit folgenden Auswahlmöglichkeiten:
  ///    - Über diese App    Öffnet den AboutDialog (s.o.)
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(Design.standardPagePadding),
      child: ListView(
        children: <Widget>[
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
          Divider(),
          ListTile(
              title: Text('Annette Homepage'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () async {
                try {
                  await launch('https://${Links.annetteWebsite}/');
                } catch (e) {
                  print(e);
                }
              }),
          Divider(),
          ListTile(
              title: Text('Kalender'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () async {
                try {
                  await launch(
                      'https://cloud.annettemoodle.de/index.php/apps/calendar/p/MTJwp7DKSZss9PXD/dayGridMonth/now');
                } catch (e) {
                  print(e);
                }
              }),
          Divider(),
          ListTile(),
          Divider(),
          ListTile(
              title: Text('Einstellungen'),
              trailing: Icon(Icons.chevron_right,
                  color: Theme.of(context).accentColor),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return DefaultScaffold(
                        isBottom: false,
                        title: 'Einstellungen',
                        content: SettingsPage());
                  }),
                );
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AboutPage();
              }));
            },
          ),
          Divider(),
        ],
      ),
    ));
  }
}
