import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password);
  Future<bool> forgot(String email);
  Future<bool> signOut();
  bool isUser();
  User? user();
  Future<String> updateInforUser(
      String displayName, PhoneAuthCredential phoneNumber, String photoURL);
  Future<bool> signInWithGoogle();
  Future<bool> signInWithFacebook();
}
