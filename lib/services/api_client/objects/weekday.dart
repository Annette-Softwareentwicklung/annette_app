import 'dart:core';

import 'package:annette_app/services/api_client/objects/lesson.dart';

import 'block.dart';
import 'lesson.dart';

class Weekday {
  final String name;
  List<Lesson> lessons;
  Weekday(this.name, this.lessons);

  ///Shell-Sort-Algorithmus, um die Stunden zu sortieren
  void sort() {
    var interval;
    for (interval = 0;
        interval < lessons.length / 3;
        // ignore: empty_statements, curly_braces_in_flow_control_structures
        interval = interval * 3 + 1);

    while (interval > 0) {
      for (var outer = interval; outer < lessons.length; ++outer) {
        var valueToInsert = lessons[outer];
        var inner = outer;
        while (inner > interval - 1 &&
            lessons[inner - interval].startTime >= valueToInsert.startTime) {
          lessons[inner] = lessons[inner - interval];
          inner -= interval;
        }

        lessons[inner] = valueToInsert;
      }

      interval--;
      interval = interval ~/ 3;
    }

    lessons.forEach((element) {
      print(element.name + " :: " + element.startTimeFormatted);
    });
  }
}
