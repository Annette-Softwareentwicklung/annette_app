import 'package:annette_app/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../custom_widgets/errorInternetContainer.dart';
import '../data/links.dart';

///
/// Diese Function holt sich die Messages von der API.
/// Die Nachrichten sind als Markdown Dateien abgespeichert
/// Bei der API handelt es sich um die private Next.js Annette-App-Api der Annette-Entwickelt-Software AG
///

///
/// Der Code für die Ansicht für alle Neuigkeiten
///

class NewsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  bool error = false;

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
  Widget build(BuildContext context) {
    if (error) {
      return ErrorInternetContainer(
        onRefresh: () {
          setState(() {
            error = false;
          });
        },
      );
    }

    return SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {},
            child: WebView(
                initialUrl: 'https://www.annettegymnasium.de/',
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) => CupertinoActivityIndicator(),
                onWebResourceError: (e) {
                  setState(() {
                    showError();
                    error = true;
                  });
                })));
  }
}
