import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:http/http.dart' as http;

class TimetableScraper {
  static Future<String> fetch(GroupIDs id) async {
    DateTime now = DateTime.now();
    //*  Stundenplan des nächsten Tages nach 18 Uhr anzeigen
    String date = now.toString().substring(0, 10);
    DateTime tomorrow = now;

    if (now.hour >= 18) {
      tomorrow = now.add(Duration(hours: 24 - now.hour + 10));
      date = tomorrow.toString().substring(0, 10);
    }

    // if its saturdays, sundays or fridays after 18 pm, then fetch timetable for monday, next week
    if (tomorrow.weekday == 6 || tomorrow.weekday == 7) {
      DateTime nextWeekMonday =
          tomorrow.add(Duration(days: 7 - now.weekday + 1));
      date = nextWeekMonday.toString().substring(0, 10);
    }
    var res = await http.get(Uri.http(
        'annette-entwickelt-software-api-totallyinformatik.vercel.app',
        'api/annette_app/dateien/stundenplan/' + id.name + "/" + date));
    if (res.statusCode != 200) {
      return "error";
      //throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {
      print("Request erfolgreich [200]");
    }

    return res.body;
  }
}
