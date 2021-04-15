import 'package:flutter/material.dart';

Container errorInternetContainer(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Icon(
          Icons.warning_rounded,
          size: 100,
          color: Theme.of(context).accentColor,
        ),
        Text('Keine Internetverbindung.\nZum Aktualisieren ziehen.'),
      ],
      mainAxisSize: MainAxisSize.min,
    ),
    margin:
        EdgeInsets.only(top: (MediaQuery.of(context).size.height - 350) / 2),
  );
}
