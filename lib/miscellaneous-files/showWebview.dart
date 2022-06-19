import 'package:flutter/cupertino.dart';
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
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (progress) => CupertinoActivityIndicator(),
          onWebResourceError: (e) {
            setState(() {
              error = true;
            });
          },
        ),
      );
    }
  }
}
