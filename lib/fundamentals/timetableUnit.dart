class TimeTableUnit {
  final int? id;
  final String? subject;
  final String? room;
  final int? dayNumber;
  final int? lessonNumber;

  TimeTableUnit(
      {this.id,
        this.subject,
        this.room,
        this.dayNumber,
        this.lessonNumber,});

  TimeTableUnit.fromJson(Map<String, dynamic> json) : id = json['id'],subject = json['subject'],room = json['room'],dayNumber = json['dayNumber'],lessonNumber = json['lessonNumber'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'subject': subject,
        'room': room,
        'dayNumber': dayNumber,
        'lessonNumber': lessonNumber,
      };
}
