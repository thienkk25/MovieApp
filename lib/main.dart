import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/configs/local_notifications.dart';
import 'package:movie_app/src/screens/configs/network_listener.dart';
import 'package:movie_app/src/screens/configs/workmanager_task.dart';
import 'package:movie_app/src/screens/home_screen.dart';
import 'package:movie_app/src/screens/login_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
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
      final data = await MovieController().newlyUpdatedMovies();

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
      ];

      final List<String> bodies = [
        "Vào xem phim đi, đừng bỏ lỡ nhé!",
        "Phim mới cập nhật rồi, xem ngay thôi nào!",
        "Nhiều phim hot đang chờ bạn đó!",
        "Nhớ thư giãn với phim hay nào!",
        "Hôm nay người đẹp xem phim gì chưa?",
        "Cập nhật phim nhanh như chớp, mở app xem ngay đi thôi!",
        "Phim hay đang đợi bạn khám phá!",
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
  await EasyLocalization.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Workmanager().initialize(callbackDispatcher);
  final pref = await SharedPreferences.getInstance();
  final isNotificationEnabled = pref.getBool("notification_enabled") ?? true;
  if (isNotificationEnabled) {
    await WorkmanagerTask.registerNotificationTasks();
  }
  await LocalNotifications().init();
  final payload = pref.getString("notification_payload");
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
  final UserController userController = UserController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadDeault();
      },
    );
    super.initState();
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  Future<void> loadDeault() async {
    final pref = await SharedPreferences.getInstance();
    String isThemeMode = pref.getString("themeMode") ?? "auto";
    int isLanguage = pref.getInt("language") ?? 0;
    if (isLanguage == 0) {
      ref.read(isLanguageProvider.notifier).state = const Locale('vi', '');
    } else {
      ref.read(isLanguageProvider.notifier).state = const Locale('en', '');
    }
    if (isThemeMode == "auto") {
      ref.read(themeModeProvider.notifier).state = ThemeMode.system;
    } else if (isThemeMode == "light") {
      ref.read(themeModeProvider.notifier).state = ThemeMode.light;
    } else {
      ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
    }

    if (widget.initialPayload != null && widget.initialPayload!.isNotEmpty) {
      await pref.remove("notification_payload");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (UserController().isUser()) {
          navigatorKey.currentState
              ?.push(
            MaterialPageRoute(
              builder: (_) =>
                  InforMovieScreen(slugMovie: widget.initialPayload!),
            ),
          )
              .then((_) {
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
    Widget home =
        userController.isUser() ? const HomeScreen() : const LoginScreen();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'app.title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: ref.watch(isLanguageProvider),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeModeProvider),
      home: NetworkListener(child: home),
    );
  }
}
