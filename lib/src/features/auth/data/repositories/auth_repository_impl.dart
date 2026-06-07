import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/features/auth/data/datasources/user_firestore_data_source.dart';
import 'package:movie_app/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserFirestoreDataSource userFirestoreDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.userFirestoreDataSource,
  });

  @override
  Future<bool> login(String email, String password) async {
    try {
      await authRemoteDataSource.login(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password) async {
    try {
      final credential = await authRemoteDataSource.register(email, password);
      final uid = credential.user?.uid;
      if (uid != null) {
        await userFirestoreDataSource.createUserDoc(uid, email);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> forgot(String email) async {
    try {
      await authRemoteDataSource.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool isUser() {
    return authRemoteDataSource.isUser();
  }

  @override
  User? user() {
    return authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<String> updateInforUser(
    String displayName,
    PhoneAuthCredential phoneNumber,
    String photoURL,
  ) async {
    try {
      await authRemoteDataSource.updateDisplayName(displayName);
      await authRemoteDataSource.updatePhoneNumber(phoneNumber);
      await authRemoteDataSource.updatePhotoURL(photoURL);
      await authRemoteDataSource.reloadUser();
      return "Cập nhật thành công";
    } catch (e) {
      return "Cập nhật thất bại";
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      await authRemoteDataSource.signInWithGoogle();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signInWithFacebook() async {
    try {
      await authRemoteDataSource.signInWithFacebook();
      return true;
    } catch (e) {
      return false;
    }
  }
}
