import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/features/auth/data/datasources/user_firestore_data_source.dart';
import 'package:movie_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/src/features/auth/domain/usecases/auth_usecases.dart';

// --- DataSource Providers ---
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final userFirestoreDataSourceProvider = Provider<UserFirestoreDataSource>((ref) {
  return UserFirestoreDataSourceImpl();
});

// --- Repository Provider ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    userFirestoreDataSource: ref.watch(userFirestoreDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final forgotUseCaseProvider = Provider((ref) {
  return ForgotUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final isUserUseCaseProvider = Provider((ref) {
  return IsUserUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final updateInforUserUseCaseProvider = Provider((ref) {
  return UpdateInforUserUseCase(ref.watch(authRepositoryProvider));
});

final signInWithGoogleUseCaseProvider = Provider((ref) {
  return SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));
});

final signInWithFacebookUseCaseProvider = Provider((ref) {
  return SignInWithFacebookUseCase(ref.watch(authRepositoryProvider));
});
