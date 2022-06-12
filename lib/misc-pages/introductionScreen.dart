import 'dart:ui';
import 'package:annette_app/data/assets.dart';
import 'package:annette_app/miscellaneous-files/setClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../data/design.dart';

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
      image: AssetImage(assetPaths.iconImagePath),
      title: 'Annette App',
      demoImage: false,
      text:
          'Die rundum erneuerte Annette App bietet zahlreiche Funktionen, um dir deinen Schulalltag zu erleichtern.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage(assetPaths.vertretungsDemoPath),
      title: 'Vertretungsplan',
      text:
          'Individuell nach deinen Kursen gefiltert - damit du direkt informiert bist.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage(assetPaths.homeworkDemoPath),
      title: 'Hausaufgaben',
      text:
          'Es war noch nie so leicht, Hausaufgaben zu erstellen und zu verwalten. Automatische Facherkennung anhand deines Stundenplans und Push-Benachrichtigungen zur Erinnerung sind nur zwei von vielen nützlichen Features.',
    ),
    ImageTitleTextModel(
      demoImage: true,
      image: AssetImage(assetPaths.timetableDemoPath),
      title: 'Stundenplan',
      text:
          'Dein individueller Stundenplan inklusive Pausenzeiten. Dank automatischer Erkennung der aktuellen Stunde lässt sich der Stundenplan schnell ablesen, und du musst nicht erst deinen Kurs in der großen Übersicht suchen.',
    ),
    ImageTitleTextModel(
      demoImage: false,
      //image: AssetImage(assetPaths.iconImagePath),
      title: 'Annette Entwickelt Software',
      text: 'Diese App wird von der Annette-Entwickelt-Software-AG mit Leidenschaft entwickelt :).'
    )
  ];
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int currentPageIndex = 0;



  void helperOrientation() {
    if (MediaQueryData.fromWindow(window).size.shortestSide < 500) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  void initState() {
    super.initState();
    helperOrientation();
  }

  @override
  dispose() {
   SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

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
                    bottom:
                        (MediaQuery.of(context).size.height < 815) ? 0 : 50.0,
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
                                  : Design.annetteColor,
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
                                    GetStorage().write('introScreen', false);
                                  })));
                        },
                      ),
                      alignment: Alignment.center,
                      width: double.infinity,
                    ),
                  )
                : Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom:
                        (MediaQuery.of(context).size.height < 815) ? 20 : 50.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CirclePageIndicator(
                        selectedDotColor: Design.annetteColor,
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
  final ImageProvider<Object>? image;
  final String title;
  final String text;
  final bool demoImage;

  const ImageTitleTextModel(
      {Key? key,
      this.image,
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
              child: image != null ?
              Container(
                width: (demoImage) ? 350 : 200,
                height: (demoImage) ? 350 : 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (Theme.of(context).brightness == Brightness.dark &&
                              demoImage)
                          ? Design.annetteColor
                          : Colors.grey,
                      width: (Theme.of(context).brightness == Brightness.dark)
                          ? 2
                          : 1),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: image!, fit: BoxFit.fitHeight),
                ),
              ): Container()
            ),
            Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height < 700) ? 0 : 18,
                  bottom: (MediaQuery.of(context).size.height < 700) ? 18 : 18,
      ),
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
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              constraints: BoxConstraints(
                minHeight: (!demoImage)
                    ? 0
                    : (MediaQuery.of(context).size.height < 700)
                        ? 115
                        : 150,
                maxWidth: 400,
                maxHeight:
                    (MediaQuery.of(context).size.height < 700) ? 115 : 1000,
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
