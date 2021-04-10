
/**
 * Diese Datei beinhaltet den Leitfaden, welcher beim ersten Start der App den Benutzer durch die Einstellungen führt.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuideDialog extends StatefulWidget {
  final VoidCallback? onCompleted;
  const GuideDialog({Key? key, this.onCompleted}) : super(key: key);

  @override
  _GuideDialogState createState() => _GuideDialogState();
}

class _GuideDialogState extends State<GuideDialog> {
  final controller = PageController(initialPage: 0);

  /**
   * Erstellen des PageViews, welcher den Leitfanden mit dessen einzelnen Seiten anzeigt
   */
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 700, maxWidth: 350),
        //padding: EdgeInsets.all(15),
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: [
            WelcomeScreen(
              onNextPage: () => controller.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.bounceIn),
            ),
            Center(
              child: FinishedScreen(
                onButtonPressed: () {
                  widget.onCompleted!();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * Dieses Widget beinhaltet die 1. Seite des Leitfadens.
 * Hier findet sich eine Erklärung der Funktionen der App.
 */
class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onNextPage;

  WelcomeScreen({this.onNextPage});


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
            controller: ScrollController(initialScrollOffset: 0),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                        height: 150,
                        width: 150,
                        image: AssetImage('images/icon.png'),
                        fit: BoxFit.fill)),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    'Hausaufgaben Organizer',textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                    controller: ScrollController(initialScrollOffset: 0),
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey[200] : Colors.grey[600],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Text('Herzlich Willkommen!',style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center),
                        Text('Swipe einfach immer weiter nach links durch den Leitfaden, um alle Einstellungen vorzunehmen.',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        Text(
                          'Verwalte und erstelle ganz unkompliziert neue Hausaufgaben. Das Fach, die Erledigungs-Frist und sogar der Zeitpunkt der Benachrichtigung werden dabei automatisch ermittelt. Neben dem Hinzufügen von Notizen kannst du selbsverständlich auch manuell alle Parameter beim Erstellen einer neuen Aufgabe bestimmen, und du hast zusätzlich die Möglichkeit, unter der Kategorie "Sonstiges" fach-unspezifische Aufgaben anzulegen.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center),
                      ]),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        Text('Swipe',
                            style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.double_arrow,
                          size: 50,
                          color: Colors.blue,
                        ),
                        Spacer(),
                      ],
                    ))
              ],
            )));
  }
}




/**
 * Dieses Widget beinhaltet die letzte Seite des Leitfadens
 * mit dem "Jetzt Starten"-Button.
 */
class FinishedScreen extends StatelessWidget {
  final VoidCallback? onButtonPressed;
  FinishedScreen({Key? key, this.onButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        //alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(initialScrollOffset: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // mainAxisSize: MainAxisSize.min,
              children: [
                //Spacer(flex: 1),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 200,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Fertig.',
                    style: TextStyle(fontSize: 23),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Viel Spaß beim Benutzen der App!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                CupertinoButton(
                  color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).floatingActionButtonTheme.backgroundColor : Theme.of(context).accentColor,
                  child: Text('Los geht\'s', style: TextStyle(color: Theme.of(context).floatingActionButtonTheme.foregroundColor),),
                  onPressed: () {
                    onButtonPressed!();
                    Navigator.of(context).pop();
                  },
                  //child: Text('Los geht\'s'),
                ),
                //Spacer(flex: 1),
              ],
            )));
  }
}
