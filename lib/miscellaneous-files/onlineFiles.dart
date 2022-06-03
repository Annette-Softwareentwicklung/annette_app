import 'dart:io';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:http/http.dart' as http;

class OnlineFiles {
  /// folgendes Attribut ist ein String für den Stundenplan
  late String difExport;

  late DateTime newVersion;

  Future<bool> initialize() async {
    Future<String?> _getDifExport() async {
      try {
        var response = await http.get(
            Uri.http('annette-app-files.vercel.app', '220524_Stundenplan.TXT'));
        if (response.statusCode == 200) {
          return response.body;
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    Future<DateTime?> _getNewVersion() async {
      /// die jetzige Zeit wird zurückgegeben, damit der Stundenplan immer neu geladen wird.
      /// das Problem ist nämlich, dass vercel keinen "lastModifiedHeader" sendet
      /// Rui hat kein Bock im Moment die Stelle zu verändern, die den "getNewVersion" Wert liest und dort das so einzustellen,
      /// dass diese nicht mehr relevant ist ;p
      /*
      HttpClient client = HttpClient();
      HttpClientRequest req = await client.getUrl(Uri.parse(
          'http://janw.bplaced.net/annetteapp/data/stundenplan.txt'));
      HttpClientResponse tempResponse = await req.close();
      print(tempResponse.headers);
      String t = tempResponse.headers.value(
          HttpHeaders.lastModifiedHeader)!;
       */
      return DateTime.now();
    }

    final difExportValue = await _getDifExport();
    final newVersionValue = await _getNewVersion();


    if (
        difExportValue != null &&
        newVersionValue != null) {
      difExport = (await _getDifExport())!;
      newVersion = (await _getNewVersion())!;
      return true;
    } else {
      return false;
    }
  }

  ///Gibt eine Liste mit allen Klassen, die es gibt, zurück.
  List<String> allClasses() {
    List<String> classes = [];

    ///Für Klasse 10 i<11, ohne Klasse 10 i<10
    int temp = (difExport.contains('10A')) ? 11 : 10;
    for (int i = 5; i < temp; i++) {
      classes.add(i.toString() + 'A');
      classes.add(i.toString() + 'B');
      classes.add(i.toString() + 'C');
      classes.add(i.toString() + 'D');

      if (difExport.contains(i.toString() + 'F')) {
        classes.add(i.toString() + 'F');
      } else {
        classes.add(i.toString() + 'E');
      }
    }
    classes.add('EF');
    classes.add('Q1');
    classes.add('Q2');

    return classes;
  }

  List<int>? getLanguage6() {
    String s1 = difExport;
    String s2;
    List<int> secondLanguage6 = [];

    while (s1.indexOf('L6') != -1) {
      s2 = s1.substring(0, s1.indexOf('L6'));
      s2 = s2.substring(s2.lastIndexOf(',,'));

      s2 = s2.substring(s2.indexOf(',"') + 2);

      int i = int.tryParse(s2.substring(0, 1))!;
      if (!secondLanguage6.contains(i)) {
        secondLanguage6.add(i);
      }
      s1 = s1.substring(s1.indexOf('L6') + 3);
    }
    return secondLanguage6;
  }

  String difExportFile() {
    return difExport;
  }

  DateTime getNewVersion() {
    return newVersion;
  }
}
