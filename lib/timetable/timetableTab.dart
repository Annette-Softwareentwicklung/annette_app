import 'package:annette_app/classes/timetableUnit.dart';
import 'package:annette_app/currentValues.dart';
import 'package:annette_app/showWebview.dart';
import 'package:annette_app/subjectsList.dart';
import 'package:annette_app/timetable/classicTimetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableTab extends StatefulWidget {
  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  bool finishedNow = false;
  CurrentValues _currentValues = new CurrentValues();
  late TimeTableUnit timeTableUnit;
  late String subject;
  int tabIndex = 0;
  bool finishedZeitraster = false;

  final Shader lightGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.tealAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader darkGradient = LinearGradient(
    colors: <Color>[Colors.tealAccent, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  void load() async {
    await _currentValues.initialize();
    timeTableUnit = (await _currentValues.getCurrentTimeTableUnit())!;
    List<String> subjectAbbreviation = getSubjectsAbbreviation();
    List<String> subjectFullnames = getSubjectsFullName();

      String tempSubjectAbbreviation = timeTableUnit.subject!;

      if (!subjectAbbreviation.contains(tempSubjectAbbreviation)) {
        subject = tempSubjectAbbreviation;
      }
      if (tempSubjectAbbreviation.contains('LK')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('LK') - 1);
      } else if (tempSubjectAbbreviation.contains('GK')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('GK') - 1);
      } else if (tempSubjectAbbreviation.contains('Z1')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('Z1') - 1);
      } else if (tempSubjectAbbreviation.contains('Z2')) {
        tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
            0, tempSubjectAbbreviation.indexOf('Z2') - 1);
      }

      int tempPositionInList =
      subjectAbbreviation.indexOf(tempSubjectAbbreviation);

      if (tempPositionInList != -1) {
        subject = subjectFullnames[tempPositionInList];
      } else {
        subject = tempSubjectAbbreviation;
      }

      if (subject == 'Kath. Religion' ||
          subject == 'Ev. Religion') {
        subject = 'Religion';
      }



    setState(() {
      finishedNow = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(child: Center(child: Column(children: [
      CupertinoSlidingSegmentedControl(children: {
        0:Container(child: Text('Aktuell'), padding: EdgeInsets.symmetric(horizontal: 30),),
        1:Container(child: Text('Gesamt'), padding: EdgeInsets.symmetric(horizontal: 30),),
        2:Container(child: Text('Zeitplan'), padding: EdgeInsets.symmetric(horizontal: 30),),
      }, onValueChanged: (int? value) {
        setState(() {
          tabIndex = value!;
        });
      },groupValue: tabIndex,),
      (tabIndex == 2) ? Expanded(child: zeitraster()) : (tabIndex == 1) ? Expanded(child: wholeTimetable()):  Expanded(child: Container(child: containerNow(),padding: EdgeInsets.all(10),),),

    ],crossAxisAlignment: CrossAxisAlignment.center,)),padding: EdgeInsets.all(15)));

  }

  Widget containerNow () {
    return (finishedNow) ? Container(child: Column(children: [Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),

      constraints: BoxConstraints(
         // minHeight: 200,
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeTableUnit.lessonNumber!.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = (Theme.of(context).brightness == Brightness.dark) ? darkGradient : lightGradient,
                ),
              ),
              Text(subject, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              Text(timeTableUnit.room!, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ],
          ),
        ], mainAxisSize: MainAxisSize.min,
      ),
    )]) ) : Center(child: CupertinoActivityIndicator());
  }

  Container zeitraster () {
    return Container(
      child: ShowWebview(url: 'https://www.annettegymnasium.de/SP/Pausenregelung.jpg',),
    );
  }

  Container wholeTimetable () {
    return Container(
      child: ClassicTimetable(),
    );
  }
}




