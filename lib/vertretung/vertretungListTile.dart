import 'dart:ui';
import 'package:annette_app/fundamentals/vertretungsEinheit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.dark) ? Colors.black26 : Colors.black12,
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
                      ),
                    )
                  : Text(''),
              Container(
                child: Row(
                  children: [
                    Text(
                      (vertretung.subjectNew != null)
                          ? vertretung.subjectNew!
                          : (vertretung.subjectOld != null)
                              ? vertretung.subjectOld!
                              : vertretung.type!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: (vertretung.subjectOld != null &&
                                vertretung.subjectNew != null &&
                                vertretung.subjectNew !=
                                    vertretung.subjectOld)
                            ? Colors.red
                            : null,
                      ),
                    ),
                    if (vertretung.subjectOld != null &&
                        vertretung.subjectNew != null &&
                        vertretung.subjectNew != vertretung.subjectOld)
                      Container(
                        child: Text(
                          vertretung.subjectOld!,
                          style: TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold),
                        ),
                        margin: EdgeInsets.only(left: 5),
                      ),
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
                    (vertretung.teacherNew != null && vertretung.teacherOld != null &&
                            vertretung.teacherOld! != vertretung.teacherNew) ||
                        (vertretung.teacherNew != null &&
                            vertretung.type != null &&
                            vertretung.type!
                                .toLowerCase()
                                .contains('vertretung')))
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          (vertretung.teacherNew != null)
                              ? vertretung.teacherNew!
                              : 'Fehler',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    else if (vertretung.teacherNew != null &&
                        vertretung.teacherNew != vertretung.teacherOld)
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          vertretung.teacherNew!,
                          style: TextStyle(
                            fontSize: 25,
                            //color: Colors.red,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                    ///Anzeige "Lehrer alt" (ggf. durchgestrichen)
                    if (vertretung.teacherOld != null)
                      Container(
                        child: Text(
                          (vertretung.teacherOld != null)
                              ? vertretung.teacherOld!
                              : 'Fehler',
                          style: TextStyle(
                              fontSize: 25,
                              decoration: ((vertretung.teacherNew != null &&
                                          vertretung.teacherOld! !=
                                              vertretung.teacherNew) ||
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
                    if (vertretung.teacherOld != null ||
                        vertretung.teacherNew != null)
                      Icon(CupertinoIcons.person_fill),
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!vertretung.type!.toLowerCase().contains('vertretung') &&
                  !vertretung.type!.toLowerCase().contains('raum')
                  //&& vertretung.subjectOld != null
              )
                Text(
                  (vertretung.comment != null)
                      ? (vertretung.type! + ':').replaceAll('.:', '.')
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
