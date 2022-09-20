# Die (in)-offizielle Dokumentation der Annette-App-Services-Abteilung
## geschrieben von: 
- Elias Dörr
- Arwed Walke

---
<br>

[![forthebadge](https://forthebadge.com/images/badges/built-with-swag.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/compatibility-ie-6.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/does-not-contain-treenuts.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/mom-made-pizza-rolls.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/no-ragrets.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/powered-by-oxygen.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/works-on-my-machine.svg)](https://forthebadge.com)
<br>
<br>

---
<br>

## Übersicht

- [API-Übersicht](#API-Übersicht)

- [timetable_storage.dart](#timetable_storage.dart)

- [setClass_V2.dart](#setClass_V2.dart)

<br>

## API-Übersicht

Beispiel für LK-Montag: 
```json
{"day":1,"lsNumber":"1","subject":{"longName":"CHEMIE Leistungskurs"},"room":"D107","regular":true}
{"day":5,"lsNumber":"5","subject":{"longName":"PHILOSOPHIE Grundkurs"},"room":"D004","regular":false},
```

- ```day```: Wochentag von 1 (Montag) bis 5 (Freitag)
- ```lsNumber```: Stundenindex ab 1
- ```subject```: Objekt
    - ```longName```: ausgeschriebener Name
    - ```shortName```: kurzer Name
- ```room```: der ausgeschriebene Raumname der Stunde
- ```regular```: true/false; zeigt an, ob es ggf. Vertretung/EVA/Raumänderungen gibt

<br>

## timetable_storage.dart
Verantwortlich für das Zwischenspeichern von Daten und ggf. dem erneuten Laden mittels api-client.dart.
- ``` getTimetableForDay(DateTime day)```: Liefert eine Liste von TimetableUnits für den angegebenen Tag, die etwa in TimetableTab.dart Verwendung finden.
- ```getTimetableForWeek(WeekMode week)```: Liefert eine Liste von TimetableUnits für die gesamte Woche, die etwa in TimetableTab.dart Verwendung finden, entweder für die aktuelle oder die nächste Woche.
- ```updateTimetable()```: Lädt die aktuellsten Stundenplandaten mittels API-Client und speichert sie mithilfe von GetStorage() ab. Wird nur von innerhalb der Klasse und nur bei Bedarf aufgerufen.
- ```getCurrentDay()```: Liefert den momentan auf dem Stundenplan anzuzeigenden Tag (zieht nicht die Uhrzeit in Betracht und dient nur dem Vermeiden von redundantem Code)
- ```getWeek(int weekday)```: Liefert die anzuzeigende Woche in Abhängigkeit eines bestimmten Tages (dient nur dem Vermeiden von redundantem Code)