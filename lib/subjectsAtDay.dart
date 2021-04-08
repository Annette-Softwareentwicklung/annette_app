/**
 * Klasse SubjectsAtDay. Diese Klasse dient dazu, die Fächer des Stundeplan für einen Tag speichern zu können.
 *
 * Die Attribute dieser Klasse sind:
 *     - id             Typ int       Speichert die Id der Zeile in der Datenbank
 *     - dayName        Typ String    Speichert den Namen des Wochentages
 *     - lesson1        Typ String    Speichert das Fach der 1. Stunde
 *     - lesson2        Typ String    Speichert das Fach der 2. Stunde
 *     - lesson3        Typ String    Speichert das Fach der 3. Stunde
 *     - lesson4        Typ String    Speichert das Fach der 4. Stunde
 *     - lesson5        Typ String    Speichert das Fach der 5. Stunde
 *     - lesson6        Typ String    Speichert das Fach der 6. Stunde
 *     - lesson7        Typ String    Speichert das Fach der 7. Stunde
 *     - lesson8        Typ String    Speichert das Fach der 8. Stunde
 *     - lesson9        Typ String    Speichert das Fach der 9. Stunde
 *     - lesson10       Typ String    Speichert das Fach der 10. Stunde
 *     - lesson11       Typ String    Speichert das Fach der 11. Stunde
 *
 *  Die Methode "toMap()" konvertiert  alle Attribute in eine Map.
 *  Diese wird benötigt, um einen neuen Task in die Datenbank einzufügen.
 */

class SubjectsAtDay {
  final int? id;
  final String? dayName;
  final String? lesson1;
  final String? lesson2;
  final String? lesson3;
  final String? lesson4;
  final String? lesson5;
  final String? lesson6;
  final String? lesson7;
  final String? lesson8;
  final String? lesson9;
  final String? lesson10;
  final String? lesson11;

  SubjectsAtDay(
      {this.id,
      this.dayName,
      this.lesson1,
      this.lesson2,
      this.lesson3,
      this.lesson4,
      this.lesson5,
      this.lesson6,
      this.lesson7,
      this.lesson8,
      this.lesson9,
      this.lesson10,
      this.lesson11});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayName': dayName,
      'lesson1': lesson1,
      'lesson2': lesson2,
      'lesson3': lesson3,
      'lesson4': lesson4,
      'lesson5': lesson5,
      'lesson6': lesson6,
      'lesson7': lesson7,
      'lesson8': lesson8,
      'lesson9': lesson9,
      'lesson10': lesson10,
      'lesson11': lesson11,
    };
  }
}
