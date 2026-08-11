import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/configs/overlay_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movie/presentation/screens/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'forgot_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    final colors = context.appColors;
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: colors.inputHint, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: Colors.amber),
      prefixIcon: prefixIcon,
      prefixIconColor: colors.inputHint,
      suffixIcon: suffixIcon,
      suffixIconColor: colors.inputHint,
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colors.inputBorder,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.amber,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildGlassDecoration() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.15),
                  blurRadius: 120,
                  spreadRadius: 60,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00F2FE).withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F2FE).withValues(alpha: 0.08),
                  blurRadius: 140,
                  spreadRadius: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          OverlayScreen().showOverlay(
              context, 'success.login'.tr(), Colors.green,
              duration: 2);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          OverlayScreen().showOverlay(
              context,
              state.errorMessage ?? 'errors.login'.tr(),
              Colors.red,
              duration: 3);
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBg,
        body: Stack(
          children: [
            _buildGlassDecoration(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.movie_filter_rounded,
                                size: 48,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'loginScreen.title'.tr(),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ).animate().fade(duration: 600.ms).slideY(
                            begin: -0.2, end: 0, curve: Curves.easeOutQuad),
                      ),
                      const SizedBox(height: 36),
                      Form(
                        key: keyForm,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color: colors.textPrimary, fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'errors.emailRequired'.tr();
                                } else if (!emailRegExp.hasMatch(value)) {
                                  return 'errors.emailInvalid'.tr();
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                labelText: "Email",
                                prefixIcon:
                                    const Icon(Icons.email_outlined, size: 20),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: pwController,
                              obscureText: obscureText,
                              style: TextStyle(
                                  color: colors.textPrimary, fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'errors.passwordRequired'.tr();
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                labelText: 'loginScreen.password'.tr(),
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() {
                                    obscureText = !obscureText;
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotScreen()),
                          ),
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state.status == AuthStatus.loading;
                          return GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (keyForm.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                            AuthEvent.loginRequested(
                                              email: emailController.text.trim(),
                                              password: pwController.text.trim(),
                                            ),
                                          );
                                    }
                                  },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.orangeAccent],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      )
                                    : Text(
                                        'loginScreen.title'.tr(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'loginScreen.noAccount'.tr(),
                            style: TextStyle(
                                color: colors.textTertiary, fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            ),
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(child: Divider(color: colors.divider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'hoặc đăng nhập với',
                              style: TextStyle(
                                  color: colors.textTertiary, fontSize: 12),
                            ),
                          ),
                          Expanded(child: Divider(color: colors.divider)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Google Button
                      GestureDetector(
                        onTap: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.googleSignInRequested()),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colors.inputFill,
                            border: Border.all(
                              color: colors.inputBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/imgs/logo_google.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Google',
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Facebook Button
                      GestureDetector(
                        onTap: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.facebookSignInRequested()),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color:
                                const Color(0xFF1877F2).withValues(alpha: 0.1),
                            border: Border.all(
                              color: const Color(0xFF1877F2)
                                  .withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/imgs/logo_facebook.png",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Facebook',
                                style: TextStyle(
                                  color: Color(0xFF1877F2),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].animate(interval: 80.ms).fade(duration: 350.ms).slideY(
                        begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
