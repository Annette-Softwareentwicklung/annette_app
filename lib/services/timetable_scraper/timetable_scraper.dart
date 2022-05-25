import 'package:annette_app/services/timetable_scraper/objects/group_ids.dart';
import 'package:http/http.dart' as http;
import 'objects/timetable.dart';

class TimetableScraper {
  static void fetch(GroupIDs id) async {
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': 'de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7',
      'Connection': 'keep-alive',
      'Cookie':
          'traceId=8d6dd7969b4dbdfaf81c110863f4a240df845bc8; traceId=8d6dd7969b4dbdfaf81c110863f4a240df845bc8; JSESSIONID=8F6D67B021F025AB199DF50BEDA6F8A6; schoolname="_YXZkaGctZHVlc3NlbGRvcmY="',
      'Referer': 'https://ajax.webuntis.com/WebUntis/?school=avdhg-duesseldorf',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-origin',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36',
      'sec-ch-ua':
          '" Not A;Brand";v="99", "Chromium";v="101", "Google Chrome";v="101"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'elementType': '1',
      'elementId': id.toString(),
      'date': '2022-05-06',
      'formatId': '3',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse(
        'https://ajax.webuntis.com/WebUntis/api/public/timetable/weekly/data?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }

    Timetable table = Timetable(res.body);
  }
}
