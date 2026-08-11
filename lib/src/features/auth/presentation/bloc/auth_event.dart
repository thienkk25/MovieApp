import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthLoginRequested;

  const factory AuthEvent.registerRequested({
    required String email,
    required String password,
  }) = AuthRegisterRequested;

  const factory AuthEvent.forgotPasswordRequested({
    required String email,
  }) = AuthForgotPasswordRequested;

  const factory AuthEvent.googleSignInRequested() = AuthGoogleSignInRequested;

  const factory AuthEvent.facebookSignInRequested() = AuthFacebookSignInRequested;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;

  const factory AuthEvent.checkAuthStatus() = AuthCheckStatus;
}
