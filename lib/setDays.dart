import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/defaultScaffold.dart';
import 'package:annette_app/setDaysSubjects.dart';

/**
 * Die Klasse SetDays gibt eine klickbare Liste mit allen Wochentagen zurück,
 * sodass man dann zur entsprechenden Seite zum Einstellen des Stundenplans für diesen Tag gelangt.
 * Diese Klasse wird im Einstellungstab verwendet, wenn man auf "Stundenplan" klickt.
 */
class SetDays extends StatelessWidget {
  final List<String> weekdays = [
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: new ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: weekdays.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text(weekdays[i]),
                trailing: Icon(Icons.chevron_right,  color: Theme.of(context).accentColor),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return DefaultScaffold(content: SetSubjects(weekdays[i]), title: weekdays[i]);
                  }),
                ),
              );
            })
        );
  }
}
