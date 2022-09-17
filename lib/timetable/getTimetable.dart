import 'dart:html';

import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:get_storage/get_storage.dart';

import '../services/api_client/api_client.dart';

///
///
///
Future<List<TimeTableUnit>> getTimetableForDay(DateTime day) async {
  List<TimeTableUnit>? timeTableForWeek =
      await getTimeTableForWeek();

  List<TimeTableUnit> timeTableForDay = [];

  for (TimeTableUnit ttu in timeTableForWeek!) {
    if (ttu.dayNumber == day.weekday) {
      timeTableForDay.add(ttu);
    }
  }
  return timeTableForDay;
}

Future<List<TimeTableUnit>?> getTimeTableForWeek(WeekMode week) async {
  GetStorage storage = GetStorage();
  return storage.read(
      week == WeekMode.THIS_WEEK ? 'timeTableThisWeek' : 'timeTableNextWeek');
}

int getCurrentWeekday() {
  return DateTime.now().weekday <= 5 ? DateTime.now().weekday : 1;
}

WeekMode getCurrentWeek() {
  return DateTime.now().weekday <= 5 ? WeekMode.THIS_WEEK : WeekMode.NEXT_WEEK;
}

void updateTimeTable(WeekMode week) async {
  String apiReturn = await ApiClient.fetchTimetableForWeek(week);
  List<TimeTableUnit> timeTableForWeek = [];
  // turns the String into a list of timeTableUnits
  // (@Arwed is assigned to this issue)

  GetStorage storage = GetStorage();
  storage.write(
      week == WeekMode.THIS_WEEK ? 'timeTableThisWeek' : 'timeTableNextWeek',
      timeTableForWeek);
}
