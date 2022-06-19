

import 'package:annette_app/page_news/newsTab.dart';
import 'package:annette_app/timetable/timetableTab.dart';
import 'package:annette_app/miscellaneous-files/update.dart';
import 'package:annette_app/vertretung/vertretungsTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import '../data/design.dart';
import '../homework/homeworkTab.dart';
import '../misc-pages/settingsTab.dart';
import '../homework/addDialog.dart';
import 'dart:async';

/// Diese Klasse gibt das Scaffold-Widget mit der Menüleiste am Boden zurück und ruft die
/// entsprechenden Tabs auf, also quasi die "Standard-Benutzeroberfläche" die erscheint,
/// wenn man die App öffnet.
///
class NavigationController extends StatefulWidget {
  NavigationController({Key? key}) : super(key: key);

  @override
  NavigationControllerState createState() => NavigationControllerState();
}

class NavigationControllerState extends State<NavigationController> {
  int tabIndex = 0;

  final ScrollPhysics bottomNavigationBarScrollPhysics = new ScrollPhysics();

  final GlobalKey<HomeworkTabState> homeworkTabAccess =
    GlobalKey<HomeworkTabState>();

  /// um wet code zu vermeiden, wird eine LUT (Look up table) verwendet, hierbei dient ist der Index der zugehörige Tabindex
  /// !!! Der Grund, wieso an Index 1 von [tabIndexToTab] null steht, ist dass dort der HomeworkTab angezeigt werden muss.
  /// Dieser Tab benötigt das [homeworkTabAccess] Attribut als Key-value. !!!
  List tabIndexToTab = [NewsTab(), VertretungsTab(), null, TimetableTab(), null, SettingsTab()];
  List tabIndexToTitle = ["Neuigkeiten", "Vertretungsplan", "Hausaufgaben", "Stundenplan", "Klausurplan", "Sonstiges"];

  /// Initialisieren
  @override
  void initState() {
    super.initState();

    ///Homescreen Quickactions
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      print(shortcutType);

      ///Homescreen Quickaction "Stundenplan"
      if (shortcutType == 'timetable') {
        print('timetable');
        setState(() {
          tabIndex = 2;
        });
      }

      ///Homescreen Quickaction "Neue newHomework"
      if (shortcutType == 'newHomework') {
        print('newHomework');
        new Future.delayed(Duration.zero, () {
          showNewHomeworkDialog();
        });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'newHomework',
          localizedTitle: 'Neue Hausaufgabe',
          icon: 'icon_add'),
      const ShortcutItem(
          type: 'timetable', localizedTitle: 'Stundenplan', icon: 'icon_plan'),
    ]);

    Future.delayed(Duration(seconds: 1),
        () {
            update(context);
        }
    );
  }




  /// Anzeige des Scaffolds mit "bottomNavigationBar". Je nach dem welcher Tab in der Menüleiste
  /// ausgewählt ist, wird der entsprechende Tab angezeigt.
  /// Der "floatingActionButton" öffnet den Dialog zum Hinzufügen von Hausaufgaben.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: Design.standardPagePadding,
                    right: Design.standardPagePadding,
                    top: Design.standardPagePadding * 2,
                    bottom: Design.standardPagePadding * 0.8),
                alignment: Alignment.centerLeft,
                child: Text(
                    tabIndexToTitle[tabIndex],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )
                )
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Design.standardPagePadding * 0.5),
                      child: (tabIndex == 2) /// sonderfall, da der key-value [homeworkTabAccess] noch eingegeben werden muss
                          ? HomeworkTab(
                        key: homeworkTabAccess,
                      )
                          : tabIndexToTab[tabIndex]
                  )
              )
            ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Design.annetteColor,
        child: Icon(Icons.add),
        onPressed: () {
          showNewHomeworkDialog();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: bottomBar(context),
    );
  }

  /// Öffnet das Dialogfenster zum Erstellen einer neuen Hausaufgabe
  void showNewHomeworkDialog() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width > 500) ? ((MediaQuery.of(context).size.width - 500) / 2) : 0,
          ),
          child: Container(
          height: (MediaQuery.of(context).size.height < 758)
              ? 638
              : (MediaQuery.of(context).size.height > 1000) ? 700 : MediaQuery.of(context).size.height - 120,

          decoration: new BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark)
                ?  Color.fromRGBO(
                    40, 40, 40, 1)
                : Color.fromRGBO(248, 248, 253, 1),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          child: AddDialog(
            onTaskCreated: (newTask) {
              if (tabIndex == 1) {
                homeworkTabAccess.currentState!.insertTask(newTask);
              }
            },
          ),
        ),),
      );
  }

  Widget bottomBar(BuildContext context) {
    return BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        unselectedFontSize: 9,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Design.annetteColor,
        items: [
          BottomNavigationBarItem(
            label: 'Aktuelles',
            icon: Icon(CupertinoIcons.exclamationmark),
            //icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Vertretung',
            icon: Icon(CupertinoIcons.rectangle_grid_1x2),
            //icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Hausaufgaben',
            icon: Icon(CupertinoIcons.square_list),
            //icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Stundenplan',
            icon: Icon(CupertinoIcons.calendar),
            //icon: Icon(Icons.date_range_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Klausurplan',
            icon: Icon(CupertinoIcons.calendar_circle),
            //icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Sonstiges',
            icon: Icon(CupertinoIcons.ellipsis),
            //icon: Icon(Icons.more_horiz_rounded),
          ),
        ],
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
        currentIndex: tabIndex,
    );
  }
}

Widget bottomBarItem(
    {required IconData icon, required String text, required int index}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(text),
      ],
    ),
  );
}
