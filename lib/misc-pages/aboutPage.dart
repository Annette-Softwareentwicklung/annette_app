import 'package:annette_app/custom_widgets/defaultScaffold.dart';
import 'package:annette_app/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:annette_app/data/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaml/yaml.dart';

class AboutPage extends StatelessWidget {
  static double sectionMargin = 20;

  DateTime? getTimetableVersion() {
    try {
      return DateTime.parse(GetStorage().read('timetableVersion'));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString("pubspec.yaml"),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String appName = "Annette App";
        String version = "0.0.0";
        DateTime? timeTableVersion = getTimetableVersion();

        if (snapshot.hasData) {
          Map yamlData = loadYaml(snapshot.data);
          version = yamlData["version"];
        }

        return new DefaultScaffold(
            title: "Über diese App",
            content: Container(
              alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(
                    horizontal: sectionMargin,
                    vertical: Design.standardPagePadding),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      //scrollDirection: Axis.vertical,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                boxShadow: (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                shape: BoxShape.rectangle,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: AssetImage(assetPaths.iconImagePath),
                                      fit: BoxFit.fitHeight),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    appName,
                                    style: TextStyle(
                                        fontSize: 25, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("Version $version"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: sectionMargin),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text("Entwickler:\nAnnette-Entwickelt-Software AG\n"),
                              Text('Annette App für das Annette-von-Droste-Hülshoff Gymnasium Düsseldorf.' +
                                  '\nEine Internet-Verbindung ist für bestimmte Funktionen erforderlich.' +
                                  '\n\nDer Stundenplan wird automatisch bei jedem Neustart der App und beim Ändern der Klasse aktualisiert.' +
                                  '\n\nDer aktuell verwendete Stundenplan ist von Stand:\n${(timeTableVersion != null) ? timeTableVersion.toString() : "Fehler"}' +
                                  '\n\nAlle Angaben ohne Gewähr!' +
                                  '\n\nKontakt / Feedback:'),
                              SelectableText(
                                'AnnetteSoftware@gmail.com',
                              ),
                                  Text('\n©2022 Annette-Entwickelt-Software AG'),

                                ])),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: sectionMargin,vertical: sectionMargin),
                          child: OutlinedButton(
                              onPressed: () => showLicensePage(
                                  context: context,
                                  applicationIcon: Container(
                                    margin: EdgeInsets.symmetric(vertical: sectionMargin),
                                    width: 100,
                                      height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: AssetImage(assetPaths.iconImagePath),
                                          fit: BoxFit.fitHeight),
                                    ),
                                  ),
                                  applicationName: appName,
                                  applicationVersion: version),
                              child: Text("Lizenzen anzeigen"),
                            ),
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
