import 'dart:io';
import 'package:annette_app/classesMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClassicTimetable extends StatefulWidget {
  @override
  _ClassicTimetableState createState() => _ClassicTimetableState();
}

class _ClassicTimetableState extends State<ClassicTimetable> {
  late String currentClassNumber;

  bool finished = false;
  bool error = false;

  void getCurrentClassNumber() async {
    error = false;
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<String> _readData() async {
      try {
        final _path = await _getPath();
        final _file = File('$_path/configuration.txt');

        String contents = await _file.readAsString();
        return contents.substring(
            contents.indexOf('c:') + 2, contents.indexOf(';'));
      } catch (e) {
        return '5A';
      }
    }

    String currentClass = await _readData();
    int classesNumber = getAllClasses().indexOf(currentClass) + 1;
    currentClassNumber = classesNumber.toString().padLeft(5, '0');
    setState(() {
      finished = true;
    });
  }

  void showError() {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
          Container(
            child: Text('Laden fehlgeschlagen', style: TextStyle(fontSize: 17)),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentClassNumber();
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Center(
        child: WebView(
          initialUrl:
              'https://www.annettegymnasium.de/SP/stundenplan_oL/c/P9/c$currentClassNumber.htm',
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (e) {
            setState(() {
              showError();
              error = true;
              finished = false;
            });
          },
        ),
      );
    } else if (error) {
      return RefreshIndicator(
          child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate.fixed([
          Container(

          child: Text('Fehler\nZum Aktualisieren ziehen',textAlign: TextAlign.center,),
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30),
      )
    ]),
                ) ]),



          onRefresh: () async {
            Future.delayed(Duration.zero, () {
getCurrentClassNumber();            });
          });
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }
}
