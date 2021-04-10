import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClassicTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: WebView(
            initialUrl: 'https://www.annettegymnasium.de/SP/stundenplan_oL/c/P9/c00001.htm',
            javascriptMode: JavascriptMode.unrestricted,
          ),
    );
  }
}