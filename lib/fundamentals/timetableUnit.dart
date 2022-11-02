class TimeTableUnit {
  late final String? subject;
  late final String? room;
  late final int? dayNumber;
  late final bool? isRegular;

  TimeTableUnit(this.subject, this.room, this.dayNumber, this.isRegular);

  factory TimeTableUnit.fromJson(dynamic json) {
    return TimeTableUnit(json['subject'], json['subject']['room'], json['day'],
        json['subject']['regular']);
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
