class VertretungsEinheit {
  final String? affectedClass;
  final String? type;
  final String? teacherNew;
  final String? lesson;
  final String? subjectNew;
  final String? subjectOld;
  final String? teacherOld;
  final String? room;
  final String? comment;

  VertretungsEinheit(this.type, this.subjectNew, this.subjectOld, this.affectedClass,
      this.comment, this.teacherOld, this.teacherNew, this.room, this.lesson);
}
