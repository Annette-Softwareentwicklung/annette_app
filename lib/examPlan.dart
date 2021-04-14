import 'dart:io';
import 'package:annette_app/widgetParts.dart';
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
  int selectedClass = 0;
  bool finished = false;
  bool error = false;
  late WebViewController controller;
  late String url;

  Future<int> getCurrentClass() async {
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

    String s =  (await _readData()).toLowerCase();
    if(s == 'q1') {
      return 1;
    } else if(s == 'q2') {
      return 2;
    } else {
      return 0;
    }
  }

  void changePlan (int pClass) {
    setState(() {
      finished = false;
      error = false;
    });

    if(pClass == 1) {
      currentClass = 'q1';
    } else if(pClass == 2) {
      currentClass = 'q2';
    } else {
      currentClass = 'ef';
    }
    selectedClass = pClass;
    url = 'http://janw.bplaced.net/annetteapp/data/klausur_$currentClass.pdf';
    controller.loadUrl(url);
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

  void load() async{
      if(await getCurrentClass() == 1) {
        currentClass = 'q1';
      } else if(await getCurrentClass() == 2) {
        currentClass = 'q2';
      } else {
        currentClass = 'ef';
      }
      selectedClass = await getCurrentClass();
      url = 'http://janw.bplaced.net/annetteapp/data/klausur_$currentClass.pdf';
      setState(() {
        finished = true;
      });
    }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return

      Container(child: Center(child:Column(children: [
      Container(child: CupertinoSlidingSegmentedControl<int>(
      children: {0: Container(child: Text('EF'), padding: EdgeInsets.symmetric(horizontal: 30),),1: Text('Q1'),2: Text('Q2'), },
        onValueChanged: (int? value) {
          changePlan(value!);},
        groupValue: selectedClass,
      ),margin: EdgeInsets.only(bottom: 15),),
        Expanded(child:

        (finished) ?
        Center(
          child: WebView(
            initialUrl:
url            ,          javascriptMode: JavascriptMode.unrestricted,
            onProgress: (progress) => CupertinoActivityIndicator(),
              onWebViewCreated: (WebViewController webViewController) {
                controller = webViewController;},
            onWebResourceError: (e) {
              setState(() {
                showError();
                error = true;
                finished = false;
              });
            },
          ),
        ) : (error) ?
       RefreshIndicator(
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
              changePlan(selectedClass);
            });
          }): Center(
        child: CupertinoActivityIndicator(),
      )



        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,)), padding: EdgeInsets.all(15),);

  }
}
