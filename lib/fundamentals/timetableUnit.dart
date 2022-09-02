class TimeTableUnit {
  final String? subject;
  final String? room;
  final int? dayNumber;
  final bool? isRegular;

  TimeTableUnit({this.subject, this.room, this.dayNumber, this.isRegular});

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'room': room,
      'dayNumber': dayNumber,
      'regular': isRegular
    };
  }

  @override
  String toString() {
    return "TimetableUnit(subject: $subject, room: $room, dayNumber: $dayNumber, regular: $isRegular)";
  }
}
