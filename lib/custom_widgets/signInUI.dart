import 'package:flutter/material.dart';
import 'package:annette_app/data/assets.dart';

class SignInWithGoogle extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInWithGoogle({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => this.onPressed(),
      child: Container(
          width: 260,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: (Theme.of(context).brightness == Brightness.dark)
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(assetPaths.googleIconPath)),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Mit Google anmelden',
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                ),
              ),
            ],
          )),
    );
  }
}

class SignInWithApple extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInWithApple({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => this.onPressed(),
      child: Container(
          width: 260,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(assetPaths.appleIconPath)),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Mit Apple anmelden',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ],
          )),
    );
  }
}
