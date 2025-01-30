import 'package:flutter/material.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/login_screen.dart';

class ManageBarScreen extends StatefulWidget {
  const ManageBarScreen({super.key});

  @override
  State<ManageBarScreen> createState() => _ManageBarScreenState();
}

class _ManageBarScreenState extends State<ManageBarScreen> {
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff30cfd0), Color(0xff330867)])),
                    ),
                    const Positioned(
                      left: 10,
                      top: 25,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://res.cloudinary.com/dksr7si4o/image/upload/v1737959542/flutter/avatar/2_zqi5hz.jpg"),
                        radius: 20,
                      ),
                    ),
                    const Positioned(
                      left: 60,
                      top: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "user@gmail.com",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.contact_mail_outlined),
                    title: Text("Thông tin cá nhân"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Thông báo"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.translate),
                    title: Text("Ngôn ngữ"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.mode_night),
                    title: Text("Giao diện"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Divider(),
                InkWell(
                  onTap: () {
                    signOut();
                  },
                  child: const ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Đăng xuất"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final result = await userController.signOut();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result),
      duration: const Duration(milliseconds: 300),
    ));
  }
}
