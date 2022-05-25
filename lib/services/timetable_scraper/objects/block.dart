class Block {
  final int startTime;
  final int endTime;
  final String roomId;
  final String name;
  final String startTimeFormatted;
  const Block(this.startTime, this.startTimeFormatted, this.endTime,
      this.roomId, this.name);
}
