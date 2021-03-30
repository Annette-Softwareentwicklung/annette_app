import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TimetableCrawler extends StatefulWidget {
  final String currentClass;
  TimetableCrawler({required this.currentClass});
  @override
  _TimetableCrawlerState createState() => _TimetableCrawlerState();
}

class _TimetableCrawlerState extends State<TimetableCrawler> {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk

  void makeRequest() async {
    print('call');
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk


    Future<String> _readData() async {
      try {
        return await rootBundle.loadString('assets/stundenplan.txt');
      } catch (e) {
        return 'error';
      }
    }
    pattern.allMatches(await _readData()).forEach((match) => print(match.group(0)));

crawler(await _readData());
  }

  void crawler(String code) {
    String timetableCode = code;
    //pattern.allMatches(timetableCode).forEach((match) => print(match.group(0)));

    while(timetableCode.indexOf(widget.currentClass) != -1) {
      print(timetableCode.substring(timetableCode.indexOf(',,', timetableCode.indexOf(widget.currentClass) - 10) + 2, timetableCode.indexOf(',,', timetableCode.indexOf(widget.currentClass))));
      timetableCode = timetableCode.substring(timetableCode.indexOf(widget.currentClass) + 10);
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
