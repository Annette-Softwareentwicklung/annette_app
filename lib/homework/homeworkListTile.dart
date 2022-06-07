import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/custom_widgets/defaultScaffold.dart';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import '../custom_widgets/customCheckbox.dart';
import 'detailedView.dart';
import 'package:annette_app/fundamentals/task.dart';
import '../miscellaneous-files/manageNotifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Diese Klasse kann den Listen-Eintrag einer Hausaufgabe anzeigen. Die Aufgabe sowie die
/// Id der position in der Liste werden neben den Funktionen, welche bei weiteren Aktionen wie
/// dem Löschen aufgerufen werden sollen, als Parameter übergeben.
///
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
  String? notes;

  final ObjectKey checkBoxKey = ObjectKey(CustomCheckboxState);

  /// (Nach einer Zeitspanne von 2 Sekunden wird geprüft, ob die Aufgabe nach wie vor
  /// abgehakt ist. Sollte dem so sein, wird die Aufgabe aus der Datenbank gelöscht und
  /// die geplante System-Benachrichtigung storniert.
  /// Durch diese 2 Sekunden hat der Benutzer noch die Möglichkeit, die Aufgabe
  /// wieder "entabzuhaken", sie also wieder als noch nicht erledigt an gezeigt wird.
  /// Dann wird die Aufgabe auch nicht gelöscht.)
  ///
  /// Die Möglichkeit die Aufgabe abzuhaken und wieder "entabzuhaken" wurde vorerst entfernt,
  /// da der Cooldown von 2 Sekunden zu Bugs beim Anzeigen der AnimatedList geführt hat.
  /// Die Methode löscht die Aufgabe nun stattdessen ohne "Überdenkzeit" aus der Datenbank
  /// und storniert die geplante Systembenachrichtigung.
  void remove() async {
    databaseDeleteTask(task!.id);
    cancelNotification(task!.id);
    widget.onRemove!(widget.index);
  }

  ///Man bekommt in 1 Stunde eine Benachrichtigung.
  ///Die Aufgabe wird in der Datenbank aktualisiert und, sofern die Detailansicht aufgerufen ist,
  ///wird diese auch aktualisiert.
  void remindMeLater(String time) {
    DateTime tempTime;

    if(time == 'afternoon') {
      tempTime = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,16);
    }
    else if(time == 'evening') {
      tempTime = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,20);
    }
    else if(time == 'tomorrowMorning') {
      tempTime = new DateTime(DateTime.now().year,DateTime.now().month,(DateTime.now().day + 1),9);
    }
    else {
      tempTime = DateTime.now().add(Duration(hours: 1));
    }

    task!.notificationTime = tempTime.toString();
    cancelNotification(task!.id!);
    scheduleNotification(
        task!.id!, task!.subject!, task!.notes, task!.deadlineTime!, tempTime);
    databaseUpdateTask(task!);
    widget.onDetailedViewReload!(task!.id!);
  }

  /// Sollten die Notizen zu lang sein, werden diese mit Punkten abgekürzt.
  @override
  void initState() {
    super.initState();
    task = widget.task;

    if (task!.notes != null) {
      if (task!.notes!.length > 20) {
        notes = task!.notes!.substring(0, 20) + '...';
      } else {
        notes = task!.notes;
      }
    }
  }

  /// Erstellen eines Listen-Elements, welche eine Hausaufgabe anzeigen kann.
  /// Im Titel steht das Fach, im Untertitel die näheren Informationen.
  /// Links beim Listenelement befindet sich die Checkbox, mit der man die Aufgaben abhaken kann.
  /// Klickt man auf das Listen-Element, wird es in der Detailansicht angezeigt.
  @override
  Widget build(BuildContext context) {
    ///Erstellen des Widgets für den "Untertitel" des Listen-Elements mit Notizen und Frist.
    Widget listTilesubtitle =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (task!.notes != null && task!.subject != 'Sonstiges')
        Text('Notiz: \n' + notes!),
      Text(
        'Bis: ' + parseTimeToUserOutput(task!.deadlineTime!),
        style: (!DateTime.parse(task!.deadlineTime!).isAfter(DateTime.now()))
            ? TextStyle(color: Colors.red)
            : null,
      )
    ]);
    ///Controller zum Steuern des "Slidable"-Widgets
    SlidableController slidableController = new SlidableController();

    return SizeTransition(
        sizeFactor: widget.animation as Animation<double>,
        child: Slidable(
          controller: slidableController,
            key: widget.key!,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 1 / 4,
            dismissal: SlidableDismissal(
              closeOnCanceled: true,
              dragDismissible: true,
              dismissThresholds: <SlideActionType, double> {
                SlideActionType.primary: 0.6,
                SlideActionType.secondary: 0.4,
              },
              onWillDismiss: (value) {
                if (value == SlideActionType.secondary) {
                  return true;
                } else {
                  remindMeLater('oneHour');
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
              ///SlideAction zum Löschen der Aufgabe
              IconSlideAction(
                closeOnTap: true,
                color: Colors.red,
                icon: CupertinoIcons.delete_solid,
                foregroundColor: Colors.white,
                onTap: () {
                  ///Wird "Löschen" ausgewählt, wird das Listtile "dismissed". Dies hat dann auch
                  ///zur Folge, dass die Aufgabe gelöscht wird.
                  slidableController.activeState!.dismiss(actionType: SlideActionType.secondary);
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
                  remindMeLater('oneHour');
                },
              ),

              IconSlideAction(
                closeOnTap: true,
                color: Colors.blueGrey,
                caption: (DateTime.now().hour < 16) ? 'Nachmittag' : (DateTime.now().hour < 20) ? 'Am Abend' : 'Morgen',
                foregroundColor: Colors.white,
                icon: CupertinoIcons.timer,
                onTap: () {
                  remindMeLater((DateTime.now().hour < 16) ? 'afternoon' : (DateTime.now().hour < 20) ? 'evening' : 'tomorrowMorning');
                },
              ),
            ],
            closeOnScroll: true,
            child: Card(
              child: ListTile(
                  leading: CustomCheckbox(
                    key: checkBoxKey,
                    task: task,
                    onChanged: () {
                      remove();
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