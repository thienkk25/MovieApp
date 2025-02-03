import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Đăng nhập thành công";
    } on FirebaseAuthException {
      return "Email hoặc Mật khẩu không chính xác!";
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
      if (e.code == "email-already-in-use") {
        return "Email đã tồn tại!";
      } else if (e.code == "invalid-email") {
        return "Email không đúng định dạng!";
      } else if (e.code == "weak-password") {
        return "Mật khẩu yếu";
      } else if (e.code == "operation-not-allowed") {
        return "Tài khoản đã bị khoá hoặc đóng. Vui lòng liên hệ với admin!";
      }
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
    } on FirebaseAuthException {
      return "Gửi thất bại";
    } catch (e) {
      return "Có lỗi!";
    }
  }

  Future<String> signOut() async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signOut();
      return "Đăng xuất thành công";
    } catch (e) {
      return "Có lỗi!";
    }
  }

  bool isUser() {
    final firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;
    if (user != null) return true;
    return false;
  }

  User? user() {
    final firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.currentUser;
  }

  Future<String> updateInforUser(String displayName,
      PhoneAuthCredential phoneNumber, String photoURL) async {
    final firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;
    if (user != null) {
      user.updateDisplayName(displayName);
      user.updatePhoneNumber(phoneNumber);
      user.updatePhotoURL(photoURL);
      user.reload();
      return "Cập nhật thành công";
    } else {
      return "Cập nhật thất bại";
    }
  }
}
