import 'package:annette_app/setClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Widget> _pages = [
    ImageTitleTextModel(
      image: AssetImage('images/icon.png'),
      title: 'Annette App',
      text: 'Die rundum erneuerte Annette App bietet zahlreiche Funktionen, um dir deinen Schulalltag zu erleichtern.',
    ),
    ImageTitleTextModel(
      image: AssetImage('images/vertretung.png'),
      title: 'Vertretungsplan',
      text: 'Individuell nach deinen Kursen gefiltert, damit du direkt informiert bist.',
    ),
    ImageTitleTextModel(
      image: AssetImage('images/icon.png'),
      title: 'Hausaufgaben',
      text: 'Es war noch nie so leicht Hausaufgaben zu erstellen und zu verwalten. Automatische Facherkennung anhand deines Stundenplans und Push-Benachrichtigungen zur Erinnerung sind nur zwei von vielen nützlichen Features.',
    ),
    ImageTitleTextModel(
      image: AssetImage('images/icon.png'),
      title: 'Stundenplan',
      text: 'Dein individueller Stundenplan inklusive Pausenzeiten. Dank automatischer Erkennung der aktuellen Stunde lässt sich der Stundenplan schnell ablesen, und du musst nicht erst deinen Kurs in der großen Übersicht suchen.',
    ),
  ];
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildPageView(),
            (currentPageIndex == (_pages.length - 1))
                ? Positioned(

              left: 0.0,
              right: 0.0,
              bottom: 50.0,
              child: Container(child: CupertinoButton(
                color: Colors.blue,
                child: Text('Konfigurieren'),
                onPressed: () {
                  /*Navigator
                      .of(context)
                      .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => SetClass(isInGuide: true, onButtonPressed: () {})));*/
                  Navigator
                      .of(context)
                      .push(new MaterialPageRoute(builder: (BuildContext context) => SetClass(isInGuide: true, onButtonPressed: () {})));
                },
              ),alignment: Alignment.center, width: double.infinity,),
            )
                :
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:  CirclePageIndicator(
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
      color: Colors.white,
    ));
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

  const ImageTitleTextModel(
      {Key? key, required this.image, required this.title, required this.text})
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
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: image, fit: BoxFit.fill),
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
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Spacer(),
            Spacer(),
          ],
        ),),
    );
  }
}
