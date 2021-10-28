import 'package:http/http.dart' as http;

Future<String?> getTimetableURL() async {
  late String htmlCode;
  try {
    var response = await http
        .get(Uri.https(
        'plaene.annettegymnasium.de', 'stundenplan_oL/frames/navbar.htm'));
    if (response.statusCode == 200) {
      htmlCode = response.body;
      htmlCode = htmlCode.substring(htmlCode.indexOf('name="week"'));
      htmlCode = htmlCode.substring(htmlCode.indexOf('option'));
      htmlCode = htmlCode.substring(htmlCode.indexOf('"') + 1);
      htmlCode = htmlCode.substring(0, htmlCode.indexOf('"'));

  return 'stundenplan_oL/c/' + htmlCode;
  }
  return null;
  } catch (e) {
  print(e);
  return null;
  }
}
