/// Diese Methode erstellt aus einem String (z.B. HH:MM:SS) ein Objekt des Tys Duration.
/// Quelle: https://stackoverflow.com/questions/54852585/how-to-convert-a-duration-like-string-to-a-real-duration-in-flutter (28.02.2021)
///
Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

/// Diese Methode gibt einen String mit einem Datum (z.B. YYYY-MM-DD-HH:MM:SS)
/// in einem für den Benutzer besser lesbaren Format aus.
/// Optional kann ein Zeitpunkt zum Vergleichen angegeben werden, alternativ wird die aktuelle Uhrzeit gewählt,
/// um "Heute", "Morgen" etc. bestimmen zu können.
/// Der neue String lautet "Wochentag, Tag. Monatsname, Stunden:Minuten Uhr".
String parseTimeToUserOutput(String s, [DateTime? pComparisonTime]) {
  DateTime temp = DateTime.parse(s);
  String hour = temp.hour.toString();
  String minute = temp.minute.toString();
  if (minute.length == 1) {
    minute = '0' + minute;
  }
  String day = temp.day.toString();
  String weekday = temp.weekday.toString();
  String month = temp.month.toString();

  switch (temp.month) {
    case 1:
      month = 'Januar';
      break;
    case 2:
      month = 'Februar';
      break;
    case 3:
      month = 'März';
      break;
    case 4:
      month = 'April';
      break;
    case 5:
      month = 'Mai';
      break;
    case 6:
      month = 'Juni';
      break;
    case 7:
      month = 'Juli';
      break;
    case 8:
      month = 'August';
      break;
    case 9:
      month = 'September';
      break;
    case 10:
      month = 'Oktober';
      break;
    case 11:
      month = 'November';
      break;
    case 12:
      month = 'Dezember';
      break;
  }

  switch (temp.weekday) {
    case 1:
      weekday = 'Montag';
      break;
    case 2:
      weekday = 'Dienstag';
      break;
    case 3:
      weekday = 'Mittwoch';
      break;
    case 4:
      weekday = 'Donnerstag';
      break;
    case 5:
      weekday = 'Freitag';
      break;
    case 6:
      weekday = 'Samstag';
      break;
    case 7:
      weekday = 'Sonntag';
      break;
  }

  DateTime comparisonTime =
      (pComparisonTime != null) ? pComparisonTime : DateTime.now();

  if (temp.year == comparisonTime.year &&
      temp.month == comparisonTime.month &&
      temp.day == comparisonTime.day) {
    weekday = 'Heute';
  } else if (temp.year == comparisonTime.year &&
      temp.month == comparisonTime.month &&
      temp.day == comparisonTime.add(Duration(days: 1)).day) {
    weekday = 'Morgen';
  } else if (temp.year == comparisonTime.year &&
      temp.month == comparisonTime.month &&
      temp.day == comparisonTime.add(Duration(days: 2)).day) {
    weekday = 'Übermorgen';
  } else if (temp.year == comparisonTime.year &&
      temp.month == comparisonTime.month &&
      temp.day == comparisonTime.subtract(Duration(days: 1)).day) {
    weekday = 'Gestern';
  } else if (temp.year == comparisonTime.year &&
      temp.month == comparisonTime.month &&
      temp.day == comparisonTime.subtract(Duration(days: 2)).day) {
    weekday = 'Vorgestern';
  }

  return '$weekday, $day. $month, $hour:$minute Uhr';
}

String getTimeFromDuration(Duration pDuration) {
  DateTime temp = new DateTime(0).add(pDuration);
  return temp.hour.toString() +
      ':' +
      temp.minute.toString().padLeft(2, '0') +
      ' Uhr';
}

DateTime? getLastModifiedTime(String s) {
  try {
    List<String> tempList = s.split(' ');
    int month = 0;
    switch (tempList[2]) {
      case 'Jan':
        month = 1;
        break;
      case 'Feb':
        month = 2;
        break;
      case 'Mar':
        month = 3;
        break;
      case 'Apr':
        month = 4;
        break;
      case 'May':
        month = 5;
        break;
      case 'Jun':
        month = 6;
        break;
      case 'Jul':
        month = 7;
        break;
      case 'Aug':
        month = 8;
        break;
      case 'Sept':
        month = 9;
        break;
      case 'Oct':
        month = 10;
        break;
      case 'Nov':
        month = 11;
        break;
      case 'Dec':
        month = 12;
        break;
    }
    List<String> time = tempList[4].split(':');
    DateTime temp = new DateTime(
        int.tryParse(tempList[3])!, month, int.tryParse(tempList[1])!,int.tryParse(time[0])!,int.tryParse(time[1])!);
    return temp;
  } catch (e) {
    print(e);
    return null;
  }
}
