import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserController userController = UserController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController rePwController = TextEditingController();
  // Regular expression for email validation
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Center(
                child: Text(
              'registerScreen.title'.tr(),
              style: const TextStyle(fontSize: 24),
            ).animate().scaleXY(duration: 1.seconds)),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
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
                      } else if (value.length < 6) {
                        return 'errors.passwordTooShort'.tr();
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
                              child: const Icon(Icons.visibility_off_outlined))
                          : GestureDetector(
                              onTap: () => setState(() {
                                    obscureText = !obscureText;
                                  }),
                              child: const Icon(Icons.visibility_outlined)),
                      labelText: 'registerScreen.password'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: rePwController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return 'errors.passwordRequired'.tr();
                      } else if (value != pwController.text) {
                        return 'errors.confirmPasswordMismatch'.tr();
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
                              child: const Icon(Icons.visibility_off_outlined))
                          : GestureDetector(
                              onTap: () => setState(() {
                                    obscureText = !obscureText;
                                  }),
                              child: const Icon(Icons.visibility_outlined)),
                      labelText: 'registerScreen.confirmPassword'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (keyForm.currentState!.validate()) {
                        register(emailController.text, pwController.text);
                        emailController.clear();
                        pwController.clear();
                        rePwController.clear();
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
                          'registerScreen.title'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'registerScreen.haveAccount'.tr(),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'loginScreen.title'.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ].animate(interval: 300.ms).scaleY(duration: 300.ms),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> register(String email, String password) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.register(email, password);
    if (!mounted) return;
    Navigator.pop(context);
    if (result) {
      OverlayScreen().showOverlay(
          context, 'success.register'.tr(), Colors.green,
          duration: 3);
    } else {
      OverlayScreen().showOverlay(context, 'errors.register'.tr(), Colors.red,
          duration: 3);
    }
  }
}
