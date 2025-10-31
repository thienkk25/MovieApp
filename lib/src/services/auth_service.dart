import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
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
        "email": email,
        "timestampt": Timestamp.now()
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgot(String email) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOut() async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
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

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await FirebaseAuth.instance.signInWithCredential(credential);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
