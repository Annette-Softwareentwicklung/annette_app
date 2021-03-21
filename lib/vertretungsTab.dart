import 'package:annette_app/vertretungListTile.dart';
import 'package:annette_app/vertretungsEinheit.dart';
import 'package:annette_app/vertretunsplanCrawler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VertretungsTab extends StatefulWidget {
  @override
  _VertretungsTabState createState() => _VertretungsTabState();
}

class _VertretungsTabState extends State<VertretungsTab> {
  String htmlCode;
  List<VertretungsEinheit> vertretungen = [];
  void makeRequest() async {
    try {
      final response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Heute_KoL/subst_001.htm'));

      if (response.statusCode == 200) {
        htmlCode = response.body;

        VertretungsplanCrawler vpc =
            new VertretungsplanCrawler(htmlCode: htmlCode);
        vpc.getCurrentDate();
        vertretungen = vpc.getVertretungen();
        vpc.getLastEdited();
        vpc.getAffectedClasses();
        setState(() {});
      } else {
        throw Exception('Failed to load.');
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Laden fehlgeschlagen'),
            Icon(
              Icons.warning_rounded,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
      child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vertretungen.length,
              itemBuilder: (BuildContext context, int index) {
                return VertretungListTile(vertretungen[index]);
              }),
      color: Colors.red,
      backgroundColor: Colors.tealAccent,
      strokeWidth: 5,
      onRefresh: () {
        return Future.delayed(Duration.zero, () {
          setState(() {
            makeRequest();
          });
        });
      },
    ));
  }
}
