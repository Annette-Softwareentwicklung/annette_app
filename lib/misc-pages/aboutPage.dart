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
        YamlList developers;
        String developerString = "";


        if (snapshot.hasData) {
          Map yamlData = loadYaml(snapshot.data);
          version = yamlData["version"];
          developers = yamlData["authors"];
          for (String developer in developers) {
            developerString += "\n- $developer";

          }
        }



        return new DefaultScaffold(
            title: "Über diese App",
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: sectionMargin, vertical: Design.standardPagePadding),
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage(assetPaths.iconImagePath)
                        ),
                        Column(
                            children: [
                              Text(appName),
                              Text("Version $version")
                            ]
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sectionMargin),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Entwickler: $developerString \n"
                          ),
                          Text(
                              'Annette App für das Annette-von-Droste-Hülshoff Gymnasium Düsseldorf.' +
                                  '\nEine Internet-Verbindung ist für bestimmte Funktionen erforderlich.' +
                                  '\n\nDer Stundenplan wird automatisch bei jedem Neustart der App und beim Ändern der Klasse aktualisiert.' +
                                  '\n\nDer aktuell verwendete Stundenplan ist von Stand:\n${(timeTableVersion != null) ? timeTableVersion.toString() : "Fehler"}' +
                                  '\n\nAlle Angaben ohne Gewähr!' +
                                  '\n\nwww.annettegymnasium.de' +
                                  '\n\nKontakt / Feedback: appentwicklung.jan@gmx.de' +
                                  '\n\n©2021 Jan Wermeckes'
                          )
                        ]
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sectionMargin),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () => showLicensePage(context: context),
                          child: Text("Lizensen anzeigen"),
                        )
                      ],
                    )
                  ],
                )
            )
        );

      },
    );
  }
  
}