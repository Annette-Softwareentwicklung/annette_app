import 'package:get_storage/get_storage.dart';
import 'package:annette_app/fundamentals/vertretungsEinheit.dart';

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

      String configurationString = GetStorage().read('configuration');
      String currentClass = configurationString.substring(
          configurationString.indexOf('c:') + 2,
          configurationString.indexOf(';', configurationString.indexOf('c:')));

      bool relevant = false;

      if (result[0] == null) {
        ///Klassen-unspezifische Ereignisse
        bool? temp = GetStorage().read('unspecificOccurences');
        if(temp == null) {
          temp = true;
        }
        relevant = temp;
      } else {
        if (result[0]!.contains(currentClass.substring(0, 1)) &&
            result[0]!.contains(currentClass.substring(1))) {
          if (currentClass == 'EF' ||
              currentClass == 'Q1' ||
              currentClass == 'Q2') {
            if (result[5] == null) {
              relevant = true;
            } else {
              ///Möglicher Fehler hier? Bsp: Fach E GK1 gewählt, werden auch GE GK1 angezeigt?
              if (configurationString.contains(result[5]!)) {
                relevant = true;
              }
            }
          } else {
            ///Unterstufe Religion, Fremdsprache, Diff hier filtern.

            /// Filter Latein
            if (result.indexWhere((element) =>
                        element != null && element.contains('L6')) !=
                    -1 ||
                result.indexWhere((element) =>
                        element != null && element.contains('L7')) !=
                    -1) {
              if (configurationString.contains('sLanguageUS:L6;') ||
                  configurationString.contains('sLanguageUS:L7;')) {
                relevant = true;
              }
            } else

            ///Französisch
            if (result.indexWhere((element) =>
                        element != null && element.contains('F6')) !=
                    -1 ||
                result.indexWhere((element) =>
                        element != null && element.contains('F7')) !=
                    -1) {
              if (configurationString.contains('sLanguageUS:F6;') ||
                  configurationString.contains('sLanguageUS:F7;')) {
                relevant = true;
              }
            } else

            ///Kath. Religion
            if ((result[4] != null && result[4]!.contains('KR')) ||
                (result[5] != null && result[5]!.contains('KR'))) {
              if (configurationString.contains('religionUS:KR;')) {
                relevant = true;
              }
            } else

            ///Ev. Religion
            if ((result[4] != null && result[4]!.contains('ER')) ||
                (result[5] != null && result[5]!.contains('ER'))) {
              if (configurationString.contains('religionUS:ER;')) {
                relevant = true;
              }
            } else

            ///PPL
            if ((result[4] != null && result[4]!.contains('PPL')) ||
                (result[5] != null && result[5]!.contains('PPL'))) {
              if (configurationString.contains('religionUS:PPL;')) {
                relevant = true;
              }
            } else

            ///S8
            if ((result[4] != null && result[4]!.contains('S8')) ||
                (result[5] != null && result[5]!.contains('S8'))) {
              if (configurationString.contains('diffUS:S8;')) {
                relevant = true;
              }
            } else

            ///IFd
            if ((result[4] != null && result[4]!.contains('IFd')) ||
                (result[5] != null && result[5]!.contains('IFd'))) {
              if (configurationString.contains('diffUS:IFd;')) {
                relevant = true;
              }
            } else

            ///KUd
            if ((result[4] != null && result[4]!.contains('KUd')) ||
                (result[5] != null && result[5]!.contains('KUd'))) {
              if (configurationString.contains('diffUS:KUd;')) {
                relevant = true;
              }
            } else

            ///PHd
            if ((result[4] != null && result[4]!.contains('PHd')) ||
                (result[5] != null && result[5]!.contains('PHd'))) {
              if (configurationString.contains('diffUS:PHd;')) {
                relevant = true;
              }
            } else

            ///GEd
            if ((result[4] != null && result[4]!.contains('GEd')) ||
                (result[5] != null && result[5]!.contains('GEd'))) {
              if (configurationString.contains('diffUS:GEd;')) {
                relevant = true;
              }
            } else {
              relevant = true;
            }
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
    while (htmlCodeTemp.indexOf('<tr') != -1) {
      htmlCodeTemp = htmlCodeTemp.substring(
          htmlCodeTemp.indexOf('>', htmlCodeTemp.indexOf('<td') + 1) + 1);
      String s = htmlCodeTemp.substring(0, htmlCodeTemp.indexOf('</td'));
      htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('</td') + 5);

      if (htmlCodeTemp.indexOf('<td') != -1 &&
          htmlCodeTemp.indexOf('<td') < htmlCodeTemp.indexOf('<tr')) {
        htmlCodeTemp = htmlCodeTemp.substring(
            htmlCodeTemp.indexOf('>', htmlCodeTemp.indexOf('<td') + 1) + 1);
        s = s + ": " + htmlCodeTemp.substring(0, htmlCodeTemp.indexOf('</td'));
        htmlCodeTemp = htmlCodeTemp.substring(htmlCodeTemp.indexOf('</td') + 5);
      }

      s = s.replaceAll('<b>', '');
      s = s.replaceAll('</b>', '');
      s = s.replaceAll('<u>', '');
      s = s.replaceAll('</u>', '');
      s = s.replaceAll('<i>', '');
      s = s.replaceAll('</i>', '');
      s = s.replaceAll('&nbsp;', '');

      while (s.indexOf('<br>') != -1 &&
          !s.contains("Betroffene Klassen") &&
          !s.contains('Farbgebung')) {
        information.add(s.substring(0, s.indexOf('<br>')));
        s = s.substring(s.indexOf('<br') + 4);
      }
      if (!s.contains("Betroffene Klassen") && !s.contains('Farbgebung')) {
        information.add(s);
        information.add('\n');
      }
    }
    if (information.length != 0) {
      information.removeLast();
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
