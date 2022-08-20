import 'package:annette_app/data/links.dart';
import 'package:annette_app/miscellaneous-files/onlineFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../miscellaneous-files/timetableURL.dart';
import '../custom_widgets/errorInternetContainer.dart';

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

    if (await onlineFiles.initialize() == false) {
      setState(() {
        error = true;
        finished = false;
        showError();
      });
    } else {
      String currentClass;
      try {
        String contents = GetStorage().read('configuration');
        currentClass = contents.substring(
            contents.indexOf('c:') + 2, contents.indexOf(';'));
      } catch (e) {
        currentClass = '5A';
      }

      int classesNumber = onlineFiles.allClasses().indexOf(currentClass) + 1;
      currentClassNumber = classesNumber.toString().padLeft(5, '0');
      try {
        tempUrl = (await getTimetableURL())!;

        setState(() {
          finished = true;
        });
      } catch (e) {
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
    super.initState();
    getCurrentClassNumber();
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Center(
        child: WebView(
          initialUrl:
              'https://${Links.timetableUrl}/$tempUrl/c$currentClassNumber.htm',
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
      return ErrorInternetContainer(
        onRefresh: () => getCurrentClassNumber(),
      );
    } else {
      return Center(
        child: Column(
          children: [CupertinoActivityIndicator(), Text('Laden ...')],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }
  }
}
