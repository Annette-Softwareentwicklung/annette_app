import 'package:annette_app/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnnetteButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const AnnetteButton({Key? key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: Design.annetteColor,
        //color: Theme.of(context).accentColor,
        child: Text(
          this.text,
          style: TextStyle(
              color:
                  Theme.of(context).floatingActionButtonTheme.foregroundColor),
        ),
        onPressed: onPressed);
  }
}
