import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserFirestoreDataSource {
  Future<void> createUserDoc(String uid, String email);
}

class UserFirestoreDataSourceImpl implements UserFirestoreDataSource {
  final FirebaseFirestore _firebaseFirestore;

  UserFirestoreDataSourceImpl({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUserDoc(String uid, String email) async {
    await _firebaseFirestore.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "timestampt": Timestamp.now(),
    });
  }
}
