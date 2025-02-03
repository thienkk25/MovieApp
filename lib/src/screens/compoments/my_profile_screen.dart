import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/src/controllers/user_controller.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File? file;
  UserController userController = UserController();
  late String myselftEmail;
  late String userName;
  late String profilePicture;
  late String phoneNumber;
  @override
  void initState() {
    load();
    super.initState();
  }

  Future<void> load() async {
    final user = userController.user();
    myselftEmail = user?.email ?? "Trống";
    userName = user?.displayName ?? "Trống";
    profilePicture = user?.photoURL ??
        "https://res.cloudinary.com/dksr7si4o/image/upload/v1737961456/flutter/avatar/6_cnm2fb.jpg";
    phoneNumber = user?.phoneNumber ?? "Add number";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getFileData(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    file = File(image.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
      ),
      body: Padding(
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
                      backgroundImage: file == null
                          ? NetworkImage(profilePicture)
                          : FileImage(file!),
                      radius: 30,
                    ),
                    InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Chọn từ thư viện'),
                                    onTap: () {
                                      getFileData(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const Divider(
                                    height: 1,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Chụp ảnh'),
                                    onTap: () {
                                      getFileData(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Opacity(
                          opacity: .6,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(width: 1, color: Colors.lightBlue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.photo_camera,
                              color: Colors.lightBlue,
                              size: 20,
                            ),
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      myselftEmail,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    )
                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
