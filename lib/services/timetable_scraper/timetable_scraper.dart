import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:annette_app/services/timetable_scraper/objects/weekdays.dart';
import 'package:http/http.dart' as http;
import 'objects/lesson.dart';
import 'objects/timetable.dart';

//1055,\"6A\",\"WG\",\"AG MINT\",\"D104\",3,7,,\n
//1055,\"6A\",\"WG\",\"AG MINT\",\"D104\",3,7,,\n

class TimetableScraper {
  static Future<http.Response> fetch(GroupIDs id) async {
    /*var res = await http.get(Uri.https(
        'annette-entwickelt-software-f16ysmude-totallyinformatik.vercel.app',
        'api/annette_app/dateien/stundenplan/' + id.name));*/
    var res = await http.get(Uri.https(
        'annette-entwickelt-software-api.vercel.app',
        'api/annette_app/dateien/stundenplan/' + id.name));
    print("fetched!");
    if (res.statusCode != 200) {
      print("error error error");
      print(res.statusCode);
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {
      print("hehe boi");
    }
    print(res.body);
    return res;
  }

  static Future<String> getAllOldFmt(String classID) async {
    print("Attempting timetable fetch...");
    String timetableString = "";
    var res = await fetch(GroupExt.fromString(key: classID));
    Timetable table = Timetable(res.body);
    table.weekdays.forEach((key, value) {
      for (Lesson l in table.weekdays[key]!.lessons) {
        timetableString += l.internalId.toString() +
            ", " +
            classID +
            ", " +
            "n/a, " +
            l.name +
            ", " +
            l.roomId +
            ", " +
            WeekdaysExt.toNumber(key).toString() +
            ", " +
            "1, " +
            ", , ";
      }
    });
    return timetableString;
  }
}
