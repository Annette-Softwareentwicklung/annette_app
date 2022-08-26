import 'package:annette_app/miscellaneous-files/setClass.dart';
import 'package:annette_app/miscellaneous-files/setClassV2.dart';
import 'package:annette_app/services/api_client/objects/group_ids.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String baseURL = "10.20.5.42:3000";

  static Future<String> fetchTimetable(String id) async {
    //TODO: durch production deployment ersetzen

    String date = DateTime.now().toString().substring(0, 10);
    print(date);

    var res = await http.get(Uri.http(baseURL,
        'api/annette_app/dateien/stundenplan/json/' + id + "/" + date));
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

  ///Sammelt alle Auswahlmöglichkeiten (z.B. DIFF-Kurse oder GK/LK-Schienen) von
  ///der API
  ///
  ///Die API unterstützt auch automatische Differenzierung von Sek I und Sek II.
  ///Das Ergebnis wird in angemessenem Format geliefert und in [SetClassV2] weiterverwendet.
  ///[id] stellt hierbei die Klasse dar, für die der Stundenplan geladen werden soll.
  static Future<String> fetchChoiceOptions(String id) async {
    var res = await http.get(Uri.http(
        baseURL, 'api/annette_app/dateien/stundenplan/optionen/' + id));
    print("fetched JSON!");
    if (res.statusCode != 200) {
      print("error error error");
      print(res.statusCode);
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {
      print("Request erfolgreich [200]");
    }

    return res.body;
  }

  ///Alle Klassen-Optionen von der API laden.
  ///
  ///Diese werden dann in der Klasse [SetClassV2] verwendet, die diese Methode
  /// auch in aufruft.
  /// TODO: Mit GetStorage abspeichern und API anpassen, sodass diese Methode nur einmal im Schuljahr ausgeführt werden muss
  static Future<String> preloadClasses() async {
    var res = await http.get(Uri.http(
        baseURL, 'api/annette_app/dateien/stundenplan/optionen/klassen'));
    if (res.statusCode != 200) {
      print("error error error");
      print(res.statusCode);
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {
      print("Request erfolgreich [200]");
    }
    return res.body;
  }
}
