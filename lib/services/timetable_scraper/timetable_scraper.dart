import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:http/http.dart' as http;

class TimetableScraper {
  static Future<String> fetch(GroupIDs id) async {
    //TODO: durch production deployment ersetzen
    var res = await http.get(Uri.http(
        'https://annette-entwickelt-software-api.vercel.app/',
        'api/annette_app/dateien/stundenplan/' + id.name));
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
