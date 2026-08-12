import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final SignOutUseCase signOutUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.signOutUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthFacebookSignInRequested>(_onFacebookSignIn);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  void _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) {
    final isLoggedIn = checkAuthStatusUseCase();
    if (isLoggedIn) {
      final user = getCurrentUserUseCase();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ));
    }
  }

  Future<void> _onLogin(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        status: AuthStatus.loading, errorMessage: null, successMessage: null));
    final result = await loginUseCase(
        LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onRegister(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        status: AuthStatus.loading, errorMessage: null, successMessage: null));
    final result = await registerUseCase(
        RegisterParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        successMessage: 'Đăng ký tài khoản thành công!',
      )),
    );
  }

  Future<void> _onForgotPassword(
      AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        status: AuthStatus.loading, errorMessage: null, successMessage: null));
    final result = await forgotPasswordUseCase(
        ForgotPasswordParams(email: event.email));
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        successMessage: 'Đã gửi liên kết khôi phục mật khẩu vào email của bạn.',
      )),
    );
  }

  Future<void> _onGoogleSignIn(
      AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        status: AuthStatus.loading, errorMessage: null, successMessage: null));
    final result = await signInWithGoogleUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onFacebookSignIn(
      AuthFacebookSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        status: AuthStatus.loading, errorMessage: null, successMessage: null));
    final result = await signInWithFacebookUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onLogout(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await signOutUseCase(NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
