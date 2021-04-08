import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/subject.dart';
import 'package:annette_app/subjectDbInteraction.dart';
import 'subjectsAtDayDbInteraction.dart';
import 'subjectsAtDay.dart';

/**
 * Diese Klasse beinhaltet die notwendigen Optionen und Methoden zum
 * Einstellen des Stundenplans für einen bestimmten Wochentag, welcher per parameter übergeben muss.
 */
class SetSubjects extends StatefulWidget {
  ///Der Wochentag, dessen Stundenplan eingestellt werden soll, muss per Parameter übergeben werden.
  final String day;
  SetSubjects(@required this.day);

  @override
  _SetSubjectsState createState() => _SetSubjectsState();
}

class _SetSubjectsState extends State<SetSubjects> {
  late SubjectsAtDay currentDay;
  String? currentDayName;
  bool finished = false;
  late List<SubjectsAtDay> allDays;
  late List<Subject> subjects;

  String? dropDownLesson1;
  String? dropDownLesson2;
  String? dropDownLesson3;
  String? dropDownLesson4;
  String? dropDownLesson5;
  String? dropDownLesson6;
  String? dropDownLesson7;
  String? dropDownLesson8;
  String? dropDownLesson9;
  String? dropDownLesson10;
  String? dropDownLesson11;

  List<String?> subjectsString = [];

  ///Hilfsmethode zum Koordinieren des Ladevorgangs
  void load() async {
    Future.delayed(Duration(seconds: 0), () {
      getCurrentDay();
      getSubjects();
    });
  }

  /**
   * Diese Methode fragt alle Fächer aus der Datenbank ab
   * und erstellt daraus eine Liste an Strings, die alle Fächer enthält
   * und als Auswahlmöglichkeit der "Dropdownbuttons" dient.
   * Diese Methode stellt außerdem die Voreinstellung der "Dropdownbuttons" auf den aktuellen Stundenplan ein.
   */
  void getSubjects() async {
    subjectsString.add('Freistunde');
    subjects = await databaseGetAllSubjects();
    for (int i = 0; i < subjects.length; i++) {
      subjectsString.add(subjects[i].name); //[i] = subjects[i].name;
    }

    dropDownLesson1 = currentDay.lesson1;
    dropDownLesson2 = currentDay.lesson2;
    dropDownLesson3 = currentDay.lesson3;
    dropDownLesson4 = currentDay.lesson4;
    dropDownLesson5 = currentDay.lesson5;
    dropDownLesson6 = currentDay.lesson6;
    dropDownLesson7 = currentDay.lesson7;
    dropDownLesson8 = currentDay.lesson8;
    dropDownLesson9 = currentDay.lesson9;
    dropDownLesson10 = currentDay.lesson10;
    dropDownLesson11 = currentDay.lesson11;

    setState(() {
      finished = true;
    });
  }

  /**
   * Diese Methoden fragt den Stundenplan/die Fächer des ausgewählten Wochentages aus der Datenbank ab
   * und speichert diese in der Variable "currentDay".
   */
  void getCurrentDay() async {
    allDays = await databaseGetAllDays();

    if (currentDayName == 'Montag') {
      currentDay = allDays[0];
    } else if (currentDayName == 'Dienstag') {
      currentDay = allDays[1];
    } else if (currentDayName == 'Mittwoch') {
      currentDay = allDays[2];
    } else if (currentDayName == 'Donnerstag') {
      currentDay = allDays[3];
    } else {
      currentDay = allDays[4];
    }

    setState(() {
      finished = true;
    });
  }

  /**
   * Diese Methoden aktualisiert den Stundenplan des aktuellen Tages.
   * Die neuen Fächer sind die, die über die "Dropdownbuttons" ausgewählt wurden.
   */
  void updateDay() async {
    databaseUpdateDay(new SubjectsAtDay(
      id: currentDay.id,
      dayName: currentDay.dayName,
      lesson1: dropDownLesson1,
      lesson2: dropDownLesson2,
      lesson3: dropDownLesson3,
      lesson4: dropDownLesson4,
      lesson5: dropDownLesson5,
      lesson6: dropDownLesson6,
      lesson7: dropDownLesson7,
      lesson8: dropDownLesson8,
      lesson9: dropDownLesson9,
      lesson10: dropDownLesson10,
      lesson11: dropDownLesson11,
    ));
  }

  /**
   * Beim Erstellen/Initialisieren des Widgets wird die Methode load() aufgerufen,
   * welche die "Dropdownbuttons" mit den entsprechenden Fächern aus der Datenbank vor einstellt.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDayName = widget.day;
    load();
  }

  /**
   * Beim Schließen/Verwerfen des Widgets mit den Auswahlmöglichkeiten wird die Methode updateDay() aufgerufen,
   * welche den (neu) eingestellten Stundenplan in der Datenbank aktualisiert.
   */
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updateDay();
  }

  /**
   * Erstellen des Widgets mit einem "Dropdownbutton" für das Fach einer jeden Schulstunde.
   */
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Container(
          padding: EdgeInsets.all(10.0),
          child: (finished)
              ? ListView.builder(
                  itemCount: 11,
                  itemBuilder: (context, i) {
                    int j = i + 1;
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('$j. Stunde:', style: TextStyle(fontSize: 17.0),),
                          DropdownButton<String>(
                            items: subjectsString
                                .map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (j == 1) {
                                  dropDownLesson1 = newValue;
                                } else if (j == 2) {
                                  dropDownLesson2 = newValue;
                                } else if (j == 3) {
                                  dropDownLesson3 = newValue;
                                } else if (j == 4) {
                                  dropDownLesson4 = newValue;
                                } else if (j == 5) {
                                  dropDownLesson5 = newValue;
                                } else if (j == 6) {
                                  dropDownLesson6 = newValue;
                                } else if (j == 7) {
                                  dropDownLesson7 = newValue;
                                } else if (j == 8) {
                                  dropDownLesson8 = newValue;
                                } else if (j == 9) {
                                  dropDownLesson9 = newValue;
                                } else if (j == 10) {
                                  dropDownLesson10 = newValue;
                                } else {
                                  dropDownLesson11 = newValue;
                                }
                              });
                            },
                            value: (j == 1)
                                ? dropDownLesson1
                                : (j == 2)
                                    ? dropDownLesson2
                                    : (j == 3)
                                        ? dropDownLesson3
                                        : (j == 4)
                                            ? dropDownLesson4
                                            : (j == 5)
                                                ? dropDownLesson5
                                                : (j == 6)
                                                    ? dropDownLesson6
                                                    : (j == 7)
                                                        ? dropDownLesson7
                                                        : (j == 8)
                                                            ? dropDownLesson8
                                                            : (j == 9)
                                                                ? dropDownLesson9
                                                                : (j == 10)
                                                                    ? dropDownLesson10
                                                                    : dropDownLesson11,
                            hint: Text('Fach'),
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ]);
                  })
              : CupertinoActivityIndicator(),
        ));
  }
}