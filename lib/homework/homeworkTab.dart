import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'package:annette_app/homework/homeworkListTile.dart';
import 'package:annette_app/fundamentals/task.dart';
import 'package:annette_app/database/taskDbInteraction.dart';
import 'package:annette_app/detailedView.dart';
import 'dart:async';

/// Diese Klasse beinhaltet den Tab mit der Hausaufgaben-Listen-Ansicht.
/// App => Menüleiste => Hausaufgaben
class HomeworkTab extends StatefulWidget {
  HomeworkTab({Key? key}) : super(key: key);

  @override
  HomeworkTabState createState() => HomeworkTabState();
}

class HomeworkTabState extends State<HomeworkTab> {
  final GlobalKey<AnimatedListState> listAccess = GlobalKey();
  final GlobalKey<DetailedViewState> detailedViewAccess = GlobalKey();

  ///Die Liste ist notwendig, um das Widget AnimatedList verwenden zu können.
  List<Task> tasks = [];
  bool finished = false;
  String? selectedOrder;
  int? orderValue;
  Task? defaultToShowOnDetailedSplitView;
  late GetStorage storage;

  /// Wenn eine neue Hausaufgabe über den "AddDialog" eingetragen wurde, wird diese als
  /// Parameter an diese Methode übergeben, welche die Aufgabe dann mit einer
  /// Animation an die Liste mit den Hausaufgaben anfügt.
  void insertTask(Task pTask) async {
    late int i;
    switch (orderValue) {
      case 1:
        print('case 1');
        i = await insertSubjectASC(pTask);
        break;
      case 2:
        print('case 2');
        i = await insertSubjectDESC(pTask);
        break;
      case 3:
        print('case 3');
        i = await insertDeadlineTimeASC(pTask);
        break;
      case 4:
        print('case 4');
        i = await insertDeadlineTimeDESC(pTask);
        break;
      case 5:
        print('case 5');
        i = await insertIdASC(pTask);
        break;
      case 6:
        print('case 6');
        i = await insertIdDESC(pTask);
        break;
    }
    if (tasks.length == 1) {
      setState(() {});
    } else {
      listAccess.currentState!.insertItem(i);
    }
  }

  ///1
  Future<int> insertSubjectASC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = 0;
      bool temp = true;
      if (i == tasks.length) {
        temp = false;
      }
      while (temp == true) {
        if (tasks[i].subject!.compareTo(pTask.subject!) < 0) {
          i++;
          if (i == tasks.length) {
            temp = false;
          }
        } else {
          temp = false;
        }
      }
      if (i == tasks.length) {
        tasks.add(pTask);
      } else {
        tasks.insert(i, pTask);
      }
      return i;
    }

    return await _getIndex();
  }

  ///2
  Future<int> insertSubjectDESC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = 0;
      bool temp = true;
      if (i == tasks.length) {
        temp = false;
      }
      while (temp == true) {
        if (tasks[i].subject!.compareTo(pTask.subject!) > 0) {
          i++;
          if (i == tasks.length) {
            temp = false;
          }
        } else {
          temp = false;
        }
      }
      if (i == tasks.length) {
        tasks.add(pTask);
      } else {
        tasks.insert(i, pTask);
      }
      return i;
    }

    return await _getIndex();
  }

  ///2
  Future<int> insertDeadlineTimeASC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = 0;
      bool temp = true;
      if (i == tasks.length) {
        temp = false;
      }
      while (temp == true) {
        if (tasks[i].deadlineTime!.compareTo(pTask.deadlineTime!) < 0) {
          i++;
          if (i == tasks.length) {
            temp = false;
          }
        } else {
          temp = false;
        }
      }
      if (i == tasks.length) {
        tasks.add(pTask);
      } else {
        tasks.insert(i, pTask);
      }
      return i;
    }

    return await _getIndex();
  }

  ///4
  Future<int> insertDeadlineTimeDESC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = 0;
      bool temp = true;
      if (i == tasks.length) {
        temp = false;
      }
      while (temp == true) {
        if (tasks[i].deadlineTime!.compareTo(pTask.deadlineTime!) > 0) {
          i++;
          if (i == tasks.length) {
            temp = false;
          }
        } else {
          temp = false;
        }
      }
      if (i == tasks.length) {
        tasks.add(pTask);
      } else {
        tasks.insert(i, pTask);
      }
      return i;
    }

    return await _getIndex();
  }

  ///5
  Future<int> insertIdASC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = tasks.length - 1;
      tasks.add(pTask);
      return i;
    }

    return await _getIndex();
  }

  ///6
  Future<int> insertIdDESC(Task pTask) async {
    Future<int> _getIndex() async {
      int i = 0;
      tasks.insert(0, pTask);
      return i;
    }

    return await _getIndex();
  }

  /// Diese Methode wird aufgerufen, wenn eine Aufgabe durch Anklicken der Checkbox
  /// abgehakt wurde. Die Id der abgehakten Aufgabe wird per Parameter übergeben,
  /// sodass diese aus der Liste, welche die aktuell angezeigten Aufgaben enthält,
  /// entfernt werden kann. Dies geschieht mit einer Animation, damit die Liste
  /// nicht unkontrolliert hin und her springt und der Benutzer nachvollziehen kann,
  /// was passiert ist.
  void removeFromList(int i) {
    tasks[i].isChecked = 1;
    Task removedTask = tasks.removeAt(i);
    listAccess.currentState!.setState(() {});
    listAccess.currentState!.removeItem(
        i,
        (context, animation) => HomeworkListTile(
              key: UniqueKey(),
              task: removedTask,
              animation: animation,
            ));

    if (tasks.length == 0) {
      setState(() {
        load();
      });
    }

    if (removedTask.id == defaultToShowOnDetailedSplitView?.id) {
      defaultToShowOnDetailedSplitView = null;
    }
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      if (detailedViewAccess.currentState!.task!.id == removedTask.id) {
        detailedViewAccess.currentState!.update(null);
      }
    }
  }

  void detailedViewDeleteTask(int pId) {
    int temp = tasks.indexWhere((element) => element.id == pId);
    if (temp != -1) {
      removeFromList(temp);
    }
  }

  /// Diese Methode wird aufgerufen, wenn eine Aufgabe durch Wischen nach links
  /// gelöscht wurde. Die Id der gelöschten Aufgabe wird per Parameter übergeben,
  /// sodass diese aus der Liste, welche die aktuell angezeigten Aufgaben enthält,
  /// entfernt werden kann. Dies geschieht ohne Animation, da das Listenelement schon
  /// zur Seite "rausgewischt" wurde und daher nicht mehr sichtbar ist.
  void deleteFromList(int i) {
    Task removedTask = tasks.removeAt(i);
    listAccess.currentState!.removeItem(i, (context, animation) => Container());
    if (tasks.length == 0) {
      setState(() {
        load();
      });
    }
    if (removedTask.id == defaultToShowOnDetailedSplitView?.id) {
      defaultToShowOnDetailedSplitView = null;
    }

    if (detailedViewAccess.currentState!.task!.id == removedTask.id) {
      detailedViewAccess.currentState!.update(null);
    }
  }

  ///Detailansicht nach Öffnen durch Benachrichtigung
  void showDetailedView(int? pId) {
    int id = tasks.indexWhere((element) => element.id == pId);
    if (id != -1) {
      Task payloadTask = tasks[id];

      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        detailedViewAccess.currentState!.update(payloadTask);
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DefaultScaffold(
            title: 'Details',
            content: DetailedView(
              isParallelDetail: false,
              task: payloadTask,
              onReload: (value) => reload(value),
              onRemove: (value) {
                detailedViewDeleteTask(value!);
                Navigator.of(context).pop();
              },
            ),
          );
        }));
      }
    }
  }

  ///Hilfsmethode zum Laden der Aufgaben.
  void load() async {
    Future.delayed(Duration(seconds: 0), () async {
      orderValue = storage.read('order');
      if (orderValue == null) {
        orderValue = 3;
      }

      switch (orderValue) {
        case 1:
          selectedOrder = 'Fach aufsteigend';
          break;
        case 2:
          selectedOrder = 'Fach absteigend';
          break;
        case 3:
          selectedOrder = 'Als nächstes';
          break;
        case 4:
          selectedOrder = 'Als letztes';
          break;
        case 5:
          selectedOrder = 'Zuerst hinzugefügt';
          break;
        case 6:
          selectedOrder = 'Zuletzt hinzugefügt';
          break;
      }

      tasks.clear();
      getTasks();
    });
  }

  /// Diese Methode fragt alle Hausaufgaben aus der Datenbank ab und
  /// speichert diese als Liste in der Variable "tasks".
  void getTasks() async {
    tasks = await databaseGetAllTasks(orderValue);
    setState(() {
      if (tasks.length > 0) {
        defaultToShowOnDetailedSplitView = tasks[0];
      } else {
        defaultToShowOnDetailedSplitView = null;
      }
      finished = true;
    });
  }

  ///Aktualisiert die Detailansicht
  void reloadDetailedView(int pTaskId) {
    try {
      detailedViewAccess.currentState!
          .update(tasks.firstWhere((element) => element.id == pTaskId));
    } catch (e) {}
  }

  void reload(int? reloadID) async {
    Task? tempTask;
    setState(() {
      finished = false;
    });
    tasks.clear();
    tasks = await databaseGetAllTasks(orderValue);

    if (reloadID != null) {
      print('rID $reloadID');
      tempTask = tasks[tasks.indexWhere((element) => element.id == reloadID)];
    }
    setState(() {
      if (tempTask != null) {
        defaultToShowOnDetailedSplitView = tempTask;
      } else if (tasks.length > 0) {
        defaultToShowOnDetailedSplitView = tasks[0];
      } else {
        defaultToShowOnDetailedSplitView = null;
      }
      finished = true;
    });
  }

  /// Beim Initialisieren dieses Tabs werden mit der Methode load()
  /// alle Hausaufgaben aus der Datenbank geladen.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage = GetStorage();
    load();
  }

  /// Dieses Widget (Container) gibt alle Hausaufgaben in einer Liste aus.
  /// Klickt man auf eine Hausaufgabe, öffnet sich eine Detailansicht.
  /// Wenn sich das Gerät im Querformat befindet, wird die Detailansicht paralell im
  /// Splitview angezeigt. beim Drehen wir hier standardmäßig die erste Aufgabe aus der Liste
  /// angezeigt.
  @override
  Widget build(BuildContext context) {
    if (finished == true) {
      return Container(
          padding: EdgeInsets.all(10.0),
          child: SafeArea(
              child: Row(children: <Widget>[
            Flexible(
              child: Column(children: [
                Container(
                  //height: 40,
                  margin: EdgeInsets.only(bottom: 7),
                  padding: EdgeInsets.only(bottom: 7, right: 7),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 178,
                    child: DropdownButton<String>(
                      items: [
                        'Als nächstes',
                        'Als letztes',
                        'Fach aufsteigend',
                        'Fach absteigend',
                        'Zuletzt hinzugefügt',
                        'Zuerst hinzugefügt'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          selectedOrder = value;
                        });
                        if (value == 'Als nächstes') {
                          orderValue = 3;
                        } else if (value == 'Zuerst hinzugefügt') {
                          orderValue = 5;
                        } else if (value == 'Zuletzt hinzugefügt') {
                          orderValue = 6;
                        } else if (value == 'Fach aufsteigend') {
                          orderValue = 1;
                        } else if (value == 'Fach absteigend') {
                          orderValue = 2;
                        } else if (value == 'Als letztes') {
                          orderValue = 4;
                        }
                        storage.write('order', orderValue);

                        reload(null);
                      },
                      value: selectedOrder,
                      hint: Text('Sortierung'),
                      icon: Icon(CupertinoIcons.arrow_up_arrow_down),
                      underline: Container(),
                      isDense: true,
                      isExpanded: true,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        child: (tasks.length == 0)
                            ? Container(
                                margin: EdgeInsets.only(bottom: 39),
                                child: Center(
                                    child: Text(
                                        'Keine Hausaufgaben zu erledigen.')))
                            : AnimatedList(
                                key: listAccess,
                                initialItemCount: tasks.length,
                                itemBuilder: (context, index, animation) {
                                  return HomeworkListTile(
                                    key: UniqueKey(),
                                    task: tasks[index],
                                    onDetailedViewCheckedtask: (value) =>
                                        detailedViewDeleteTask(value!),
                                    onRemove: (value) => removeFromList(value!),
                                    onDelete: (value) => deleteFromList(value!),
                                    onDetail: (task) {
                                      detailedViewAccess.currentState!
                                          .update(task);
                                    },
                                    onReload: (value) => reload(value),
                                    onDetailedViewReload: (value) =>
                                        reloadDetailedView(value),
                                    index: index,
                                    animation: animation,
                                  );
                                })))
              ]),
            ),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              VerticalDivider(
                color: Colors.grey,
                width: 2.0,
                thickness: 2,
                endIndent: 25,
              ),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              Flexible(
                  child: Container(
                      child: DetailedView(
                isParallelDetail: true,
                onReload: (value) => reload(value),
                onRemove: (value) => detailedViewDeleteTask(value!),
                key: detailedViewAccess,
                task:
                    defaultToShowOnDetailedSplitView, //task: (tasks.length > 0) ? tasks[0] : null,
              ))),
          ])));
    } else {
      return Container(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
  }
}
