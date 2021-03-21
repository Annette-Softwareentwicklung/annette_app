import 'package:annette_app/vertretung/vertretungsEinheit.dart';
import 'package:flutter/material.dart';

class VertretungListTile extends StatelessWidget {

  final VertretungsEinheit vertretung;

  VertretungListTile(this.vertretung);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        if(vertretung.affectedClass != null) Text(vertretung.affectedClass),
        if(vertretung.type != null) Text(vertretung.type),
        if(vertretung.teacher_old != null) Text(vertretung.teacher_old),
        if(vertretung.teacher_new != null) Text(vertretung.teacher_new),
        if(vertretung.comment != null) Text(vertretung.comment),
        if(vertretung.lesson != null) Text(vertretung.lesson),
        if(vertretung.room != null)  Text(vertretung.room),
        if(vertretung.subject_new != null) Text(vertretung.subject_new),
        if(vertretung.subject_old != null) Text(vertretung.subject_old),


      ],),
    );
  }
}
