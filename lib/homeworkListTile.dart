import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'package:annette_app/parseTime.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import 'custom_widgets/customCheckbox.dart';
import 'detailedView.dart';
import 'package:annette_app/fundamentals/task.dart';
import 'manageNotifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/**
 * Diese Klasse kann den Listen-Eintrag einer Hausaufgabe anzeigen. Die Aufgabe sowie die
 * Id der position in der Liste werden neben den Funktionen, welche bei weiteren Aktionen wie
 * dem Löschen aufgerufen werden sollen, als Parameter übergeben.
 */
class HomeworkListTile extends StatefulWidget {
  final Task task;
  final int? index;
  final Function(int?)? onRemove;
  final Function(int?)? onDetailedViewCheckedtask;
  final Function(int?)? onDelete;
  final Function(Task?)? onDetail;
  final Function(int?)? onReload;
  final Function(int)? onDetailedViewReload;///Callback zum Aktualisieren der Detailansicht. Task-ID als Parameter.
  final Animation? animation;

  HomeworkListTile(
      {Key? key,
      required this.task,
      this.onRemove,
      this.onDelete,
      this.onDetailedViewCheckedtask,
      this.onDetail,
      this.index,
      this.onReload,
      this.onDetailedViewReload,
      this.animation})
      : super(key: key);

  @override
  _HomeworkListTileState createState() => _HomeworkListTileState();
}

class _HomeworkListTileState extends State<HomeworkListTile> {
  Task? task;
  int? isChecked;
  String? notes;

  final ObjectKey checkBoxKey = ObjectKey(CustomCheckboxState);

  /**
   * Diese Methode wird aufgerufen, wenn die Aufgabe abgehakt wurde.
   * Sollte ein Haken gesetzt sein, wird die Methode remove() aufgerufen.
   */
  void check() {
    if (isChecked == 0) {
      isChecked = 1;
      remove();
    } else {
      isChecked = 0;
    }
  }

  /**
   * Nach einer Zeitspanne von 2 Sekunden wird geprüft, ob die Aufgabe nach wie vor
   * abgehakt ist. Sollte dem so sein, wird die Aufgabe aus der Datenbank gelöscht und
   * die geplante System-Benachrichtigung storniert.
   * Durch diese 2 Sekunden hat der Benutzer noch die Möglichkeit, die Aufgabe
   * wieder "entabzuhaken", sie also wieder als noch nicht erledigt an gezeigt wird.
   * Dann wird die Aufgabe auch nicht gelöscht.
   */
  void remove() async {
    Future.delayed(Duration(seconds: 2), () {
      if (isChecked == 1) {
        databaseDeleteTask(task!.id);
        cancelNotification(task!.id);
        widget.onRemove!(widget.index);
      }
    });
  }

  ///Zurzeit nicht in Verwendung
  /*
  void check() {
    if (isChecked == 0) {
      isChecked = 1;
      remove();
      cancelNotification(task.id);
    } else {
      isChecked = 0;

      if (DateTime.parse(task.notificationTime).isAfter(DateTime.now())) {
        scheduleNotification(task.id, task.subject, task.notes,
            task.deadlineTime, DateTime.parse(task.notificationTime));
      } else if (DateTime.parse(task.notificationTime)
          .isAfter(DateTime.now().subtract(Duration(minutes: 1)))) {
        showNotification(task.id, task.subject, task.notes, task.deadlineTime);
      }
    }

    databaseUpdateTask(new Task(
        id: task.id,
        subject: task.subject,
        notes: task.notes,
        notificationTime: task.notificationTime,
        deadlineTime: task.deadlineTime,
        isChecked: isChecked));
  }

  void remove() async {
    Future.delayed(Duration(seconds: 2), () {
      if (isChecked == 1) {
        widget.onRemove(widget.index);
        //cancelNotification(task.id);
      }
    });
  }
*/

  ///Man bekommt in 1 Stunde eine Benachrichtigung.
  ///Die Aufgabe wird in der Datenbank aktualisiert und, sofern die Detailansicht aufgerufen ist,
  ///wird diese auch aktualisiert.
  void notificationInOneHour() {
    DateTime tempTime = DateTime.now().add(Duration(hours: 1));
    task!.notificationTime = tempTime.toString();
    cancelNotification(task!.id!);
    scheduleNotification(
        task!.id!, task!.subject!, task!.notes, task!.deadlineTime!, tempTime);
    databaseUpdateTask(task!);
    widget.onDetailedViewReload!(task!.id!);
  }

  /**
   * Sollten die Notizen zu lang sein, werden diese mit Punkten abgekürzt.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    task = widget.task;
    isChecked = task!.isChecked;

    if (task!.notes != null) {
      if (task!.notes!.length > 20) {
        notes = task!.notes!.substring(0, 20) + '...';
      } else {
        notes = task!.notes;
      }
    }
  }

  /**
   * Erstellen eines Listen-Elements, welche eine Hausaufgabe anzeigen kann.
   * Im Titel steht das Fach, im Untertitel die näheren Informationen.
   * Links beim Listenelement befindet sich die Checkbox, mit der man die Aufgaben abhaken kann.
   * Klickt man auf das Listen-Element, wird es in der Detailansicht angezeigt.
   */
  @override
  Widget build(BuildContext context) {
    ///Erstellen des Widgets für den "Untertitel" des Listen-Elements mit Notizen und Frist.
    Widget listTilesubtitle =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (task!.notes != null && task!.subject != 'Sonstiges')
        Text('Notiz: ' + notes!),
      Text(
        'Bis: ' + parseTimeToUserOutput(task!.deadlineTime!),
        style: (!DateTime.parse(task!.deadlineTime!).isAfter(DateTime.now()))
            ? TextStyle(color: Colors.red)
            : null,
      )
    ]);

    return SizeTransition(
        sizeFactor: widget.animation as Animation<double>,
        child: Slidable(
            key: widget.key!,
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 1 / 4,
            dismissal: SlidableDismissal(
              closeOnCanceled: true,
              dragDismissible: true,
              onWillDismiss: (value) {
                if (value == SlideActionType.secondary) {
                  return true;
                } else {
                  notificationInOneHour();
                  return false;
                }
              },
              onDismissed: (value) {
                if (value == SlideActionType.secondary) {
                  cancelNotification(task!.id);
                  databaseDeleteTask(task!.id);
                  widget.onDelete!(widget.index);
                }
              },
              child: SlidableDrawerDismissal(),
            ),
            secondaryActions: [
              IconSlideAction(
                closeOnTap: true,
                color: Colors.red,
                icon: CupertinoIcons.delete_solid,
                foregroundColor: Colors.white,
                onTap: () {
                  cancelNotification(task!.id);
                  databaseDeleteTask(task!.id);
                  widget.onDelete!(widget.index);
                },
              ),
            ],
            actions: [
              IconSlideAction(
                closeOnTap: true,
                color: Colors.orange,
                caption: '1 Stunde',
                foregroundColor: Colors.white,
                icon: CupertinoIcons.timer,
                onTap: () {
                  notificationInOneHour();
                },
              ),
              /*IconSlideAction(
                closeOnTap: true,
                color: Colors.blueGrey,
                caption: 'Morgen Nachmittag',
                foregroundColor: Colors.white,
                icon: CupertinoIcons.timer,
              ),*/
            ],
            closeOnScroll: true,
            child: Card(
              child: ListTile(
                  leading: CustomCheckbox(
                    key: checkBoxKey,
                    task: task,
                    onChanged: () {
                      check();
                    },
                  ),
                  title: (task!.subject == 'Sonstiges')
                      ? Text(notes!)
                      : Text(task!.subject!),
                  subtitle: listTilesubtitle,
                  trailing: Icon(Icons.info_outlined,
                      color: Theme.of(context).accentColor),
                  onTap: () {
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape) {
                      widget.onDetail!(task);
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return DefaultScaffold(
                          title: 'Details',
                          content: DetailedView(
                            isParallelDetail: false,
                            task: task,
                            onRemove: (int) {
                              widget.onDetailedViewCheckedtask!(task!.id);
                              Navigator.of(context).pop();
                            },
                            onReload: (value) => widget.onReload!(value),
                          ),
                        );
                      }));
                    }
                  }),
            )));
  }
}

/**
 * Dieses Widget wird im Hintergrund angezeigt, wenn das Listenelement
 * zur Seite raus gewischt wird.
 * (Roter Hintergrund mit Mülleimer-Icon)
 */
Widget backgroundItem() {
  return Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20.0),
    child: Icon(
      CupertinoIcons.delete_solid,
      color: Colors.white,
    ),
  );
}

/*
return SizeTransition(
        sizeFactor: widget.animation as Animation<double>,
        child: Dismissible(
            key: widget.key!,
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              cancelNotification(task!.id);
              databaseDeleteTask(task!.id);
              widget.onDelete!(widget.index);
            },
            background: backgroundItem(),
            child: Card(
              child: ListTile(
                  leading: CustomCheckbox(
                    key: checkBoxKey,
                    task: task,
                    onChanged: () {
                      check();
                    },
                  ),
                  title: (task!.subject == 'Sonstiges')
                      ? Text(notes!)
                      : Text(task!.subject!),
                  subtitle: listTilesubtitle,
                  trailing: Icon(Icons.info_outlined,
                      color: Theme.of(context).accentColor),
                  onTap: () {
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape) {
                      widget.onDetail!(task);
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return DefaultScaffold(
                          title: 'Details',
                          content: DetailedView(
                            isParallelDetail: false,
                            task: task,
                            onRemove: (int) {
                              widget.onDetailedViewCheckedtask!(task!.id);
                              Navigator.of(context).pop();
                            },
                            onReload: (value) => widget.onReload!(value),
                          ),
                        );
                      }));
                    }
                  }),
            )));
 */
