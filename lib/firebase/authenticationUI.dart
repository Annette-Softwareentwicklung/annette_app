import 'dart:io';
import 'package:annette_app/custom_widgets/customDialog.dart';
import 'package:annette_app/custom_widgets/signInUI.dart';
import 'package:annette_app/firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationUI extends StatefulWidget {
  final bool isInGuide;
  const AuthenticationUI({Key? key, required this.isInGuide}) : super(key: key);

  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  bool loading = false;
  late bool anonymousLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.isInGuide)
      anonymousLogin = false;
    else anonymousLogin = true;
    print(anonymousLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 20.0,
                  right: 0.0,
                  top: 70.0,
                  child: Container(
                    child: Text(
                      'Geräteübergreifende Synchronisierung',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(bottom: 15),
                    margin: EdgeInsets.only(left: 5),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 200, bottom: 100, left: 10, right: 10),
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                            borderRadius: BorderRadius.circular(10),
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Colors.black26
                                : Colors.white),
                        child: Column(
                          children: [
                            Text(
                              'Wenn du die Annette App auf mehreren Geräten nutzen möchtest, kannst du deine Einstellungen synchronisieren.\n\n' +
                                  '${(!anonymousLogin) ? 'Damit niemand anderes Zugriff auf deine Daten bekommt, ist es wichtig, dass du dich einloggst.' : 'Du kannst diese Funktion jedoch auch später noch jederzeit konfigurieren.'}',
                              style: TextStyle(fontSize: 17),
                            ),
                            if(widget.isInGuide)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                            if(widget.isInGuide)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Synchronisierung',
                                  style: TextStyle(fontSize: 17,
                                  ),
                                ),
                                CupertinoSwitch(
                                    value: !anonymousLogin,
                                    onChanged: (value) {
                                      setState(() {
                                        anonymousLogin = !value;
                                      });
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      if (anonymousLogin)
                        Container(
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              UserCredential? userCredential =
                                  await AuthenticationService().signInAnonymously();
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                height: 60,
                                width: 260,
                                decoration: BoxDecoration(
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Theme.of(context).accentColor
                                      : Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  'Weiter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      if (Platform.isIOS && !anonymousLogin)
                        SignInWithApple(
                          onPressed: () async {
                            await showCustomInformationDialog(
                                context,
                                'Fehler',
                                'Diese Funktion wird dir in Kürze zur Verfügung stehen.',
                                true,
                                false,
                                true);
                          },
                        ),
                      if (!anonymousLogin)
                        SignInWithGoogle(
                          onPressed: () async {
                            try {
                              setState(() {
                                loading = true;
                              });
                                  await AuthenticationService()
                                      .signInWithGoogle(!widget.isInGuide);
                            } catch (e) {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                        ),
                      if(!widget.isInGuide)
                      TextButton(onPressed: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Zurück', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline,
                            fontSize: 17
                            ),),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            Container(
              color: (loading) ? Colors.black26 : null,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
