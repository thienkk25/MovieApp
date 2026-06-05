import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  late User? user;
  late String uid;
  late String email;
  late String name;
  late String photo;
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentUser = UserController().user();
    user = currentUser;
    uid = currentUser?.uid ?? "";
    email = currentUser?.email ?? "";
    name = currentUser?.displayName ?? "";
    photo = currentUser?.photoURL ?? "";
    nameController.text = name;
  }

  Future<void> _saveName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty || user == null) return;
    await user!.updateDisplayName(newName);
    await user!.reload();
    setState(() {
      name = FirebaseAuth.instance.currentUser?.displayName ?? newName;
      isEditing = false;
      ref.read(currentNameUser.notifier).state = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF141E30), Color(0xFF243B55)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          'profileScreen.title'.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF141E30), Color(0xFF243B55)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(color: Colors.black.withValues(alpha: .2)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profileAvatar',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: photo,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white10,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isEditing)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: nameController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white30),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                      onSubmitted: (_) async => _saveName(),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async => _saveName(),
                                    icon: const Icon(Icons.check,
                                        color: Colors.lightGreenAccent),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => isEditing = false),
                                    icon: const Icon(Icons.close,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name.isNotEmpty ? name : "-",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => isEditing = true),
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .8),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _infoTile("UID", uid),
                  _infoTile('profileScreen.name'.tr(), name),
                  _infoTile('profileScreen.email'.tr(), email),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1F25), Color(0xFF16181D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : "—",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
