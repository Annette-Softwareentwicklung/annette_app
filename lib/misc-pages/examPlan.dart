import 'dart:io';
import 'package:annette_app/custom_widgets/errorContainer.dart';
import 'package:annette_app/fundamentals/progressPercentage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class ExamPlan extends StatefulWidget {
  @override
  _ExamPlanState createState() => _ExamPlanState();
}

class _ExamPlanState extends State<ExamPlan> {
  int selectedClass = 0;
  bool error = false;
  late firebase_storage.FirebaseStorage firebaseStorage;

  int getCurrentClass() {
    String s = (GetStorage().read('configuration')).toLowerCase();
    s = s.substring(s.indexOf('c:') + 2, s.indexOf(';', s.indexOf('c:')));
    if (s == 'q1') {
      return 1;
    } else if (s == 'q2') {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseStorage = firebase_storage.FirebaseStorage.instance;
    selectedClass = getCurrentClass();
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
                setState(() {
                  selectedClass = value!;
                });
              },
              groupValue: selectedClass,
            ),
            margin: EdgeInsets.only(bottom: 15),
          ),
          Expanded(
              child: (!error)
                  ? ChangeNotifierProvider<ProgressPercentage>(
                      create: (BuildContext context) {
                        ProgressPercentage percentage = ProgressPercentage(0);
                        return percentage;
                      },
                      child: new ShowExamPlan(
                          plan:
                              'klausur_${(selectedClass == 1) ? 'q1' : (selectedClass == 2) ? 'q2' : 'ef'}'),
                    )
                  : ErrorInternetContainer(
                      onRefresh: () {
                        //changePlan(selectedClass);
                      },
                    )),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      )),
      padding: EdgeInsets.all(15),
    );
  }
}


class ShowExamPlan extends StatefulWidget {
  final String plan;
  const ShowExamPlan({Key? key, required this.plan}) : super(key: key);

  @override
  _ShowExamPlanState createState() => _ShowExamPlanState();
}

class _ShowExamPlanState extends State<ShowExamPlan> {
  Future<File> downloadFile(String plan) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$plan.pdf');
    firebase_storage.DownloadTask _task = firebase_storage
        .FirebaseStorage.instance
        .ref('$plan.pdf')
        .writeToFile(downloadToFile);

    _task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      Provider.of<ProgressPercentage>(context, listen: false).setValue(
         ((snapshot.bytesTransferred / snapshot.totalBytes) * 100).round());
    });
    return downloadToFile;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: downloadFile(widget.plan),
      builder: (context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: /*Container(
              width: 100,
              height: 100,
              color: (snapshot.data!.path.contains('klausur_q1')) ? Colors.blue : (snapshot.data!.path.contains('klausur_q2')) ? Colors.green : Colors.red,
            )*/ new PDFView(filePath: snapshot.data!.path),
          );
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: LinearProgressIndicator(
                  value:
                  (context.watch<ProgressPercentage>().value).toDouble() /
                      100,
                ),
                width: 300,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    'Lade Klausurplan: ${(context.watch<ProgressPercentage>().value)}%'),
              ),
            ],
          ),
        );
      },
    );
  }
}


