/// Diese Datei beinhaltet den Leitfaden, welcher beim ersten Start der App den Benutzer durch die Einstellungen führt.
import 'dart:io';
import 'package:annette_app/setClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:path_provider/path_provider.dart';

class IntroductionScreen extends StatefulWidget {
  final VoidCallback onFinished;
  IntroductionScreen({Key? key, required this.onFinished}) : super(key: key);

  @override
  IntroductionScreenState createState() {
    return new IntroductionScreenState();
  }
}

class IntroductionScreenState extends State<IntroductionScreen> {
  List<Widget> _pages = [
    ImageTitleTextModel(
      image: AssetImage('images/icon.png'),
      title: 'Annette App',
      demoImage: false,
      text:
          'Die rundum erneuerte Annette App bietet zahlreiche Funktionen, um dir deinen Schulalltag zu erleichtern.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage('images/vertretungDemo.png'),
      title: 'Vertretungsplan',
      text:
          'Individuell nach deinen Kursen gefiltert, damit du direkt informiert bist.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage('images/homeworkDemo.png'),
      title: 'Hausaufgaben',
      text:
          'Es war noch nie so leicht, Hausaufgaben zu erstellen und zu verwalten. Automatische Facherkennung anhand deines Stundenplans und Push-Benachrichtigungen zur Erinnerung sind nur zwei von vielen nützlichen Features.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage('images/timetableDemo.png'),
      title: 'Stundenplan',
      text:
          'Dein individueller Stundenplan inklusive Pausenzeiten. Dank automatischer Erkennung der aktuellen Stunde lässt sich der Stundenplan schnell ablesen, und du musst nicht erst deinen Kurs in der großen Übersicht suchen.',
    ),
  ];
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildPageView(),
            (currentPageIndex == (_pages.length - 1))
                ? Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 50.0,
                    child: Container(
                      child: TextButton(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            //height: 50,
                            constraints: BoxConstraints(
                              minWidth: 150,
                              minHeight: 50,
                              maxWidth: 200,
                            ),
                            //width: 150,
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Theme.of(context).accentColor
                                  : Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              'Konfigurieren',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => SetClass(
                                  isInGuide: true,
                                  onButtonPressed: () async {
                                    widget.onFinished();

                                    Future<String> _getPath() async {
                                      final _dir =
                                          await getApplicationDocumentsDirectory();
                                      return _dir.path;
                                    }

                                    Future<void> _writeData() async {
                                      final _path = await _getPath();
                                      final _myFile = File('$_path/data.txt');
                                      await _myFile.writeAsString(1.toString());
                                    }

                                    await _writeData();
                                  })));
                        },
                      ),

                      /*CupertinoButton(
                        color: Colors.blue,
                        child: Text('Konfigurieren',style: TextStyle(color:
                        (Theme.of(context).brightness == Brightness.dark) ? Colors.black : Colors.white,
                        ),),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => SetClass(
                                  isInGuide: true,
                                  onButtonPressed: () async {
                                    widget.onFinished();

                                    Future<String> _getPath() async {
                                      final _dir =
                                          await getApplicationDocumentsDirectory();
                                      return _dir.path;
                                    }

                                    Future<void> _writeData() async {
                                      final _path = await _getPath();
                                      final _myFile = File('$_path/data.txt');
                                      await _myFile.writeAsString(1.toString());
                                    }

                                    await _writeData();
                                  })));
                        },
                      ),*/

                      alignment: Alignment.center,
                      width: double.infinity,
                    ),
                  )
                : Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CirclePageIndicator(
                        selectedDotColor: Colors.blue,
                        size: 13,
                        selectedSize: 13,
                        // dotSpacing: 15,
                        onPageSelected: (value) {
                          pageController.animateToPage(value,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },

                        dotColor: Colors.grey,
                        itemCount: _pages.length,
                        currentPageNotifier: _currentPageNotifier,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _buildPageView() {
    return Container(
      child: PageView.builder(
          itemCount: _pages.length,
          controller: pageController,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: _pages[index]);
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
            setState(() {
              currentPageIndex = index;
            });
          }),
    );
  }
}

class ImageTitleTextModel extends StatelessWidget {
  final ImageProvider<Object> image;
  final String title;
  final String text;
  final bool demoImage;

  const ImageTitleTextModel(
      {Key? key,
      required this.image,
      required this.title,
      required this.text,
      required this.demoImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Container(
                width: (demoImage) ? 350 : 200,
                height: (demoImage) ? 350 : 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (Theme.of(context).brightness == Brightness.dark &&
                              demoImage)
                          ? Colors.blue
                          : Colors.grey,
                      width: (Theme.of(context).brightness == Brightness.dark)
                          ? 2
                          : 1),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: image, fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              constraints: BoxConstraints(
                minHeight: (demoImage) ? 150 : 0,
              ),
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
