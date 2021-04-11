import 'package:annette_app/vertretung/vertretungListTile.dart';
import 'package:annette_app/vertretung/vertretungsEinheit.dart';
import 'package:annette_app/vertretung/vertretunsplanCrawler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VertretungsTab extends StatefulWidget {
  @override
  _VertretungsTabState createState() => _VertretungsTabState();
}

class _VertretungsTabState extends State<VertretungsTab> {
  String? htmlCode;
  List<VertretungsEinheit>? vertretungenHeute = [];
  List<VertretungsEinheit>? vertretungenMorgen = [];
  List<String> informationToday = [];
  List<String> informationTomorrow = [];
  String dateTomorrow = 'Morgen';
  String dateToday = 'Heute';
  String lastEdited = '--';
  bool load = true;
  void makeRequest() async {

    try {
      var response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Heute_KoL/subst_001.htm'));
      if (response.statusCode == 200) {
        htmlCode = response.body;
        VertretungsplanCrawler vpc1 =
            new VertretungsplanCrawler(htmlCode: htmlCode);
        dateToday = vpc1.getCurrentDate();
        lastEdited = vpc1.getLastEdited();
        informationToday = vpc1.getInformation();
        vertretungenHeute = await vpc1.getVertretungen();

        /*
        vpc1.getAffectedClasses();
        */
        load = true;
        setState(() {});
      } else {

        load = false;
      }

      response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Morgen_KoL/subst_001.htm'));
      if (response.statusCode == 200) {
        htmlCode = response.body;
        VertretungsplanCrawler vpc2 =
            new VertretungsplanCrawler(htmlCode: htmlCode);
        dateTomorrow = vpc2.getCurrentDate();
        informationTomorrow = vpc2.getInformation();
        vertretungenMorgen = await vpc2.getVertretungen();

        /*
        vpc2.getAffectedClasses();
        */
        load = true;
        setState(() {});
      } else {
        load = false;

      }
    } catch (e) {
      load = false;
    }

    if (!load) {
      final snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.white,
            ),
            Container(
              child:
                  Text('Laden fehlgeschlagen', style: TextStyle(fontSize: 17)),
              margin: EdgeInsets.only(left: 15),
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
      child: Column(children: [
        Text('Stand: $lastEdited'),
        Expanded(
            child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                height: 50,
                child: Text(dateToday),
              )
            ])),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return VertretungListTile(vertretungenHeute![
                      index]); // you can add your available item here
                },
                childCount: vertretungenHeute!.length,
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Container(
                height: 50,
                child: Text(dateTomorrow),
              )
            ])),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return VertretungListTile(vertretungenMorgen![
                      index]); // you can add your available item here
                },
                childCount: vertretungenMorgen!.length,
              ),
            )
          ],
          physics: const AlwaysScrollableScrollPhysics(),
        )),
      ]),
      //color: Colors.red,
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

