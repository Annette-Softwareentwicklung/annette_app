import 'package:annette_app/database/taskDbInteraction.dart';
import 'package:annette_app/parseTime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'classes/task.dart';
import 'manageNotifications.dart';
import 'navigationController.dart';
import 'theme.dart';
//import 'package:timezone/data/latest.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translation.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

/**
 * Die Datei main.dart mit der Methode "main()"ist der Einstiegspunkt der App.
 *
 * Außerdem wird hier das Plugin für die Systembenachrichtigungen initialisiert.
 */
/*final FlutterLofinal FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
calNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();*/
final navigationControllerAccess = GlobalKey<NavigationControllerState>();
/**
 * Diese Methode wird als erstes beim Starten der App ausgeführt.
 */
void main() async {
  ///Initialisierung des Plugins für die Systembenachrichtigungen
  WidgetsFlutterBinding.ensureInitialized();

  ///notifications
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'homework',
        channelName: 'homework',
        channelDescription: 'Notification channel for homework tasks',
        defaultColor: Colors.blue,
        ledColor: Colors.white)
  ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      print("error");
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().actionStream.listen((receivedNotification) async {
    try {
      if (receivedNotification.buttonKeyPressed == 'oneHour') {
        Task task = await databaseGetSpecificTask(receivedNotification.id!);
        DateTime newTime = DateTime.now().add(new Duration(hours: 1));

        try {
          scheduleNotification(receivedNotification.id!, task.subject!,
              task.notes, task.deadlineTime!, newTime);
          task.notificationTime = newTime.toString();
          print(task.notificationTime);
          databaseUpdateTask(task);

        } catch (e) {
          print('error: $e');
        }
      } else if (receivedNotification.buttonKeyPressed == 'nextAfternoon') {
        Task task = await databaseGetSpecificTask(receivedNotification.id!);
        DateTime newTime = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
        newTime = newTime.add(new Duration(days: 1, hours: 16));

        try {
          scheduleNotification(receivedNotification.id!, task.subject!,
              task.notes, task.deadlineTime!, newTime);
          task.notificationTime = newTime.toString();
          print(task.notificationTime);
          databaseUpdateTask(task);

        } catch (e) {
          print('error: $e');
        }
      } else if (receivedNotification.buttonKeyPressed == 'done') {
        databaseDeleteTask(receivedNotification.id!);
        if (navigationControllerAccess.currentState != null) {
          if (navigationControllerAccess.currentState!.tabIndex == 1) {
            navigationControllerAccess
                .currentState!.homeworkTabAccess.currentState!
                .deleteFromList(receivedNotification.id!, true);
          }
        }
        print('deleted');
      } else {
        helper(receivedNotification.payload!['id']);
      }
    } catch (e) {}
    print(receivedNotification);
  });

  //AwesomeNotifications().cancelAll();

  /*await flutterLocalNotificationsPlugin.initialize(initializationSettings,
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
  }*/

  /*var initializationSettingsAndroid = AndroidInitializationSettings('icon');
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
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
*/
  ///Starten der App
  runApp(MyApp());
}

void helper(String? payload) async {
  bool load = false;
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

      if (navigationControllerAccess.currentState!.tabIndex == 1) {
        load = true;
        print('tr4ue');
      }
    } catch (e) {
      load = false;
    }
  } while (!load);
}

/**
 * Einstiegspunkt der App.
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      themeMode: ThemeMode.system,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: NavigationController(key: navigationControllerAccess),
    );
  }
}
