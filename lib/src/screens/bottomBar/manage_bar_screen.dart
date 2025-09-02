import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
  late final User? user;
  late final String myselftEmail;
  late final String userName;
  late final String profilePicture;
  late final SharedPreferences pref;
  late bool isNotification;
  @override
  void initState() {
    user = userController.user()!;
    myselftEmail = user?.email ?? "";
    userName = user?.displayName ?? "";
    profilePicture = user?.photoURL ??
        "https://res.cloudinary.com/dksr7si4o/image/upload/v1737961456/flutter/avatar/6_cnm2fb.jpg";
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
        title: const Text('app.information').tr(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff30cfd0), Color(0xff330867)])),
                  child: Row(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'app.hi'.tr(args: [userName]),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'app.email'.tr(args: [myselftEmail]),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyProfileScreen()));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.contact_mail_outlined),
                    title: const Text('profileScreen.title').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
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
                                title: const Text(
                                        'settingsScreen.notifications.on')
                                    .tr(),
                                trailing: isNotification
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.notifications.on'.tr(),
                                      Colors.green,
                                      duration: 2);
                                  pref.setBool("notification_enabled", true);
                                  stateSetter(() => isNotification = true);
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                title: Text(
                                    'settingsScreen.notifications.off'.tr()),
                                trailing: isNotification
                                    ? null
                                    : const Icon(Icons.check),
                                onTap: () async {
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.notifications.off'.tr(),
                                      Colors.grey,
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
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title:
                        const Text('settingsScreen.notifications.title').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
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
                                title: const Text('settingsScreen.language.vi')
                                    .tr(),
                                trailing: ref.watch(isLanguageProvider) ==
                                        const Locale('vi', '')
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  context.setLocale(const Locale('vi', ''));
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.language.vi'.tr(),
                                      Colors.blueGrey,
                                      duration: 2);
                                  ref.read(isLanguageProvider.notifier).state =
                                      const Locale('vi', '');
                                  await pref.setInt("language", 0);
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                title: const Text('settingsScreen.language.en')
                                    .tr(),
                                trailing: ref.watch(isLanguageProvider) ==
                                        const Locale('en', '')
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  context.setLocale(const Locale('en', ''));
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.language.en'.tr(),
                                      Colors.blueGrey,
                                      duration: 2);
                                  ref.read(isLanguageProvider.notifier).state =
                                      const Locale('en', '');
                                  await pref.setInt("language", 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.translate),
                    title: const Text('app.language').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
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
                                title: const Text('settingsScreen.theme.light')
                                    .tr(),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.light
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.light;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.theme.light'.tr(),
                                      Colors.blueGrey,
                                      duration: 2);
                                  pref.setString("themeMode", "light");
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                leading: const Icon(Icons.dark_mode),
                                title: const Text('settingsScreen.theme.dark')
                                    .tr(),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.dark
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.dark;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.theme.dark'.tr(),
                                      Colors.blueGrey,
                                      duration: 2);
                                  pref.setString("themeMode", "dark");
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone_android),
                                title: const Text('settingsScreen.theme.system')
                                    .tr(),
                                trailing: ref.watch(themeModeProvider) ==
                                        ThemeMode.system
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () async {
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.system;
                                  Navigator.pop(context);
                                  OverlayScreen().showOverlay(
                                      context,
                                      'settingsScreen.theme.system'.tr(),
                                      Colors.blueGrey,
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
                  child: ListTile(
                    leading: const Icon(Icons.mode_night),
                    title: const Text('settingsScreen.theme.title').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
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
                                                                    'app.watch')
                                                                .tr()),
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
                                                                        'success.delete'
                                                                            .tr(),
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
                                                                        'errors.delete'
                                                                            .tr(),
                                                                        Colors
                                                                            .red,
                                                                        duration:
                                                                            3);
                                                              }
                                                            },
                                                            child: const Text(
                                                                    'app.del')
                                                                .tr()),
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
                                              'historyScreen.watchedEpisode'.tr(
                                                args: [
                                                  'movie.episode'.plural(
                                                      dataHistory[index]
                                                          ['episode'])
                                                ],
                                              ),
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
                              : Center(
                                  child:
                                      Text('historyScreen.emptyMessage'.tr()),
                                );
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('historyScreen.title').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title:
                              const Text('settingsScreen.notifications.title')
                                  .tr(),
                          content: const Text('dialog.confirmLogout').tr(),
                          actions: [
                            CupertinoDialogAction(
                                child: const Text('navigation.cancel').tr(),
                                onPressed: () => Navigator.pop(context)),
                            CupertinoDialogAction(
                                child: const Text('navigation.ok').tr(),
                                onPressed: () => signOut()),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('profileScreen.logout').tr(),
                    trailing: const Icon(Icons.arrow_forward_ios),
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

    if (result) {
      OverlayScreen().showOverlay(context, 'success.logout'.tr(), Colors.green,
          duration: 3);
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.logout'.tr(), Colors.red, duration: 3);
    }
  }
}
