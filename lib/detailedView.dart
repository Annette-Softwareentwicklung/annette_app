import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
/**
 * Diese Datei beinhaltet die Detailansicht einer Hausaufgabe,
 * bei der alle Informationen bezüglich der Aufgabe angezeigt werden können.
 */
import 'package:flutter/material.dart';
import 'package:annette_app/taskDbInteraction.dart';
import 'manageNotifications.dart';
import 'task.dart';
import 'parseTime.dart';

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

  final TextEditingController _textEdetingController = TextEditingController();

  void editDeadlineTime() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setError) {
            return AlertDialog(
              title: Text('Zu erledigen bis:'),
              content: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).accentColor)),
                          child: SizedBox(
                              height: 150,
                              width: 280,
                              child: CupertinoDatePicker(
                                use24hFormat: true,
                                initialDateTime: updateDeadlineTime,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                onDateTimeChanged: (value) {
                                  updateDeadlineTime = value;
                                  /*setError(() {
                                    if (updateDeadlineTime!.isBefore(
                                        DateTime.parse(
                                            task!.notificationTime!))) {
                                      errorDeadlineTime = true;
                                    } else {
                                      errorDeadlineTime = false;
                                    }
                                  });*/
                                },
                              ))),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: (errorDeadlineTime)
                            ? Text(
                                'Fehler: Frist vor Erinnerung',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(''),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (!errorDeadlineTime) {
                      Task newTask = new Task(
                          id: task!.id,
                          subject: task!.subject,
                          isChecked: task!.isChecked,
                          deadlineTime: updateDeadlineTime.toString(),
                          notificationTime: task!.notificationTime,
                          notes: task!.notes);
                      databaseUpdateTask(newTask);


                      setState(() {
                        task = newTask;
                      });
                      widget.onReload!(task!.id);
                      Navigator.pop(context);
                      if (DateTime.parse(task!.notificationTime!)
                          .isAfter(DateTime.now())) {

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
                  },
                  child: Text('Ändern'),
                ),
              ],
            );
          });
        });
  }

  void editNotificationTime() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setError) {
            return AlertDialog(
              title: Text('Erinnerungs-Zeit'),
              content: SingleChildScrollView(
                  child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).accentColor)),
                        child: SizedBox(
                            height: 150,
                            width: 280,
                            child: CupertinoDatePicker(
                              use24hFormat: true,
                              initialDateTime: updateNotificationTime,
                              mode: CupertinoDatePickerMode.dateAndTime,
                              onDateTimeChanged: (value) {
                                updateNotificationTime = value;
                                setError(() {
                                  if (updateNotificationTime!
                                      .add(Duration(minutes: 1))
                                      .isBefore(DateTime.now())) {
                                    errorNotificationTime = true;
                                  } else {
                                    errorNotificationTime = false;
                                  }
                                });
                              },
                            ))),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: (errorNotificationTime)
                          ? Text(
                              'Ungültige Zeit',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(''),
                    ),
                  ],
                ),
              )),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () {
                    if (!errorNotificationTime) {
                      Task newTask = new Task(
                          id: task!.id,
                          subject: task!.subject,
                          isChecked: task!.isChecked,
                          deadlineTime: task!.deadlineTime,
                          notificationTime: updateNotificationTime.toString(),
                          notes: task!.notes);
                      databaseUpdateTask(newTask);
                      cancelNotification(task!.id);

                      if (updateNotificationTime!.isAfter(DateTime.now())) {
                        scheduleNotification(
                            newTask.id!,
                            newTask.subject!,
                            newTask.notes,
                            newTask.deadlineTime.toString(),
                            updateNotificationTime!);
                      } else if (updateNotificationTime!.isAfter(
                          DateTime.now().subtract(Duration(minutes: 1)))) {
                        showNotification(newTask.id!, newTask.subject!,
                            newTask.notes, newTask.deadlineTime.toString());
                      }

                      setState(() {
                        task = newTask;
                      });
                      widget.onReload!(task!.id);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ändern'),
                ),
              ],
            );
          });
        });
  }

  void editNotes() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setError) {
            return AlertDialog(
              title: Text('Notizen'),
              content: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(children: [
                    TextField(
                      dragStartBehavior: DragStartBehavior.down,
                      controller:
                          _textEdetingController, //TextEditingController(text: updateNotes),
                      decoration: InputDecoration(hintText: 'Notizen'),
                      onChanged: (text) {
                        updateNotes = text;

                        _textEdetingController.text = updateNotes!;
                        _textEdetingController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: _textEdetingController.text.length));
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
                      },
                    ),
                    (errorNotes)
                        ? Text(
                            'Notiz erforderlich',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(''),
                  ]),
                ),
              ),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (!errorNotes) {
                      if (updateNotes == '' || updateNotes == null) {
                        updateNotes = null;
                      }
                      Task newTask = new Task(
                          id: task!.id,
                          subject: task!.subject,
                          isChecked: task!.isChecked,
                          deadlineTime: task!.deadlineTime,
                          notificationTime: task!.notificationTime,
                          notes: updateNotes);
                      databaseUpdateTask(newTask);
                      setState(() {
                        task = newTask;
                      });
                      widget.onReload!(task!.id);
                      Navigator.pop(context);

                    if (DateTime.parse(task!.notificationTime!)
                        .isAfter(DateTime.now())) {

                      cancelNotification(task!.id);
                      await Future.delayed(Duration(seconds: 1), () {});

                      scheduleNotification(
                          newTask.id!,
                          newTask.subject!,
                          newTask.notes,
                          newTask.deadlineTime.toString(),
                          DateTime.parse(newTask.notificationTime!));
                    }}
                  },
                  child: Text('Ändern'),
                ),
              ],
            );
          });
        });
  }

  /**
   * Diese Methode dient dazu, im Querformat eine andere Aufgabe in der Detailansicht anzuzeigen
   * und die Detailansicht so zu aktualisieren.
   */
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
    // TODO: implement initState
    super.initState();
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

  /**
   * Rückgabe eines Containers mit der gesamten Detailansicht.
   */
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
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10),
            child: Center(
                child: Column(
              children: <Widget>[
                Subject(task!.subject!),
                if (task!.notes != null) Notes(task!.notes!, context),
                Deadlinetime(task!.deadlineTime!, context),
                Notificationtime(task!.notificationTime!, context),
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
                        borderRadius: BorderRadius.circular(5)),
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
                                ? Colors.blue
                                : Theme.of(context).accentColor,
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
                      borderRadius: BorderRadius.circular(5)),
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
                                color: Theme.of(context).accentColor,
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

  Widget Deadlinetime(String pTime, BuildContext context) {
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
                  Text('Zu erledigen bis:', style: TextStyle(fontSize: 17)),
                  Text(
                    parseTimeToUserOutput(pTime),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: (!DateTime.parse(pTime).isAfter(DateTime.now()))
                            ? Colors.red
                            : null),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded,
                  color: Theme.of(context).accentColor),
              onPressed: () {
                errorDeadlineTime = false;
                updateDeadlineTime = DateTime.parse(task!.deadlineTime!);
                editDeadlineTime();
              },
            )
          ],
        ));
  }

  Widget Notes(String pNotes, BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 10.0, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Notizen:', style: TextStyle(fontSize: 17)),
                Text(
                  pNotes,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon:
                Icon(Icons.edit_rounded, color: Theme.of(context).accentColor),
            onPressed: () {
              errorNotes = false;
              _textEdetingController.text = updateNotes!;
              _textEdetingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textEdetingController.text.length));
              //setState(() {});
              editNotes();
            },
          )
        ],
      ),
    );
  }

  Widget Notificationtime(String pTime, BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 10.0, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Zeitpunkt der Erinnerung:',
                    style: TextStyle(fontSize: 17)),
                Text(parseTimeToUserOutput(pTime),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          IconButton(
            icon:
                Icon(Icons.edit_rounded, color: Theme.of(context).accentColor),
            onPressed: () {
              errorNotificationTime = false;
              updateNotificationTime = DateTime.parse(task!.notificationTime!);
              editNotificationTime();
            },
          )
        ],
      ),
    );
  }
}

/**
 * Dieses Widget gibt einen Container zurück, welche in die Detailanscht eingebunden wird.
 * Dieses Widget beinhaltet das Fach der Hausaufgabe.
 */
Widget Subject(String pSubject) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.0),
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Fach:', style: TextStyle(fontSize: 17)),
        Text(pSubject,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            )),
      ],
    ),
  );
}
