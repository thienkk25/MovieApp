import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/screens/forgot_screen.dart';
import 'package:movie_app/src/screens/home_screen.dart';
import 'package:movie_app/src/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserController userController = UserController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text(
                  'loginScreen.title'.tr(),
                  style: const TextStyle(fontSize: 24),
                ).animate().scaleXY(duration: 1.seconds),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: sizeWidth / 1.2,
              child: Form(
                key: keyForm,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'errors.emailRequired'.tr();
                        } else if (!emailRegExp.hasMatch(value)) {
                          return 'errors.emailInvalid'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(width: 1),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: pwController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'errors.passwordRequired'.tr();
                        }
                        return null;
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: obscureText
                            ? GestureDetector(
                                onTap: () => setState(() {
                                      obscureText = !obscureText;
                                    }),
                                child:
                                    const Icon(Icons.visibility_off_outlined))
                            : GestureDetector(
                                onTap: () => setState(() {
                                      obscureText = !obscureText;
                                    }),
                                child: const Icon(Icons.visibility_outlined)),
                        labelText: 'loginScreen.password'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(width: 1),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ForgotScreen())),
                          child: const Text('loginScreen.forgotPassword').tr()),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (keyForm.currentState!.validate()) {
                          login(emailController.text, pwController.text);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: Colors.lightBlue,
                            border:
                                Border.all(width: 1, color: Colors.lightBlue)),
                        child: Center(
                          child: Text(
                            'loginScreen.title'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'loginScreen.noAccount'.tr(),
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen())),
                          child: Text(
                            'registerScreen.title'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Text('app.or').tr(),
                        ),
                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        signInWithGoogle();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        width: sizeWidth / 1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border:
                              Border.all(width: 1, color: Colors.grey.shade400),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Image.asset(
                              "assets/imgs/logo_google.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              'loginScreen.loginWith'.tr(args: ["Google"]),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        signInWithFacebook();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        width: sizeWidth / 1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF1877F2),
                          border: Border.all(
                              width: 1, color: const Color(0xFF1877F2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Image.asset(
                              "assets/imgs/logo_facebook.png",
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              'loginScreen.loginWith'.tr(args: ["Facebook"]),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].animate(interval: 300.ms).scaleX(duration: 300.ms),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.login(email, password);
    final isUser = userController.isUser();
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
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.signInWithGoogle();
    final isUser = userController.isUser();
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
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.signInWithFacebook();
    final isUser = userController.isUser();
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
