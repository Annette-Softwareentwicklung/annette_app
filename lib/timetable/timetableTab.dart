import 'dart:io';
import 'dart:ui';
import 'package:annette_app/classes/lessonStartTime.dart';
import 'package:annette_app/classes/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/lessonStartTimes.dart';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/showWebview.dart';
import 'package:annette_app/subjectsList.dart';
import 'package:annette_app/timetable/classicTimetable.dart';
import 'package:annette_app/timetableURL.dart';
import 'package:annette_app/classes/vertretungsEinheit.dart';
import 'package:annette_app/vertretung/vertretunsplanCrawler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  late List<LessonStartTime> allTimes;
  late String displayDayString;
  List<Widget> displayTimetable = [];
  ScrollController scrollController = new ScrollController();
  GlobalKey globalKeyNow = new GlobalKey();
  bool isNow = false;

  late String htmlCode;
  bool vertretungsplanError = false;
  List<VertretungsEinheit>? vertretungenHeute = [];
  List<VertretungsEinheit>? vertretungenMorgen = [];
  String? dateTomorrow;
  String?  dateToday;

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

  Future<bool> vertretunsplan () async {
    try {
      var response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Heute_KoL/subst_001.htm'));
      if (response.statusCode == 200) {
        htmlCode = response.body;
        VertretungsplanCrawler vpc1 =
        new VertretungsplanCrawler(htmlCode: htmlCode);
        dateToday = vpc1.getCurrentDate();
        vertretungenHeute = await vpc1.getVertretungen();

        if (vertretungenHeute != null) {
          vertretungenHeute!.sort((a, b) {
            return a.lesson!.compareTo(b.lesson!);
          });
        }
      }

      response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Morgen_KoL/subst_001.htm'));
      if (response.statusCode == 200) {
        htmlCode = response.body;
        VertretungsplanCrawler vpc2 =
        new VertretungsplanCrawler(htmlCode: htmlCode);
        dateTomorrow = vpc2.getCurrentDate();
        vertretungenMorgen = await vpc2.getVertretungen();
        if (vertretungenMorgen != null) {
          vertretungenMorgen!.sort((a, b) {
            return a.lesson!.compareTo(b.lesson!);
          });
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void load() async {

  //vertretungsplanError = await  vertretunsplan();
    subjectAbbreviation = getSubjectsAbbreviation();
    subjectFullnames = getSubjectsFullName();
    allTimes = getAllTimes();
    allTimeTableUnits = await databaseGetAllTimeTableUnit();

    allTimeTableUnits.sort((a, b) {
      return a.lessonNumber!.compareTo(b.lessonNumber!);
    });

    DateTime tempTime = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int displayDay = DateTime.now().weekday;
    if (displayDay == 6 || displayDay == 7) {
      displayDay = 1;
      displayDayString = 'Montag';
      await setDay(1, null, null);
    } else {
      displayDayString = '--';
      int currentLessonNumber = 0;
      bool isInBreak = false;
      int i = 0;

      for (int i = 0; i < allTimes.length; i++) {
        if (!DateTime.now()
            .isBefore(tempTime.add(parseDuration(allTimes[i].time!)))) {
          currentLessonNumber = i + 1;
          isInBreak = false;
        }
        if (!DateTime.now().isBefore(tempTime
            .add(parseDuration(allTimes[i].time!))
            .add(Duration(minutes: 45)))) {
          currentLessonNumber = i + 1;
          isInBreak = true;
        }
      }


      if (currentLessonNumber == 0) {
        await setDay(DateTime.now().weekday, null, null);
        displayDayString = 'Heute';
      } else {
        if (allTimeTableUnits.indexWhere((element) =>
                (element.dayNumber == DateTime.now().weekday &&
                    element.lessonNumber! >=
                        (currentLessonNumber + ((isInBreak) ? 1 : 0)))) !=
            -1) {
          await setDay(DateTime.now().weekday, currentLessonNumber, isInBreak);
          displayDayString = 'Jetzt';
          isNow = true;
        } else {
          int temp = DateTime.now().weekday + 1;
          await setDay((temp == 6) ? 1 : temp, null, null);
          displayDayString = (temp == 6) ? 'Montag' : 'Morgen';
        }
      }
    }

    displayTimetable.insert(
      0,
      Container(
        width: double.infinity,
        child: Text(
          displayDayString,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        margin: EdgeInsets.only(bottom: 15),
      ),
    );


    displayTimetable.add(Container(
      margin: EdgeInsets.only(bottom: 40),
    ));

    setState(() {
      finishedNow = true;
    });

    if (isNow) {
      try {
        Future.delayed(Duration(milliseconds: 50), () {
          RenderBox? box =
              globalKeyNow.currentContext!.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);

          double animationHeight = scrollController.offset +
              position.dy -
              MediaQueryData.fromWindow(window).padding.top -
              110.0;
          scrollController.animateTo(animationHeight,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        });
      } catch (e) {}
    }
  }

  Future<void> setDay(int pWeekday, int? pLessonNumber, bool? isInBreak) async {
    Duration tempDuration;
    displayTimetable.add(timeDivider(
        getTimeFromDuration(parseDuration(allTimes[0].time!)),
        (pLessonNumber == 0 && isInBreak == false) ? true : false,
        (pLessonNumber == 0 && isInBreak == false) ? globalKeyNow : null));
    int temp = allTimeTableUnits.indexWhere((element) =>
        (element.dayNumber == pWeekday && element.lessonNumber == 1));
    if (temp != -1) {
      displayTimetable.add(displayTimetableUnit(allTimeTableUnits[temp], null));
    } else {
      displayTimetable.add(displayFree(1));
    }
    tempDuration = parseDuration(allTimes[0].time!) + Duration(minutes: 45);
    displayTimetable.add(timeDivider(
        getTimeFromDuration(tempDuration),
        (pLessonNumber == 0 && isInBreak == true) ? true : false,
        (pLessonNumber == 0 && isInBreak == true) ? globalKeyNow : null));

    int i = 2;
    while (allTimeTableUnits.indexWhere((element) =>
            (element.dayNumber! == pWeekday && element.lessonNumber! >= i )) !=
        -1) {
      tempDuration = parseDuration(allTimes[(i - 1)].time!) -
          parseDuration(allTimes[(i - 2)].time!) -
          Duration(minutes: 45);
      displayTimetable.add(displayBreak(tempDuration.inMinutes.toString()));
      displayTimetable.add(timeDivider(
          getTimeFromDuration(parseDuration(allTimes[(i - 1)].time!)),
          (pLessonNumber == i && isInBreak == false) ? true : false,
          (pLessonNumber == i && isInBreak == false) ? globalKeyNow : null));

      if (allTimeTableUnits.indexWhere((element) =>
              (element.dayNumber! == pWeekday && element.lessonNumber! == i)) !=
          -1) {
        displayTimetable.add(displayTimetableUnit(
            allTimeTableUnits.firstWhere((element) =>
                (element.dayNumber! == pWeekday && element.lessonNumber! == i)),
            null));
      } else {
        displayTimetable.add(displayFree(i));
      }

      tempDuration =
          parseDuration(allTimes[(i - 1)].time!) + Duration(minutes: 45);
      displayTimetable.add(timeDivider(
          getTimeFromDuration(tempDuration),
          (pLessonNumber == i && isInBreak == true) ? true : false,
          (pLessonNumber == i && isInBreak == true) ? globalKeyNow : null));

      i++;
    }
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
                      child: Text('Aktuell'),
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                    1: Container(
                      child: Text('Gesamt'),
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                    2: Container(
                      child: Text('Zeitplan'),
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                  },
                  onValueChanged: (int? value) {
                    setState(() {
                      tabIndex = value!;
                    });
                    if (value == 0 && isNow == true) {
                      try {
                        Future.delayed(Duration(milliseconds: 50), () {
                          RenderBox? box = globalKeyNow.currentContext!
                              .findRenderObject() as RenderBox;
                          Offset position = box.localToGlobal(Offset.zero);

                          double animationHeight = scrollController.offset +
                              position.dy -
                              MediaQueryData.fromWindow(window).padding.top -
                              110.0;
                          scrollController.animateTo(animationHeight,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
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
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                            ),
                          ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            )),
            padding: EdgeInsets.only(top: 15, left: 15, right: 15)));
  }

  Widget containerNow() {
    return (finishedNow)
        ? SingleChildScrollView(
            controller: scrollController,
            child: Container(
              child: Column(
                children: displayTimetable,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ))
        : Center(
            child: Column(
            children: [
              CupertinoActivityIndicator(),
              Text('Laden ...'),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
          ));
  }

  Widget timeDivider(String time, bool isNow, Key? key) {
    return Container(
      key: key,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: (isNow) ? Colors.red : null,
                  fontWeight: (isNow) ? FontWeight.w600 : null),
            ),
            width: 70,
            alignment: Alignment.centerRight,
          ),
          Expanded(
            child: Container(
              height: (isNow) ? 5 : 1,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: (isNow) ? Colors.red : (Theme.of(context).brightness == Brightness.dark) ? Colors.white54 : Colors.black,
                borderRadius: (isNow) ? BorderRadius.circular(2) : BorderRadius.circular(0),
              ),
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
            //crossAxisAlignment: () ?  CrossAxisAlignment.start : null,
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
              Expanded(child: IntrinsicWidth(child: Container(child: Text(
                getSubjectFullname(timeTableUnit.subject!),
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),),),),
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
          if (vertretung != null &&
              vertretung.teacher_new != null &&
              vertretung.teacher_old != vertretung.teacher_new)
            Row(
              children: [
                Text(
                  vertretung.teacher_new!,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Text(
                    (vertretung.teacher_old != null)
                        ? vertretung.teacher_old!
                        : '',
                    style: TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.normal),
                  ),
                  margin: EdgeInsets.only(right: 5, left: 5),
                ),
                Icon(CupertinoIcons.person_fill),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          if (vertretung != null)
            Container(
              child: Row(
                children: [
                  Container(
                    child: Text(
                      (vertretung.comment != null)
                          ? vertretung.type! + ':'
                          : vertretung.type!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 5),
                  ),
                  if (vertretung.comment != null)
                    Text(
                      vertretung.comment!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              margin: EdgeInsets.only(top: 15),
            ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Widget displayBreak(String duration) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 80,
            height: 20,
            //child: Text('Jetzt',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
            alignment: Alignment.center,
          ),
          Expanded(
              child: Container(
            // margin: EdgeInsets.only(left: 80),

            padding: EdgeInsets.all(15),
            //width: double.infinity - 80,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            /*constraints: BoxConstraints(
          // minHeight: 200,
        ),*/
            alignment: Alignment.center,
            child: Text(
              '$duration min. Pause',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ))
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      width: double.infinity,
    );
  }

  Widget displayFree(int pHour) {
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
            child: Row(
              children: [
                Text(
                  pHour.toString(),
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
                  'Freistunde',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(''),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          )
        ]));
  }

  Container zeitraster() {
    return Container(
      child: (Platform.isIOS) ? ShowWebview(url: 'https://www.annettegymnasium.de/SP/Pausenregelung.jpg',) :
      Image.network('https://www.annettegymnasium.de/SP/Pausenregelung.jpg'),
    );
  }

  Container wholeTimetable() {
    return Container(
      child: ClassicTimetable(),
    );
  }
}
