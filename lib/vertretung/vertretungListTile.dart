import 'package:annette_app/vertretung/vertretungsEinheit.dart';
import 'package:flutter/material.dart';

class VertretungListTile extends StatelessWidget {
  final VertretungsEinheit vertretung;

  VertretungListTile(this.vertretung);

  final Shader linearGradient1 = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader lightGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.tealAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader darkGradient = LinearGradient(
    colors: <Color>[Colors.tealAccent, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: BoxConstraints(minHeight: 200),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (vertretung.lesson != null)
                  ? Text(
                      vertretung.lesson!,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = (Theme.of(context).brightness == Brightness.dark) ? darkGradient : lightGradient,
                      ),
                    )
                  : Text(''),
              Text((vertretung.subject_new != null) ? vertretung.subject_new! : vertretung.type!, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ],
          ),
          if (vertretung.affectedClass != null) Text(vertretung.affectedClass!),
          if (vertretung.type != null && vertretung.subject_new != null) Text(vertretung.type!),
          if (vertretung.teacher_old != null) Text(vertretung.teacher_old!),
          if (vertretung.teacher_new != null) Text(vertretung.teacher_new!),
          if (vertretung.comment != null) Text(vertretung.comment!),
          if (vertretung.room != null) Text(vertretung.room!),
          if (vertretung.subject_new != null) Text(vertretung.subject_new!),
          if (vertretung.subject_old != null && vertretung.subject_old != vertretung.subject_new) Text(vertretung.subject_old!),
        ],
      ),
    );
  }
}
