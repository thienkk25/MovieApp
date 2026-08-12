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
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthExceptionMessage(e));
    }
  }

  @override
  Future<UserCredential> register(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthExceptionMessage(e));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthExceptionMessage(e));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _facebookAuth.logOut();
    } catch (_) {}
    await _firebaseAuth.signOut();
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

  bool _isGoogleSignInInitialized = false;

  Future<void> _initGoogleSignIn() async {
    if (!_isGoogleSignInInitialized) {
      try {
        await _googleSignIn.initialize(
          serverClientId:
              '374460320009-8h4r4ohe86fjjf1b39m7bspl9fc3g3ge.apps.googleusercontent.com',
        );
        _isGoogleSignInInitialized = true;
      } catch (_) {
        // Ignored if initialized
      }
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      await _initGoogleSignIn();

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthExceptionMessage(e));
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('cancel') || errStr.contains('canceled') || errStr.contains('hủy')) {
        throw Exception('Đã hủy đăng nhập Google');
      }
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        return await _firebaseAuth.signInWithCredential(credential);
      }

      if (result.status == LoginStatus.cancelled) {
        throw Exception('Đã hủy đăng nhập Facebook');
      }

      // Native login failed (e.g. key hash issue or no FB app installed), try web login
      final LoginResult webResult = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.webOnly,
      );

      if (webResult.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(webResult.accessToken!.tokenString);
        return await _firebaseAuth.signInWithCredential(credential);
      }

      if (webResult.status == LoginStatus.cancelled) {
        throw Exception('Đã hủy đăng nhập Facebook');
      }

      throw Exception(webResult.message ?? 'Đăng nhập Facebook thất bại');
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthExceptionMessage(e));
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('cancel') || errStr.contains('canceled') || errStr.contains('hủy')) {
        throw Exception('Đã hủy đăng nhập Facebook');
      }
      rethrow;
    }
  }

  String _mapFirebaseAuthExceptionMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Tài khoản email này đã được sử dụng với phương thức đăng nhập khác.';
      case 'invalid-credential':
        return 'Thông tin xác thực không hợp lệ.';
      case 'user-disabled':
        return 'Tài khoản của bạn đã bị khóa.';
      case 'user-not-found':
        return 'Tài khoản không tồn tại.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác.';
      case 'email-already-in-use':
        return 'Địa chỉ email này đã được đăng ký.';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ.';
      case 'operation-not-allowed':
        return 'Phương thức đăng nhập này chưa được kích hoạt trên hệ thống.';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối Internet.';
      default:
        return e.message ?? 'Đã xảy ra lỗi xác thực (${e.code}).';
    }
  }
}
