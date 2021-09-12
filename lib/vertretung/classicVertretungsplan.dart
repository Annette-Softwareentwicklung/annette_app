import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../custom_widgets/errorContainer.dart';

class ClassicVertretungsplan extends StatefulWidget {
  @override
  _ClassicVertretungsplanState createState() => _ClassicVertretungsplanState();
}

class _ClassicVertretungsplanState extends State<ClassicVertretungsplan> {
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
    } else {
      return Center(
        child: Flex(
          direction:
              (MediaQuery.of(context).orientation == Orientation.landscape)
                  ? Axis.horizontal
                  : Axis.vertical,
          children: [
            Expanded(
              child: WebView(
                initialUrl:
                    'https://www.annettegymnasium.de/SP/vertretung/Heute_KoL/subst_001.htm',
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) => CupertinoActivityIndicator(),
                onWebResourceError: (e) {
                  setState(() {
                    showError();
                    error = true;
                  });
                },
              ),
            ),
            Expanded(
              child: WebView(
                initialUrl:
                    'https://www.annettegymnasium.de/SP/vertretung/Morgen_KoL/subst_001.htm',
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) => CupertinoActivityIndicator(),
                onWebResourceError: (e) {
                  setState(() {
                    showError();
                    error = true;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
