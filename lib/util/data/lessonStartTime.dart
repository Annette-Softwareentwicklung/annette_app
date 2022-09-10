/// Klasse LessonStartTime. Diese Klasse dient dazu, die Anfangszeit einer Schulstunde zu speichern.
///
/// Die Attribute einer "LessonStartTime" sind:
///     - id             Typ int       Speichert die Id der Zeile in der Datenbank
///     - time           Typ String    Speichert den Zeitpunkt als String
///
///  Die Methode "toMap()" konvertiert alle Attribute in eine Map.
///  Diese wird benötigt, um eine neue Zeit in die Datenbank einzufügen.
///
/// TODO: MERGE WITH lessonStartTimes.dart
///
class LessonStartTime {
  final int? id;
  final String? time;

  LessonStartTime({this.id, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
    };
  }
}
