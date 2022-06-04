import 'dart:ui';
import 'package:annette_app/data/subjects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/fundamentals/task.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:annette_app/fundamentals/lessonStartTime.dart';
import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:annette_app/miscellaneous-files/manageNotifications.dart';
import 'package:annette_app/miscellaneous-files/currentValues.dart';
import 'package:flutter/services.dart';
import '../data/lessonStartTimes.dart';

///Diese Klasse beinhaltet das Dialogfenster und alle notwendigen Funktionen zum hinzufügen einer neuen Hausaufgabe.
class AddDialog extends StatefulWidget {
  static int notesLines = 3;

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

    subjectNames.add('Sonstiges');
    subjectCodes.add('-');

    Map<String, dynamic> subjectResults =
        await getUserSubjects(subjectCodes, subjectNames);
    timetableUnits = subjectResults["timetableUnits"];
    subjectCodes = subjectResults["subjectCodes"];
    subjectNames = subjectResults["subjectNames"];

    await getAutoValues();

    if (detectedSubject == null) {
      selectedSubject = 'Sonstiges';
    } else {
      // TODO: hier könnte ein Fehler auftauchen: Wenn der Nutzer einfach random Fächer in der Konfiguration
      // TODO: eingibt, dann kann es dazu kommen, dass ein Error auftaucht
      selectedSubject = subjectNames[subjectCodes.indexOf(detectedSubject!)];
    }

    times = getAllTimes();

    setState(() {
      finished = true;
    });
  }

  /// Diese Methode sorgt dafür, dass die Werte aktuelles Fach, nächster Zeitpunkt laut Stundenplan und Zeitpunkt
  /// der Benachrichtigung automatisch ermittelt werden.
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

  /// Diese Methode berechnet anhand eines per Parameter übergebenen Zetpunkts
  /// den für diesen Zeitpunkt entsprechen Zeitpunkt für eine System-Benachrichtigung
  /// und gibt diesen ermittelten Zeitpunkt zurück.
  /// (16 Uhr am Vortag)
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

  /// Diese Methode wird beim Klicken auf den "Hinzufügen"-Button ausgeführt.
  /// Zunächst werden die vom Benutzer eingestellten Werte übernommen und auf Fhler überprüft.
  /// Liegen keine Fehler vor, wird die neue Aufgabe in die Datenbank und in die Listenansicht eingefügt.
  /// Außerdem wird eine System-Benachrichtigung geplant bzw. je nach Zeitpunkt direkt ausgegeben.
  void addTask() async {
    errorNotes = false;
    String? subjectToInsert;
    String? notesToInsert = notes;
    print(notesToInsert);
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

  /// Diese Methode ermittelt die nächste Id, welche eine zukünftige Aufgabe erhalten muss.
  /// Dies ist notwendig, damit es zu keinen Konflikten beim löschen der Aufgaben aus der AnimatedList und
  /// beim stornieren der geplanten Benachrichtigungen gibt.
  void getNextId() async {
    List<Task> list = await databaseGetAllTasks(5, true);

    if (list.length == 0) {
      nextId = 1;
    } else {
      nextId = list[list.length - 1].id! + 1;
    }
  }

  /// beim Initialisieren werden mit der Methode load() die notwendigen Objekte aus der Datenbank geladen
  /// sowie mit der Methode getNextId() die zukünftige Id der potentiellen neuen Hausaufgabe ermittelt.
  @override
  void initState() {
    super.initState();
    helperOrientation();
    load();
    getNextId();
  }

  void helperOrientation() {
    if (MediaQueryData.fromWindow(window).size.shortestSide < 640) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  /// Erstellen des Widget (Dialogfenster zum Hinzufügen einer neuen Hausaufgabe) mit:
  ///  - Möglichkeit zur Wahl des Fachs (mittels Dropdownbutton)
  ///  - Textfeld für Notizen
  ///  - Möglichkeit zur Wahl, ob die zeit automatisch ermittelt werden soll
  ///    (Dann je nach Auswahl DateTime-Picker zum manuellen Auswählen einer
  ///    Zeit oder Anzeige der automatisch ermittelten Werte)
  ///  - Button zum Hinzufügen einer neuen Aufagbe sowie zum Abbrechen
  ///
  /// Hinweis:
  ///  - Sollte zu dem aktuellen Tag kein Fach im Stundenplan gefunden werden, wird
  ///    standardmäßig die Option "Sonstiges" ausgewählt.
  ///  - Sollte zu dem ausgewählten Fach kein Auftauchen im Stundenplan gefunden werden, entfällt die
  ///    Option "Zeit automatisch wählen".
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: (!finished)
          ? CupertinoActivityIndicator()
          : Column(
              children: <Widget>[
                Text('Neue Hausaufgabe',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                Divider(
                  thickness: 1,
                  endIndent: 0,
                  height: 40,
                  color: Colors.grey,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.grey
                                  : Theme.of(context).dividerColor,
                        ),
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Color.fromRGBO(50, 50, 50, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        iconSize: 35,
                        isExpanded: true,
                        underline: Container(),
                        items: subjectNames
                            .map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value;
                            errorNotes = false;
                            errorTime = false;

                            if (selectedSubject != 'Sonstiges') {
                              detectedDeadlineTime = getCV.getNextLesson(
                                  subjectCodes[
                                      subjectNames.indexOf(selectedSubject!)]);
                              if (detectedDeadlineTime == null) {
                                autoTime = false;
                              } else {
                                autoTime = true;
                                detectedNotificationTime =
                                    getNotificationTime(detectedDeadlineTime!);
                              }
                            } else {
                              autoTime = false;
                            }
                          });
                        },
                        value: selectedSubject,
                        hint: Text('Fach'),
                        icon: Icon(Icons.arrow_drop_down_outlined),
                      ),
                    ),
                    CupertinoTextField(
                      autofocus: false,
                      placeholder: (selectedSubject == 'Sonstiges')
                          ? 'Notizen (Erforderlich)'
                          : 'Notizen (Optional)',
                      placeholderStyle: TextStyle(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Colors.white70
                            : Colors.grey,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: (errorNotes)
                              ? Colors.red
                              : (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.grey
                                  : Theme.of(context).dividerColor,
                        ),
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Color.fromRGBO(50, 50, 50, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clearButtonMode: OverlayVisibilityMode.editing,
                      maxLines: AddDialog.notesLines,
                      enableInteractiveSelection: true,
                      onChanged: (text) {
                        setState(() {
                          if (selectedSubject == 'Sonstiges' && text == '') {
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
                      /* child: (errorNotes)
                        ? Text(
                            'Bitte eine Notiz eintragen',
                            style: TextStyle(color: Colors.red),
                          )
                        : null,

                    */
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Color.fromRGBO(50, 50, 50, 1)
                                  : Colors.white,
                          border: Border.all(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.grey
                                  : Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
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
                                            selectedTime.isBefore(DateTime.now()
                                                .subtract(
                                                    Duration(minutes: 1)))) {
                                          errorTime = true;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            if (selectedSubject != 'Sonstiges' &&
                                detectedDeadlineTime != null)
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            if (autoTime)
                              Column(
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Erinnerung:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                parseTimeToUserOutput(
                                                    detectedNotificationTime
                                                        .toString()),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ])),
                                  Divider(),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Zu erledigen bis:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(
                                                parseTimeToUserOutput(
                                                    detectedDeadlineTime
                                                        .toString()),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ])),
                                ],
                              ),
                            if (!autoTime)
                              Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text('Wähle eine Erinnerungs-Zeit:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: CupertinoDatePicker(
                                      use24hFormat: true,
                                      initialDateTime: selectedTime,
                                      mode: CupertinoDatePickerMode.dateAndTime,
                                      onDateTimeChanged: (value) {
                                        selectedTime = value;
                                        setState(() {
                                          if (!selectedTime
                                              .add(Duration(minutes: 1))
                                              .isBefore(DateTime.now())) {
                                            errorTime = false;
                                          } else {
                                            errorTime = true;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: (errorTime)
                                        ? Text(
                                            'Ungültige Zeit',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(''),
                                  ),
                                ],
                              ),
                          ],
                        )),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
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
                          child: Text(
                            'Abbrechen',
                            style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.white70
                                  : Colors.black54,
                              //color: Theme.of(context).accentColor
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
