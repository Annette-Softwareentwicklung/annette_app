import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
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
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    String htmlCode = code;
    htmlCode = htmlCode.substring(
        htmlCode.indexOf('<', htmlCode.indexOf('>', htmlCode.indexOf('<TABLE'))),
        htmlCode.lastIndexOf('</TABLE'));
    htmlCode = htmlCode.substring(0, htmlCode.lastIndexOf('</TABLE'));
    htmlCode =
        htmlCode.substring(htmlCode.indexOf('<TR', htmlCode.indexOf('Freitag')));
    //pattern.allMatches(htmlCode).forEach((match) => print(match.group(0)));

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

    for (int i = 0; i < startOfRow.length; i++) {
      print('---$i');
      String s = htmlCode.substring(startOfRow[i], endOfRow[i]);
      if(s.contains('*') || s.length == 7) {} else {
        pattern.allMatches(s).forEach((match) => print(match.group(0)));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeRequest();
  }
  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}


