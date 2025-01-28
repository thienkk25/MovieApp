import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_app/src/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController hvtController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController rePwController = TextEditingController();
  AuthService authService = AuthService();
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
            height: 100,
            width: double.infinity,
            child: Center(
                child: const Text(
              "Đăng ký",
              style: TextStyle(fontSize: 24),
            ).animate().scaleXY(duration: 1.seconds)),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Form(
              key: keyForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: hvtController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Vui lòng không để trống";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_mail_outlined),
                      labelText: "Họ và Tên",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Vui lòng không để trống!";
                      } else if (!emailRegExp.hasMatch(value)) {
                        return "Email không đúng định dạng!";
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pwController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Vui lòng không để trống!";
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
                      labelText: "Mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: rePwController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Vui lòng không để trống!";
                      } else if (value != pwController.text) {
                        return "Mật khẩu không khớp!";
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
                      labelText: "Nhập lại mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (keyForm.currentState!.validate()) {
                        // TODO
                        register(hvtController.text, emailController.text,
                            pwController.text);
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
                      child: const Center(
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn đã có tài khoản?",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(fontWeight: FontWeight.bold),
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

  Future<void> register(String name, String email, String password) async {
    final result = await authService.register(name, email, password);
  }
}
