import 'package:flutter/material.dart';

/// Diese Klasse beinhaltet einen (zunächst leeren) Stadard-Scaffold.
/// Der Titel des Scaffolds wird als String und der Inhalt wird als Widget per Parameter übergeben.
/// Zusätzlich können Parameter für einen FloatingActionButton übergeben werden,
/// welcher dann enstprechend auch mit Funktion eingefügt wird.
///
/// Dieser Standard-Scaffold wird benötigt, um ein sich in einem Container befindenes Feature,
/// zum Beispiel das auswählen des Zeitplans, als eigenes "Fenster" anzeigen zu können.
class DefaultScaffold extends StatelessWidget {

  final String? title;
  final Widget? content;

  ///Für einen optionalen FloatingActionButton
  final String? fabLabel;
  final Icon? fabIcon;
  final Function? onFabPressed;

  DefaultScaffold(
      {this.title,
      this.content,
      this.fabLabel,
      this.fabIcon,
        this.onFabPressed
      });

  @override
  Widget build(BuildContext context) {
    if (fabLabel == null) {
      ///Falls kein FloatingActionButton gefordert:
      return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: SafeArea(child: content!),//SafeArea(child: content),
      );
    } else {
      /// Falls FloatingActionButton gefordert:
      return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => onFabPressed!(),
          label: Text(fabLabel!),
          icon: Icon(Icons.add_circle),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(child: content!),
      );
    }
  }
}
