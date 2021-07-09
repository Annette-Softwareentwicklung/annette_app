import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorInternetContainer extends StatelessWidget {
  final VoidCallback onRefresh;
  const ErrorInternetContainer({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            Icons.warning_rounded,
            size: 100,
            color: Theme.of(context).accentColor,
          ),
          Text(
            'Du scheinst nicht mit dem Internet verbunden zu sein.',
            textAlign: TextAlign.center,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: OutlinedButton(
                onPressed: () {
                  onRefresh();
                },
                child: Text('Erneut versuchen')),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      margin:
          EdgeInsets.only(top: (MediaQuery.of(context).size.height - 500) / 2),
    );
  }
}
