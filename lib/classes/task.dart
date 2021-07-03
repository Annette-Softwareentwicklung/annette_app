/**
 * Klasse Task. Diese Klasse dient dazu, eine Hausaufgabe speichern zu können.
 *
 * Die Attribute einer Hausaufgabe sind:
 *     - id                Typ int       Speichert die Id der Zeile in der Datenbank
 *     - subject           Typ String    Speichert das Fach
 *     - notes             Typ String    Speichert zusätzliche Notizen zur Aufgabe
 *     - notificationTime  Typ String    Speichert den Zeitpunkt der Benachrichtigung (als String)
 *     - deadlineTime      Typ String    Speichert die Frist der Aufgabe (als String)
 *     - isChecked         Typ int       Speichert, ob die Aufgabe erledigt ist
 *
 *  Die Methode "toMap()" konvertiert alle Attribute in eine Map.
 *  Diese wird benötigt, um einen neuen Task in die Datenbank einzufügen.
 */
class Task {
  final int? id;
  final String? subject;
  final String? notes;
  String? notificationTime;
  final String? deadlineTime;
  int? isChecked;

  Task(
      {this.id,
      this.subject,
      this.notes,
      this.notificationTime,
        this.deadlineTime,
      this.isChecked});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'notes': notes,
      'notificationTime': notificationTime,
      'deadlineTime': deadlineTime,
      'isChecked': isChecked,
    };
  }
}
