import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  UserController userController = UserController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
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
              "Quên mật khẩu",
              style: TextStyle(fontSize: 24),
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
                children: [
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (keyForm.currentState!.validate()) {
                        forgot(emailController.text);
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
                          "Gửi",
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
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  )
                ].animate(interval: 300.ms).scaleXY(duration: 300.ms),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> forgot(String email) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.forgot(email);
    if (!mounted) return;
    Navigator.pop(context);
    if (result == "Gửi thành công") {
      OverlayScreen().showOverlay(context,
          "$result, vui lòng kiểm tra thư hoặc ở thư rác", Colors.green,
          duration: 3);
    } else {
      OverlayScreen().showOverlay(context, result, Colors.red, duration: 3);
    }
  }
}
