import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/features/auth/presentation/screens/forgot_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/home_screen.dart';
import 'package:movie_app/src/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
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
      floatingLabelStyle: const TextStyle(color: Colors.orangeAccent),
      prefixIcon: prefixIcon,
      prefixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused)
              ? Colors.orangeAccent
              : colors.inputHint),
      suffixIcon: suffixIcon,
      suffixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused)
              ? Colors.orangeAccent
              : colors.inputHint),
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
          color: Colors.orangeAccent,
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
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  Widget _buildGlassDecoration() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withValues(alpha: 0.12),
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE91E63).withValues(alpha: 0.06),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE91E63).withValues(alpha: 0.06),
                  blurRadius: 120,
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
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Stack(
        children: [
          _buildGlassDecoration(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent.withValues(alpha: 0.1),
                              border: Border.all(
                                color: Colors.orangeAccent.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orangeAccent.withValues(alpha: 0.05),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.movie_filter_rounded,
                              size: 44,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'loginScreen.title'.tr(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 800.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
                    ),
                    const SizedBox(height: 36),
                    Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: colors.textPrimary, fontSize: 15),
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
                              prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: pwController,
                            obscureText: obscureText,
                            style: TextStyle(color: colors.textPrimary, fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'errors.passwordRequired'.tr();
                              }
                              return null;
                            },
                            decoration: _buildInputDecoration(
                              labelText: 'loginScreen.password'.tr(),
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
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
                          MaterialPageRoute(builder: (_) => const ForgotScreen()),
                        ),
                        child: Text(
                          'loginScreen.forgotPassword'.tr(),
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (keyForm.currentState!.validate()) {
                          login(emailController.text, pwController.text);
                        }
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.orangeAccent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
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
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'loginScreen.noAccount'.tr(),
                          style: TextStyle(color: colors.textTertiary, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ),
                          child: Text(
                            'registerScreen.title'.tr(),
                            style: const TextStyle(
                              color: Colors.orangeAccent,
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
                            'app.or'.tr(),
                            style: TextStyle(color: colors.textTertiary, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: colors.divider)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Google Social login
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        signInWithGoogle();
                      },
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
                              'loginScreen.loginWith'.tr(args: ["Google"]),
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
                    // Facebook Social login
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        signInWithFacebook();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF1877F2).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(0xFF1877F2).withValues(alpha: 0.3),
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
                            Text(
                              'loginScreen.loginWith'.tr(args: ["Facebook"]),
                              style: const TextStyle(
                                color: Color(0xFF1877F2),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].animate(interval: 100.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final colors = context.appColors;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141622),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.border,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _buildLoadingIndicator(),
    );
    final result = await ref.read(loginUseCaseProvider).call(email, password);
    final isUser = ref.read(isUserUseCaseProvider).call();
    if (!mounted) return;
    Navigator.pop(context);
    if (result) {
      OverlayScreen().showOverlay(context, 'success.login'.tr(), Colors.green,
          duration: 2);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (isUser) {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      });
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.login'.tr(), Colors.red, duration: 3);
    }
  }

  Future<void> signInWithGoogle() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _buildLoadingIndicator(),
    );
    final result = await ref.read(signInWithGoogleUseCaseProvider).call();
    final isUser = ref.read(isUserUseCaseProvider).call();
    if (!mounted) return;
    Navigator.pop(context);
    if (result && isUser) {
      OverlayScreen().showOverlay(context, 'success.login'.tr(), Colors.green,
          duration: 2);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.login'.tr(), Colors.red, duration: 3);
    }
  }

  Future<void> signInWithFacebook() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _buildLoadingIndicator(),
    );
    final result = await ref.read(signInWithFacebookUseCaseProvider).call();
    final isUser = ref.read(isUserUseCaseProvider).call();
    if (!mounted) return;
    Navigator.pop(context);
    if (result && isUser) {
      OverlayScreen().showOverlay(context, 'success.login'.tr(), Colors.green,
          duration: 2);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.login'.tr(), Colors.red, duration: 3);
    }
  }
}
