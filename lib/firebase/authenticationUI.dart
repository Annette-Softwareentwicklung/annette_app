import 'dart:io';
import 'package:annette_app/custom_widgets/customDialog.dart';
import 'package:annette_app/custom_widgets/signInUI.dart';
import 'package:annette_app/firebase/authentication.dart';
import 'package:flutter/material.dart';

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({Key? key}) : super(key: key);

  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: TextButton(
                  onPressed: () {},
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Theme.of(context).accentColor
                            : Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        'Ohne Anmeldung fortfahren',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      )),
                ),
              ),
              Divider(indent: 30,endIndent: 30),
              SignInWithGoogle(onPressed: () async {
                await AuthenticationService().signInWithGoogle();
              },),
              if(Platform.isIOS)
              SignInWithApple(onPressed: () async {
                await showCustomInformationDialog(
                    context,
                    'Fehler',
                    'Diese Funktion wird dir in Kürze zur Verfügung stehen.',
                    true,
                    false,
                    true);
              },),
            ],
          ),
        ),
      ),
    );
  }
}
