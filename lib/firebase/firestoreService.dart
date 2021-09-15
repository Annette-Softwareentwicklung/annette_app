import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final User currentUser;
  FirestoreService({required this.currentUser});
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUserDocument() {
    return users
        .doc(currentUser.uid)
        .set({
          'configuration': null,
          'timetableVersion': DateTime(0,0,0).toString(),
          'changingLkSubject': null,
          'changingLkWeeknumber': 2,
          'unspecificOccurences': true,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> checkIfUserDocumentExists() {
    return users.doc(currentUser.uid).get().then((value) => value.exists);
  }

  Future<void> updateDocument (String key, Object value) async{
      return users
          .doc(currentUser.uid)
          .update({key: value})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUserCollection(String collectionName) async {
    return FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection(collectionName).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> insertInUserCollection(String collectionName, Map<String, dynamic> data) async {
    await users.doc(currentUser.uid).collection(collectionName).add(data);
  }

  Future<Object> readValue(String key) async {
      var result = users.doc(currentUser.uid).get();
      return (await result)[key];
  }

  Future<void> insertTimetableUnit(TimeTableUnit timeTableUnit) async{
    insertInUserCollection('timetable', <String, dynamic>{
      'subject': timeTableUnit.subject,
      'room': timeTableUnit.room,
      'dayNumber': timeTableUnit.dayNumber,
      'lessonNumer': timeTableUnit.lessonNumber,
    });
  }
}
