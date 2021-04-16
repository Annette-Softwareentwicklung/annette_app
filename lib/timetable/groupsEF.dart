import 'package:http/http.dart' as http;
class GroupsEF {
  List<List<String>> groupsEfList = [];
  Future<bool> initialize () async{
    Future<String?> _getTimetable() async {
      try {
        String tempUrl;

        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplanPfad.txt'));
        if (response.statusCode == 200) {
          tempUrl = response.body;


        response = await http.get(
            Uri.https('www.annettegymnasium.de', '$tempUrl/c00026.htm'));
        if (response.statusCode == 200) {
          return response.body;
        }}
        return null;
      } catch (e) {
        return null;
      }
    }

    if(await _getTimetable() != null) {
      String htmlCode = (await _getTimetable())!;
      htmlCode = htmlCode.replaceAll('Gk', 'GK');

      groupsEfList.add([]);
      groupsEfList.add([]);


      for(int i=1; i<13; i++) {
          List<String> tempList = [];
          String tempCode = htmlCode;
          int tempIndex = tempCode.indexOf('GK-Schiene $i');
          if(tempIndex == -1) {
            tempIndex = tempCode.indexOf('GK Schiene $i');
          }
          tempCode = tempCode.substring(0, tempCode.indexOf('</TABLE', tempIndex));
          tempCode = tempCode.substring(tempCode.lastIndexOf('TABLE'));
          tempCode = tempCode.substring(tempCode.indexOf('<TR>', tempCode.indexOf('<TR>') + 4));

          while(tempCode.indexOf('<B>') != -1) {
            tempCode = tempCode.substring(tempCode.indexOf('<B>') + 3);
            String s = tempCode.substring(0, tempCode.indexOf('</B'));
            s = s.replaceAll('.', ' ');
            s = s.trim();
            tempList.add(s);
            tempCode = tempCode.substring(tempCode.indexOf('</B'));
          }
          groupsEfList.add(tempList);
      }

      groupsEfList.add(['SP GK1','SP GK2','SP GK3','SP GK4','SP GK5',]);
      groupsEfList.add([]);
      groupsEfList.add([]);

      return true;
    } else {
      return false;
    }
  }

  List<List<String>> getGroupsEf () {
    return groupsEfList;
  }
}