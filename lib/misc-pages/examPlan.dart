import 'dart:io';
import 'package:annette_app/custom_widgets/errorInternetContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ExamPlan extends StatefulWidget {
  @override
  _ExamPlanState createState() => _ExamPlanState();
}

class _ExamPlanState extends State<ExamPlan> {
  late File file;
  late String currentClass;
  int selectedClass = 0;
  bool finished = false;
  bool error = false;

  Future<int> getCurrentClass() async {
    error = false;

    String s = (GetStorage().read('configuration')).toLowerCase();
    s = s.substring(s.indexOf('c:') + 2, s.indexOf(';', s.indexOf('c:')));
    print(s);
    if (s == 'q1') {
      return 1;
    } else if (s == 'q2') {
      return 2;
    } else {
      return 0;
    }
  }

  void changePlan(int pClass) async {
    setState(() {
      finished = false;
      error = false;
    });

    if (pClass == 1) {
      currentClass = 'q1';
    } else if (pClass == 2) {
      currentClass = 'q2';
    } else {
      currentClass = 'ef';
    }
    selectedClass = pClass;
    try {
      file = await loadFromNetwork('klausur_$currentClass');
      setState(() {
        finished = true;
      });
    } catch (e) {
      setState(() {
        finished = false;
        error = true;
      });
    }
  }

  void load() async {
    if (await getCurrentClass() == 1) {
      currentClass = 'q1';
    } else if (await getCurrentClass() == 2) {
      currentClass = 'q2';
    } else {
      currentClass = 'ef';
    }
    selectedClass = await getCurrentClass();
    try {
      file = await loadFromNetwork('klausur_$currentClass');
      setState(() {
        finished = true;
      });
    } catch (e) {
      setState(() {
        finished = false;
        error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: [
          Container(
            child: CupertinoSlidingSegmentedControl<int>(
              children: {
                0: Container(
                  child: Text('EF'),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                ),
                1: Text('Q1'),
                2: Text('Q2'),
              },
              onValueChanged: (int? value) {
                changePlan(value!);
              },
              groupValue: selectedClass,
            ),
            margin: EdgeInsets.only(bottom: 15),
          ),
          Expanded(
              child: (finished)
                  ? Center(
                      child: PDFView(
                        filePath: file.path,
                      ),
                    )
                  : (error)
                      ? ErrorInternetContainer(
                          onRefresh: () {
                            changePlan(selectedClass);
                          },
                        )
                      : Center(
                          child: Column(
                            children: [
                              CupertinoActivityIndicator(),
                              Text('Lade Klausurplan ...'),
                            ],
                            mainAxisSize: MainAxisSize.min,
                          ),
                        )),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      )),
      padding: EdgeInsets.all(15),
    );
  }

  Future<File> loadFromNetwork(String plan) async {
    final response = await http
        .get(Uri.http('janw.bplaced.net', 'annetteapp/data/$plan.pdf'));
    final bytes = response.bodyBytes;
    return _storeFile(plan, bytes);
  }

  Future<File> _storeFile(plan, bytes) async {
    final filename = '$plan.pdf';
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
