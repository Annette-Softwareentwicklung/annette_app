import 'package:http/http.dart' as http;

class OnlineFiles {
  late List<String> classesList;
  late String difExport;
  late int newVersion;
  late List<String> times;
  late List<int> language6;

  Future<bool> initialize() async {
    Future<List<String>?> _getClassesList() async {
      try {
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/klassenListe.txt'));
        if (response.statusCode == 200) {
          return response.body.split(',');
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    Future<List<int>?> _getLanguage6() async {
      try {
        var response = await http
            .get(Uri.http('janw.bplaced.net', 'annetteapp/data/sprache6.txt'));
        if (response.statusCode == 200) {
          List<String> temp = response.body.split(',');
          List<int> result = [];
          temp.forEach((element) {
            result.add(int.tryParse(element)!);
          });
          return result;
        }
        return null;
      } catch (e) {
        return null;
      }
    }

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

    Future<List<String>?> _getNewTimes() async {
      try {
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/zeitraster.txt'));
        if (response.statusCode == 200) {
          return response.body.split(',');
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    if (await _getLanguage6() != null &&
        await _getNewTimes() != null &&
        await _getDifExport() != null &&
        await _getClassesList() != null &&
        await _getNewVersion() != null) {
      difExport = (await _getDifExport())!;
      language6 = (await _getLanguage6())!;
      classesList = (await _getClassesList())!;
      newVersion = (await _getNewVersion())!;
      times = (await _getNewTimes())!;
      return true;
    } else {
      return false;
    }
  }

  List<String> allClasses() {
    return classesList;
  }

  List<int> getLanguage6() {
    return language6;
  }

  String difExportFile() {
    return difExport;
  }

  int getNewVersion() {
    return newVersion;
  }

  List<String> getTimes() {
    return times;
  }
}
