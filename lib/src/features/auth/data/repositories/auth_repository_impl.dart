import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_firestore_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserFirestoreDataSource userFirestoreDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.userFirestoreDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final credential = await authRemoteDataSource.login(email, password);
      final user = credential.user;
      if (user != null) {
        return Right(UserEntity(
          uid: user.uid,
          email: user.email ?? email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ));
      }
      return const Left(AuthFailure('Đăng nhập thất bại, không tìm thấy thông tin tài khoản'));
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String email, String password) async {
    try {
      final credential = await authRemoteDataSource.register(email, password);
      final user = credential.user;
      if (user != null) {
        await userFirestoreDataSource.createUserDoc(user.uid, email);
        return Right(UserEntity(
          uid: user.uid,
          email: user.email ?? email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ));
      }
      return const Left(AuthFailure('Đăng ký thất bại'));
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await authRemoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final credential = await authRemoteDataSource.signInWithGoogle();
      final user = credential.user;
      if (user != null) {
        return Right(UserEntity(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ));
      }
      return const Left(AuthFailure('Đăng nhập Google thất bại'));
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final credential = await authRemoteDataSource.signInWithFacebook();
      final user = credential.user;
      if (user != null) {
        return Right(UserEntity(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ));
      }
      return const Left(AuthFailure('Đăng nhập Facebook thất bại'));
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  bool isUserLoggedIn() {
    return authRemoteDataSource.isUser();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = authRemoteDataSource.getCurrentUser();
    if (user != null) {
      return UserEntity(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    }
    return null;
  }
}
