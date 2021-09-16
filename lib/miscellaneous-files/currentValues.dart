import 'package:annette_app/firebase/timetableUnitFirebaseInteraction.dart';
import 'package:annette_app/data/lessonStartTimes.dart';
import 'package:annette_app/miscellaneous-files/parseTime.dart';
import 'package:annette_app/fundamentals/lessonStartTime.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';

class CurrentValues {
  DateTime currentTime = DateTime.now();
  late List<LessonStartTime> times;
  late List<TimeTableUnit> allTimetableUnits;

  Future<void> initialize() async {
    times =  getAllTimes();
    allTimetableUnits = await databaseGetAllTimeTableUnit();
  }

  /// Diese Methode gibt den Zeitpunkt des Starts der 1. Stunde am aktuellen Tag zurück.
  DateTime getStartOfFirstLesson() {
    DateTime temp =
    new DateTime(currentTime.year, currentTime.month, currentTime.day);
    temp = temp.add(parseDuration(times[0].time!));
    return temp;
  }

  Future<String?> getCurrentSubject() async {
    TimeTableUnit? temp = await getCurrentTimeTableUnit();
    if (temp != null) {
      return temp.subject;
    } else {
      return null;
    }
  }

  Future<TimeTableUnit?> getCurrentTimeTableUnit() async {
    int currentLesson = 0;
    TimeTableUnit? timetableUnit;
    int weekdayForDays = currentTime.weekday;

    for (int i = 0; i < times.length; i++) {
      DateTime temp =
          new DateTime(currentTime.year, currentTime.month, currentTime.day);
      temp = temp.add(parseDuration(times[i].time!));

      if (currentTime.isAfter(temp)) {
        if (allTimetableUnits.indexWhere((element) =>
                element.lessonNumber == i + 1 &&
                element.dayNumber == weekdayForDays) !=
            -1) {
          currentLesson = i + 1;
        }
      }
    }


    int tempIndex = allTimetableUnits.indexWhere((element) =>
        element.lessonNumber == currentLesson &&
        element.dayNumber == weekdayForDays);

    if (tempIndex != -1) {
      timetableUnit = allTimetableUnits[tempIndex];
    } else {
      timetableUnit = null;
    }
    return timetableUnit;
  }

  /// Diese Methode gibt den zeitpunkt zurück, wann der Benutzer das per Parameter
  /// übergebene Fach das nächste Mal laut Stundenplan hat.
  DateTime? getNextLesson(String? pSubject) {
    if (pSubject == null) {
      return null;
    }

    DateTime nextLesson;
    bool gotNext = false;
    TimeTableUnit? nextTimeTableUnit;
    int i = currentTime.weekday + 1;
    int exitLoop = 0;

    while (!gotNext) {
      if (exitLoop > 5) {
        return null;
      }
      if (i > 5) {
        i = 1;
      }
      if (allTimetableUnits.indexWhere((element) =>
              element.subject == pSubject && element.dayNumber == i) != -1) {
        nextTimeTableUnit = allTimetableUnits[allTimetableUnits.indexWhere(
            (element) =>
                element.subject == pSubject && element.dayNumber == i)];

        if(allTimetableUnits.indexWhere(
                (element) =>
            element.subject == nextTimeTableUnit!.subject && element.dayNumber == nextTimeTableUnit.dayNumber && element.lessonNumber == (nextTimeTableUnit.lessonNumber! - 1)) != -1) {
          nextTimeTableUnit = allTimetableUnits[allTimetableUnits.indexWhere(
                  (element) =>
              element.subject == nextTimeTableUnit!.subject && element.dayNumber == nextTimeTableUnit.dayNumber && element.lessonNumber == (nextTimeTableUnit.lessonNumber! - 1))];
        }
        gotNext = true;
      }
      i++;
      exitLoop++;
    }

    int temp = nextTimeTableUnit!.dayNumber! - currentTime.weekday;
    if(temp < 1)
      temp+= 7;
    nextLesson = new DateTime(currentTime.year, currentTime.month, currentTime.day);
    //nextLesson = nextLesson.add(new Duration(days: nextTimeTableUnit!.dayNumber! - (currentTime.weekday)));
    nextLesson = nextLesson.add(new Duration(days: temp));
    nextLesson = nextLesson.add(parseDuration(times[(nextTimeTableUnit.lessonNumber! - 1)].time!));

    return nextLesson;
  }
}
