import 'package:annette_app/setClass.dart';
import 'package:annette_app/vertretung/vertretungsTab.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/guide.dart';
import 'homeworkTab.dart';
import 'settingsTab.dart';
import 'addDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

/**
 * Diese Klasse gibt das Scaffold-Widget mit der Menüleiste am Boden zurück und ruft die
 * entsprechenden Tabs auf, also quasi die "Standard-Benutzeroberfläche" die erscheint,
 * wenn man die App öffnet.
 */
class NavigationController extends StatefulWidget {
  NavigationController({Key? key}) : super(key: key);

  @override
  NavigationControllerState createState() => NavigationControllerState();
}

class NavigationControllerState extends State<NavigationController> {
  int tabIndex = 0;
  final GlobalKey<HomeworkTabState> homeworkTabAccess =
      GlobalKey<HomeworkTabState>();

  /**
   * Diese Methode sorgt dafür, dass bei erstmaligem Starten der App
   * ein Leitfaden angezeigt wird. In der Datei "data.txt" ist gespeichert (0 oder 1),
   * ob der Leitfaden angezeigt werden muss.
   * Die Textdatei wird ausgelesen und dann bei Bedarf der Leitfaden angezeigt.
   * Wenn der Leitfaden zurückgibt, dass dieser erfolgreich beendet wurde,
   * wird 1 in die Datei geschrieben, sodass der Leitfaden beim nächsten Starten
   * nicht wieder angezeigt wird.
   *
   * Quellen zum schreiben von .txt Dateien:
   * https://flutter.dev/docs/cookbook/persistence/reading-writing-files
   * https://www.kindacode.com/article/flutter-how-to-read-and-write-text-files/
   */
  void showTest() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return GuideDialog(
        );
      },
    );
  }

  void showGuide() async {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<int> _readData() async {
      try {
        final _path = await _getPath();
        final _file = File('$_path/data.txt');

        String contents = await _file.readAsString();
        return int.parse(contents);
      } catch (e) {
        return 0;
      }
    }

    Future<void> _writeData() async {
      final _path = await _getPath();
      final _myFile = File('$_path/data.txt');
      await _myFile.writeAsString(1.toString());
    }

    if (await _readData() == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) {
          return GuideDialog(
            onCompleted: () async => await _writeData(),
          );
        },
      );
    }
  }

  /**
   * Beim Initialisieren wird showGuide() aufgerufen, um bei Bedarf den Leitfaden anzuzeigen.
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(Duration.zero, () {
      showGuide();
    });
  }


  /**
   * Anzeige des Scaffolds mit "bottomNavigationBar". Je nach dem welcher Tab in der Menüleiste
   * ausgewählt ist, wird der entsprechende Tab angezeigt.
   * Der "floatingActionButton" öffnet den Dialog zum Hinzufügen von Hausaufgaben.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (tabIndex == 0) ? Text('Vertretungsplan') : (tabIndex == 1) ? Text('Hausaufgaben') : (tabIndex == 2) ? Text('Stundenplan') : Text('Sonstiges'),
      ),
      body:
      (tabIndex == 0) ? VertretungsTab() : (tabIndex == 1) ? HomeworkTab(key: homeworkTabAccess,) : (tabIndex == 2) ? SetClass() : SettingsTab(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            useSafeArea: true,
            builder: (context) {
              return AddDialog(
                onTaskCreated: (newTask) {
                  if (tabIndex == 1) {
                    homeworkTabAccess.currentState!.insertTask(newTask);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Vertretung',
            icon: Icon(Icons.list),
          ),

          BottomNavigationBarItem(
            label: 'Hausaufgaben',
            icon: Icon(Icons.list),
          ),

          BottomNavigationBarItem(
            label: 'Stundenplan',
            icon: Icon(Icons.list),
          ),

          BottomNavigationBarItem(
            label: 'Sonstiges',
            icon: Icon(Icons.more_horiz_rounded),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
        currentIndex: tabIndex,
      ),
    );
  }
}
