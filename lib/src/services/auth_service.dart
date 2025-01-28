import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Đăng nhập thành công";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return "Đăng nhập thất bại";
    } catch (e) {
      return "Có lỗi!";
    }
  }

  Future<String> register(String name, String email, String password) async {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseFirestore = FirebaseFirestore.instance;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        "uid": firebaseAuth.currentUser!.uid,
        "name": name,
        "email": email,
        "timestampt": Timestamp.now()
      });
      return "Đăng ký thành công";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return "Đăng ký thất bại";
    } catch (e) {
      return "Có lỗi!";
    }
  }

  Future<String> forgot(String email) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Gửi thành công";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return "Gửi thất bại";
    } catch (e) {
      return "Có lỗi!";
    }
  }
}
