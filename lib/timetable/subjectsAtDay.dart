

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
