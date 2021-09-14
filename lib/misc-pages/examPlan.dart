import 'dart:io';
import 'package:annette_app/custom_widgets/errorContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:connectivity_plus/connectivity_plus.dart';


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

  void showErrorSnackBar(BuildContext context) {
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
            child: Text('Keine Internetverbindung', style: TextStyle(fontSize: 17)),
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

  Future<File> downloadFile(String plan) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$plan.pdf');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if(await downloadToFile.exists()) {
        showErrorSnackBar(context);
        return downloadToFile;
          }
          setState(() {
            error = true;
          });
          return downloadToFile;
    } else {
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('$plan.pdf')
            .writeToFile(downloadToFile);
      } on firebase_core.FirebaseException catch (e) {
        if (e.code == 'object-not-found')
          try {
            await firebase_storage.FirebaseStorage.instance
                .ref('/examError/$plan.pdf')
                .writeToFile(downloadToFile);
          } on firebase_core.FirebaseException catch (e) {
            print(e.code);
            setState(() {
              error = true;
            });
          }
      }

      return downloadToFile;
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseStorage = firebase_storage.FirebaseStorage.instance;
    selectedClass = getCurrentClass();
  }

  late List<PDFView> pdfViews;

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
                  error = false;
                  selectedClass = value!;
                });
              },
              groupValue: selectedClass,
            ),
            margin: EdgeInsets.only(bottom: 15),
          ),
          Expanded(
              child: (!error)
                  ? FutureBuilder(
                      future: downloadFile((selectedClass == 1)
                          ? 'klausur_q1'
                          : (selectedClass == 2)
                              ? 'klausur_q2'
                              : 'klausur_ef'),
                      builder: (context, AsyncSnapshot<File?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return PDFView(filePath: snapshot.data!.path);
                        }
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator.adaptive(),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text('Lade Klausurplan...'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : ErrorInternetContainer(
                      onRefresh: () {
                        setState(() {
                          error = false;
                        });
                      },
                    )),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      )),
      padding: EdgeInsets.all(15),
    );
  }
}
