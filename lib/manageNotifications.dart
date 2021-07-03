/// Diese Datei beinhaltet alle notwendigen Methoden zum Verwalten der System-Benachrichigungen.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'parseTime.dart';

//Initialisierung des PlugIns für den Zugriff auf die System-Bnachrichigungen.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Diese Methode löscht alle ausstehenden System-Benachrichigungen.
void cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

/// Diese Methode löscht die ausstehende System-Benachrichigung einer bestimmten Hausaufgabe,
/// deren Id per Parameter übergeben wird.
void cancelNotification(int? pTaskId) async {
  List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();


  for (int i = 0; i < pendingNotificationRequests.length; i++) {
    if (pendingNotificationRequests[i].payload == pTaskId.toString()) {
      await flutterLocalNotificationsPlugin.cancel(pendingNotificationRequests[i].id);
      print('cancel $i');
    }
  }
}

/// Diese Methode plant eine System-Benachrichigungen für die Zukunft für einen bestimmten Zeitpunkt.
/// Das Fach (für den Titel), die Notizen und die Frist (beides für den Inhalt) werden per Parameter übergeben.
/// Ebenso wird der Zeitpunkt, wann die System-Benachrichigung erscheinen soll, übergeben.
void scheduleNotification(int pId, String pTitle, String? pNotes,
    String pDeadlineTime, DateTime pNotificationTime) async {
  String payload = pId.toString();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'notification', 'notification', 'Channel for notification',
    importance: Importance.max,
    priority: Priority.high,
    //showWhen: false
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  String? title = pTitle + '-Hausaufgabe';
  if (pTitle == 'Sonstiges') {
    title = pNotes;
  }
  String body = 'Bis: ' + parseTimeToUserOutput(pDeadlineTime, pNotificationTime);
  if (pNotes != null && pTitle != 'Sonstiges') {
    body = body + ', Notizen: ' + pNotes;
  }
  await flutterLocalNotificationsPlugin.zonedSchedule(
    pId,
    title,
    body,
    tz.TZDateTime.from(pNotificationTime, tz.local),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    payload: payload,
  );
}

/// Diese Methode zeigt sofort eine System-Benachrichigungen an.
/// Das Fach (für den Titel), die Notizen und die Frist (beides für den Inhalt) werden per Parameter übergeben.
void showNotification(
    int pId, String pTitle, String? pNotes, String pDeadlineTime) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'notification', 'notification', 'Channel for notification',
    importance: Importance.max,
    priority: Priority.high,
    //showWhen: false
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  String? title = pTitle + '-Hausaufgabe';

  if (pTitle == 'Sonstiges') {
    title = pNotes;
  }

  String body = 'Bis: ' + parseTimeToUserOutput(pDeadlineTime);
  if (pNotes != null && pTitle != 'Sonstiges') {
    body = body + ', Notizen: ' + pNotes;
  }

  await flutterLocalNotificationsPlugin.show(
      pId, title, body, platformChannelSpecifics,
      payload: pId.toString());
}
