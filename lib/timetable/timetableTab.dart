import 'dart:io';
import 'dart:ui';
import 'package:annette_app/custom_widgets/customDialog.dart';
import 'package:annette_app/data/links.dart';
import 'package:annette_app/fundamentals/lessonStartTime.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/data/lessonStartTimes.dart';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:annette_app/miscellaneous-files/showWebview.dart';
import 'package:annette_app/timetable/classicTimetable.dart';
import 'package:annette_app/fundamentals/vertretungsEinheit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/subjects.dart';
import 'package:get_storage/get_storage.dart';
import 'package:week_of_year/week_of_year.dart';

BoxDecoration decorationTimetable(BuildContext context) {
  return BoxDecoration(
    /*boxShadow: (Theme.of(context).brightness == Brightness.dark) ? null : [
  BoxShadow(
  color: Colors.grey.withOpacity(0.15),
  spreadRadius: 3,
  blurRadius: 5,
  offset: Offset(1, 3), // changes position of shadow
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
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),
    );

    displayTimetable.add(Container(
      margin: EdgeInsets.only(bottom: 40),
    ));

    setState(() {
      finishedNow = true;
    });

    if (isNow) {
      Future.delayed(Duration(milliseconds: 50), () {
        try {
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

            animationHeight = scrollController.position.maxScrollExtent;
          }

          scrollController.animateTo(animationHeight,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  Future<void> setDay(int pWeekday, int? pLessonNumber, bool? isInBreak) async {
    Duration tempDuration = Duration(days: 1);
    if (allTimeTableUnits
            .indexWhere((element) => (element.dayNumber! == pWeekday)) ==
        -1) {
      displayTimetable.add(TimeDivider(
          time: getTimeFromDuration(parseDuration(allTimes[(0)].time!)),
          isNow: false,
          key: null));
      displayTimetable.add(DisplayFree(pHour: '1'));
      displayTimetable.add(TimeDivider(
          time: getTimeFromDuration(
              parseDuration(allTimes[(0)].time!) + Duration(minutes: 45)),
          isNow: false,
          key: null));
    } else {
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
                -1 &&
            allTimeTableUnits.indexWhere((element) =>
                    element.dayNumber == pWeekday &&
                    element.lessonNumber == i) !=
                -1) {
          displayTimetable
              .add(DisplayBreak(duration: tempDuration.inMinutes.toString()));
        }

        if (allTimeTableUnits.indexWhere((element) =>
                (element.dayNumber! == pWeekday &&
                    element.lessonNumber! == i)) ==
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

        if (i == 1 || !isFree)
          displayTimetable.add(TimeDivider(
              time: getTimeFromDuration(parseDuration(allTimes[(i - 1)].time!)),
              isNow: (pLessonNumber != null &&
                      pLessonNumber >= i &&
                      pLessonNumber < j &&
                      ((isInBreak == false && !isFree) || (isFree)))
                  ? true
                  : false,
              key: (pLessonNumber != null &&
                      pLessonNumber >= i &&
                      pLessonNumber < j &&
                      ((isInBreak == false && !isFree) || (isFree)))
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
          TimeTableUnit tempTimetableUnit = allTimeTableUnits.firstWhere(
              (element) => (element.dayNumber! == pWeekday &&
                  element.lessonNumber! == i));

          bool isChangingLK = false;
          if (tempTimetableUnit.subject!.contains('LK') &&
              allTimeTableUnits.indexWhere((element) =>
                      element.lessonNumber == i &&
                      element.dayNumber == pWeekday &&
                      element.subject != tempTimetableUnit.subject) !=
                  -1) {
            isChangingLK = true;
            GetStorage storage = GetStorage();
            print(storage.read('changingLkSubject'));
            print(storage.read('changingLkWeekNumber'));
            if ((DateTime.now().weekOfYear.isEven &&
                    storage.read('changingLkWeekNumber').isEven) ||
                (!DateTime.now().weekOfYear.isEven &&
                    !storage.read('changingLkWeekNumber').isEven)) {
              if (storage.read('changingLkSubject') !=
                  tempTimetableUnit.subject!) {
                tempTimetableUnit = allTimeTableUnits.firstWhere((element) =>
                    (element.dayNumber! == pWeekday &&
                        element.lessonNumber! == i &&
                        element.subject == storage.read('changingLkSubject')));
              }
            } else {
              if (storage.read('changingLkSubject') ==
                  tempTimetableUnit.subject!) {
                tempTimetableUnit = allTimeTableUnits.firstWhere((element) =>
                    (element.dayNumber! == pWeekday &&
                        element.lessonNumber! == i &&
                        element.subject != storage.read('changingLkSubject')));
              }
            }
          }

          displayTimetable.add(DisplayTimetableUnit(
              timeTableUnit: tempTimetableUnit,
              isChangingLK: isChangingLK,
              allTimetableUnits: allTimeTableUnits,
              vertretung: null));
        }

        tempDuration =
            parseDuration(allTimes[(i - 1)].time!) + Duration(minutes: 45);

        if (!isFree) {
          bool nextFree = false;
          if (allTimeTableUnits.indexWhere((element) =>
                  (element.dayNumber! == pWeekday &&
                      element.lessonNumber! > i)) !=
              -1) {
            j = i + 1;
            while (allTimeTableUnits.indexWhere((element) =>
                    element.dayNumber == pWeekday &&
                    element.lessonNumber == j) ==
                -1) {
              nextFree = true;
              j++;
            }
          }

          displayTimetable.add(TimeDivider(
              time: getTimeFromDuration(tempDuration),
              isNow: (((isInBreak == true &&
                          pLessonNumber == i &&
                          (allTimeTableUnits.indexWhere((element) =>
                                  (element.dayNumber! == pWeekday &&
                                      element.lessonNumber! > i)) !=
                              -1)) ||
                      (pLessonNumber != null &&
                          pLessonNumber > i &&
                          pLessonNumber < j &&
                          nextFree)))
                  ? true
                  : false,
              key: (((isInBreak == true &&
                          pLessonNumber == i &&
                          (allTimeTableUnits.indexWhere((element) =>
                                  (element.dayNumber! == pWeekday &&
                                      element.lessonNumber! > i)) !=
                              -1)) ||
                      (pLessonNumber != null && pLessonNumber > i && pLessonNumber < j && nextFree)))
                  ? globalKeyNow
                  : null));
        }

        i++;
      }
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
                              child: (finishedNow)
                                  ? Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                      ),
                                      alignment: Alignment.topCenter,
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          children: displayTimetable,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                      children: [
                                        CupertinoActivityIndicator(),
                                        Text('Laden ...'),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                    )),
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                            ),
                          ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            )),
            padding: EdgeInsets.only(top: 15)));
  }

  Container zeitraster() {
    return Container(
      child: (Platform.isIOS)
          ? ShowWebview(
              url: 'https://${Links.times}',
            )
          : Image.network('https://${Links.times}'),
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
        margin: EdgeInsets.only(left: 95, right: 15),
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
                  'Frei',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
      margin: EdgeInsets.symmetric(horizontal: 15),
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

class DisplayTimetableUnit extends StatefulWidget {
  final TimeTableUnit timeTableUnit;
  final VertretungsEinheit? vertretung;
  final bool isChangingLK;
  final List<TimeTableUnit> allTimetableUnits;

  DisplayTimetableUnit(
      {Key? key,
      required this.timeTableUnit,
      this.vertretung,
      required this.allTimetableUnits,
      required this.isChangingLK})
      : super(key: key);

  @override
  _DisplayTimetableUnitState createState() => _DisplayTimetableUnitState();
}

class _DisplayTimetableUnitState extends State<DisplayTimetableUnit> {
  late TimeTableUnit timeTableUnit;

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

  void changeLK(BuildContext context) async {
    String lk1 = '---';
    String lk2 = '---';
    int selectedLK = 0;
    var storage = GetStorage();
    try {
      lk1 = widget.allTimetableUnits
          .firstWhere((element) => element.subject!.contains('LK'))
          .subject!;
      lk2 = widget.allTimetableUnits
          .firstWhere((element) =>
              element.subject!.contains('LK') &&
              !element.subject!.contains(lk1))
          .subject!;

      if ((DateTime.now().weekOfYear.isEven &&
              storage.read('changingLkWeekNumber').isEven) ||
          (!DateTime.now().weekOfYear.isEven &&
              !storage.read('changingLkWeekNumber').isEven)) {
        if (storage.read('changingLkSubject') == lk2) {
          selectedLK = 1;
        }
      } else {
        if (storage.read('changingLkSubject') == lk1) {
          selectedLK = 1;
        }
      }
    } catch (e) {
      print(e);
    }

    await showCustomInformationDialog(
      context,
      'Wechselnder LK',
      'Diese Woche: ${(selectedLK == 0) ? lk1 : lk2}\nNächste Woche: ${(selectedLK == 1) ? lk1 : lk2}\n\nIm Bereich "Einstellungen" kannst du dies verändern.',
      true,
      false,
      true,
    );
  }

  @override
  void initState() {
    super.initState();
    timeTableUnit = widget.timeTableUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 95, right: 15),
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
                if (widget.vertretung != null)
                  Container(
                    child: Text(
                      widget.vertretung!.room!,
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
                      decoration: (widget.vertretung != null)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
                Icon(CupertinoIcons.location_solid),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          if (widget.vertretung != null &&
              widget.vertretung!.teacherNew != null &&
              widget.vertretung!.teacherOld != widget.vertretung!.teacherNew)
            Row(
              children: [
                Text(
                  widget.vertretung!.teacherNew!,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Text(
                    (widget.vertretung!.teacherOld != null)
                        ? widget.vertretung!.teacherOld!
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
          if (widget.vertretung != null)
            Container(
              child: Row(
                children: [
                  Container(
                    child: Text(
                      (widget.vertretung!.comment != null)
                          ? widget.vertretung!.type! + ':'
                          : widget.vertretung!.type!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 5),
                  ),
                  if (widget.vertretung!.comment != null)
                    Text(
                      widget.vertretung!.comment!,
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
          if (widget.isChangingLK)
            GestureDetector(
              onTap: () {
                changeLK(context);
              },
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'Wechselnder LK',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Icon(
                        CupertinoIcons.info_circle,
                        color: Colors.blue,
                        size: 23,
                      ),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                margin: EdgeInsets.only(top: 20),
              ),
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
      margin: EdgeInsets.symmetric(horizontal: 15),
      //key: passedKey,
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
