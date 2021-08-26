import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../custom_widgets/errorInternetContainer.dart';

class ShowWebview extends StatefulWidget {
  final String url;
  ShowWebview({required this.url});
  @override
  _ShowWebviewState createState() => _ShowWebviewState();
}

class _ShowWebviewState extends State<ShowWebview> {
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
      return
                  ErrorInternetContainer(
                    onRefresh: () {
                      setState(() {
                        error = false;
                      });
                    },
                  )
                ;
    } else {
      return Center(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (progress) => CupertinoActivityIndicator(),
          onWebResourceError: (e) {
            setState(() {
              showError();
              error = true;
            });
          },
        ),
      );
    }
  }
}
