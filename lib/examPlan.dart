import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExamPlan extends StatefulWidget {
  @override
  _ExamPlanState createState() => _ExamPlanState();
}

class _ExamPlanState extends State<ExamPlan> {
  late String currentClass;
  bool finished = false;
  bool error = false;

  void getCurrentClass() async {
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
        contents = contents.substring(
            contents.indexOf('c:') + 2, contents.indexOf(';'));
        if (contents == 'Q1' || contents == 'Q2') {
          return contents;
        } else {
          return 'EF';
        }
      } catch (e) {
        return 'EF';
      }
    }

    currentClass = (await _readData()).toLowerCase();
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
    getCurrentClass();
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Center(
        child: WebView(
          initialUrl:
              'http://janw.bplaced.net/annetteapp/data/klausur_$currentClass.pdf',
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (progress) => CupertinoActivityIndicator(),
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
                      child: Text(
                        'Fehler\nZum Aktualisieren ziehen',
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30),
                    )
                  ]),
                )
              ]),
          onRefresh: () async {
            Future.delayed(Duration.zero, () {
              getCurrentClass();
            });
          });
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }
}
