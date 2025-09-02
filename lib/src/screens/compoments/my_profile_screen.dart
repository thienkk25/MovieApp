import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/controllers/user_controller.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = UserController().user();
    final String uid = user?.uid ?? "";
    final String myselftEmail = user?.email ?? "";
    final String userName = user?.displayName ?? "";
    final String profilePicture = user?.photoURL ??
        "https://res.cloudinary.com/dksr7si4o/image/upload/v1737961456/flutter/avatar/6_cnm2fb.jpg";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('profileScreen.title').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: profilePicture,
                    height: 50,
                    width: 50,
                    memCacheHeight: 100,
                  ),
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
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("UID"),
                Text(
                  uid,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('profileScreen.name').tr(),
                Text(
                  userName,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('profileScreen.email').tr(),
                Text(
                  myselftEmail,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
