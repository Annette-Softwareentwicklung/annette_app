import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  Future<UserCredential> signInAnonymously() async {
    UserCredential _userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    //addUserDocument(_userCredential);
    return _userCredential;
  }

  Future<UserCredential> signInWithGoogle(bool isUpdate) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    late UserCredential _userCredential;
    if(isUpdate) {
      _userCredential =
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
    } else {
      _userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    }

    //addUserDocument(_userCredential);
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
}
