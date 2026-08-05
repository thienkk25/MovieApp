import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/src/features/movie/data/datasources/movie_firestore_data_source.dart';
import 'package:movie_app/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:movie_app/src/core/providers/core_providers.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/core/configs/local_notifications.dart';
import 'package:movie_app/src/core/configs/network_listener.dart';
import 'package:movie_app/src/core/configs/workmanager_task.dart';
import 'package:movie_app/src/features/movie/presentation/screens/home_screen.dart';
import 'package:movie_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final pref = await SharedPreferences.getInstance();
  await pref.setString("notification_payload", response.payload ?? "");
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "fetch_api_newlyUpdatedMovies") {
      final data = await MovieRepositoryImpl(
        remoteDataSource: MovieRemoteDataSourceImpl(),
        firestoreDataSource: MovieFirestoreDataSourceImpl(),
      ).newlyUpdatedMovies(1);

      if (data.isNotEmpty) {
        final title = "Phim ${data['items'][0]['name']}";
        const body = "Phim mới cập nhật 🎬. Vào xem ngay nào!";

        await LocalNotifications().showNotification(
          title: title,
          body: body,
          payload: data['items'][0]['slug'] ?? "",
        );
      }
    } else if (task == "random_notification_app") {
      final List<String> titles = [
        "🎬 Phim mới ra lò!",
        "🍿 Giải trí cùng Movie App",
        "🔥 Hot hot hot!",
        "📺 Có gì mới nè",
        "🚀 Tin tức phim nhanh nhất",
        "❤️ Dành cho bạn",
        "✨ Khám phá phim mới",
        "🎥 Đêm nay xem gì?",
        "🌟 Phim hay mỗi ngày",
        "🎞️ Movie Time!",
        "💥 Blockbuster đang chờ",
        "🎉 Cuối tuần xem phim thôi",
        "🍕 Chill cùng phim hay",
        "🌙 Đêm nay có phim mới",
        "🎬 Không thể bỏ lỡ!",
        "🏆 Top phim hôm nay",
        "📢 Phim mới vừa cập bến",
        "🎁 Món quà giải trí dành cho bạn",
        "🔥 Xu hướng phim mới",
        "⭐ Bộ phim tiếp theo đang đợi",
        "🎭 Hành trình điện ảnh bắt đầu",
        "🎬 Xem ngay kẻo lỡ",
        "🎉 Phim hot hôm nay",
        "🍀 Đã đến giờ giải trí",
        "💫 Movie App nhớ bạn rồi!",
        "🎊 Có phim mới dành riêng cho bạn",
        "📽️ Rạp phim trong túi bạn",
        "🎈 Một bộ phim tuyệt vời đang chờ",
        "🍿 Chuẩn bị bắp rang chưa?",
        "🎥 Hôm nay xem gì nào?",
      ];

      final List<String> bodies = [
        "Vào xem phim đi, đừng bỏ lỡ nhé!",
        "Phim mới cập nhật rồi, xem ngay thôi nào!",
        "Nhiều phim hot đang chờ bạn đó!",
        "Nhớ thư giãn với phim hay nào!",
        "Hôm nay xem phim gì chưa?",
        "Cập nhật phim nhanh như chớp, mở app xem ngay!",
        "Phim hay đang đợi bạn khám phá!",
        "Một bộ phim thú vị vừa được thêm vào.",
        "Có phim mới đúng gu của bạn đó!",
        "Dành vài phút thư giãn với Movie App nhé.",
        "Kho phim vừa có thêm nhiều nội dung hấp dẫn.",
        "Đừng để bộ phim yêu thích trôi qua nhé!",
        "Mở app và khám phá những bộ phim nổi bật hôm nay.",
        "Hàng loạt phim mới đã sẵn sàng để bạn thưởng thức.",
        "Đã đến lúc xem một bộ phim thật hay rồi!",
        "Top phim thịnh hành đang chờ bạn.",
        "Có rất nhiều lựa chọn thú vị hôm nay.",
        "Bỏng ngô đã sẵn sàng chưa? Phim cũng vậy!",
        "Thư giãn sau một ngày dài với một bộ phim nhé.",
        "Phim mới cập nhật liên tục mỗi ngày.",
        "Đừng quên quay lại để khám phá nội dung mới.",
        "Bạn còn nhiều bộ phim chưa xem đó!",
        "Tiếp tục bộ phim đang xem chỉ với một chạm.",
        "Danh sách yêu thích của bạn đang chờ.",
        "Khám phá những bộ phim được xem nhiều nhất hôm nay.",
        "Có thể bạn sẽ tìm thấy bộ phim yêu thích tiếp theo.",
        "Một thế giới giải trí đang chờ bạn khám phá.",
        "Xem ngay những bộ phim đang được yêu thích.",
        "Movie App đã chuẩn bị những bộ phim hấp dẫn cho bạn.",
        "Giờ là lúc tận hưởng những phút giây giải trí.",
        "Đừng để tối nay thiếu một bộ phim hay!",
        "Hàng loạt nội dung mới vừa được cập nhật.",
        "Mở app để xem những bộ phim mới nhất.",
        "Kho phim luôn có điều bất ngờ dành cho bạn.",
        "Một bộ phim hay có thể làm ngày của bạn tuyệt vời hơn.",
        "Giải trí chưa bao giờ dễ dàng đến thế.",
        "Bạn đã bỏ lỡ vài bộ phim rất hấp dẫn đấy!",
        "Movie App nhớ bạn, quay lại xem phim nhé!",
        "Có rất nhiều điều thú vị đang chờ bạn khám phá.",
        "Bắt đầu buổi xem phim ngay bây giờ nào!",
      ];

      final random = Random();
      final title = titles[random.nextInt(titles.length)];
      final body = bodies[random.nextInt(bodies.length)];

      await LocalNotifications().showNotification(
        title: title,
        body: body,
      );
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _cleanUpMediaKitTempFiles();
  await LocalNotifications().init();
  await EasyLocalization.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final pref = await SharedPreferences.getInstance();
  final isNotificationEnabled = pref.getBool("notification_enabled") ?? true;
  if (isNotificationEnabled) {
    await WorkmanagerTask.registerNotificationTasks();
  }

  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  final String? payload = details?.notificationResponse?.payload ??
      pref.getString("notification_payload");
  MediaKit.ensureInitialized();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('vi', ''), Locale('en', '')],
        path: 'assets/translations',
        fallbackLocale: const Locale('vi', ''),
        child: MyApp(initialPayload: payload),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final String? initialPayload;
  const MyApp({super.key, this.initialPayload});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadDeault(context);
      },
    );
    super.initState();
  }

  Future<void> loadDeault(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    String isThemeMode = pref.getString("themeMode") ?? "auto";
    int isLanguage = pref.getInt("language") ?? 0;
    bool isNotification = pref.getBool("notification_enabled") ?? true;

    if (isLanguage == 0) {
      if (!context.mounted) return;
      context.setLocale(const Locale('vi', ''));
      ref.read(isLanguageProvider.notifier).state = const Locale('vi', '');
    } else {
      if (!context.mounted) return;
      context.setLocale(const Locale('en', ''));
      ref.read(isLanguageProvider.notifier).state = const Locale('en', '');
    }

    if (isThemeMode == "auto") {
      ref.read(themeModeProvider.notifier).state = ThemeMode.system;
    } else if (isThemeMode == "light") {
      ref.read(themeModeProvider.notifier).state = ThemeMode.light;
    } else {
      ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
    }

    if (widget.initialPayload != null &&
        widget.initialPayload!.isNotEmpty &&
        isNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ref.read(isUserUseCaseProvider).call()) {
          navigatorKey.currentState
              ?.push(
            MaterialPageRoute(
              builder: (_) =>
                  InforMovieScreen(slugMovie: widget.initialPayload!),
            ),
          )
              .then((_) async {
            await pref.remove("notification_payload");
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
              (router) => false,
            );
          });
        } else {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (router) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget home = ref.watch(isUserUseCaseProvider).call()
        ? const HomeScreen()
        : const LoginScreen();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'app.title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: ref.watch(isLanguageProvider),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.light.scaffoldBg,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.light.appBarBg,
          foregroundColor: AppColors.light.textPrimary,
          elevation: 0,
        ),
        dividerColor: AppColors.light.divider,
        extensions: const [AppColors.light],
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.dark.scaffoldBg,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.dark.appBarBg,
          foregroundColor: AppColors.dark.textPrimary,
          elevation: 0,
        ),
        dividerColor: AppColors.dark.divider,
        extensions: const [AppColors.dark],
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeModeProvider),
      home: NetworkListener(child: home),
    );
  }
}

Future<void> _cleanUpMediaKitTempFiles() async {
  try {
    final directories = <Directory>[];

    try {
      directories.add(Directory.systemTemp);
    } catch (_) {}

    try {
      final supportDir = await getApplicationSupportDirectory();
      directories.add(supportDir);
    } catch (_) {}
    try {
      final cacheDir = await getTemporaryDirectory();
      directories.add(cacheDir);
    } catch (_) {}

    for (final dir in directories) {
      if (await dir.exists()) {
        final entities = await dir.list().toList();
        for (final entity in entities) {
          if (entity is File) {
            final filename = p.basename(entity.path);
            if (filename.startsWith(
                'com.alexmercerind.media_kit.NativeReferenceHolder.')) {
              try {
                await entity.delete();
              } catch (_) {}
            }
          }
        }
      }
    }
  } catch (_) {}
}
