import 'package:annette_app/fundamentals/timetableUnit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final User currentUser;

  FirestoreService({required this.currentUser});

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUserDocument() {
    return users.doc(currentUser.uid).set({
      'configuration': null,
      'timetableVersion': DateTime(0, 0, 0).toString(),
      'changingLkSubject': null,
      'changingLkWeeknumber': 2,
      'unspecificOccurences': true,
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> checkIfUserDocumentExists() async {
    return (await users
            .doc(currentUser.uid)
            .get(GetOptions(source: Source.serverAndCache)))
        .exists;
  }

  Future<void> updateDocument(String key, Object value) async {
    return users.doc(currentUser.uid).update({key: value}).catchError(
        (error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUserCollection(String collectionName) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection(collectionName)
        .get(GetOptions(source: Source.serverAndCache));

    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> insertInUserCollection(
      String collectionName, Map<String, dynamic> data) async {
    return users.doc(currentUser.uid).collection(collectionName).add(data);
  }

  Future<Object> readValue(String key) async {
    return users
        .doc(currentUser.uid)
        .get(GetOptions(source: Source.serverAndCache))
        .then((value) => value[key]);
  }

  Future<DocumentReference<Map<String, dynamic>>> insertTimetableUnit(
      TimeTableUnit timeTableUnit) async {
    return insertInUserCollection('timetable', <String, dynamic>{
      'subject': timeTableUnit.subject,
      'room': timeTableUnit.room,
      'dayNumber': timeTableUnit.dayNumber,
      'lessonNumer': timeTableUnit.lessonNumber,
    });
  }

  Stream<DocumentSnapshot<Object?>> documentStream () => users.doc(currentUser.uid).snapshots();
}
