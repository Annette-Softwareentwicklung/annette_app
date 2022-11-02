import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:annette_app/custom_widgets/errorInternetContainer.dart';
import 'package:annette_app/data/design.dart';
import 'package:annette_app/services/timetable_scraper/annette_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:annette_app/services/api_client/api_client.dart';

// ignore: must_be_immutable
class SetClassV2 extends StatefulWidget {
  final bool isInGuide;
  final VoidCallback onButtonPressed;

  var selectedClass = "5A";

  SetClassV2(
      {super.key, required this.isInGuide, required this.onButtonPressed});

  @override
  _SetClassV2State createState() => _SetClassV2State();
}

class _SetClassV2State extends State<SetClassV2> {
  //Die gewählten Kurse des Nutzers
  HashMap<int, String> classList = HashMap<int, String>();

  //Alle auswählbaren Klassen
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
    } else {
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
              //Schützt das UI vor Notches oder anderen Elementen, die es verdecken könnten
              body: SafeArea(
                //Verschiedene Widgets ohne Layout relations
                child: Stack(children: <Widget>[
                  Container(
                      //height: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child:
                          //Zentrum des Screens, hier wird die Auswahl der Klasse angezeigt
                          Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 170,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: finished
                                  ? Expanded(
                                      child: CourseOptionsSelector(
                                          courseChanged, widget.selectedClass,
                                          () {
                                      saveConfig();
                                      Navigator.of(context).pop();
                                    }))
                                  : ClassSelector(
                                      classOptions: classOptions,
                                      onClassSelected: (selectedClass) =>
                                          {classSelected(selectedClass)}),
                            ),
                          ],
                        ),
                      )),
                  //Obere Leiste: ein Positioned-Widget ist komplett vom restlichen
                  //Layout getrennt, dieses wird oben positioniert
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 35.0,
                      child: Column(children: [
                        Container(
                          //etwas Spacing, damit der Text nicht so nah am Rand ist
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                            child: Text(
                              'App konfigurieren',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
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
            );
    }
  }

  void courseChanged(id, selection) {
    classList[id] = selection;
    print("$id: $selection");
  }

  void classSelected(selectedClass) {
    setState(() {
      finished = true;
    });
    widget.selectedClass = selectedClass;
    GetStorage().write("class", selectedClass);

    print(selectedClass);
  }

  void saveConfig() {
    GetStorage().write("class", widget.selectedClass);
    GetStorage().write("courses", this.classList.values);
    print(GetStorage().read("courses"));
  }
}

class CourseOptionsSelector extends StatefulWidget {
  final Function(int, String?) onCourseSelected;
  final Function() onFinished;

  final String selectedCourse;
  CourseOptionsSelector(
      this.onCourseSelected, this.selectedCourse, this.onFinished);

  @override
  State<StatefulWidget> createState() {
    return CourseOptionsSelectorState(
        onCourseSelected, selectedCourse, this.onFinished);
  }
}

class CourseOptionsSelectorState extends State {
  CourseOptionsSelectorState(this.onChanged, this.classId, this.onFinished);

  final Function(int, String?) onChanged;
  final Function() onFinished;
  final String classId;

  HashMap<String, List<String>> options = HashMap<String, List<String>>();

  bool loading = true;

  void load() async {
    var optionsTemp = jsonDecode(await ApiClient.fetchChoiceOptions(classId));
    options = HashMap.from(optionsTemp?.map((key, value) {
      List<dynamic> values = List.from(value);
      return MapEntry(
          key.toString(),
          values.map((theValue) {
            return theValue.toString();
          }).toList());
    }));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var el in options.keys.toList()..sort())
                    (classId.toUpperCase() == "EF" ||
                            classId.toUpperCase() == "Q1" ||
                            classId.toUpperCase() == "Q2")
                        ? CourseWidget(options.keys.toList().indexOf(el), el,
                            options[el]!..add("Freistunde"), onChanged)
                        : CourseWidget(options.keys.toList().indexOf(el), el,
                            options[el]!, onChanged),
                  AnnetteButton(
                      text: "Moin Leute Trymacs hier", onPressed: onFinished),
                ],
              ),
            ),
          );
  }
}

class CourseWidget extends StatefulWidget {
  CourseWidget(this.id, this.text, this.options, this.onChanged);

  final int id;
  final String text;
  final List<String> options;
  final Function(int, String?) onChanged;

  void _onChanged(String? value) {
    onChanged(this.id, value);
  }

  @override
  State<StatefulWidget> createState() {
    return CourseWidgetState(text, options, _onChanged);
  }
}

class CourseWidgetState extends State<CourseWidget> {
  CourseWidgetState(this.text, this.options, this.onChanged);

  final String text;
  final List<String>? options;
  final Function(String?) onChanged;

  String selected = "";

  void _onChanged(String? value) {
    setState(() {
      selected = value!;
    });
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: Text(text)),
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton(
                    value: selected == "" ? null : selected,
                    items:
                        options?.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _onChanged,
                    hint: Text("Wähle eine Option")),
              ),
            ]));
  }
}

class ClassSelector extends StatelessWidget {
  final List<String> classOptions;
  final Function(String) onClassSelected;

  var selectedClass = "none";

  ClassSelector({required this.classOptions, required this.onClassSelected});

  @override
  Widget build(BuildContext context) {
    //Verhindern, dass das Column-Widget den ganzen Screen beansprucht
    return SizedBox(
      height: 150,
      child: Column(
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
      ),
    );
  }
}
