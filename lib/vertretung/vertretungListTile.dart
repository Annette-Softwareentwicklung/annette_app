import 'dart:ui';
import 'package:annette_app/classes/vertretungsEinheit.dart';
import 'package:flutter/cupertino.dart';
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

  /*final Shader darkGradient = LinearGradient(
    colors: <Color>[Colors.tealAccent, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));*/

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //constraints: BoxConstraints(minHeight: 200),
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
                        color: Colors.blue,
                        //foreground: Paint()..shader = lightGradient,
                      ),
                    )
                  : Text(''),
              Container(
                child: Row(
                  children: [
                    Text(
                      (vertretung.subject_new != null)
                          ? vertretung.subject_new!
                          : (vertretung.subject_old != null)
                              ? vertretung.subject_old!
                              : vertretung.type!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: (vertretung.subject_old != null &&
                                vertretung.subject_new != null &&
                                vertretung.subject_new !=
                                    vertretung.subject_old)
                            ? Colors.red
                            : null,
                      ),
                    ),
                    if (vertretung.subject_old != null &&
                        vertretung.subject_new != null &&
                        vertretung.subject_new != vertretung.subject_old)
                      Container(
                        child: Text(
                          vertretung.subject_old!,
                          style: TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold),
                        ),
                        margin: EdgeInsets.only(left: 5),
                      ),
                    /*Container(margin: EdgeInsets.only(left: 5,),child: Text(
                      '(' + vertretung.affectedClass! + ')',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal),
                    ),),*/
                  ],
                ),
              ),
            ],
          ),
          if (vertretung.room != null)
            Row(
              children: [
                Text(
                  (vertretung.type != null &&
                          vertretung.type!.toLowerCase().contains('raum'))
                      ? vertretung.type! + ':'
                      : '',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          vertretung.room!,
                          style: TextStyle(
                              fontSize: 25,
                              color: (vertretung.type != null &&
                                      vertretung.type!
                                          .toLowerCase()
                                          .contains('raum'))
                                  ? Colors.red
                                  : null,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.location_solid,
                        color: (vertretung.type != null &&
                                vertretung.type!.toLowerCase().contains('raum'))
                            ? Colors.red
                            : null,
                      ),
                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          Row(
            children: [
              Text(
                (vertretung.type != null &&
                        vertretung.type!.toLowerCase().contains('vertretung'))
                    ? vertretung.type! + ':'
                    : '',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal),
              ),
              Container(
                child: Row(
                  children: [
                    ///Anzeige "Lehrer neu"

                    if (
                    (vertretung.teacher_new != null && vertretung.teacher_old != null &&
                            vertretung.teacher_old! != vertretung.teacher_new) ||
                        (vertretung.teacher_new != null &&
                            vertretung.type != null &&
                            vertretung.type!
                                .toLowerCase()
                                .contains('vertretung')))
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          (vertretung.teacher_new != null)
                              ? vertretung.teacher_new!
                              : 'Fehler',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    else if (vertretung.teacher_new != null &&
                        vertretung.teacher_new != vertretung.teacher_old)
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          vertretung.teacher_new!,
                          style: TextStyle(
                            fontSize: 25,
                            //color: Colors.red,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                    ///Anzeige "Lehrer alt" (ggf. durchgestrichen)
                    if (vertretung.teacher_old != null)
                      Container(
                        child: Text(
                          (vertretung.teacher_old != null)
                              ? vertretung.teacher_old!
                              : 'Fehler',
                          style: TextStyle(
                              fontSize: 25,
                              decoration: ((vertretung.teacher_new != null &&
                                          vertretung.teacher_old! !=
                                              vertretung.teacher_new) ||
                                      (vertretung.type != null &&
                                          vertretung.type!
                                              .toLowerCase()
                                              .contains('vertretung')))
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontWeight: FontWeight.normal),
                        ),
                        margin: EdgeInsets.only(right: 5),
                      ),

                    ///Icon "Person"
                    if (vertretung.teacher_old != null ||
                        vertretung.teacher_new != null)
                      Icon(CupertinoIcons.person_fill),
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: [
              if (!vertretung.type!.toLowerCase().contains('vertretung') &&
                  !vertretung.type!.toLowerCase().contains('raum')
                  && vertretung.subject_old != null
              )
                Text(
                  (vertretung.comment != null)
                      ? vertretung.type! + ':'
                      : vertretung.type!,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                )
              else if (vertretung.comment != null)
                Text(
                  'Hinweis:',
                  style: TextStyle(
                      fontSize: 25,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
              if (vertretung.comment != null)
                Expanded(
                  child: Text(
                    vertretung.comment!,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal),
                  ),
                ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }
}
