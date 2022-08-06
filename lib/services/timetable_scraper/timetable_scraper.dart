import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:http/http.dart' as http;

class TimetableScraper {
  static Future<String> fetch(GroupIDs id) async {
    //TODO: durch production deployment ersetzen

    String date = DateTime.now().toString().substring(0, 10);
    print(date);

    var res = await http.get(Uri.http(
        'annette-entwickelt-software-6oaro0t5x-totallyinformatik.vercel.app',
        'api/annette_app/dateien/stundenplan/' + id.name + "/" + date));
    print("fetched!");
    if (res.statusCode != 200) {
      print("error error error");
      print(res.statusCode);
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {
      print("Request erfolgreich [200]");
    }
    print(res.body);

    return res.body;
  }
}
