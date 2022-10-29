class TimeTableUnit {
  late final String? subject;
  late final String? room;
  late final int? dayNumber;
  late final bool? isRegular;

  TimeTableUnit({this.subject, this.room, this.dayNumber, this.isRegular});

  TimeTableUnit.fromJson(Map<String, dynamic> json) {
    dayNumber = json['day'];
    subject = json['subject']['longName'];
    room = json['subject']['room'];
    isRegular = json['subject']['regular'];
  }

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
