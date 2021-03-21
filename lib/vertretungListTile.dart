import 'package:annette_app/vertretungsEinheit.dart';
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
      child: Text(vertretung.affectedClass + vertretung.type),
    );
  }
}
