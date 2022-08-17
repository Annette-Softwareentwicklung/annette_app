class Lesson {
  final int internalId;
  final int startTime;
  final int endTime;
  final String roomId;
  final String name;
  final String startTimeFormatted;
  const Lesson(this.internalId, this.startTime, this.startTimeFormatted,
      this.endTime, this.roomId, this.name);
}
