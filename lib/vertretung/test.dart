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

  final LinearGradient redYellowGradient = LinearGradient(colors: [
    Color.fromRGBO(236, 112, 111, 1),
    Color.fromRGBO(234, 157, 73, 1)
  ]);
  final LinearGradient lightGradient = LinearGradient(colors: [
    Color.fromRGBO(74, 149, 236, 1),
    Color.fromRGBO(110, 160, 200, 1)
  ]);
  final LinearGradient darkGradient = LinearGradient(colors: [
    Color.fromRGBO(44, 119, 206, 1),
    Color.fromRGBO(90, 140, 180, 1)
  ]);

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

        if (vertretungenHeute != null) {
          vertretungenHeute!.sort((a, b) {
            return a.lesson!.compareTo(b.lesson!);
          });
        }
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
        if (vertretungenMorgen != null) {
          vertretungenMorgen!.sort((a, b) {
            return a.lesson!.compareTo(b.lesson!);
          });
        }
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
            Container(
              child: Text('Stand: $lastEdited'),
              padding: EdgeInsets.all(2),
            ),
            Expanded(
                child:

                CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      dateToday,
                                      style: TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        if (informationToday.length != 0)
                                          Text(
                                            'Infos zum Tag:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        else
                                          Text(
                                            'Keine weiteren Nachrichten',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (informationToday.length != 0)
                                          Text(
                                            informationToday.join('\n'),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      //color: Colors.black12,
                                      gradient:
                                      (Theme.of(context).brightness == Brightness.dark)
                                          ? darkGradient
                                          : lightGradient,
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(color: Theme.of(context).accentColor, width: 1),
                                    ),
                                    width: double.infinity,
                                    //margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                  )
                                ]),
                            margin:
                            EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              //    border: Border.all(color: Theme.of(context).accentColor, width: 1),
                            ),
                          ),
                        ])),
                    if (vertretungenHeute!.length != 0)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return VertretungListTile(vertretungenHeute![index]);
                          },
                          childCount: vertretungenHeute!.length,
                        ),
                      )else
                      SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            Container(
                              child: Center(
                                  child: Text(
                                    'Keine Vertretungen',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              padding: EdgeInsets.all(10),
                              margin:
                              EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                //border: Border.all(color: Theme.of(context).accentColor, width: 1),
                              ),
                            ),
                          ])),
                    SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      dateTomorrow,
                                      style: TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        if (informationTomorrow.length != 0)
                                          Text(
                                            'Infos zum Tag:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        else
                                          Text(
                                            'Keine weiteren Nachrichten',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (informationTomorrow.length != 0)
                                          Text(
                                            informationTomorrow.join('\n'),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      gradient:
                                      (Theme.of(context).brightness == Brightness.dark)
                                          ? darkGradient
                                          : lightGradient,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity,
                                  )
                                ]),
                            margin:
                            EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              //    border: Border.all(color: Theme.of(context).accentColor, width: 1),
                            ),
                          ),
                        ])),
                    if (vertretungenMorgen!.length != 0)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return VertretungListTile(vertretungenMorgen![
                            index]); // you can add your available item here
                          },
                          childCount: vertretungenMorgen!.length,
                        ),
                      ),
                    if (vertretungenMorgen!.length == 0)
                      SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            Container(child:Center(
                                child: Text(
                                  'Keine Vertretungen',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              padding: EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Theme.of(context).accentColor, width: 1),
                              ),

                              margin:
                              EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
                              height: 50,

                            ),

                          ])),
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
