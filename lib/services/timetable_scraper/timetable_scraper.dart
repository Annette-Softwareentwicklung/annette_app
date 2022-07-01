import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:annette_app/services/timetable_scraper/objects/weekdays.dart';
import 'package:http/http.dart' as http;
import 'objects/lesson.dart';
import 'objects/timetable.dart';

//1055,\"6A\",\"WG\",\"AG MINT\",\"D104\",3,7,,\n
//1055,\"6A\",\"WG\",\"AG MINT\",\"D104\",3,7,,\n

class TimetableScraper {
  static Future<String> fetch(GroupIDs id) async {
    /*var res = await http.get(Uri.https(
        'annette-entwickelt-software-f16ysmude-totallyinformatik.vercel.app',
        'api/annette_app/dateien/stundenplan/' + id.name));*/
    var res = await http.get(Uri.http(
        'annette-entwickelt-software-a0de4y9t7-totallyinformatik.vercel.app',
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

    //TODO: zurückändern!!!
    return res.body;
    //return "0,\"5A\",\"WEB\",\"E\",\"B101\",1,3,,1,\"5A\",\"WEB\",\"EK\",\"B101\",1,4,,2,\"5A\",\"KO\",\"KU\",\"C101\",1,1,,3,\"5A\",\"KO\",\"KU\",\"C101\",1,2,,4,\"5A\",\"DU\",\"MU\",\"A010\",1,6,,5,\"5A\",\"GZ\",\"IF\",\"D102\",1,5,,";
  }
}
