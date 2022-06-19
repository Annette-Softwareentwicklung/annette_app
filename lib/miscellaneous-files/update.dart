import 'dart:io';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:annette_app/services/timetable_scraper/timetable_scraper.dart';
import 'package:annette_app/timetable/timetableCrawler.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

///Zum Aktualisieren des Stundenplans im Hintergrund

final snackBarTimetableUpdateFailed = SnackBar(
  duration: Duration(seconds: 3),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        Icons.warning_rounded,
        color: Colors.white,
      ),
      Container(
        child:
            Text('Fehler Stundenplan-Update', style: TextStyle(fontSize: 17)),
        margin: EdgeInsets.only(left: 15),
      ),
    ],
  ),
  margin: EdgeInsets.all(10),
  behavior: SnackBarBehavior.floating,
);

final snackBarTimetableUpdated = SnackBar(
  duration: Duration(seconds: 3),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        Icons.info_outline_rounded,
        color: Colors.white,
      ),
      Container(
        child: Text('Stundenplan wurde aktualisiert',
            style: TextStyle(fontSize: 17)),
        margin: EdgeInsets.only(left: 15),
      ),
    ],
  ),
  margin: EdgeInsets.all(10),
  behavior: SnackBarBehavior.floating,
);

Future<void> update(BuildContext context) async {
  ///Update Vertretungsplan
  try {
    var storage = GetStorage();

    if (storage.read('timetableVersion') == null) {
      storage.write('timetableVersion', DateTime(0, 0).toString());
    }

    DateTime version = DateTime.parse(storage.read('timetableVersion'));

    DateTime versionNew;
    try {
      /*HttpClient client = HttpClient();
      HttpClientRequest req = await client.getUrl(
          Uri.parse('http://janw.bplaced.net/annetteapp/data/stundenplan.txt'));
      HttpClientResponse tempResponse = await req.close();
      String t = tempResponse.headers.value(HttpHeaders.lastModifiedHeader)!;
      print('Zuletzt geändert: $t');
      versionNew = getLastModifiedTime(t)!;*/
      //TO DO: Fehlerbehandlung
      if (true) {
        if (await updateTimetable(/*versionNew*/)) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarTimetableUpdated);
          /*storage.write('timetableVersion', versionNew.toString());*/
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBarTimetableUpdateFailed);
        }
      }
    } catch (e) {}
  } catch (e) {
    print(e);
  }
}

Future<bool> updateTimetable(/*DateTime newVersion*/) async {
  try {
    String stundenplanDIF;

    /*var response = await http
        .get(Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplan.txt'));*/

    //actually fake a response using the new scraper like a boss

    String configuration;
    try {
      configuration = GetStorage().read('configuration');
    } catch (e) {
      configuration = 'c:error;';
    }
    String currentClass = configuration.substring(
        configuration.indexOf('c:') + 2, configuration.indexOf(';'));
    print(currentClass);
    var timetableString =
        await TimetableScraper.fetch(GroupExt.fromString(key: currentClass));
    print("object");
    stundenplanDIF = timetableString.body
        .substring(1, timetableString.body.length - 1)
        .replaceAll("\\", "");
    if (stundenplanDIF.contains(currentClass)) {
      TimetableCrawler timetableCrawler = new TimetableCrawler();
      timetableCrawler.setConfiguration(
          configuration, stundenplanDIF, new DateTime.now());
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }
  return false;
}
