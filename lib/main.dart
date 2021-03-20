import 'dart:async';

import 'package:annette_app/vertretunsplanCrawler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String htmlCode;
  void makeRequest() async {
    Future<String> fetchAlbum() async {
      final response = await http.get(Uri.https(
          'www.annettegymnasium.de', 'SP/vertretung/Heute_KoL/subst_001.htm'));

      if (response.statusCode == 200) {
        htmlCode = response.body;

        VertretungsplanCrawler vpc = new VertretungsplanCrawler(htmlCode: htmlCode);
        String test = vpc.getCurrentDate();
        vpc.getVertretungen();
      } else {
        throw Exception('Failed to load album');
      }
    }

    await fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    makeRequest();
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: RefreshIndicator(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              color: Colors.red,
              width: 500,
              height: 300,
              child: Text((htmlCode == null) ? 'test' : htmlCode),
            ),
          ],
        ),
        color: Colors.red,
        backgroundColor: Colors.tealAccent,
        strokeWidth: 5,
        onRefresh: () {
          return Future.delayed(Duration(seconds: 2), () {
            setState(() {
              print('test');
            });
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
