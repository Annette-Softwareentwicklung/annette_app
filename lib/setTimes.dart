import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'lessonStartTime.dart';
import 'lessonStartTimeDbInteraction.dart';
import 'parseTime.dart';

/**
 * Diese Klasse beinhaltet die notwendigen Optionen und Methoden zum Ändern des Zeitplans.
 */
class SetTimes extends StatefulWidget {
  @override
  _SetTimesState createState() => _SetTimesState();
}

class _SetTimesState extends State<SetTimes> {
  late List<LessonStartTime> times;
  bool finished = false;

  late Duration timeLesson1;
  late Duration timeLesson2;
  late Duration timeLesson3;
  late Duration timeLesson4;
  late Duration timeLesson5;
  late Duration timeLesson6;
  late Duration timeLesson7;
  late Duration timeLesson8;
  late Duration timeLesson9;
  late Duration timeLesson10;
  late Duration timeLesson11;

  /**
   * Diese Methoden fragt die Anfangszeiten aller Schulstunden aus der Datenbank ab
   * und speichert diese in den entsprechenden Variablen.
   */
  void getTimes() async {
    times = await databaseGetAllTimes();

    timeLesson1 = parseDuration(times[0].time!);
    timeLesson2 = parseDuration(times[1].time!);
    timeLesson3 = parseDuration(times[2].time!);
    timeLesson4 = parseDuration(times[3].time!);
    timeLesson5 = parseDuration(times[4].time!);
    timeLesson6 = parseDuration(times[5].time!);
    timeLesson7 = parseDuration(times[6].time!);
    timeLesson8 = parseDuration(times[7].time!);
    timeLesson9 = parseDuration(times[8].time!);
    timeLesson10 = parseDuration(times[9].time!);
    timeLesson11 = parseDuration(times[10].time!);

    setState(() {
      finished = true;
    });
  }

  //Hilfsmethode
  void load() async {
    Future.delayed(Duration(seconds: 0), () {
      getTimes();
    });
  }

  /**
   * Diese Methoden aktualisiert die Anfangszeiten der Schulstunden.
   * Die neuen Zeitpunkte sind die, die über die "Duration-Picker" ausgewählt wurden.
   */
  void updateTimes() async {
    databaseUpdateTime(
        new LessonStartTime(id: 1, time: timeLesson1.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 2, time: timeLesson2.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 3, time: timeLesson3.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 4, time: timeLesson4.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 5, time: timeLesson5.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 6, time: timeLesson6.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 7, time: timeLesson7.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 8, time: timeLesson8.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 9, time: timeLesson9.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 10, time: timeLesson10.toString()));
    databaseUpdateTime(
        new LessonStartTime(id: 11, time: timeLesson11.toString()));
  }

  /**
   * Beim Erstellen/Initialisieren des Widgets wird die Methode load() aufgerufen,
   * welche die "Duration-Picker" mit den entsprechenden Zeiten aus der Datenbank vor einstellt.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  /**
   * Beim Schließen/Verwerfen des Widgets mit den Auswahlmöglichkeiten wird die Methode updateTimes() aufgerufen,
   * welche die neu eingestellten Zeiten in der Datenbank aktualisiert.
   */
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updateTimes();
  }

  /**
   * Erstellen des Widgets mit einem "Duration-Picker" für die Anfangszeit einer jeden Schulstunde.
   */
  @override
  Widget build(BuildContext context) {
    return Center(
      child: (finished)
          ? Container(
              child: ListView.builder(
                  itemCount: 11,
                  itemBuilder: (context, i) {
                    int j = i + 1;

                    return SafeArea(
                        child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                child: Column(children: <Widget>[
                                  Text(
                                    'Beginn $j. Schulstunde:',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height: 130,
                                      child: /*Container(
                                          width: 350,
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:*/ CupertinoTimerPicker(
                                              mode: CupertinoTimerPickerMode.hm,
                                              initialTimerDuration: (j == 1)
                                                  ? timeLesson1
                                                  : (j == 2)
                                                      ? timeLesson2
                                                      : (j == 3)
                                                          ? timeLesson3
                                                          : (j == 4)
                                                              ? timeLesson4
                                                              : (j == 5)
                                                                  ? timeLesson5
                                                                  : (j == 6)
                                                                      ? timeLesson6
                                                                      : (j == 7)
                                                                          ? timeLesson7
                                                                          : (j == 8)
                                                                              ? timeLesson8
                                                                              : (j == 9)
                                                                                  ? timeLesson9
                                                                                  : (j == 10)
                                                                                      ? timeLesson10
                                                                                      : timeLesson11,
                                              onTimerDurationChanged: (newTime) {
                                                if (j == 1) {
                                                  timeLesson1 = newTime;
                                                } else if (j == 2) {
                                                  timeLesson2 = newTime;
                                                } else if (j == 3) {
                                                  timeLesson3 = newTime;
                                                } else if (j == 4) {
                                                  timeLesson4 = newTime;
                                                } else if (j == 5) {
                                                  timeLesson5 = newTime;
                                                } else if (j == 6) {
                                                  timeLesson6 = newTime;
                                                } else if (j == 7) {
                                                  timeLesson7 = newTime;
                                                } else if (j == 8) {
                                                  timeLesson8 = newTime;
                                                } else if (j == 9) {
                                                  timeLesson9 = newTime;
                                                } else if (j == 10) {
                                                  timeLesson10 = newTime;
                                                } else {
                                                  timeLesson11 = newTime;
                                                }
                                              })),
                                ]))));
                  }))
          : CupertinoActivityIndicator(),
    );
  }
}
