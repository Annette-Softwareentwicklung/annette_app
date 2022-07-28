import 'package:annette_app/data/design.dart';
import 'package:annette_app/data/subjects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import '../miscellaneous-files/manageNotifications.dart';
import 'package:annette_app/fundamentals/task.dart';
import '../miscellaneous-files/parseTime.dart';
import 'addDialog.dart';

/// Diese Datei beinhaltet die Detailansicht einer Hausaufgabe,
/// bei der alle Informationen bezüglich der Aufgabe angezeigt werden können.
class DetailedView extends StatefulWidget {
  final Task? task;
  final Function(int?)? onReload;
  final Function(int?)? onRemove;
  final bool? isParallelDetail;

  DetailedView(
      {Key? key,
      this.task,
      this.onReload,
      this.onRemove,
      this.isParallelDetail})
      : super(key: key);

  @override
  DetailedViewState createState() => DetailedViewState();
}

class DetailedViewState extends State<DetailedView> {

  Task? task;
  String? updateNotes;
  DateTime? updateNotificationTime;
  DateTime? updateDeadlineTime;
  late bool errorNotificationTime;
  late bool errorDeadlineTime;
  late bool errorNotes;
  bool? checked = false;

  // attribtues concerning subject changing
  List<String> subjectNames = [];
  String selectedSubject = "none";


  final TextEditingController _textEditingController = TextEditingController();

  static double timePickerHeight = 150;
  static double timePickerWidth = 280;
  static BoxDecoration timePickerBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
          width: 1
      )
  );



  void initSubjects() async {
    Map<String, dynamic> subjectResult = await getUserSubjects([], []);
    this.subjectNames = subjectResult["subjectNames"];
  }

  void editDialog(String title, StatefulBuilder childWidgets, Function confirmFunction) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Builder(builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 450,
                    ),
                    padding: EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          IntrinsicHeight(
                            child: childWidgets
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    size: 30,
                                  )),
                              IconButton(
                                  onPressed: confirmFunction(),
                                  icon: Icon(
                                    Icons.check_rounded,
                                    size: 30,
                                  )),
                            ],
                          )
                        ],
                      ),
                    )));
          });
        });
  }

  /// use this function to update any changes in tasks
  confirmTaskChange(bool error, Task newTask) async {

    if (!error) {
      databaseUpdateTask(newTask);

      setState(() {
        task = newTask;
      });

      widget.onReload!(task!.id);
      Navigator.pop(context);

      if (DateTime.parse(task!.notificationTime!).isAfter(DateTime.now())) {

        cancelNotification(task!.id);
        await Future.delayed(Duration(seconds: 1), () {});



        scheduleNotification(
            newTask.id!,
            newTask.subject!,
            newTask.notes,
            newTask.deadlineTime.toString(),
            DateTime.parse(newTask.notificationTime!));
      }
    }

  }

  confirmDeadlineTime() async {

    confirmTaskChange(
        errorDeadlineTime,
        new Task(
            id: task!.id,
            subject: task!.subject,
            isChecked: task!.isChecked,
            deadlineTime:
            updateDeadlineTime.toString(),
            notificationTime:
            task!.notificationTime,
            notes: task!.notes
        )
    );

  }

  void editDeadlineTime() {

    editDialog(
      "Zu erledigen bis",
      StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Container(
              decoration: timePickerBorder,
              child: SizedBox(
                height: timePickerHeight,
                width: timePickerWidth,
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  initialDateTime: updateDeadlineTime,
                  mode: CupertinoDatePickerMode
                      .dateAndTime,
                  onDateTimeChanged: (value) {
                    updateDeadlineTime = value;
                  },
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: (errorDeadlineTime) ?
                  Text('Fehler: Frist vor Erinnerung', style: TextStyle(color: Colors.red)) : Text(''),
            )
          ]
        );
      }),
      () => confirmDeadlineTime
    );
  }

  confirmNotificationTime() {

    confirmTaskChange(
        errorNotificationTime,
        new Task(
            id: task!.id,
            subject: task!.subject,
            isChecked: task!.isChecked,
            deadlineTime: task!.deadlineTime,
            notificationTime: updateNotificationTime.toString(),
            notes: task!.notes
        )
    );

  }

  void editNotificationTime() {

    editDialog(
        "Erinnerungs-Zeit",
        StatefulBuilder(builder: (context, setState) {
          return Column(
              children: [
                Container(
                  decoration: timePickerBorder,
                  child: SizedBox(
                      height: timePickerHeight,
                      width: timePickerWidth,
                      child: CupertinoDatePicker(
                        use24hFormat: true,
                        initialDateTime: updateNotificationTime,
                        mode:
                        CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (value) {
                          updateNotificationTime = value;
                          setState(() {
                            if (updateNotificationTime!
                                .add(Duration(minutes: 1))
                                .isBefore(DateTime.now())) {
                              errorNotificationTime = true;
                            } else {
                              errorNotificationTime = false;
                            }
                          });
                        },
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: (errorNotificationTime) ?
                    Text('Ungültige Zeit', style: TextStyle(color: Colors.red),) : Text('')
                )
              ]
          );
        }),
        () => confirmNotificationTime
    );

  }

  void confirmNotes() async {

    if (!errorNotes && updateNotes == "") {
      updateNotes = null;
    }

    confirmTaskChange(
      errorNotes,
      new Task(
          id: task!.id,
          subject: task!.subject,
          isChecked: task!.isChecked,
          deadlineTime: task!.deadlineTime,
          notificationTime: task!.notificationTime,
          notes: updateNotes
      )
    );

  }

  void onNotesChanged(String text, Function setError) {
    updateNotes = text;
    _textEditingController.text = updateNotes!;
    _textEditingController.selection =
        TextSelection.fromPosition(TextPosition(
            offset: _textEditingController
                .text.length));
    setState(() {});

    if (updateNotes == '' || updateNotes == null) {
      updateNotes = null;
    }
    if (updateNotes == null &&
        task!.subject == 'Sonstiges') {
      setError(() {
        errorNotes = true;
      });
    } else {
      setError(() {
        errorNotes = false;
      });
    }
  }


  void editNotes() {

    editDialog(
      "Notizen",
      StatefulBuilder(builder: (context, setError) {
        return Column(children: [
          TextField(
            minLines: 1,
            maxLines: AddDialog.notesLines,
            dragStartBehavior: DragStartBehavior.down,
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Notizen'),
            onChanged: (text) => onNotesChanged(text, setError),
          ),
          (errorNotes)
              ? Text(
            'Notiz erforderlich',
            style: TextStyle(color: Colors.red),
          )
              : Text(''),
        ]);
      }),
        () => confirmNotes
    );

  }

  /// Diese Methode dient dazu, im Querformat eine andere Aufgabe in der Detailansicht anzuzeigen
  /// und die Detailansicht so zu aktualisieren.
  update(Task? pTask) {
    setState(() {
      task = pTask;
      if (task != null) {
        updateNotes = task!.notes;
        updateNotificationTime = DateTime.parse(task!.notificationTime!);
        if (task!.isChecked == 1) {
          checked = true;
        } else {
          checked = false;
        }
      }
    });
  }

  void remove() async {
    Future.delayed(Duration(seconds: 2), () {
      if (checked == true) {
        databaseDeleteTask(task!.id);
        cancelNotification(task!.id);
        widget.onRemove!(task!.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initSubjects();

    task = widget.task;
    if (task != null) {
      updateNotes = task!.notes;
      updateNotificationTime = DateTime.parse(task!.notificationTime!);
      if (task!.isChecked == 1) {
        checked = true;
      } else {
        checked = false;
      }
    }

  }

  /// Rückgabe eines Containers mit der gesamten Detailansicht.
  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Center(child: Text('Keine Aufgabe ausgewählt.'));
    } else {
      return ListView(children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.white
                    : Colors.grey[800],
                border: Border.all(color: Colors.black45, width: 1.0),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Design.standardPagePadding),
            margin: EdgeInsets.all(Design.standardPagePadding),
            child: Center(
                child: Column(
                children: <Widget>[
                  subjectWidget(task!.subject!),
                  if (task!.notes != null) notesWidget(task!.notes!, context),
                    deadlinetimeWidget(task!.deadlineTime!, context),
                    notificationtimeWidget(task!.notificationTime!, context),
                    quickNotifications(),
                ],
            ))),
        Center(
          child: Flex(
            direction:
                (MediaQuery.of(context).orientation == Orientation.landscape &&
                        widget.isParallelDetail == true)
                    ? ((MediaQuery.of(context).size.width / 2) < 407)
                        ? Axis.vertical
                        : Axis.horizontal
                    : (MediaQuery.of(context).size.width < 350)
                        ? Axis.vertical
                        : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: ,
            children: [
              if (task!.notes == null)
                Container(
                    width: 170,
                    decoration: BoxDecoration(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.white
                                : Colors.grey[800],
                        border: Border.all(color: Colors.black45, width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          errorNotes = false;
                          editNotes();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CupertinoIcons.add,
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Design.annetteColor
                                : Theme.of(context).colorScheme.secondary,
                            size: 28,
                          ),
                          Text(
                            'Notizen',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    )),
              Container(
                  width: 170,
                  decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.white
                          : Colors.grey[800],
                      border: Border.all(color: Colors.black45, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        checked = !checked!;
                        remove();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        checked!
                            ? Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: Colors.green,
                                size: 28,
                              )
                            : Icon(
                                CupertinoIcons.circle,
                                size: 28,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        checked!
                            ? Text(
                                'Erledigt',
                                style: TextStyle(fontSize: 17),
                              )
                            : Text('Erledigen', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ]);
    }
  }

  void remindMeLater(String time) {
    DateTime tempTime;

    if (time == 'afternoon') {
      tempTime = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 16);
    } else if (time == 'evening') {
      tempTime = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 20);
    } else if (time == 'tomorrowMorning') {
      tempTime = new DateTime(DateTime.now().year, DateTime.now().month,
          (DateTime.now().day + 1), 9);
    } else {
      tempTime = DateTime.now().add(Duration(hours: 1));
    }

    task!.notificationTime = tempTime.toString();
    cancelNotification(task!.id!);
    scheduleNotification(
        task!.id!, task!.subject!, task!.notes, task!.deadlineTime!, tempTime);
    databaseUpdateTask(task!);
    setState(() {});
  }

  Widget quickNotifications() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              remindMeLater('oneHour');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.timer,
                    color: Colors.orange,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'In 1 Stunde erinnern',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              remindMeLater((DateTime.now().hour < 16)
                  ? 'afternoon'
                  : (DateTime.now().hour < 20)
                      ? 'evening'
                      : 'tomorrowMorning');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.timer,
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.blueGrey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      (DateTime.now().hour < 16)
                          ? 'Am Nachmittag erinnern'
                          : (DateTime.now().hour < 20)
                              ? 'Am Abend erinnern'
                              : 'Am Morgen erinnern',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailedViewEditableTile(String title, List<Widget> furtherWidgets, Function editFunction, [bool editable=true]) {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0, top: 20),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 17)),
                  ...furtherWidgets
                ],
              ),
            ),
            if (editable)
              IconButton(
                icon: Icon(Icons.edit_rounded,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: editFunction(),
              )
          ],
        ));
  }

  Widget deadlinetimeWidget(String pTime, BuildContext context) {

    return detailedViewEditableTile(
        'Zu erledigen bis:',
        [
          Text(
            parseTimeToUserOutput(pTime),
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: (!DateTime.parse(pTime).isAfter(DateTime.now()))
                    ? Colors.red
                    : null),
          )
        ],
        () => () {
            errorDeadlineTime = false;
            updateDeadlineTime = DateTime.parse(task!.deadlineTime!);
            editDeadlineTime();
        }
    );
  }

  Widget notesWidget(String pNotes, BuildContext context) {

    return detailedViewEditableTile(
        'Notizen:',
        [
          SelectableText(
            pNotes,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
        () => () {
          errorNotes = false;
          _textEditingController.text = task!.notes!;
          _textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textEditingController.text.length));


          editNotes();
        }
    );

  }

  Widget notificationtimeWidget(String pTime, BuildContext context) {

    return detailedViewEditableTile(
        'Zeitpunkt der Erinnerung:',
        [
          Text(parseTimeToUserOutput(pTime),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
          ))
        ],
        () => () {
          errorNotificationTime = false;
          updateNotificationTime = DateTime.parse(task!.notificationTime!);
          editNotificationTime();
        }
    );

  }



  confirmSubject() {

    confirmTaskChange(
        false,
        new Task(
            id: task!.id,
            subject: selectedSubject,
            isChecked: task!.isChecked,
            deadlineTime: task!.deadlineTime.toString(),
            notificationTime: task!.notificationTime,
            notes: task!.notes
        )
    );

  }

  /// Dieses Widget gibt einen Container zurück, welche in die Detailanscht eingebunden wird.
  /// Dieses Widget beinhaltet das Fach der Hausaufgabe.
  Widget subjectWidget(String pSubject) {

    return detailedViewEditableTile(
        "Fach",
        [
          Text(pSubject,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ))
        ],
        () => () {

          selectedSubject = task!.subject!;

          editDialog(
              "Fach",
              StatefulBuilder(builder: (context, setState) {
                return DropdownButton(
                  iconSize: 35,
                  isExpanded: true,
                  //underline: Container(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedSubject = value!;
                    });
                  },
                  value: selectedSubject,
                  hint: Text('Fach'),
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  items: this.subjectNames.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                );
              }),
              () => confirmSubject
          );

        },
        task!.subject! != "Sonstiges" // editieren soll nicht erlaubt werden wenn Sonstiges ausgewählt wurde
    );

  }
}