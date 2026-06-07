import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<bool> call(String email, String password) {
    return _repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<bool> call(String email, String password) {
    return _repository.register(email, password);
  }
}

class ForgotUseCase {
  final AuthRepository _repository;
  ForgotUseCase(this._repository);

  Future<bool> call(String email) {
    return _repository.forgot(email);
  }
}

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<bool> call() {
    return _repository.signOut();
  }
}

class IsUserUseCase {
  final AuthRepository _repository;
  IsUserUseCase(this._repository);

  bool call() {
    return _repository.isUser();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  User? call() {
    return _repository.user();
  }
}

class UpdateInforUserUseCase {
  final AuthRepository _repository;
  UpdateInforUserUseCase(this._repository);

  Future<String> call(String displayName, PhoneAuthCredential phoneNumber, String photoURL) {
    return _repository.updateInforUser(displayName, phoneNumber, photoURL);
  }
}

class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  Future<bool> call() {
    return _repository.signInWithGoogle();
  }
}

class SignInWithFacebookUseCase {
  final AuthRepository _repository;
  SignInWithFacebookUseCase(this._repository);

  Future<bool> call() {
    return _repository.signInWithFacebook();
  }
}
