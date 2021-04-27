class VertretungsEinheit {
  final String? affectedClass;
  final String? type;
  final String? teacher_new;
  final String? lesson;
  final String? subject_new;
  final String? subject_old;
  final String? teacher_old;
  final String? room;
  final String? comment;

  VertretungsEinheit(this.type, this.subject_new, this.subject_old, this.affectedClass,
      this.comment, this.teacher_old, this.teacher_new, this.room, this.lesson);
}
