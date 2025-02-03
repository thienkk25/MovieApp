import 'package:flutter/material.dart';
import 'package:movie_app/src/controllers/user_controller.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserController userController = UserController();
  late String myselftEmail;
  late String userName;
  late String profilePicture;
  late String phoneNumber;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        load();
      },
    );
    super.initState();
  }

  Future<void> load() async {
    final user = userController.user();
    myselftEmail = user?.email ?? "Trống";
    userName = user?.displayName ?? "Trống";
    profilePicture = user?.photoURL ?? "Trống";
    phoneNumber = user?.phoneNumber ?? "Add number";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture),
                      radius: 30,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.grey[400],
                        ))
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(userName), Text(myselftEmail)],
                )
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Name"),
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    cursorColor: Colors.lightGreen,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: userName,
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email account"),
                SizedBox(
                  width: 150,
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: myselftEmail),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    cursorColor: Colors.lightGreen,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mobile number"),
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    cursorColor: Colors.lightGreen,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: phoneNumber,
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Location"),
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    cursorColor: Colors.lightGreen,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "VN",
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Container(
                height: 35,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(5))),
                child: const Center(
                  child: Text(
                    "Save change",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
