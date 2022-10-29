import 'dart:convert';

import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:get_storage/get_storage.dart';

import '../services/api_client/api_client.dart';

Future<List<TimeTableUnit>> getTimetableForDay(int weekday) async {
  List<TimeTableUnit>? timeTableForWeek =
      await getTimetableForWeek(getWeek(weekday));

  List<TimeTableUnit> timeTableForDay = [];

  for (TimeTableUnit ttu in timeTableForWeek) {
    if (ttu.dayNumber == weekday) {
      timeTableForDay.add(ttu);
    }
  }
  return timeTableForDay;
}

Future<List<TimeTableUnit>> getTimetableForWeek(WeekMode week) async {
  updateTimeTable(week);
  GetStorage storage = GetStorage();
  return storage.read(
      week == WeekMode.THIS_WEEK ? 'timeTableThisWeek' : 'timeTableNextWeek');
}

int getCurrentWeekday() {
  return DateTime.now().weekday <= 5 ? DateTime.now().weekday : 1;
}

WeekMode getWeek(int weekday) {
  return weekday <= 5 ? WeekMode.THIS_WEEK : WeekMode.NEXT_WEEK;
}

void updateTimeTable(WeekMode week) async {
  List<TimeTableUnit> timeTableForWeek = [];
  await ApiClient.fetchTimetableForWeek(WeekMode.THIS_WEEK).then((apiReturn) {
    // turns the String into a list of timeTableUnits
    var apiJson = json.decode(apiReturn);
    print(apiJson);
    // timeTableForWeek = apiJson.map((e) => TimeTableUnit.fromJson(e.toMap())).toList();

    print("Zeitplan:");
    print(timeTableForWeek);

    GetStorage storage = GetStorage();
    storage.write(
        week == WeekMode.THIS_WEEK ? 'timeTableThisWeek' : 'timeTableNextWeek',
        timeTableForWeek);
  });
}

DateTime? getTimetableVersion() {
  try {
    return DateTime.parse(GetStorage().read('timetableVersion'));
  } catch (e) {
    print(e);
    return null;
  }
}
