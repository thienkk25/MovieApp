import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/my_profile_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/screens/configs/workmanager_task.dart';
import 'package:movie_app/src/screens/login_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageBarScreen extends ConsumerStatefulWidget {
  const ManageBarScreen({super.key});

  @override
  ConsumerState<ManageBarScreen> createState() => _ManageBarScreenState();
}

class _ManageBarScreenState extends ConsumerState<ManageBarScreen> {
  final UserController userController = UserController();
  final MovieController movieController = MovieController();
  late User user;
  late final SharedPreferences pref;
  late bool isNotification;
  @override
  void initState() {
    user = userController.user()!;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadData();
      },
    );
    super.initState();
  }

  Future<void> loadData() async {
    await movieController.historyWatchMovies(ref);
    pref = await SharedPreferences.getInstance();
    isNotification = pref.getBool("notification") ?? true;
  }

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
                        radius: 20,
                        // child: CachedNetworkImage(
                        //   imageUrl:
                        //       "https://res.cloudinary.com/dksr7si4o/image/upload/v1737959542/flutter/avatar/2_zqi5hz.jpg",
                        //   memCacheHeight: 100,
                        // ),
                      ),
                    ),
                    Positioned(
                      left: 60,
                      top: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Xin chào, ${user.email?.split('@')[0] ?? "Không có"}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Email: ${user.email ?? "Không có"}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyProfileScreen()));
                  },
                  child: const ListTile(
                    leading: Icon(Icons.contact_mail_outlined),
                    title: Text("Thông tin cá nhân"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, StateSetter stateSetter) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                title: const Text('Bật thông báo'),
                                trailing: isNotification
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context, "Bật thông báo", Colors.green,
                                      duration: 2);
                                  pref.setBool("notification_enabled", true);
                                  stateSetter(() => isNotification = true);
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                title: const Text('Tắt thông báo'),
                                trailing: isNotification
                                    ? null
                                    : const Icon(Icons.check),
                                onTap: () async {
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context, "Tắt thông báo", Colors.grey,
                                      duration: 2);
                                  pref.setBool("notification_enabled", false);
                                  await WorkmanagerTask
                                      .cancelNotificationTasks();
                                  stateSetter(() => isNotification = false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Thông báo"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              title: const Text('Tiếng Việt'),
                              onTap: () {
                                Navigator.pop(context);
                                OverlayScreen().showOverlay(
                                    context, "Chưa phát hành", Colors.orange,
                                    duration: 2);
                              },
                            ),
                            const Divider(
                              height: 1,
                            ),
                            ListTile(
                              title: const Text('Tiếng Anh'),
                              onTap: () {
                                Navigator.pop(context);
                                OverlayScreen().showOverlay(
                                    context, "Chưa phát hành", Colors.orange,
                                    duration: 2);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.translate),
                    title: Text("Ngôn ngữ"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Consumer(
                        builder: (context, ref, child) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.light_mode),
                                title: const Text('Giao diện sáng'),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.light
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.light;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context, "Sáng", Colors.blueGrey,
                                      duration: 2);
                                  pref.setString("themeMode", "light");
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                leading: const Icon(Icons.dark_mode),
                                title: const Text('Giao diện tối'),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.dark
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.dark;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context, "Tối", Colors.blueGrey,
                                      duration: 2);
                                  pref.setString("themeMode", "dark");
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone_android),
                                title: const Text('Giao diện theo hệ thống'),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.system
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.system;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context, "Theo hệ thống", Colors.blueGrey,
                                      duration: 2);
                                  pref.setString("themeMode", "auto");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.mode_night),
                    title: Text("Giao diện"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Consumer(
                        builder: (context, ref, child) {
                          Map data = ref.watch(historyMoviesNotifierProvider);
                          List dataHistory = data.values.toList();
                          return dataHistory.isNotEmpty
                              ? Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  )),
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: SafeArea(
                                    child: ListView.builder(
                                      itemCount: dataHistory.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    InforMovieScreen(
                                                      slugMovie:
                                                          dataHistory[index]
                                                              ['slug'],
                                                    ))),
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          InforMovieScreen(
                                                                            slugMovie:
                                                                                dataHistory[index]['slug'],
                                                                          )));
                                                            },
                                                            child: const Text(
                                                                "Xem")),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              final result = await movieController
                                                                  .removeHistoryWatchMovies(
                                                                      dataHistory[
                                                                              index]
                                                                          [
                                                                          'slug']);

                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              if (result) {
                                                                OverlayScreen()
                                                                    .showOverlay(
                                                                        context,
                                                                        "Xóa thành công",
                                                                        Colors
                                                                            .green,
                                                                        duration:
                                                                            3);
                                                                ref
                                                                    .read(historyMoviesNotifierProvider
                                                                        .notifier)
                                                                    .removeState(
                                                                        dataHistory[index]
                                                                            [
                                                                            'slug']);
                                                              } else {
                                                                OverlayScreen()
                                                                    .showOverlay(
                                                                        context,
                                                                        "Có lỗi, vui lòng thử lại",
                                                                        Colors
                                                                            .red,
                                                                        duration:
                                                                            3);
                                                              }
                                                            },
                                                            child: const Text(
                                                                "Xóa")),
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1))),
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                              imageUrl: dataHistory[index]
                                                  ['poster_url'],
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.fill,
                                              memCacheHeight: 100,
                                            ),
                                            title: Text(
                                              dataHistory[index]['name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              "Đã từng xem: Tập ${dataHistory[index]['episode'].toString()}",
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_sharp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text("Lịch sử trống"),
                                );
                        },
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Lịch sử xem"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Thông báo"),
                          content:
                              const Text("Bạn có chắc muốn đăng xuất không?"),
                          actions: [
                            CupertinoDialogAction(
                                child: const Text("Hủy"),
                                onPressed: () => Navigator.pop(context)),
                            CupertinoDialogAction(
                                child: const Text("OK"),
                                onPressed: () => signOut()),
                          ],
                        );
                      },
                    );
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

    if (result == "Đăng xuất thành công") {
      OverlayScreen().showOverlay(context, result, Colors.green, duration: 3);
    } else {
      OverlayScreen().showOverlay(context, result, Colors.red, duration: 3);
    }
  }
}
