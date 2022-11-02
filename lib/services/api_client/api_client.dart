import 'package:annette_app/miscellaneous-files/setClassV2.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String baseURL = "172.29.32.1:3000";

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
    //Workaround für einen Bug/eine Fehlkonfiguration auf der Seite von WebUntis,
    //durch den nur die Pläne für a-Klassen alle Diff-Optionen enthalten
    if (id.startsWith("9") || id.startsWith("10")) {
      id = id.substring(0) + "A";
    }

    //HTTP-Request
    var res = await http.get(Uri.http(
        baseURL, 'api/annette_app/dateien/stundenplan/optionen/' + id));

    //req erfolgreich
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

  static Future<String> fetchTimetableForWeek(WeekMode weekMode) async {
    var classValue = GetStorage().read("class");
    var urlString = 'api/annette_app/dateien/stundenplan/json/${classValue}/';

    if (weekMode == WeekMode.THIS_WEEK) {
      urlString += DateTime.now().toString();
    } else {
      urlString += DateTime.now().add(Duration(days: 7)).toString();
    }

    var res = await http.get(Uri.http(baseURL, urlString));
    if (res.statusCode != 200) {
      print(
          "Error occured while fetching weekly timetable: received code ${res.statusCode}");
    } else {
      print("Succesfully refreshed weekly timetable.");
    }
    return res.body;
  }
}

enum WeekMode { THIS_WEEK, NEXT_WEEK }
