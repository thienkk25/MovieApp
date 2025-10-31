import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/my_profile_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/screens/configs/workmanager_task.dart';
import 'package:movie_app/src/screens/login_screen.dart';
import 'package:movie_app/src/screens/widgets/animated_movie_header.dart';
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
    profilePicture = user?.photoURL ?? "";
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await loadData();
        ref.read(currentNameUser.notifier).state = userName;
      },
    );
    super.initState();
  }

  Future<void> loadData() async {
    await movieController.historyWatchMovies(ref);
    pref = await SharedPreferences.getInstance();
    isNotification = pref.getBool("notification_enabled") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
            ),
          ),
        ),
        title: Text(
          'app.information'.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, child) => AnimatedMovieHeader(
                      profilePicture: profilePicture,
                      userName: ref.watch(currentNameUser),
                      myselftEmail: myselftEmail,
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
                          builder: (context, StateSetter stateSetter) =>
                              SafeArea(
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
                                  title:
                                      const Text('settingsScreen.language.vi')
                                          .tr(),
                                  trailing: ref.watch(isLanguageProvider) ==
                                          const Locale('vi', '')
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    context.setLocale(const Locale('vi', ''));
                                    OverlayScreen().showOverlay(
                                        context,
                                        'settingsScreen.language.vi'.tr(),
                                        Colors.blueGrey,
                                        duration: 2);
                                    ref
                                        .read(isLanguageProvider.notifier)
                                        .state = const Locale('vi', '');
                                    ref.read(currentTitle.notifier).state =
                                        'app.home';
                                    await pref.setInt("language", 0);
                                  },
                                ),
                                const Divider(
                                  height: 1,
                                ),
                                ListTile(
                                  title:
                                      const Text('settingsScreen.language.en')
                                          .tr(),
                                  trailing: ref.watch(isLanguageProvider) ==
                                          const Locale('en', '')
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    context.setLocale(const Locale('en', ''));
                                    OverlayScreen().showOverlay(
                                        context,
                                        'settingsScreen.language.en'.tr(),
                                        Colors.blueGrey,
                                        duration: 2);
                                    ref
                                        .read(isLanguageProvider.notifier)
                                        .state = const Locale('en', '');
                                    ref.read(currentTitle.notifier).state =
                                        'app.home';
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
                                  title:
                                      const Text('settingsScreen.theme.light')
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
                                  title:
                                      const Text('settingsScreen.theme.system')
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
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (context) => Consumer(
                          builder: (context, ref, child) {
                            Map data = ref.watch(historyMoviesNotifierProvider);
                            List dataHistory = data.values.toList();

                            if (dataHistory.isEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.history,
                                          size: 64, color: Colors.grey),
                                      const SizedBox(height: 12),
                                      Text('historyScreen.emptyMessage'.tr(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 5,
                                        children: [
                                          const Icon(
                                            Icons.history,
                                            size: 30,
                                          ),
                                          Text(
                                            'historyScreen.title'.tr(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: dataHistory.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) {
                                        final item = dataHistory[index];

                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => InforMovieScreen(
                                                  slugMovie: item['slug']),
                                            ),
                                          ),
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        item['name'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ElevatedButton.icon(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      InforMovieScreen(
                                                                          slugMovie:
                                                                              item['slug']),
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .play_arrow),
                                                            label: Text(
                                                                'app.watch'
                                                                    .tr()),
                                                          ),
                                                          OutlinedButton.icon(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  WidgetStatePropertyAll(
                                                                      Colors.red[
                                                                          400]),
                                                              iconColor:
                                                                  const WidgetStatePropertyAll(
                                                                      Colors
                                                                          .white),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              final result =
                                                                  await movieController
                                                                      .removeHistoryWatchMovies(
                                                                          item[
                                                                              'slug']);
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(
                                                                  context);
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
                                                                        item[
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
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            label: Text(
                                                              'app.del'.tr(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withValues(alpha: .95),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: .05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        item['poster_url'],
                                                    height: 90,
                                                    width: 65,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                progress) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error,
                                                            size: 40),
                                                    memCacheHeight: 150,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item['name'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          'historyScreen.watchedEpisode'
                                                              .tr(
                                                            args: [
                                                              'movie.episode'
                                                                  .plural(item[
                                                                      'episode'])
                                                            ],
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 18,
                                                    color: Colors.grey),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                ],
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'settingsScreen.notifications.title'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'dialog.confirmLogout'.tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('navigation.cancel'.tr()),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      signOut();
                                    },
                                    child: Text('navigation.ok'.tr()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
