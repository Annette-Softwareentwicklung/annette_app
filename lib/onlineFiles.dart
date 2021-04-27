import 'package:http/http.dart' as http;

class OnlineFiles {
  late String difExport;
  late int newVersion;

  Future<bool> initialize() async {
    Future<String?> _getDifExport() async {
      try {
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplan.txt'));
        if (response.statusCode == 200) {
          return response.body;
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    Future<int?> _getNewVersion() async {
      try {
        var response = await http
            .get(Uri.http('janw.bplaced.net', 'annetteapp/data/version.txt'));
        if (response.statusCode == 200) {
          return int.tryParse(response.body);
        }
        return null;
      } catch (e) {
        return null;
      }
    }


    if (
        await _getDifExport() != null &&
        await _getNewVersion() != null) {
      difExport = (await _getDifExport())!;
      newVersion = (await _getNewVersion())!;
      return true;
    } else {
      return false;
    }
  }

  List<String> allClasses() {
    List<String> classes = [];

    for (int i = 5; i < 10; i++) {
      classes.add(i.toString() + 'A');
      classes.add(i.toString() + 'B');
      classes.add(i.toString() + 'C');
      classes.add(i.toString() + 'D');

      if (difExport.contains(i.toString() + 'F')) {
        classes.add(i.toString() + 'F');
      } else {
        classes.add(i.toString() + 'E');
      }
    }
    classes.add('EF');
    classes.add('Q1');
    classes.add('Q2');

    return classes;
  }

  List<int>? getLanguage6() {
    String s1 = difExport;
    String s2;
    List<int> secondLanguage6 = [];

    while (s1.indexOf('L6') != -1) {
      s2 = s1.substring(0, s1.indexOf('L6'));
      s2 = s2.substring(s2.lastIndexOf(',,'));

      s2 = s2.substring(s2.indexOf(',"') + 2);

      int i = int.tryParse(s2.substring(0, 1))!;
      if (!secondLanguage6.contains(i)) {
        secondLanguage6.add(i);
      }
      s1 = s1.substring(s1.indexOf('L6') + 3);
    }
    return secondLanguage6;
  }

  String difExportFile() {
    return difExport;
  }

  int getNewVersion() {
    return newVersion;
  }
}
