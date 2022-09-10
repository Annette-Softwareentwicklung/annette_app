class TimeTableUnit {
  final int? id;
  final String? subject;
  final String? room;
  final int? dayNumber;
  final int? lessonNumber;

  TimeTableUnit({
    this.id,
    this.subject,
    this.room,
    this.dayNumber,
    this.lessonNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'room': room,
      'dayNumber': dayNumber,
      'lessonNumber': lessonNumber,
    };
  }

  @override
  String toString() {
    return "TimetableUnit(id: $id, subject: $subject, room: $room, dayNumber: $dayNumber, lessonNumber: $lessonNumber)";
  }
}
