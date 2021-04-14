import 'package:annette_app/subjectsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/classes/task.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import 'package:annette_app/classes/timetableUnit.dart';
import 'package:annette_app/classes/lessonStartTime.dart';
import 'package:annette_app/database/lessonStartTimeDbInteraction.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/manageNotifications.dart';
import 'package:annette_app/currentValues.dart';

///Diese Klasse beinhaltet das Dialogfenster und alle notwendigen Funktionen zum hinzufügen einer neuen Hausaufgabe.
class AddDialog extends StatefulWidget {
  final Function(Task)? onTaskCreated;
  AddDialog({this.onTaskCreated});

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  CurrentValues getCV = new CurrentValues();
  bool finished = false;
  int? nextId;
  DateTime currentTime = DateTime.now();

  bool errorSubject = false;
  bool errorTime = false;
  bool errorNotes = false;

  bool autoTime = true;
  DateTime selectedTime = DateTime.now();

  String? selectedSubject;
  String? notes;
  String? detectedSubject;
  DateTime? detectedNotificationTime;
  DateTime? detectedDeadlineTime;

  late List<LessonStartTime> times;
  late List<TimeTableUnit> timetableUnits;
  List<String> subjectCodes = [];
  List<String> subjectNames = [];

  ///   Diese Methode fragt die Fächer, den Stundenplan sowie den zeitplan aus der Datenbank ab
  ///  und speichert diese Objekte in den entpsrechenden Listen.
  ///  Außerdem wird als Auswahlmöglichkeit für den Dropdownbutton eine Liste mit allen
  ///  Fächern zuzüglich der Option "Sonstiges" erstellt.
  ///  Zudem sorgt diese Methode dafür, dass mittels der Methode getAutoValues() (s.u.) die
  ///  automatischen Werte ermittelt werden.

  void getSubjectsAndTimes() async {
    ///Zuordnung: Abkürzung => Fachname
    List<String> classesAbbreviation = getSubjectsAbbreviation();
    List<String> classesFullName = getSubjectsFullName();
    timetableUnits = await databaseGetAllTimeTableUnit();

    subjectNames.add('Sonstiges');
    subjectCodes.add('-');

    for (int i = 0; i < timetableUnits.length; i++) {
      String tempSubjectAbbreviation = timetableUnits[i].subject!;

      if (!subjectCodes.contains(tempSubjectAbbreviation)) {
        subjectCodes.add(tempSubjectAbbreviation);
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
          classesAbbreviation.indexOf(tempSubjectAbbreviation);
      late String tempSubjectFullName;

      if (tempPositionInList != -1) {
        tempSubjectFullName = classesFullName[tempPositionInList];
      } else {
        tempSubjectFullName = tempSubjectAbbreviation;
      }

      if (tempSubjectFullName == 'Kath. Religion' ||
          tempSubjectFullName == 'Ev. Religion') {
        tempSubjectFullName = 'Religion';
      }

      if (!subjectNames.contains(tempSubjectFullName)) {
        subjectNames.add(tempSubjectFullName);
      }
    }

    times = await databaseGetAllTimes();

    await getAutoValues();
    print(detectedSubject);
    if (detectedSubject == null) {
      selectedSubject = 'Sonstiges';
    } else {
      selectedSubject = subjectNames[subjectCodes.indexOf(detectedSubject!)];
    }

    setState(() {
      finished = true;
    });
  }

  /**
   * Diese Methode sorgt dafür, dass die Werte aktuelles Fach, nächster Zeitpunkt laut Stundenplan und Zeitpunkt
   * der Benachrichtigung automatisch ermittelt werden.
   */
  Future<void> getAutoValues() async {
    if (currentTime.weekday > 5 ||
        currentTime.isBefore(getCV.getStartOfFirstLesson()) ||
        await getCV.getCurrentSubject() == null) {
      autoTime = false;
    } else {
      detectedSubject = await getCV.getCurrentSubject();
      detectedDeadlineTime = getCV
          .getNextLesson(subjectCodes[subjectCodes.indexOf(detectedSubject!)]);
      detectedNotificationTime = getNotificationTime(detectedDeadlineTime!);
    }
  }

  /**
   * Diese Methode berechnet anhand eines per Parameter übergebenen Zetpunkts
   * den für diesen Zeitpunkt entsprechen Zeitpunkt für eine System-Benachrichtigung
   * und gibt diesen ermittelten Zeitpunkt zurück.
   * (16 Uhr am Vortag)
   */
  DateTime getNotificationTime(DateTime pDateTime) {
    DateTime temp = pDateTime.subtract(new Duration(days: 1));
    temp = new DateTime(temp.year, temp.month, temp.day);
    temp = temp.add(new Duration(hours: 16));
    return temp;
  }

  ///Hilfsmethode zum Laden der Fächer und des Stundenplans.
  void load() async {
    Future.delayed(Duration(seconds: 0), () async {
      await getCV.initialize();
      getSubjectsAndTimes();
    });
  }

  /**
   * Diese Methode wird beim Klicken auf den "Hinzufügen"-Button ausgeführt.
   * Zunächst werden die vom Benutzer eingestellten Werte übernommen und auf Fhler überprüft.
   * Liegen keine Fehler vor, wird die neue Aufgabe in die Datenbank und in die Listenansicht eingefügt.
   * Außerdem wird eine System-Benachrichtigung geplant bzw. je nach Zeitpunkt direkt ausgegeben.
   */
  void addTask() async {
    errorNotes = false;
    String? subjectToInsert;
    String? notesToInsert = notes;
    DateTime? notificationTimeToInsert;
    DateTime? deadlineTimeToInsert;

    subjectToInsert = selectedSubject;

    if (autoTime) {
      notificationTimeToInsert = detectedNotificationTime;
      deadlineTimeToInsert = detectedDeadlineTime;
    } else {
      notificationTimeToInsert = selectedTime;
      deadlineTimeToInsert = notificationTimeToInsert;
    }

    if (subjectToInsert == null) {
      errorSubject = true;
    }

    if (deadlineTimeToInsert!
        .add(Duration(minutes: 1))
        .isBefore(DateTime.now())) {
      errorTime = true;
    }

    if (deadlineTimeToInsert.isBefore(notificationTimeToInsert!)) {
      errorTime = true;
    }

    if (subjectToInsert == 'Sonstiges' &&
        (notesToInsert == null || notesToInsert == '')) {
      errorNotes = true;
    }

    if (notesToInsert == '') {
      notesToInsert = null;
    }

    if (!errorSubject && !errorTime && !errorNotes) {
      Task newTask = new Task(
          id: nextId,
          subject: subjectToInsert,
          notes: notesToInsert,
          notificationTime: notificationTimeToInsert.toString(),
          deadlineTime: deadlineTimeToInsert.toString(),
          isChecked: 0);

      databaseInsertTask(newTask);

      if (notificationTimeToInsert.isAfter(DateTime.now())) {
        scheduleNotification(nextId!, subjectToInsert!, notesToInsert,
            deadlineTimeToInsert.toString(), notificationTimeToInsert);
      } else if (notificationTimeToInsert
          .isAfter(DateTime.now().subtract(Duration(minutes: 1)))) {
        showNotification(nextId!, subjectToInsert!, notesToInsert,
            deadlineTimeToInsert.toString());
      }

      Navigator.pop(context);
      widget.onTaskCreated!(newTask);
    } else {
      setState(() {
        //
      });
    }
  }

  /**
   * Diese Methode ermittelt die nächste Id, welche eine zukünftige Aufgabe erhalten muss.
   * Dies ist notwendig, damit es zu keinen Konflikten beim löschen der Aufgaben aus der AnimatedList und
   * beim stornieren der geplanten Benachrichtigungen gibt.
   */
  void getNextId() async {
    List<Task> list = await databaseGetAllTasks(5);

    if (list.length == 0) {
      nextId = 1;
    } else {
      nextId = list[list.length - 1].id! + 1;
    }
  }

  /**
   * beim Initialisieren werden mit der Methode load() die notwendigen Objekte aus der Datenbank geladen
   * sowie mit der Methode getNextId() die zukünftige Id der potentiellen neuen Hausaufgabe ermittelt.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    getNextId();
  }

  /**
   * Erstellen des Widget (Dialogfenster zum Hinzufügen einer neuen Hausaufgabe) mit:
   *  - Möglichkeit zur Wahl des Fachs (mittels Dropdownbutton)
   *  - Textfeld für Notizen
   *  - Möglichkeit zur Wahl, ob die zeit automatisch ermittelt werden soll
   *    (Dann je nach Auswahl DateTime-Picker zum manuellen Auswählen einer
   *    Zeit oder Anzeige der automatisch ermittelten Werte)
   *  - Button zum Hinzufügen einer neuen Aufagbe sowie zum Abbrechen
   *
   * Hinweis:
   *  - Sollte zu dem aktuellen Tag kein Fach im Stundenplan gefunden werden, wird
   *    standardmäßig die Option "Sonstiges" ausgewählt.
   *  - Sollte zu dem ausgewählten Fach kein Auftauchen im Stundenplan gefunden werden, entfällt die
   *    Option "Zeit automatisch wählen".
   */
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          //height: 565,
          constraints: BoxConstraints(maxWidth: 350, maxHeight: 565),
          padding: (MediaQuery.of(context).orientation == Orientation.landscape)
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 25)
              : EdgeInsets.all(10.0),
          child: (!finished)
              ? CupertinoActivityIndicator()
              : SingleChildScrollView(
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text('Neue Hausaufgabe',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      Divider(
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        //padding: EdgeInsets.all(10),
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Fach:',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400)),
                                Spacer(flex: 1),
                                DropdownButton<String>(
                                  items: subjectNames
                                      .map<DropdownMenuItem<String>>(
                                          (String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() async {
                                      selectedSubject = value;
                                      errorNotes = false;
                                      errorTime = false;

                                      if (selectedSubject != 'Sonstiges') {
                                        detectedDeadlineTime =
                                            getCV.getNextLesson(subjectCodes[
                                                subjectNames.indexOf(
                                                    selectedSubject!)]);
                                        if (detectedDeadlineTime == null) {
                                          autoTime = false;
                                        } else {
                                          autoTime = true;
                                          detectedNotificationTime =
                                              getNotificationTime(
                                                  detectedDeadlineTime!);
                                        }
                                      } else {
                                        autoTime = false;
                                      }
                                    });
                                  },
                                  value: selectedSubject,
                                  hint: Text('Fach'),
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                                Spacer(flex: 1),
                              ]),
                          TextField(
                            decoration: InputDecoration(
                                hintText: (selectedSubject == 'Sonstiges')
                                    ? 'Notizen (Erforderlich)'
                                    : 'Notizen (Optional)'),
                            onChanged: (text) {
                              setState(() {
                                if (selectedSubject == 'Sonstiges' &&
                                    text == '') {
                                  errorNotes = true;
                                } else {
                                  errorNotes = false;
                                }
                                notes = text;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: (errorNotes)
                                ? Text(
                                    'Bitte eine Notiz eintragen',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text(''),
                          ),
                          //Spacer(flex: 1),
                          SizedBox(
                              height: 270,
                              child: Column(
                                children: [
                                  if (selectedSubject != 'Sonstiges' &&
                                      detectedDeadlineTime != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Zeit automatisch wählen',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400)),
                                        CupertinoSwitch(
                                          value: autoTime,
                                          onChanged: (value) {
                                            setState(() {
                                              autoTime = value;

                                              if (autoTime) {
                                                errorTime = false;
                                              } else if (!autoTime &&
                                                  selectedTime.isBefore(
                                                      DateTime.now().subtract(
                                                          Duration(
                                                              minutes: 1)))) {
                                                errorTime = true;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  if (autoTime)
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .dividerColor)),
                                        child: Column(
                                          children: [
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          'Erinnerungszeitpunkt:',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      Text(
                                                          parseTimeToUserOutput(
                                                              detectedNotificationTime
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ])),
                                            Divider(),
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text('Zu erledigen bis:',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      Text(
                                                          parseTimeToUserOutput(
                                                              detectedDeadlineTime
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ])),
                                          ],
                                        )),
                                  if (!autoTime)
                                    Container(
                                        //padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .dividerColor)),
                                        child: Column(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                    'Wähle eine Erinnerungs-Zeit:',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                              SizedBox(
                                                  height: 150,
                                                  child: CupertinoDatePicker(
                                                    use24hFormat: true,
                                                    initialDateTime:
                                                        selectedTime,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .dateAndTime,
                                                    onDateTimeChanged: (value) {
                                                      selectedTime = value;
                                                      setState(() {
                                                        if (!selectedTime
                                                            .add(Duration(
                                                                minutes: 1))
                                                            .isBefore(DateTime
                                                                .now())) {
                                                          errorTime = false;
                                                        } else {
                                                          errorTime = true;
                                                        }
                                                      });
                                                    },
                                                  ))
                                            ])),
                                  //Spacer(flex: 2),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: (errorTime)
                                        ? Text(
                                            'Ungültige Zeit',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(''),
                                  ),
                                ],
                              )),
                        ],
                      ),

                      if (MediaQuery.of(context).size.height > 20000) Spacer(),
                      //Spacer(),
                      CupertinoButton(
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Theme.of(context)
                                      .floatingActionButtonTheme
                                      .backgroundColor
                                  : Theme.of(context).accentColor,
                          //color: Theme.of(context).accentColor,
                          child: Text(
                            'Hinzufügen',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .floatingActionButtonTheme
                                    .foregroundColor),
                          ),
                          onPressed: () {
                            addTask();
                          }),
                      CupertinoButton(
                          child: Text('Abbrechen',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .accentColor)), //color: Colors.black54)),
                          onPressed: () => Navigator.pop(context)),
                    ])),
        ));
  }
}
