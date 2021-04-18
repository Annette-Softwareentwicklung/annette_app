import 'package:annette_app/classes/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/showWebview.dart';
import 'package:annette_app/subjectsList.dart';
import 'package:annette_app/timetable/classicTimetable.dart';
import 'package:annette_app/vertretung/vertretungsEinheit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableTab extends StatefulWidget {
  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  bool finishedNow = false;
  int tabIndex = 0;
  bool finishedZeitraster = false;
  late List<TimeTableUnit> allTimeTableUnits;
  late List<String> subjectAbbreviation;
  late List<String> subjectFullnames;

  final Shader lightGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.tealAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader darkGradient = LinearGradient(
    colors: <Color>[Colors.tealAccent, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  String getSubjectFullname(String pSubject) {
    String subjectFullname;

    if (!subjectAbbreviation.contains(pSubject)) {
      subjectFullname = pSubject;
    }
    if (pSubject.contains('LK')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('LK') - 1);
    } else if (pSubject.contains('GK')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('GK') - 1);
    } else if (pSubject.contains('Z1')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('Z1') - 1);
    } else if (pSubject.contains('Z2')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('Z2') - 1);
    }

    int tempPositionInList = subjectAbbreviation.indexOf(pSubject);

    if (tempPositionInList != -1) {
      subjectFullname = subjectFullnames[tempPositionInList];
    } else {
      subjectFullname = pSubject;
    }

    if (subjectFullname == 'Kath. Religion' ||
        subjectFullname == 'Ev. Religion') {
      subjectFullname = 'Religion';
    }

    return subjectFullname;
  }

  void load() async {
    allTimeTableUnits = await databaseGetAllTimeTableUnit();
    allTimeTableUnits.sort((a, b) {
      return a.lessonNumber!.compareTo(b.lessonNumber!);
    });

    subjectAbbreviation = getSubjectsAbbreviation();
    subjectFullnames = getSubjectsFullName();

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
    return SafeArea(
        child: Container(
            child: Center(
                child: Column(
              children: [
                CupertinoSlidingSegmentedControl(
                  children: {
                    0: Container(
                      child: Text('Jetzt'),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    1: Container(
                      child: Text('Gesamt'),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    2: Container(
                      child: Text('Zeitplan'),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                  },
                  onValueChanged: (int? value) {
                    setState(() {
                      tabIndex = value!;
                    });
                  },
                  groupValue: tabIndex,
                ),
                (tabIndex == 2)
                    ? Expanded(child: zeitraster())
                    : (tabIndex == 1)
                        ? Expanded(child: wholeTimetable())
                        : Expanded(
                            child: Container(
                              child: containerNow(),
                              padding: EdgeInsets.all(10),
                            ),
                          ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            )),
            padding: EdgeInsets.all(15)));
  }

  Widget containerNow() {
    return (finishedNow)
        ? SingleChildScrollView(
            child: Container(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text('Montag', style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),),margin: EdgeInsets.only(bottom: 15),
                ),
                timeDivider('8:00 Uhr'),
                displayTimetableUnit(
                    allTimeTableUnits[0],
                    new VertretungsEinheit(
                        'type',
                        'subject_new',
                        'subject_old',
                        'affectedClass',
                        'comment',
                        'WWW',
                        'MMM',
                        'A211',
                        'lesson')),
                timeDivider('8:45 Uhr'),
                displayBreak('5'),
                timeDivider('8:50 Uhr'),
                displayTimetableUnit(allTimeTableUnits[2], null),
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ))
        : Center(child: CupertinoActivityIndicator());
  }

  Widget timeDivider(String time) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            child: Text(
              time,
              textAlign: TextAlign.right,
            ),
            width: 70,
            alignment: Alignment.centerRight,
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: EdgeInsets.only(left: 10),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayTimetableUnit(
      TimeTableUnit timeTableUnit, VertretungsEinheit? vertretung) {
    return Container(
      margin: EdgeInsets.only(left: 80),
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
                  color: Colors.blue,
                  /*foreground: Paint()
                    ..shader = (Theme.of(context).brightness == Brightness.dark)
                        ? darkGradient
                        : lightGradient,*/
                ),
              ),
              Text(
                getSubjectFullname(timeTableUnit.subject!),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              if (vertretung != null)
                Container(
                  child: Text(
                    vertretung.room!,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
              Text(
                timeTableUnit.room!,
                style: TextStyle(
                    fontSize: 25,
                    decoration: (vertretung != null)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontWeight: FontWeight.normal),
              ),
              Icon(CupertinoIcons.location_solid),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),

          if(vertretung != null && vertretung.teacher_new != null && vertretung.teacher_old != vertretung.teacher_new)Row(
            children: [
                     Text(
                          vertretung.teacher_new!,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),

                    Container(child: Text(
                      (vertretung.teacher_old != null) ? vertretung.teacher_old! : '',
                      style: TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.normal),
                    ),margin: EdgeInsets.only(right: 5, left: 5),),
                    Icon(CupertinoIcons.person_fill),



            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),

          if (vertretung != null)
            Container(child:Row(children: [
              Container(
                child: Text(
    (vertretung.comment != null) ? vertretung.type! + ':': vertretung.type! ,
                  style: TextStyle(
                    fontSize: 20,color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(right: 5),
              ),
              if(vertretung.comment != null)
              Text(
                vertretung.comment!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,),
            margin: EdgeInsets.only(top: 15),),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Widget displayBreak(String duration) {
    return Container(
        margin: EdgeInsets.only(left: 80),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            constraints: BoxConstraints(
                // minHeight: 200,
                ),
            alignment: Alignment.center,
            child: Text(
              '$duration min. Pause',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          )
        ]));
  }

  Container zeitraster() {
    return Container(
      child: ShowWebview(
        url: 'https://www.annettegymnasium.de/SP/Pausenregelung.jpg',
      ),
    );
  }

  Container wholeTimetable() {
    return Container(
      child: ClassicTimetable(),
    );
  }
}
