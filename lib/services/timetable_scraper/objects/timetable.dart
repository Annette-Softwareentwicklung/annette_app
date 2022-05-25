import 'dart:convert';

import 'block.dart';
import 'weekday.dart';
import 'weekdays.dart';

class Timetable {
  ///Die ID der ausgewählten Stufe/Klasse.
  late final int groupId;

  ///Map, in der alle Wochentage des Stundenplans gespeichert werden
  ///
  ///Montag enthält z.B. alle Stunden, die am Montag stattfinden.
  var weekdays = {
    Weekdays.monday: Weekday("Montag", []),
    Weekdays.tuesday: Weekday("Dienstag", []),
    Weekdays.wednesday: Weekday("Mittwoch", []),
    Weekdays.thursday: Weekday("Donnerstag", []),
    Weekdays.friday: Weekday("Freitag", []),
    Weekdays.saturday: Weekday("Samstag", []),
    Weekdays.sunday: Weekday("Sonntag", [])
  };

  ///Konstruktor der Klasse [Timetable]
  ///
  ///Nimmt [dataString] als Parameter und generiert alle notwendigen Objekte
  ///basierend auf den JSON-Daten.
  Timetable(String dataString) {
    //String formatieren, um die JSON-Daten auslesen zu können
    var data = jsonDecode(dataString);

    //groupId setzen
    groupId = data['data']['result']['data']['elementIds'][0];

    ///Hilfsvariable, die die IDs und die Menschen geläufigeren Namen der Fächer speichert
    var subjects = {};

    ///Hilfsvariable, die die IDs und die Namen der Räume enthält
    ///
    ///z.B. 123 für Raum X004
    var rooms = {};

    //aufgrund der seltsamen JSON-Struktur die Informationen zu Räumen und Fächern auslesen,
    //entscheiden, ob es sich um einen Raum (4), Fach (3) oder eine Gruppe/Klasse (1) handelt
    //und dementsprechend die Informationen in der dazugehörigen Map speichern
    for (var entry in data['data']['result']['data']['elements']) {
      switch (entry['type']) {
        case 4:
          rooms[entry['id']] = entry['displayname'];
          break;
        case 3:
          subjects[entry['id']] = entry['displayname'];
          break;
        case 1:
      }
    }

    //Die Fächer ausgeben (debug)
    /*
    subjects.forEach((key, value) {
      print('$key: $value');
    });
    */

    //Die Räume ausgeben (debug)
    /*
    rooms.forEach((key, value) {
      print('$key: $value');
    });
    */

    //Jeden Block in JSON durchlaufen und in ein Objekt der Klasse Block überführen
    for (var entry in data['data']['result']['data']['elementPeriods']
        [groupId.toString()]) {
      //Der Raum, in dem die Stunde stattfindet
      var room = "n/a";

      //Der Name des Fachs
      var name = "n/a";

      //Erneut müssen die attachments anhand der ID auseinandergehalten werden
      for (var sub in entry['elements']) {
        switch (sub['type']) {
          case 1: //Klassen sind momentan irrelevant
            break;
          case 3:
            //Namen laden
            name = subjects[sub['id']];
            break;
          case 4:
            //Raumnamen laden
            room = rooms[sub['id']];
            break;
        }
      }

      //Das eigentliche Objekt erstellen und mit den gesammelten Informationen füllen
      Block block = Block(
          entry['startTime'],
          weirdTimeConvert(entry['startTime'].toString()),
          entry['endTime'],
          room,
          name);

      //Das Objekt dem entsprechenden Wochentag in der obigen Map zuteilen
      //Aufgrund des Formats muss das Datum dafür konvertiert werden
      print(block.name +
          " | " +
          entry['date'].toString() +
          " => " +
          weirdDayConvert(entry['date']).toString());
      weekdays[weirdDayConvert(entry['date'])]?.blocks.add(block);
    }
    weekdays.forEach(
      (key, value) => {
        value.blocks.forEach((element) {
          print(value.name +
              " -> " +
              element.name +
              " | " +
              element.startTimeFormatted);
        })
      },
    );
    cleanupWeekdays();
  }

  void cleanupWeekdays() {
    weekdays.forEach((key, value) {
      value.sort();
    });
  }

  ///Konvertiert das JSON-Datum in einen Wochentag des enums [Weekdays].
  ///
  ///z.B. "20220507" -> [Weekdays.saturday]
  Weekdays weirdDayConvert(int dayAsNumber) {
    String day = dayAsNumber.toString();
    var _year = day.substring(0, 4);
    var _month = day.substring(4, 6);
    var _day = day.substring(6);

    DateTime actualDay = DateTime(
      int.parse(_year),
      int.parse(_month),
      int.parse(_day),
    );

    assert(actualDay.weekday <= 7);
    return Weekdays.values[actualDay.weekday - 1];
  }

  ///Konvertiert das JSON-Format für Uhrzeiten in einen String, der einfacher zu lesen ist.
  ///
  ///z.B. 845 -> 08:45
  ///z.B. 1040 -> 10:40
  String weirdTimeConvert(String time) {
    switch (time.length) {
      case 3:
        return "0" + time.substring(0, 1) + ":" + time.substring(1);
      case 4:
        return time.substring(0, 2) + ":" + time.substring(2);
    }

    return "n/a";
  }
}
