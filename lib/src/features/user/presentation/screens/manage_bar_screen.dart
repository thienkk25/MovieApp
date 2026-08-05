import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/features/user/presentation/screens/my_profile_screen.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/configs/workmanager_task.dart';
import 'package:movie_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:movie_app/src/core/widgets/animated_movie_header.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';
import 'package:movie_app/src/core/providers/core_providers.dart';
import 'package:movie_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageBarScreen extends ConsumerStatefulWidget {
  const ManageBarScreen({super.key});

  @override
  ConsumerState<ManageBarScreen> createState() => _ManageBarScreenState();
}

class _ManageBarScreenState extends ConsumerState<ManageBarScreen> {
  late final User? user;
  late final String myselftEmail;
  late final String userName;
  late final String profilePicture;
  late final SharedPreferences pref;
  late bool isNotification;

  @override
  void initState() {
    user = ref.read(getCurrentUserUseCaseProvider).call();
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
    final data = await ref.read(getHistoryMoviesUseCaseProvider).call();
    ref.read(historyMoviesNotifierProvider.notifier).initState(data);
    pref = await SharedPreferences.getInstance();
    isNotification = pref.getBool("notification_enabled") ?? true;
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.orangeAccent, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: colors.iconInactive, size: 20),
          ],
        ),
      ),
    );
  }

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appColors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter stateSetter) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: context.appColors.iconInactive,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'settingsScreen.notifications.on'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing: isNotification
                    ? const Icon(Icons.check_circle_rounded,
                        color: Colors.orangeAccent)
                    : null,
                onTap: () async {
                  Navigator.pop(context);
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.notifications.on'.tr(), Colors.green,
                      duration: 2);
                  pref.setBool("notification_enabled", true);
                  setState(() => isNotification = true);
                },
              ),
              Divider(height: 1, color: context.appColors.divider),
              ListTile(
                title: Text(
                  'settingsScreen.notifications.off'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing: isNotification
                    ? null
                    : const Icon(Icons.check_circle_rounded,
                        color: Colors.orangeAccent),
                onTap: () async {
                  Navigator.pop(context);
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.notifications.off'.tr(), Colors.grey,
                      duration: 2);
                  pref.setBool("notification_enabled", false);
                  await WorkmanagerTask.cancelNotificationTasks();
                  setState(() => isNotification = false);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appColors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: context.appColors.iconInactive,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'settingsScreen.language.vi'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing:
                    ref.watch(isLanguageProvider) == const Locale('vi', '')
                        ? const Icon(Icons.check_circle_rounded,
                            color: Colors.orangeAccent)
                        : null,
                onTap: () async {
                  Navigator.pop(context);
                  context.setLocale(const Locale('vi', ''));
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.language.vi'.tr(), Colors.blueGrey,
                      duration: 2);
                  ref.read(isLanguageProvider.notifier).state =
                      const Locale('vi', '');
                  ref.read(currentTitle.notifier).state = 'app.home';
                  await pref.setInt("language", 0);
                },
              ),
              Divider(height: 1, color: context.appColors.divider),
              ListTile(
                title: Text(
                  'settingsScreen.language.en'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing:
                    ref.watch(isLanguageProvider) == const Locale('en', '')
                        ? const Icon(Icons.check_circle_rounded,
                            color: Colors.orangeAccent)
                        : null,
                onTap: () async {
                  Navigator.pop(context);
                  context.setLocale(const Locale('en', ''));
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.language.en'.tr(), Colors.blueGrey,
                      duration: 2);
                  ref.read(isLanguageProvider.notifier).state =
                      const Locale('en', '');
                  ref.read(currentTitle.notifier).state = 'app.home';
                  await pref.setInt("language", 1);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appColors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: context.appColors.iconInactive,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.light_mode, color: context.appColors.iconSecondary),
                title: Text(
                  'settingsScreen.theme.light'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing: ref.watch(themeModeProvider) == ThemeMode.light
                    ? const Icon(Icons.check_circle_rounded,
                        color: Colors.orangeAccent)
                    : null,
                onTap: () async {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                  Navigator.pop(context);
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.theme.light'.tr(), Colors.blueGrey,
                      duration: 2);
                  pref.setString("themeMode", "light");
                },
              ),
              Divider(height: 1, color: context.appColors.divider),
              ListTile(
                leading: Icon(Icons.dark_mode, color: context.appColors.iconSecondary),
                title: Text(
                  'settingsScreen.theme.dark'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing: ref.watch(themeModeProvider) == ThemeMode.dark
                    ? const Icon(Icons.check_circle_rounded,
                        color: Colors.orangeAccent)
                    : null,
                onTap: () async {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                  Navigator.pop(context);
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.theme.dark'.tr(), Colors.blueGrey,
                      duration: 2);
                  pref.setString("themeMode", "dark");
                },
              ),
              Divider(height: 1, color: context.appColors.divider),
              ListTile(
                leading: Icon(Icons.phone_android, color: context.appColors.iconSecondary),
                title: Text(
                  'settingsScreen.theme.system'.tr(),
                  style: TextStyle(
                      color: context.appColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                trailing: ref.watch(themeModeProvider) == ThemeMode.system
                    ? const Icon(Icons.check_circle_rounded,
                        color: Colors.orangeAccent)
                    : null,
                onTap: () async {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.system;
                  Navigator.pop(context);
                  OverlayScreen().showOverlay(context,
                      'settingsScreen.theme.system'.tr(), Colors.blueGrey,
                      duration: 2);
                  pref.setString("themeMode", "auto");
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appColors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          Map data = ref.watch(historyMoviesNotifierProvider);
          List dataHistory = data.values.toList();

          if (dataHistory.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 64, color: Colors.orangeAccent),
                    const SizedBox(height: 12),
                    Text(
                      'historyScreen.emptyMessage'.tr(),
                      style:
                          TextStyle(fontSize: 16, color: context.appColors.textTertiary),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: context.appColors.iconInactive,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        const Icon(Icons.history_rounded,
                            size: 26, color: Colors.orangeAccent),
                        Text(
                          'historyScreen.title'.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          color: context.appColors.iconSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(color: context.appColors.divider),
                Expanded(
                  child: ListView.separated(
                    itemCount: dataHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = dataHistory[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                InforMovieScreen(slugMovie: item['slug']),
                          ),
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: context.appColors.dialogBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: context.appColors.textPrimary),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            foregroundColor: Colors.white,
                                          ),
                                          icon: const Icon(
                                              Icons.play_arrow_rounded),
                                          label: Text('app.watch'.tr()),
                                        ),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.redAccent
                                                .withValues(alpha: 0.1),
                                            side: const BorderSide(
                                                color: Colors.redAccent),
                                            foregroundColor: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            final result = await ref
                                                .read(
                                                    removeHistoryWatchMovieUseCaseProvider)
                                                .call(item['slug']);
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                            if (result) {
                                              OverlayScreen().showOverlay(
                                                  context,
                                                  'success.delete'.tr(),
                                                  Colors.green,
                                                  duration: 3);
                                              ref
                                                  .read(
                                                      historyMoviesNotifierProvider
                                                          .notifier)
                                                  .removeState(item['slug']);
                                            } else {
                                              OverlayScreen().showOverlay(
                                                  context,
                                                  'errors.delete'.tr(),
                                                  Colors.red,
                                                  duration: 3);
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.delete_outline_rounded),
                                          label: Text('app.del'.tr()),
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
                            borderRadius: BorderRadius.circular(16),
                            color: context.appColors.cardBg.withValues(alpha: 0.6),
                            border: Border.all(
                                color: context.appColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: CardMovie.resolveImageUrl(item['poster_url'] ?? ''),
                                  height: 90,
                                  width: 65,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => const Center(
                                          child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error,
                                          size: 40, color: Colors.white24),
                                  memCacheHeight: 150,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: context.appColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'historyScreen.watchedEpisode'.tr(
                                          args: [
                                            'movie.episode'
                                                .plural(item['episode'])
                                          ],
                                        ),
                                        style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  size: 20, color: context.appColors.iconInactive),
                              const SizedBox(width: 12),
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
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: context.appColors.dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                'settingsScreen.notifications.title'
                    .tr(), // Just a header or "Log Out"
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'dialog.confirmLogout'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  color: context.appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.appColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('navigation.cancel'.tr(),
                          style: TextStyle(color: context.appColors.textSecondary)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        signOut();
                      },
                      child: Text('navigation.ok'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.appBarBg,
                colors.appBarBgSecondary,
              ],
            ),
          ),
        ),
        title: Text(
          'app.information'.tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: colors.textPrimary,
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
              Consumer(
                builder: (context, ref, child) => AnimatedMovieHeader(
                  profilePicture: profilePicture,
                  userName: ref.watch(currentNameUser),
                  myselftEmail: myselftEmail,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.cardBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: colors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        icon: Icons.contact_mail_outlined,
                        title: 'profileScreen.title'.tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyProfileScreen()));
                        },
                      ),
                      Divider(height: 1, color: colors.divider),
                      _buildSettingItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'settingsScreen.notifications.title'.tr(),
                        onTap: () => _showNotificationSheet(),
                      ),
                      Divider(height: 1, color: colors.divider),
                      _buildSettingItem(
                        icon: Icons.translate_rounded,
                        title: 'app.language'.tr(),
                        onTap: () => _showLanguageSheet(),
                      ),
                      Divider(height: 1, color: colors.divider),
                      _buildSettingItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'settingsScreen.theme.title'.tr(),
                        onTap: () => _showThemeSheet(),
                      ),
                      Divider(height: 1, color: colors.divider),
                      _buildSettingItem(
                        icon: Icons.history_rounded,
                        title: 'historyScreen.title'.tr(),
                        onTap: () => _showHistorySheet(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.cardBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: colors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildSettingItem(
                    icon: Icons.exit_to_app_rounded,
                    title: 'profileScreen.logout'.tr(),
                    onTap: () => _showLogoutConfirmDialog(),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.redAccent, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Text(
                      '© ${DateTime.now().year} MovieApp. All rights reserved.',
                      style: const TextStyle(
                        color: Color(0xFF6E6E6E),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Developed with ❤️ by ',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Thien Nguyen',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Version 1.3.0',
                      style: TextStyle(
                        color: Color(0xFF8B8B8B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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

    final result = await ref.read(signOutUseCaseProvider).call();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );

    if (result) {
      ref.invalidate(historyMoviesNotifierProvider);
      ref.invalidate(getFavoriteMoviesNotifierProvider);
      OverlayScreen().showOverlay(context, 'success.logout'.tr(), Colors.green,
          duration: 3);
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.logout'.tr(), Colors.red, duration: 3);
    }
  }
}
