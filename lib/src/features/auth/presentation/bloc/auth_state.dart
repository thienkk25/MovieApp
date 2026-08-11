import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
  }) = _AuthState;
}
