import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login(String email, String password);
  Future<UserCredential> register(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  bool isUser();
  User? getCurrentUser();
  Future<void> updateDisplayName(String displayName);
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneNumber);
  Future<void> updatePhotoURL(String photoURL);
  Future<void> reloadUser();
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithFacebook();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<UserCredential> login(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  bool isUser() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
    }
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneNumber) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePhoneNumber(phoneNumber);
    }
  }

  @override
  Future<void> updatePhotoURL(String photoURL) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
    }
  }

  @override
  Future<void> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    _googleSignIn.initialize();
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login(
      permissions: ['email', 'public_profile'],
    );
    if (result.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return _firebaseAuth.signInWithCredential(credential);
    }
    throw Exception('Facebook sign in failed: ${result.message}');
  }
}
