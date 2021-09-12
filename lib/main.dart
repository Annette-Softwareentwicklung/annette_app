import 'package:annette_app/custom_widgets/errorContainer.dart';
import 'package:annette_app/firebase/authenticationUI.dart';
import 'package:annette_app/fundamentals/preferredTheme.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'miscellaneous-files/translation.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/assets.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final navigationControllerAccess = GlobalKey<NavigationControllerState>();

late bool guide;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

  ///Initialisierung des Plugins für die Systembenachrichtigungen
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

  tz.initializeTimeZones();
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
                      child: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.userChanges(),
                          builder: (context, snapshot) {

    if (snapshot.hasError) {
                              return Scaffold(
                                  body: FatalErrorContainer());
                            }
                            if (snapshot.data != null) {
                              print('3');
                              Future.delayed(Duration.zero, () =>Navigator.of(context).popUntil((route) => route.isFirst));
                              return NavigationController(
                                  key: navigationControllerAccess);
                            } else {
                              print('4');
                              Future.delayed(Duration.zero, () =>Navigator.of(context).popUntil((route) => route.isFirst));
                              return IntroductionScreen();
                              //SetClass(
                              //                                   isInGuide: true,
                              //                                   onButtonPressed: () async {
                              //                                     widget.onFinished();
                              //                                     GetStorage().write('introScreen', false);
                              //                                   })

                              //Navigator.of(context).pop();
                              //                                   Navigator.of(context).pushReplacement(
                              //                                       new MaterialPageRoute(
                              //                                           builder: (BuildContext context) =>
                              //                                               NavigationController(
                              //                                                   key:
                              //                                                   navigationControllerAccess)));
                            }
                          })),
                ),
              ),
            )));
  }
}
