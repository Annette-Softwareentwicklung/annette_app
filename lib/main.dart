/*import 'package:annette_app/database/timetableUnitDbInteraction.dart';
import 'package:annette_app/fundamentals/preferredTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'data/design.dart';
import 'miscellaneous-files/dismissKeyboard.dart';
import 'misc-pages/introductionScreen.dart';
import 'miscellaneous-files/navigationController.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'miscellaneous-files/translation.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final navigationControllerAccess = GlobalKey<NavigationControllerState>();

late bool guide;

void main() async {
  ///Initialisierung des Plugins für die Systembenachrichtigungen
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      helper(payload);

      debugPrint('notification payload: ' + payload);
    }
  });
  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    helper(notificationAppLaunchDetails!.payload);
  }

  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

  tz.initializeTimeZones();

  ///
  /// Da die Annette-App sich mit dem Annette-Gymnasium beschäftigt, muss
  /// eigentlich nur die Zeitzone Europe/Berlin betrachtet werden oder?
  ///
  /// Der Grund wieso ich das geändert habe ist weil der vorherige Code einen
  /// Fehler geworfen hat
  ///

  tz.setLocalLocation(tz.getLocation("Europe/Berlin"));

  await GetStorage.init();

  ///Migration zu neuem Speichersystem "GetStorage"
  try {
    Future<String> _getPath() async {
      final _dir = await getApplicationDocumentsDirectory();
      return _dir.path;
    }

    Future<void> _deleteData(String s) async {
      final _path = await _getPath();
      final _myFile = File('$_path/$s');
      await _myFile.delete();
    }

    Future<String?> _readData(String s) async {
      try {
        final _path = await _getPath();
        final _file = File('$_path/$s');
        String contents = await _file.readAsString();
        return contents;
      } catch (e) {
        return null;
      }
    }

    final storage = GetStorage();
    if (await _readData('configuration.txt') != null &&
        storage.read('configuration') == null) {
      storage.write('configuration', await _readData('configuration.txt'));
      storage.write('timetableVersion', DateTime(0, 0).toString());
    }
    if (await _readData('data.txt') != null &&
        storage.read('introScreen') == null) {
      storage.write('introScreen', false);
      _deleteData('data.txt');
    }
    if (await _readData('configuration.txt') != null) {
      _deleteData('configuration.txt');
    }
    if (await _readData('data.txt') != null) {
      _deleteData('data.txt');
    }
    if (await _readData('version.txt') != null) {
      _deleteData('version.txt');
    }
    if (await _readData('order.txt') != null) {
      _deleteData('order.txt');
    }
  } catch (e) {
    print(e);
  }
  final storage = GetStorage();

  if (storage.read('configuration') != null) {
    if ((storage.read('configuration').contains('Q1') ||
            storage.read('configuration').contains('Q2')) &&
        (storage.read('changingLkSubject') == null ||
            storage.read('changingLkWeekNumber') == null)) {
      try {
        storage.write(
            'changingLkSubject',
            (await databaseGetAllTimeTableUnit())
                .firstWhere((element) => element.subject!.contains('LK')));
        storage.write('changingLkWeeknumber', 1);
      } catch (e) {
        print(e);
      }
    }
  }

  ///Leitfaden beim ersten Öffnen der App
  var introScreen = GetStorage().read('introScreen');
  if (introScreen == null || introScreen == true) {
    guide = true;
  } else {
    guide = false;
  }

  runApp(MyApp());
}

///Öffnet die Detailansicht, wenn auf eine Benachrichtigung geklickt wird.
void helper(String? payload) async {
  bool load;
  do {
    try {
      await Future.delayed(Duration.zero, () async {
        navigationControllerAccess.currentState!.setState(() {
          navigationControllerAccess.currentState!.tabIndex = 1;
        });
        await Future.delayed(Duration(milliseconds: 500), () {
          navigationControllerAccess
              .currentState!.homeworkTabAccess.currentState!
              .showDetailedView(int.tryParse(payload!));
        });
      });

      load = true;
    } catch (e) {
      load = false;
    }
  } while (!load);
}

/// Einstiegspunkt der App.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
        child: ChangeNotifierProvider<PreferredTheme>(
            create: (BuildContext context) {
              int? temp = GetStorage().read('preferredTheme');
              if (temp == null) {
                temp = 2;
              }
              return PreferredTheme(temp);
            },
            child: Builder(
              builder: (context) => MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  CupertinoLocalizationsDelegate(),
                ],
                supportedLocales: [
                  const Locale('de', ''), // German
                ],
                debugShowCheckedModeBanner: false,
                themeMode: (context.watch<PreferredTheme>().value == 0)
                    ? ThemeMode.light
                    : (context.watch<PreferredTheme>().value == 1)
                        ? ThemeMode.dark
                        : ThemeMode.system,
                theme: Design.lightTheme,
                darkTheme: Design.darkTheme,
                home: Builder(
                  builder: (context) => Center(
                    child: (guide)
                        ? IntroductionScreen(
                            onFinished: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NavigationController(
                                              key:
                                                  navigationControllerAccess)));
                            },
                          )
                        : NavigationController(key: navigationControllerAccess),
                  ),
                ),
              ),
            )));
  }
}*/

import 'dart:convert';
import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'homescreenWidget/FlutterWidgetData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WidgetKit.reloadAllTimelines();
    WidgetKit.reloadTimelines('test');

    final data = FlutterWidgetData('Hello From Flutter');
    final resultString = await WidgetKit.getItem('testString', 'group.com.annetteapp');
    final resultBool = await WidgetKit.getItem('testBool', 'group.com.annetteapp');
    final resultNumber = await WidgetKit.getItem('testNumber', 'group.com.annetteapp');
    final resultJsonString = await WidgetKit.getItem('testJson', 'group.com.annetteapp');

    var resultData;
    if(resultJsonString != null) {
      resultData = FlutterWidgetData.fromJson(jsonDecode(resultJsonString));
    }

    WidgetKit.setItem('testString', 'Hello World', 'group.com.annetteapp');
    WidgetKit.setItem('testBool', false, 'group.com.annetteapp');
    WidgetKit.setItem('testNumber', 10, 'group.com.annetteapp');
    WidgetKit.setItem('testJson', jsonEncode(data), 'group.com.annetteapp');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iOS Widget Showcase'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter a text 🙏🏻',
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextField(
                      controller: textController
                  )),
              ElevatedButton(onPressed: () {
                //WidgetKit.setItem('widgetData', jsonEncode(FlutterWidgetData(textController.text)), 'group.com.annetteapp');
                WidgetKit.setItem('widgetData', jsonEncode(TimeTableUnit(dayNumber: 1,lessonNumber: 1,room: 'A101',id: 0,subject: 'Deutsch')), 'group.com.annetteapp');
                WidgetKit.reloadAllTimelines();
                print('reload');
              }, child: Text('Update Widget 🥳')),
              ElevatedButton(onPressed: () {
                WidgetKit.removeItem('widgetData', 'group.com.annetteapp');
                WidgetKit.reloadAllTimelines();
              }, child: Text('Remove Widget Data ⚠️'))
            ],
          ),
        ),
      ),
    );
  }
}

