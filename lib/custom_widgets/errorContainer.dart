import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/data/assets.dart';

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
                ? Theme.of(context).accentColor
                : Colors.blueAccent,
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

class FatalErrorContainer extends StatelessWidget {
  final int errorCode;
  const FatalErrorContainer({Key? key, required this.errorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                boxShadow: (Theme.of(context).brightness ==
                    Brightness.dark)
                    ? null
                    : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(
                        0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage(assetPaths.iconImagePath),
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 50, bottom: 100),
                child: Text('Ein unerwarteter Fehler ist aufgetreten. Versuche die App neu zu starten, ansonsten kontaktiere bitte den Support: appentwicklung.jan@gmx.de\nFehlercode: #${errorCode.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15
                  ),))
          ],
        ));
  }
}

