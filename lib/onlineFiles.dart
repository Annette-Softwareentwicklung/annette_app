import 'package:http/http.dart' as http;
class OnlineFiles {
  late List<String> classesList;
  late String difExport;
  late int newVersion;

  Future<bool> initialize () async{
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

    Future<String?> _getDifExport() async {
      try {
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplan.txt'));
        if (response.statusCode == 200) {
          return response.body;
        }
        return null;} catch (e) {
        return null;
      }
    }

    Future<int?> _getNewVersion() async {
      try {
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/version.txt'));
        if (response.statusCode == 200) {
          return int.tryParse(response.body);
        }
        return null;
      } catch (e) {
        return null;
      }
    }


    if(await _getDifExport() != null && await _getClassesList() != null && await _getNewVersion() != null) {
      difExport = (await _getDifExport())!;
      classesList = (await _getClassesList())!;
      newVersion = (await _getNewVersion())!;
      return true;
    } else {
      return false;
    }
  }

  List<String> allClasses () {
   return classesList;
  }

  String difExportFile () {
    return difExport;
  }

  int getNewVersion () {
    return newVersion;
  }
}