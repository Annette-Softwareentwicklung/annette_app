import 'package:annette_app/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

///
/// Diese Function holt sich die Messages von der API.
/// Die Nachrichten sind als Markdown Dateien abgespeichert
/// Bei der API handelt es sich um die private Next.js Annette-App-Api der Annette-Entwickelt-Software AG
///

Future<String> getMarkdownData() async {

  http.Response apiResponse = await http.get(Uri.parse("https://annette-entwickelt-software-api.vercel.app/api/annette_app/dateien/nachricht"));

  return apiResponse.body;

}

///
/// Der Code für die Ansicht für alle Neuigkeiten
///


class NewsTab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _NewsTabState();

}

class _NewsTabState extends State<NewsTab> {

  static final String loadingString = "-#.Loading.#-";
  String markdownNewsData = loadingString;

  initializeMarkdownNewsData() async {

    String response = await getMarkdownData();
    setState(() {
      markdownNewsData = response;
    });
  }

  @override
  void initState() {
    super.initState();

    initializeMarkdownNewsData();
  }

  @override
  Widget build(BuildContext context) {

    if (markdownNewsData == loadingString) { /// Inhalt ist noch nicht geladen worden
      return CupertinoActivityIndicator();
    }

    return SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            String response = await getMarkdownData();
            setState(() {
              markdownNewsData = response;
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Design.standardPagePadding),
              child: MarkdownBody(
                onTapLink: (String string1, String? url, String string3) {
                  if (url == null) return;

                  launchUrlString(url);

                },
                data: markdownNewsData
              )
            )
          ),

        )
    );
  }



}
