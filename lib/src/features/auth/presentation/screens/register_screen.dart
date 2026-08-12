import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/configs/overlay_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController rePwController = TextEditingController();
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
          top: -80,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.12),
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
              color: const Color(0xFF00F2FE).withValues(alpha: 0.06),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F2FE).withValues(alpha: 0.06),
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && state.successMessage != null) {
          OverlayScreen().showOverlay(
              context, state.successMessage!, Colors.green,
              duration: 3);
          Navigator.pop(context);
        } else if (state.status == AuthStatus.failure) {
          OverlayScreen().showOverlay(
              context,
              state.errorMessage ?? 'errors.register'.tr(),
              Colors.red,
              duration: 3);
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: colors.iconSecondary, size: 20),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 48,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Đăng ký tài khoản',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
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
                                } else if (value.length < 6) {
                                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                labelText: 'Mật khẩu',
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
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: rePwController,
                              obscureText: obscureText,
                              style: TextStyle(
                                  color: colors.textPrimary, fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'errors.passwordRequired'.tr();
                                } else if (value != pwController.text) {
                                  return 'Mật khẩu không trùng khớp';
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                labelText: 'Xác nhận mật khẩu',
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
                      const SizedBox(height: 36),
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
                                            AuthEvent.registerRequested(
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
                                    : const Text(
                                        'Tạo tài khoản',
                                        style: TextStyle(
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản?',
                            style: TextStyle(
                                color: colors.textTertiary, fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Đăng nhập ngay',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
