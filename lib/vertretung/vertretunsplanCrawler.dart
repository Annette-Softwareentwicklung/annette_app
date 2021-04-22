import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:annette_app/vertretung/vertretungsEinheit.dart';

class VertretungsplanCrawler {
  final String? htmlCode;
  VertretungsplanCrawler({this.htmlCode});

  Future<List<VertretungsEinheit>> getVertretungen() async {


    String htmlCodeTemp = htmlCode!;
    int tempStart = htmlCodeTemp.indexOf('<table');
    tempStart = htmlCodeTemp.indexOf('<table', tempStart + 5);
    tempStart = htmlCodeTemp.indexOf('<table', tempStart + 5);
    int tempEnd = htmlCodeTemp.lastIndexOf('/table>');
    htmlCodeTemp = htmlCodeTemp.substring(tempStart + 25, tempEnd - 2);

    List<VertretungsEinheit> vertretungen = [];
    String tempRow;
    htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('/tr>') + 4);

    while (htmlCodeTemp.indexOf('tr') != -1) {
      tempRow = htmlCodeTemp.substring(
          htmlCodeTemp.indexOf('>', htmlCodeTemp.indexOf('tr')) + 1,
          htmlCodeTemp.indexOf('</tr'));

      String tempColumn = tempRow;
      List<String?> result = [];
      for (int i = 0; i < 9; i++) {
        int start;
        if (tempColumn.indexOf('<span') < tempColumn.indexOf('/td>') &&
            tempColumn.indexOf('<span') != -1) {
          start = tempColumn.indexOf('>', tempColumn.indexOf('>') + 2) + 1;
        } else {
          start = tempColumn.indexOf('>') + 1;
        }
        int end = tempColumn.indexOf('<', start + 1);
        String tempValue = tempColumn.substring(start, end);

        if (tempValue == '&nbsp;' || tempValue == '---' || tempValue == '+') {
          result.add(null);
        } else {
          result.add(tempColumn.substring(start, end));
        }

        tempColumn = tempColumn.substring(tempColumn.indexOf('/td>') + 4);
      }

      Future<String> _getPath() async {
        final _dir = await getApplicationDocumentsDirectory();
        return _dir.path;
      }

      Future<String> _readData() async {
        try {
          final _path = await _getPath();
          final _file = File('$_path/configuration.txt');

          String contents = await _file.readAsString();
          return contents;
        } catch (e) {
          return '5A';
        }
      }

      String configurationString = await _readData();
      String currentClass = configurationString.substring(
          configurationString.indexOf('c:') + 2,
          configurationString.indexOf(';', configurationString.indexOf('c:')));

      bool relevant = false;

      if(result[0] == null)
      {
        ///Klassen-unspezifische Ereignisse
        relevant = false;
      } else
      {



        if (result[0]!.contains(currentClass.substring(0, 1)) &&
            result[0]!.contains(currentClass.substring(1))) {
          if (currentClass == 'EF' ||
              currentClass == 'Q1' ||
              currentClass == 'Q2') {
            if (result[5] == null) {
              relevant = true;
            } else {
              if (configurationString.contains(result[5]!)) {
                relevant = true;
              }
            }
          } else {
            relevant = true;
          }
        }
      }



      if (relevant) {

        vertretungen.add(new VertretungsEinheit(result[1], result[5], result[4],
            result[0], result[8], result[6], result[2], result[7], result[3]));

      }

      htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('/tr>') + 4);
    }
    return vertretungen;
  }

  String getCurrentDate() {
    String htmlCodeTemp = htmlCode!;
    int tempStart = htmlCodeTemp.indexOf('<div class="mon_title">') + 23;
    int tempEnd = htmlCodeTemp.indexOf("/div", tempStart) - 1;
    String currentDate = htmlCodeTemp.substring(tempStart, tempEnd);
    return currentDate;
  }

  List<String> getInformation() {
    List<String> information = [];
    String htmlCodeTemp = htmlCode!;

    htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('Nachrichten'));
    htmlCodeTemp = htmlCodeTemp.substring(0, htmlCodeTemp.indexOf('</table'));
    htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('</tr') + 5);
    htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('</tr') + 5);

    if (htmlCodeTemp.indexOf('<tr') != -1) {
      do {
        htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('<td') + 29);
        String s = htmlCodeTemp.substring(0, htmlCodeTemp.indexOf('</td'));
        htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('</td') + 5);

        while (s.indexOf('<br') != -1) {
          information.add(s.substring(0, htmlCodeTemp.indexOf('<')));
          s = s.substring(s.indexOf('<br') + 4);
        }
        information.add(s);
      } while (htmlCodeTemp.indexOf('<tr') != -1);
    }
    return information;
  }

  String getLastEdited() {
    String htmlCodeTemp = htmlCode!;
    int tempStart = htmlCodeTemp.indexOf('Stand: ') + 7;
    int tempEnd = htmlCodeTemp.indexOf("<", tempStart);
    String lastEdited = htmlCodeTemp.substring(tempStart, tempEnd);
    return lastEdited;
  }

  String getAffectedClasses() {
    String htmlCodeTemp = htmlCode!;
    int tempStart = htmlCodeTemp.indexOf('Betroffene Klassen&nbsp;</td>') + 59;
    int tempEnd = htmlCodeTemp.indexOf("<", tempStart);
    String affectedClasses = htmlCodeTemp.substring(tempStart, tempEnd);
    return affectedClasses;
  }
}
