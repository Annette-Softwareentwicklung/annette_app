import 'dart:io';
import 'dart:ui';
import 'package:annette_app/fundamentals/lessonStartTime.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/lessonStartTimes.dart';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/showWebview.dart';
import 'package:annette_app/timetable/classicTimetable.dart';
import 'package:annette_app/fundamentals/vertretungsEinheit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../subjectsMap.dart';

BoxDecoration decorationTimetable(BuildContext context) {
  return BoxDecoration(
    /*  boxShadow: (Theme.of(context).brightness == Brightness.dark) ? null : [
  BoxShadow(
  color: Colors.grey.withOpacity(0.15),
  spreadRadius: 2,
  blurRadius: 5,
  offset: Offset(0, 3), // changes position of shadow
  ),
  ],*/
    //border: Border.all(color: Colors.blue, width: 1),
    color: (Theme.of(context).brightness == Brightness.dark)
        ? Colors.black26
        : Colors.black12,
    borderRadius: BorderRadius.circular(20),
  );
}

class TimetableTab extends StatefulWidget {
  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  bool finishedNow = false;
  int tabIndex = 0;
  bool finishedZeitraster = false;
  late List<TimeTableUnit> allTimeTableUnits;
  late List<String> subjectFullnames;
  late List<LessonStartTime> allTimes;
  late String displayDayString;
  List<Widget> displayTimetable = [];
  ScrollController scrollController = new ScrollController();
  GlobalKey globalKeyNow = new GlobalKey();
  GlobalKey globalKeyEnd = new GlobalKey();

  bool isNow = false;

  late String htmlCode;
  bool vertretungsplanError = false;
  List<VertretungsEinheit>? vertretungenHeute = [];
  List<VertretungsEinheit>? vertretungenMorgen = [];
  String? dateTomorrow;
  String? dateToday;

  final Shader lightGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.tealAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader darkGradient = LinearGradient(
    colors: <Color>[Colors.tealAccent, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  void load() async {
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
          RenderBox? boxEnd =
              globalKeyEnd.currentContext!.findRenderObject() as RenderBox;
          Offset positionEnd = boxEnd.localToGlobal(Offset.zero);

          RenderBox? box =
              globalKeyNow.currentContext!.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);

          double animationHeight = scrollController.offset +
              position.dy -
              MediaQueryData.fromWindow(window).padding.top -
              110.0;

          double temp = MediaQueryData.fromWindow(window).size.height;
          temp -= 110;
          temp -= MediaQueryData.fromWindow(window).padding.top;
          temp -= MediaQueryData.fromWindow(window).padding.bottom;
          temp -= 110;

          if (positionEnd.dy - position.dy < temp) {
            animationHeight -= positionEnd.dy - position.dy;
            print(MediaQueryData.fromWindow(window).size.height);
            print(temp);
            print(positionEnd.dy);
            print(position.dy);
            print(positionEnd.dy - position.dy);

            animationHeight = scrollController.position.maxScrollExtent;
          }

          scrollController.animateTo(animationHeight,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        });
      } catch (e) {}
    }
  }

  Future<void> setDay(int pWeekday, int? pLessonNumber, bool? isInBreak) async {
    pWeekday = 1;
    pLessonNumber = 4;
    isInBreak = false;
    Duration tempDuration = Duration(days: 1);

    int i = 1;
    while (allTimeTableUnits.indexWhere((element) =>
            (element.dayNumber! == pWeekday && element.lessonNumber! >= i)) !=
        -1) {
      int? tempEnd;
      bool isFree = false;
      int j = i + 1;
      if (i != 1) {
        tempDuration = parseDuration(allTimes[(i - 1)].time!) -
            parseDuration(allTimes[(i - 2)].time!) -
            Duration(minutes: 45);
      }

      if (i != 1 &&
          allTimeTableUnits.indexWhere((element) =>
                  element.dayNumber == pWeekday &&
                  element.lessonNumber == i - 1) !=
              -1) {
        displayTimetable
            .add(DisplayBreak(duration: tempDuration.inMinutes.toString()));
      }

      if (allTimeTableUnits.indexWhere((element) =>
              (element.dayNumber! == pWeekday && element.lessonNumber! == i)) ==
          -1) {
        isFree = true;
        j = i + 1;
        while (allTimeTableUnits.indexWhere((element) =>
                element.dayNumber == pWeekday && element.lessonNumber == j) ==
            -1) {
          tempEnd = j;
          j++;
        }
      }

      print(j);
      displayTimetable.add(TimeDivider(
          time: getTimeFromDuration(parseDuration(allTimes[(i - 1)].time!)),
          isNow: (pLessonNumber >= i && pLessonNumber < j && ((isInBreak == false && !isFree) || (isFree))) ? true : false,
          key: (pLessonNumber == i && isInBreak == false)
              ? globalKeyNow
              : null));
      if (isFree) {
        displayTimetable.add(DisplayFree(
            pHour:
                '${i.toString()}${(tempEnd != null) ? ' - ${tempEnd.toString()}' : ''}'));
      }

      if (tempEnd != null) {
        i = tempEnd;
      }
      if (!isFree) {
        displayTimetable.add(DisplayTimetableUnit(
            timeTableUnit: allTimeTableUnits.firstWhere((element) =>
                (element.dayNumber! == pWeekday && element.lessonNumber! == i)),
            vertretung: null));
      }

      tempDuration =
          parseDuration(allTimes[(i - 1)].time!) + Duration(minutes: 45);

      if (tempEnd == null) {
        displayTimetable.add(TimeDivider(
            time: getTimeFromDuration(tempDuration),
            isNow: (pLessonNumber == i &&
                    isInBreak == true &&
                    (allTimeTableUnits.indexWhere((element) =>
                            (element.dayNumber! == pWeekday &&
                                element.lessonNumber! > i)) !=
                        -1))
                ? true
                : false,
            key: (pLessonNumber == i &&
                    isInBreak == true &&
                    (allTimeTableUnits.indexWhere((element) =>
                            (element.dayNumber! == pWeekday &&
                                element.lessonNumber! > i)) !=
                        -1))
                ? globalKeyNow
                : null));
      }

      i++;
    }

    displayTimetable.add(Container(
      key: globalKeyEnd,
      height: 1,
      width: double.infinity,
    ));
  }

  @override
  void initState() {
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
                          RenderBox? boxEnd = globalKeyEnd.currentContext!
                              .findRenderObject() as RenderBox;
                          Offset positionEnd =
                              boxEnd.localToGlobal(Offset.zero);

                          RenderBox? box = globalKeyNow.currentContext!
                              .findRenderObject() as RenderBox;
                          Offset position = box.localToGlobal(Offset.zero);

                          double animationHeight = scrollController.offset +
                              position.dy -
                              MediaQueryData.fromWindow(window).padding.top -
                              110.0;

                          double temp =
                              MediaQueryData.fromWindow(window).size.height;
                          temp -= 110;
                          temp -= MediaQueryData.fromWindow(window).padding.top;
                          temp -=
                              MediaQueryData.fromWindow(window).padding.bottom;
                          temp -= 110;

                          if (positionEnd.dy - position.dy < temp) {
                            animationHeight -= positionEnd.dy - position.dy;
                            print(
                                MediaQueryData.fromWindow(window).size.height);
                            print(temp);
                            print(positionEnd.dy);
                            print(position.dy);
                            print(positionEnd.dy - position.dy);

                            animationHeight =
                                scrollController.position.maxScrollExtent;
                          }

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
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: displayTimetable,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                )))
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

  Container zeitraster() {
    return Container(
      child: (Platform.isIOS)
          ? ShowWebview(
              url: 'https://www.annettegymnasium.de/SP/Pausenregelung.jpg',
            )
          : Image.network(
              'https://www.annettegymnasium.de/SP/Pausenregelung.jpg'),
    );
  }

  Container wholeTimetable() {
    return Container(
      child: ClassicTimetable(),
    );
  }
}

class DisplayFree extends StatelessWidget {
  final String pHour;

  const DisplayFree({Key? key, required this.pHour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 80),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: decorationTimetable(context),
            constraints: BoxConstraints(
                // minHeight: 200,
                ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  pHour,
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
}

class DisplayBreak extends StatelessWidget {
  final String duration;

  const DisplayBreak({Key? key, required this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 80,
            height: 20,
            alignment: Alignment.center,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(15),
            decoration: decorationTimetable(context),
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
}

class DisplayTimetableUnit extends StatelessWidget {
  final TimeTableUnit timeTableUnit;
  final VertretungsEinheit? vertretung;

  const DisplayTimetableUnit(
      {Key? key, required this.timeTableUnit, this.vertretung})
      : super(key: key);

  String getSubjectFullname(String pSubject) {
    String subjectFullname;
    Map<String, String> allSubjects = getSubjects();

    if (pSubject.contains('LK')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('LK') - 1);
    } else if (pSubject.contains('GK')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('GK') - 1);
    } else if (pSubject.contains('Z1')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('Z1') - 1);
    } else if (pSubject.contains('Z2')) {
      pSubject = pSubject.substring(0, pSubject.indexOf('Z2') - 1);
    }

    if (allSubjects.containsKey(pSubject)) {
      subjectFullname = allSubjects[pSubject]!;
    } else {
      subjectFullname = pSubject;
    }

    if (subjectFullname == 'Kath. Religion' ||
        subjectFullname == 'Ev. Religion') {
      subjectFullname = 'Religion';
    }

    return subjectFullname;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 80),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: decorationTimetable(context),
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
              Expanded(
                child: IntrinsicWidth(
                  child: Container(
                    child: Text(
                      getSubjectFullname(timeTableUnit.subject!),
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (timeTableUnit.room! != '-')
            Row(
              children: [
                if (vertretung != null)
                  Container(
                    child: Text(
                      vertretung!.room!,
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
              vertretung!.teacherNew != null &&
              vertretung!.teacherOld != vertretung!.teacherNew)
            Row(
              children: [
                Text(
                  vertretung!.teacherNew!,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Text(
                    (vertretung!.teacherOld != null)
                        ? vertretung!.teacherOld!
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
                      (vertretung!.comment != null)
                          ? vertretung!.type! + ':'
                          : vertretung!.type!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 5),
                  ),
                  if (vertretung!.comment != null)
                    Text(
                      vertretung!.comment!,
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
}

class TimeDivider extends StatelessWidget {
  final String time;
  final bool isNow;

  const TimeDivider({Key? key, required this.time, required this.isNow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: (isNow)
                    ? Colors.red
                    : (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.white54
                        : Colors.black,
                borderRadius: (isNow)
                    ? BorderRadius.circular(2)
                    : BorderRadius.circular(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
