import 'package:annette_app/custom_widgets/customDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  Future<UserCredential> signInAnonymously() async {
    UserCredential _userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    addUserDocument(_userCredential);
    return _userCredential;
  }

  Future<UserCredential> signInWithGoogle(
      bool isUpdate, BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    late UserCredential _userCredential;
    if (isUpdate) {
      try {
        _userCredential = await FirebaseAuth.instance.currentUser!
            .linkWithCredential(credential);
        print('q');
        await showCustomInformationDialog(
            context,
            'Login erfolgreich',
            'Deine Einstellungen wurden mit deinem Google-Konto verknüpft. Logge dich auf deinen anderen Geräten mit dem selben Account ein.',
            true,
            false,
            false);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'credential-already-in-use') {
          bool? checkOutWithThisAcc = await showCustomInformationDialog(
              context,
              'Account existiert bereits',
              'Möchtest du dich mit dem Google-Konto "${googleUser.email}" einloggen und dessen Einstellungen sychronisieren? Deine lokalen Einstellungen gehen verloren.',
              true,
              true,
              false);
          if (checkOutWithThisAcc != null && checkOutWithThisAcc == true) {
            print('login');
            _userCredential =
                await googleSignInOAuthCredential(credential, context);
          }
        }
      }
    } else {
      _userCredential = await googleSignInOAuthCredential(credential, context);
    }

    //addUserDocument(_userCredential);
    return _userCredential;
  }

  Future<UserCredential> googleSignInOAuthCredential(
      OAuthCredential _credential, BuildContext context) async {
    UserCredential _userCredential =
        await FirebaseAuth.instance.signInWithCredential(_credential);
    return _userCredential;
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUserDocument(UserCredential userCredential) {
    return users
        .doc(userCredential.user!.uid)
        .set({'full_name': "Mary Jane", 'age': 18})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> checkIfUserDocumentExists(UserCredential _user) {
    return users.doc(_user.user!.uid).get().then((value) => value.exists);
  }
}
