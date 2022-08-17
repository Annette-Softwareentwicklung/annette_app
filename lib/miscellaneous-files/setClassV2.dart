import 'dart:async';
import 'dart:convert';
import 'package:annette_app/custom_widgets/errorInternetContainer.dart';
import 'package:annette_app/data/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:annette_app/services/api_client/api_client.dart';

class SetClassV2 extends StatefulWidget {
  final bool isInGuide;
  final VoidCallback onButtonPressed;

  const SetClassV2(
      {super.key, required this.isInGuide, required this.onButtonPressed});

  @override
  _SetClassV2State createState() => _SetClassV2State();
}

class _SetClassV2State extends State<SetClassV2> {
  late final List<String> classOptions;
  bool loading = true;

  ///Initialisieren der Page
  ///
  ///Hier wird unter Anderem der [ApiClient] initialisiert.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    //Result decoden und weiterverwenden
    ApiClient.preloadClasses().then(
      (result) => setState(() {
        classOptions = (jsonDecode(result) as List<dynamic>).cast<String>();
        loading = false;
      }),
    );
  }

  bool errorInternet = false;
  bool showFinishedConfiguration = false;
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else
      //Falls keine Internetverbindung besteht (wird im Code überprüft) Fehler anzeigen
      return errorInternet
          ? ErrorInternetContainer(
              onRefresh: () {
                errorInternet = false;
                load();
              },
              //onButtonPressed: () {},
            )
          : Scaffold(
              body: SafeArea(
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(children: [
                    //Zentrum des Screens, hier wird die Auswahl der Klasse angezeigt
                    Center(
                      child: ClassSelector(
                          classOptions: classOptions,
                          onClassSelected: (selectedClass) =>
                              {classSelected(selectedClass)}),
                    ),

                    //Obere Leiste
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 70.0,
                        child: Column(children: [
                          Container(
                            child: Text(
                              'App konfigurieren',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 15),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          //Schritt 1 abgeschlossen: finished == true; showFinishedConfiguration == false
                          //Schritt 1 und 2 abgeschlossen: finished == true; showFinishedConfiguration == true
                          if (!showFinishedConfiguration)
                            Row(
                              children: [
                                if (!finished)
                                  Expanded(
                                      flex: 2,
                                      child: LinearProgressIndicator(
                                        minHeight: 2,
                                        backgroundColor:
                                            (Theme.of(context).brightness ==
                                                    Brightness.dark)
                                                ? Colors.grey
                                                : Design.annetteColorLight
                                                    .withOpacity(0.5),
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Design.annetteColor,
                                      )),
                                if (finished)
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 2,
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Design.annetteColor,
                                    ),
                                  ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: (!finished)
                                              ? Colors.grey
                                              : (Theme.of(context).brightness ==
                                                      Brightness.dark)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Design.annetteColor,
                                          width: 2),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 2,
                                    color: Design.annetteColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Design.annetteColor, width: 2),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 2,
                                    color: (!showFinishedConfiguration)
                                        ? Colors.grey
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Design.annetteColor,
                                  ),
                                ),
                              ],
                            )
                        ]))
                  ]),
                ),
              ),
            );
  }

  classSelected(selectedClass) {
    print(selectedClass);
  }
}

class ClassSelector extends StatelessWidget {
  final List<String> classOptions;
  final Function(String) onClassSelected;

  var selectedClass = "none";

  ClassSelector(
      {required this.classOptions, required, required this.onClassSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: 0),
          itemExtent: 60,
          children: List.generate(
            classOptions.length,
            (index) => Align(
              alignment: Alignment.center,
              child: Text(
                classOptions[index],
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          onSelectedItemChanged: (index) => {
            selectedClass = classOptions[index],
          },
        ),
        SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: () => {onClassSelected(selectedClass)},
          child: Text("Weiter "),
        ),
      ],
    );
  }
}
