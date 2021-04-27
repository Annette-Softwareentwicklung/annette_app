import 'dart:io';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/timetable/timetableCrawler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final snackBarTimetableUpdateFailed  = SnackBar(
  duration: Duration(seconds: 3),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        Icons.warning_rounded,
        color: Colors.white,
      ),
      Container(
        child: Text('Fehler Stundenplan-Update', style: TextStyle(fontSize: 17)),
        margin: EdgeInsets.only(left: 15),
      ),
    ],
  ),
  //backgroundColor: Colors.redAccent,
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
        child: Text('Stundenplan wurde aktualisiert', style: TextStyle(fontSize: 17)),
        margin: EdgeInsets.only(left: 15),
      ),
    ],
  ),
  //backgroundColor: Colors.redAccent,
  margin: EdgeInsets.all(10),
  behavior: SnackBarBehavior.floating,
);

Future<void> update (BuildContext context) async {
  try{
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _writeData(DateTime newVersion) async {
      final _path = await _getPath();
      final _myFile = File('$_path/version.txt');
      await _myFile.writeAsString(newVersion.toString());
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
    DateTime? version = await _readData();

    if(version != null) {
      DateTime versionNew;
        try {
          HttpClient client = HttpClient();
          HttpClientRequest req = await client.getUrl(Uri.parse(
              'http://janw.bplaced.net/annetteapp/data/stundenplan.txt'));
          HttpClientResponse tempResponse = await req.close();
          String t = tempResponse.headers.value(
              HttpHeaders.lastModifiedHeader)!;
          print('Zuletzt geändert: $t');
          versionNew = getLastModifiedTime(t)!;

          if (version.isBefore(versionNew)) {
            if (await updateTimetable(versionNew)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBarTimetableUpdated);
              await _writeData(versionNew);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBarTimetableUpdateFailed);
            }
          }
        } catch (e) {}




    }
    } catch(e) {
    print(e);
  }
}

Future<bool> updateTimetable (DateTime newVersion) async {
  try {
    String stundenplanDIF;

       var response = await http.get(
        Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplan.txt'));
    if (response.statusCode == 200) {
        stundenplanDIF = response.body;
        Future<String> _getPath() async {
          final _dir = await getApplicationDocumentsDirectory();
          return _dir.path;
        }

        Future<String> _readData() async {
          try {
            final _path = await _getPath();
            final _file = File('$_path/configuration.txt');

            String contents = await _file.readAsString();
            return contents;
          } catch (e) {
            return 'c:error;';
          }
        }
        String configuration = await _readData();
        String currentClass = configuration.substring(configuration.indexOf('c:') + 2, configuration.indexOf(';'));
        if(stundenplanDIF.contains(currentClass)) {
          TimetableCrawler timetableCrawler = new TimetableCrawler();
          timetableCrawler.setConfiguration(configuration, stundenplanDIF, newVersion);
          return true;
        }
    }
    return false;
  } catch (e) {
    return false;
  }
}