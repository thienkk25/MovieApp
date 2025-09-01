import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/src/services/auth_service.dart';

class UserController {
  AuthService authService = AuthService();
  Future<String> login(String email, String password) async {
    final result = await authService.login(email, password);
    return result;
  }

  Future<String> register(String name, String email, String password) async {
    final result = await authService.register(name, email, password);
    return result;
  }

  Future<String> forgot(String email) async {
    final result = await authService.forgot(email);
    return result;
  }

  Future<String> signOut() async {
    final result = await authService.signOut();
    return result;
  }

  bool isUser() {
    final result = authService.isUser();
    return result;
  }

  User? user() {
    final user = authService.user();
    return user;
  }

  Future<bool> signInWithGoogle() async {
    final result = await authService.signInWithGoogle();
    return result;
  }

  Future<bool> signInWithFacebook() async {
    final result = await authService.signInWithFacebook();
    return result;
  }
}
