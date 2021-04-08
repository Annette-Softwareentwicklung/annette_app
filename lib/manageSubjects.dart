import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'subjectsAtDay.dart';
import 'subjectDbInteraction.dart';
import 'subject.dart';
import 'subjectsAtDayDbInteraction.dart';

/**
 * Diese Klasse beinhaltet die notwendigen Optionen und Methoden zum
 * Verwalten der Fächer, d.h. Hizufügen und Löschen.
 */
class ManageSubjects extends StatefulWidget {
  ManageSubjects({Key? key}) : super(key: key);
  @override
  ManageSubjectsState createState() => ManageSubjectsState();
}

class ManageSubjectsState extends State<ManageSubjects> {
  late List<Subject> subjects;
  int? numberSubjects;
  bool finished = false;
  String? inputText; //Für das Hinzufügen eines neuen Fachs
  late List<SubjectsAtDay> timetable; //Für die Überprüfung vor dem Löschen

  ///Hilfsmethode zum Koordinieren des Ladevorgangs
  void load() async {
    Future.delayed(Duration(seconds: 0), () {
      getSubjects();
      getTimetable();
    });
  }

  /**
   * Diese Methode fragt alle Fächer aus der Datenbank ab
   * und speichert sie in der Liste "subjects".
   */
  void getSubjects() async {
    subjects = await databaseGetAllSubjects();
    numberSubjects = subjects.length;

    setState(() {
      finished = true;
    });
  }

  /**
   * Diese Methode fragt den gesamten Stundenplan aus der Datenbank ab
   * und speichert diesen in der Liste "timetable".
   */
  void getTimetable() async {
    timetable = await databaseGetAllDays();
  }

  /**
   * Diese Methode prüft, ob ein  bestimmtes Fach Bestandteil des Stundenplans
   * ist. Das zu prüfende Fach wird per Parameter übergeben.
   * Die Methode gibt einen Wert vom Typ boolean zurück.
   */
  bool checkIfIsInTimetable(String? pName) {
    bool isExisting = false;
    for (int i = 0; i < 5; i++) {
      if (timetable[i].lesson1 == pName ||
          timetable[i].lesson2 == pName ||
          timetable[i].lesson3 == pName ||
          timetable[i].lesson4 == pName ||
          timetable[i].lesson5 == pName ||
          timetable[i].lesson6 == pName ||
          timetable[i].lesson7 == pName ||
          timetable[i].lesson8 == pName ||
          timetable[i].lesson9 == pName ||
          timetable[i].lesson10 == pName ||
          timetable[i].lesson11 == pName) {
        isExisting = true;
      }
    }
    return isExisting;
  }

  /**
   * Diese Methode wird ausgeführt, wenn der Benutzer ein Fach löschen möchte.
   * Mit der Methode checkIfIsInTimetable(9 wird überprüft, ob das Fach Bestandteil des Stundenplans
   * ist. Sollte dem der Fall sein wird eine entsprechende Meldung ausgegeben.
   * Andernfalls kommt eine Abfrage, ob das Fach wirklich gelöscht werden soll.
   * Bestätigt der Benutzer diese, wird das Fach gelöscht.
   */
  void deleteSubject(int? pId, String? pName) {
    if (checkIfIsInTimetable(pName)) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: Text('Löschen fehlgeschlagen'),
                content: Text(
                    'Das Fach "$pName"  ist Bestandteil deines Stundenplans, du kannst es daher nicht löschen. Bitte überprüfe zunächst deinen Stundenplan.'),
                actions: [
                  RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: Text('Wirklich löschen?'),
                content: Text('Willst du das Fach "$pName" endgültig löschen?'),
                actions: [
                  RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Abbrechen'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      databaseDeleteSubject(pId);
                      setState(() {
                        load();
                      });
                    },
                    child: Text('Löschen'),
                  ),
                ],
              ));
    }
  }

  ///Hilfsmethode zum setzen der Variable "inputText" auf die Benutzer-Eingabe.
  void updateTextInput(String pText) {
    inputText = pText;
  }


  /**
   * Wenn der Benutzer ein neues Fach hinzufügen möchte, wird diese Methode aufgerufen.
   * Es öffnet sich ein Dialogfenster mit einem Textfeld zum Eingeben eines neues Fachs.
   * Sollte die Eingabe keine Fehler enthalte, wird das neue Fach mit
   * einem Klick auf "Hinzufügen" in die Datenbank eingetragen.
   * Sollte das Fach schon existieren, wird eine ensprechende Meldung ausgegeben.
   */
  void addSubject() {
    bool errorInput = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Fach hinzufügen'),
              content: IntrinsicHeight(child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Fach'),
                  onChanged: (text) => updateTextInput(text),
                ),
                if(errorInput) Text('Keine gültige Eingabe!',
                    style: TextStyle(color: Colors.red)),
                if(!errorInput) Text(''),
              ])),
              actions: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
                RaisedButton(
                 onPressed: () {

                    if (inputText != '' && inputText != null && !inputText!.toLowerCase().contains('sonstiges') && !inputText!.toLowerCase().contains('freistunde')) {
                      bool existing = false;
                      for (int i = 0; i < subjects.length; i++) {
                        if (subjects[i].name == inputText) {
                          existing = true;
                        }
                      }

                      if (!existing) {
                        Navigator.pop(context);
                        databaseInsertSubject(new Subject(name: inputText));
                        errorInput = false;
                        setState(() {
                          load();
                        });
                      } else {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text('Hinzufügen fehlgeschlagen'),
                                  content: Text(
                                      'Das Fach "$inputText" existiert bereits.'),
                                  actions: [
                                    RaisedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                ));
                      }
                    } else {
                      errorInput = true;
                      setState(() {

                      });
                    }
                  },
                  child: Text('Hinzufügen'),
                ),
              ],
            );
          });});
  }

  /**
   * Beim Initialisieren wird alles Notwendige mit der Methode load() aus der Datenbank geladen.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  /**
   * Erstellt ein Widget (Container) mit einer Liste mit allen Fächern.
   */
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Center(
            child: (finished == true)
                ? ListView.builder(
                    itemCount: numberSubjects,
                    itemBuilder: (context, numberSubjects) {
                      return ListTile(
                        title: Text(subjects[numberSubjects].name!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,  color: Theme.of(context).accentColor),
                          onPressed: () {
                            deleteSubject(subjects[numberSubjects].id,
                                subjects[numberSubjects].name);
                          },
                        ),
                      );
                    },
                  )
                : CupertinoActivityIndicator(),
          ),
        );
  }
}
