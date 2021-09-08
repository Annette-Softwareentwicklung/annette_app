import 'package:flutter/material.dart';

Future<bool?> showCustomInformationDialog(
  BuildContext _context,
  String _title,
  String _text,
  bool _checkOption,
  bool _cancelOption,
  bool _barrierDismissible,
) async {
  return await showDialog<bool?>(
      context: _context,
      barrierDismissible: _barrierDismissible,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: 450,
                ),
                padding:
                    EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _text,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_cancelOption)
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                icon: Icon(
                                  Icons.clear_rounded,
                                  size: 30,
                                )),
                          if (_checkOption)
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                icon: Icon(
                                  Icons.check_rounded,
                                  size: 30,
                                )),
                        ],
                      ),
                    ],
                  ),
                )));
      });
}
