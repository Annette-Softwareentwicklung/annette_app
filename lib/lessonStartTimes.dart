import 'classes/lessonStartTime.dart';

/**
 * Diese Methode gibt alle sich in der Tabelle befindlichen Anfangszeiten der Schulstunden zurück.
 * Die Rückgabe geschieht in Form einer Liste mit einzelnen Objekten der Klasse LessonStartTime.
 */
List<LessonStartTime> getAllTimes() {
  List<LessonStartTime> temp = [];
  temp.add(new LessonStartTime(id: 1,time: '8:00:00.000000'));
  temp.add(new LessonStartTime(id: 2,time: '8:50:00.000000'));
  temp.add(new LessonStartTime(id: 3,time: '9:55:00.000000'));
  temp.add(new LessonStartTime(id: 4,time: '10:45:00.000000'));
  temp.add(new LessonStartTime(id: 5,time: '11:50:00.000000'));
  temp.add(new LessonStartTime(id: 6,time: '12:40:00.000000'));
  temp.add(new LessonStartTime(id: 7,time: '13:35:00.000000'));
  temp.add(new LessonStartTime(id: 8,time: '14:30:00.000000'));
  temp.add(new LessonStartTime(id: 9,time: '15:20:00.000000'));
  temp.add(new LessonStartTime(id: 10,time: '16:10:00.000000'));
  temp.add(new LessonStartTime(id: 11,time: '17:00:00.000000'));

  return temp;
}
