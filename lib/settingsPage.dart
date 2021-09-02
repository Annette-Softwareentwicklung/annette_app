import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'database/databaseCreate.dart';
import 'fundamentals/preferredTheme.dart';
import 'package:week_of_year/week_of_year.dart';

import 'manageNotifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var storage = GetStorage();
  late bool? unspecificOccurences;
  late PreferredTheme preferredTheme;
  String lk1 = '---';
  String lk2 = '---';
  late int selectedLK;
  late List<TimeTableUnit> allTimetableUnits;
  bool hasDeletedDoneTasks = false;

  @override
  void initState() {
    super.initState();
    unspecificOccurences = storage.read('unspecificOccurences');
    if (unspecificOccurences == null) {
      unspecificOccurences = true;
    }
    selectedLK = 0;
    setChangingLK();
  }

  void setChangingLK() async {
    allTimetableUnits = await databaseGetAllTimeTableUnit();
    try {
      lk1 = allTimetableUnits
          .firstWhere((element) => element.subject!.contains('LK'))
          .subject!;
      lk2 = allTimetableUnits
          .firstWhere((element) =>
              element.subject!.contains('LK') &&
              !element.subject!.contains(lk1))
          .subject!;

      print(
          'load: ${storage.read('changingLkSubject')} ${storage.read('changingLkWeekNumber')}');
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

      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    preferredTheme = context.watch<PreferredTheme>();

    var textDescription = TextStyle(
        fontSize: 14,
        color: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white60
            : Colors.black54);
    var boxDecoration = BoxDecoration(
        boxShadow: (Theme.of(context).brightness == Brightness.dark)
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
        borderRadius: BorderRadius.circular(10),
        color: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black26
            : Colors.white);
    return Container(
      alignment: Alignment.topCenter,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints(maxWidth: 500),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: double.infinity,
                  decoration: boxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Klassen-unspezifisches',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      CupertinoSwitch(
                          value: unspecificOccurences!,
                          onChanged: (value) {
                            storage.write('unspecificOccurences', value);
                            setState(() {
                              unspecificOccurences = value;
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                      'Dir werden auf dem Vertretungsplan ${(unspecificOccurences!) ? '' : 'keine '}Ereignisse angezeigt, die nicht einer spezifischen Klasse zugeordnet sind. ${(unspecificOccurences!) ? 'Diese können trotzdem relevant für dich sein.' : 'Auch wenn diese dennoch für dich relevant sein könnten.'}',
                      style: textDescription),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: boxDecoration,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erscheinungsbild der App',
                        style: TextStyle(fontSize: 17),
                      ),
                      ListTile(
                        title: Text("Hell"),
                        leading: Radio(
                          value: 0,
                          groupValue: context.watch<PreferredTheme>().value,
                          onChanged: (value) {
                            preferredTheme.setValue(value as int);
                          },
                          activeColor:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Theme.of(context).accentColor
                                  : Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: Text("Dunkel"),
                        leading: Radio(
                          value: 1,
                          groupValue: context.watch<PreferredTheme>().value,
                          onChanged: (value) {
                            preferredTheme.setValue(value as int);
                          },
                          activeColor:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Theme.of(context).accentColor
                                  : Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: Text("System"),
                        leading: Radio(
                          value: 2,
                          groupValue: context.watch<PreferredTheme>().value,
                          onChanged: (value) {
                            preferredTheme.setValue(value as int);
                          },
                          activeColor:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Theme.of(context).accentColor
                                  : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Das Erscheinungsbild der App ist ${(context.watch<PreferredTheme>().value == 0) ? 'immer hell' : (context.watch<PreferredTheme>().value == 1) ? 'immer dunkel' : 'abhängig vom Betriebssystem'}.',
                    style: textDescription,
                  ),
                ),
                if (storage.read('configuration').contains('Q1') ||
                    storage.read('configuration').contains('Q2'))
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: boxDecoration,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wechselnde LK-Schiene',
                          style: TextStyle(fontSize: 17),
                        ),
                        ListTile(
                          title: Text(lk1),
                          leading: Radio(
                            value: 0,
                            groupValue: selectedLK,
                            onChanged: (value) {
                              storage.write('changingLkSubject', lk1);
                              storage.write('changingLkWeekNumber',
                                  DateTime.now().weekOfYear);
                              print(storage.read('changingLkSubject'));
                              print(storage.read('changingLkWeekNumber'));
                              setState(() {
                                selectedLK = value as int;
                              });
                            },
                            activeColor: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).accentColor
                                : Colors.blue,
                          ),
                        ),
                        ListTile(
                          title: Text(lk2),
                          leading: Radio(
                            value: 1,
                            groupValue: selectedLK,
                            onChanged: (value) {
                              storage.write('changingLkSubject', lk2);
                              storage.write('changingLkWeekNumber',
                                  DateTime.now().weekOfYear);
                              print(storage.read('changingLkSubject'));
                              print(storage.read('changingLkWeekNumber'));
                              setState(() {
                                selectedLK = value as int;
                              });
                            },
                            activeColor: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).accentColor
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (storage.read('configuration').contains('Q1') ||
                    storage.read('configuration').contains('Q2'))
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Wähle das Fach, das du in der aktuellen Woche hast. Der LK wechselt wöchentlich. ',
                      style: textDescription,
                    ),
                  ),
                ///TODO: Erledigte Aufgaben im Hintergrund behalten mit der Option zum Anzeigen im homeworkTab noch nicht implementiert.
                /*GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: boxDecoration,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'Erledigte Hausaufgaben löschen',
                      style: TextStyle(
                        fontSize: 17,
                        color:
                            (hasDeletedDoneTasks) ? Colors.grey : Colors.blue,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      hasDeletedDoneTasks = true;
                    });
                    databaseDeleteDoneTasks();
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Deine erledigten Hausaufgaben werden im Hintergrund noch gespeichert. Unter "Sortierung > Erledigte einblenden" kannst du sie einsehen.',
                    style: textDescription,
                  ),
                ),*/
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: boxDecoration,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'App zurücksetzen',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setError) {
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
                                          margin: EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Reset',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'Willst du wirklich die gesamte App auf Werkseinstellungen zurücksetzten?',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                onPressed: () async {
                                                  var storage = GetStorage();

                                                  storage.write(
                                                      'introScreen', true);
                                                  storage.write(
                                                      'prefferedTheme', 2);
                                                  storage.write('configuration',
                                                      'c:5A;lk1:Freistunde;lk2:Freistunde;gk1:Freistunde;gk2:Freistunde;gk3:Freistunde;gk4:Freistunde;gk5:Freistunde;gk6:Freistunde;gk7:Freistunde;gk8:Freistunde;gk9:Freistunde;gk10:Freistunde;gk11:Freistunde;gk12:Freistunde;gk13:Freistunde;zk1:Freistunde;zk2:Freistunde;religionUS:Freistunde;sLanguageUS:Freistunde;diffUS:Freistunde;');
                                                  storage.write(
                                                      'unspecificOccurences', true);
                                                  storage.write(
                                                      'order', 3);


                                                  ///Datenbank löschen
                                                  WidgetsFlutterBinding
                                                      .ensureInitialized();
                                                  final Future<Database>
                                                      database = openDatabase(
                                                    join(
                                                        await getDatabasesPath(),
                                                        'local_database.db'),
                                                    onCreate: (db, version) {
                                                      createDb(db);
                                                    },
                                                    version: 1,
                                                  );
                                                  Database db = await database;
                                                  await db.execute(
                                                      "DELETE FROM homeworkTasks");
                                                  await db.execute(
                                                      "DELETE FROM timetable");
                                                  cancelAllNotifications();

                                                  ///Dialogfenster schließen
                                                  Navigator.of(context).pop();

                                                  ///Dialog zur Information des Benutzers
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setError) {
                                                          return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              child: Container(
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxWidth: 450,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 30,
                                                                        left:
                                                                            30,
                                                                        right:
                                                                            30,
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          'Reset erfolgreich',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 25),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          'Alles wurde zurückgesetzt. Bitte starte die App neu.',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                        });
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.check_rounded,
                                                  size: 30,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          });
                        });
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Die gesamte App und alle Einstellungen werden zurückgesetzt.',
                    style: textDescription,
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 50),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
