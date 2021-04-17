import 'dart:io';
import 'package:annette_app/onlineFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../widgetParts.dart';

class ClassicTimetable extends StatefulWidget {
  @override
  _ClassicTimetableState createState() => _ClassicTimetableState();
}

class _ClassicTimetableState extends State<ClassicTimetable> {
  late String currentClassNumber;
  OnlineFiles onlineFiles = new OnlineFiles();
  bool finished = false;
  bool error = false;
  late String tempUrl;


  void getCurrentClassNumber() async {
    error = false;

    if(await onlineFiles.initialize() == false) {
      setState(() {
        error = true;
        finished = false;
        showError();
      });
   } else

    {
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


      int classesNumber = onlineFiles.allClasses().indexOf(currentClass) + 1;
      currentClassNumber = classesNumber.toString().padLeft(5, '0');
      try{
        var response = await http.get(
            Uri.http('janw.bplaced.net', 'annetteapp/data/stundenplanPfad.txt'));
        if (response.statusCode == 200) {
          tempUrl = response.body;
        }

          setState(() {
        finished = true;
      });} catch(e) {
        setState(() {
          showError();
          finished = false;
          error = true;
        });
      }
    }

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
              'https://www.annettegymnasium.de/$tempUrl/c$currentClassNumber.htm',
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
                    errorInternetContainer(context),

                  ]),
                )
              ]),
          onRefresh: () async {
            Future.delayed(Duration.zero, () {
              getCurrentClassNumber();
            });
          });
    } else {
      return Center(
        child: Column(children: [CupertinoActivityIndicator(),Text('Laden ...')],mainAxisSize: MainAxisSize.min,),
      );
    }
  }
}
