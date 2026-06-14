import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController rePwController = TextEditingController();

  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    rePwController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: Colors.orangeAccent),
      prefixIcon: prefixIcon,
      prefixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused)
              ? Colors.orangeAccent
              : Colors.white38),
      suffixIcon: suffixIcon,
      suffixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused)
              ? Colors.orangeAccent
              : Colors.white38),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
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
    return Scaffold(
      backgroundColor: const Color(0xFF090A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                              Icons.person_add_alt_1_rounded,
                              size: 44,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'registerScreen.title'.tr(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                            style: const TextStyle(color: Colors.white, fontSize: 15),
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
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'errors.passwordRequired'.tr();
                              } else if (value.length < 6) {
                                return 'errors.passwordTooShort'.tr();
                              }
                              return null;
                            },
                            decoration: _buildInputDecoration(
                              labelText: 'registerScreen.password'.tr(),
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
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: rePwController,
                            obscureText: obscureText,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'errors.passwordRequired'.tr();
                              } else if (value != pwController.text) {
                                return 'errors.confirmPasswordMismatch'.tr();
                              }
                              return null;
                            },
                            decoration: _buildInputDecoration(
                              labelText: 'registerScreen.confirmPassword'.tr(),
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
                    const SizedBox(height: 36),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (keyForm.currentState!.validate()) {
                          register(emailController.text, pwController.text);
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
                            'registerScreen.title'.tr(),
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'registerScreen.haveAccount'.tr(),
                          style: const TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'loginScreen.title'.tr(),
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141622),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
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

  Future<void> register(String email, String password) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _buildLoadingIndicator(),
    );
    final result = await ref.read(registerUseCaseProvider).call(email, password);
    if (!mounted) return;
    Navigator.pop(context);
    if (result) {
      OverlayScreen().showOverlay(
          context, 'success.register'.tr(), Colors.green,
          duration: 3);
      emailController.clear();
      pwController.clear();
      rePwController.clear();
      // Go back to login screen on success
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      OverlayScreen().showOverlay(context, 'errors.register'.tr(), Colors.red,
          duration: 3);
    }
  }
}
