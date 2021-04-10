import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TimetableCrawler extends StatefulWidget {
  final String configurationString;
  TimetableCrawler({required this.configurationString});

  @override
  _TimetableCrawlerState createState() => _TimetableCrawlerState();
}

class _TimetableCrawlerState extends State<TimetableCrawler> {
  late String configurationString;


  void makeRequest() async {
    print('call');
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk

    var response = await http.get(Uri.https(
        'www.annettegymnasium.de', 'SP/stundenplan_oL/c/P9/c00001.htm'));
    if (response.statusCode == 200) {
      crawler(response.body);
      //pattern.allMatches(response.body).forEach((match) => print(match.group(0)));

    } else {
      throw Exception('failed to load');
    }
  }

  void crawler(String code) {
    final pattern = RegExp('.{1,800}');

    ///Tabelle mit dem Stundenplan herausfiltern
    String htmlCode = code;
    htmlCode = htmlCode.substring(
        htmlCode.indexOf(
            '<', htmlCode.indexOf('>', htmlCode.indexOf('<TABLE'))),
        htmlCode.lastIndexOf('</TABLE'));
    htmlCode = htmlCode.substring(0, htmlCode.lastIndexOf('</TABLE'));
    htmlCode = htmlCode
        .substring(htmlCode.indexOf('<TR', htmlCode.indexOf('Freitag')));

    ///Start und Endwerte der einzelnen Reihen der Tabelle herausfinden
    List<int> startOfRow = [];
    List<int> endOfRow = [];
    int tempStartTR = 0;
    int tempEndTR = 0;

    do {
      startOfRow.add(tempStartTR);
      do {
        tempStartTR = htmlCode.indexOf('<TR', tempStartTR + 1);
        tempEndTR = htmlCode.indexOf('</TR', tempEndTR + 1);
        tempEndTR++;
        tempStartTR++;
      } while (tempStartTR < tempEndTR);
      endOfRow.add(tempEndTR--);
      tempStartTR = tempEndTR + 5;
    } while (htmlCode.indexOf('<TR', tempStartTR + 1) != -1);

    ///Jede Reihe der "großen" stundenplan tabelle als String in einer Liste abspeichern.
    List<String> rows = [];
    for (int i = 0; i < startOfRow.length; i++) {
      String s = htmlCode.substring(startOfRow[i], endOfRow[i]);
      if (s.contains('*') || s.length == 7) {
      } else {
        rows.add(s.substring(4, s.lastIndexOf('>') + 1));
      }
    }

    //for (int i = 0; i < rows.length; i++) {
    String tempRow = rows[0];
    List<int> startOfTD = [];
    List<int> endOfTD = [];
    int tempStartTD = 0;
    int tempEndTD = 0;
    tempRow = tempRow.substring(2);
    // pattern.allMatches(tempRow).forEach((match) => print(match.group(0)));

    //do {
      startOfTD.add(tempStartTD);
      do {
        tempStartTD = tempRow.indexOf('<TD', tempStartTD + 1);
        tempEndTD = tempRow.indexOf('</TD', tempEndTD + 1);
        tempStartTD++;
        tempEndTD++;
      } while (tempStartTD < tempEndTD);
      endOfTD.add(tempEndTD--);
      tempStartTD = tempEndTD;
    //} while (tempRow.indexOf('<TD', tempStartTD + 1) != -1);
    /*List<String> td = [];
      for (int i = 0; i < startOfTD.length; i++) {
        String s = htmlCode.substring(startOfTD[i], endOfTD[i]);
          td.add(s);
      }
    for (int i = 0; i < td.length; i++) {
      print('---$i');
      pattern.allMatches(td[i]).forEach((match) => print(match.group(0)));
    }*/
    //}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurationString = widget.configurationString;
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}
