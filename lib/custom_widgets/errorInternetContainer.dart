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
        Text('Du scheinst nicht mit dem Internet verbunden zu sein.\nZum Aktualisieren ziehen.', textAlign: TextAlign.center,),

        //Text('Fehler beim Verbindungsaufbau.\nBitte überprüfe deine Internet-Verbindung!\nZum Aktualisieren ziehen.', textAlign: TextAlign.center,),
      ],
      mainAxisSize: MainAxisSize.min,
    ),
    margin:
        EdgeInsets.only(top: (MediaQuery.of(context).size.height - 350) / 2),
  );
}
