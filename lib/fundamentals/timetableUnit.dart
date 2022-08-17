class TimeTableUnit {
  final int? id;
  final String? subject;
  final String? room;
  final int? dayNumber;

  TimeTableUnit({
    this.id,
    this.subject,
    this.room,
    this.dayNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'room': room,
      'dayNumber': dayNumber,
    };
  }

  @override
  String toString() {
    return "TimetableUnit(id: $id, subject: $subject, room: $room, dayNumber: $dayNumber)";
  }
}
