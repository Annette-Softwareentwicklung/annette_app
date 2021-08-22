import 'dart:io';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/timetable/timetableCrawler.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
  try {
    var storage = GetStorage();

    DateTime version = DateTime.parse(storage.read('timetableVersion'));

      DateTime versionNew;
      try {
        HttpClient client = HttpClient();
        HttpClientRequest req = await client.getUrl(Uri.parse(
            'http://janw.bplaced.net/annetteapp/data/stundenplan.txt'));
        HttpClientResponse tempResponse = await req.close();
        String t = tempResponse.headers.value(HttpHeaders.lastModifiedHeader)!;
        print('Zuletzt geändert: $t');
        versionNew = getLastModifiedTime(t)!;

        if (version.isBefore(versionNew)) {
          if (await updateTimetable(versionNew)) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarTimetableUpdated);
            storage.write('timetableVersion', versionNew.toString());
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

Future<bool> updateTimetable(DateTime newVersion) async {
  try {
    String stundenplanDIF;

    var response = await http
        .get(Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplan.txt'));
    if (response.statusCode == 200) {
      stundenplanDIF = response.body;
      String configuration;
      try{
        configuration = GetStorage().read('configuration');
      } catch(e) {
        configuration = 'c:error;';
      }
      String currentClass = configuration.substring(
          configuration.indexOf('c:') + 2, configuration.indexOf(';'));
      if (stundenplanDIF.contains(currentClass)) {
        TimetableCrawler timetableCrawler = new TimetableCrawler();
        timetableCrawler.setConfiguration(
            configuration, stundenplanDIF, newVersion);
        return true;
      }
    }
    return false;
  } catch (e) {
    return false;
  }
}
