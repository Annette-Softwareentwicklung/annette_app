import 'package:flutter/material.dart';

import '../data/design.dart';

class ErrorInternetContainer extends StatelessWidget {
  final VoidCallback onRefresh;

  const ErrorInternetContainer({Key? key, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(),
          Icon(
            Icons.wifi_off_sharp,
            size: 150,
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Theme.of(context).colorScheme.secondary
                : Design.annetteColor,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
              'Du scheinst nicht mit dem Internet verbunden zu sein. Bitte überprüfe deine Verbindung.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            margin: EdgeInsets.only(bottom: 20, top: 30),
          ),
          OutlinedButton(
            onPressed: () {
              onRefresh();
            },
            child: Text('Erneut versuchen'),
          ),
          Spacer(),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
