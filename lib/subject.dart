/**
 * Klasse Subject. Diese Klasse dient dazu, ein Schulfach speichern zu können.
 * Wird u.a. dazu verwendet, alle Fächer im Drop-Down-Menü darzustellen.
 *
 * Die Attribute eines Faches sind:
 *     - id         Typ int       Speichert die Id der Zeile in der Datenbank
 *     - name       Typ String    Speichert den Namen des Faches
 *
 *  Die Methode "toMap()" konvertiert alle Attribute in eine Map.
 *  Diese wird benötigt, um einen neuen Task in die Datenbank einzufügen.
 */
class Subject {
  final int? id;
  final String? name;

  Subject({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
