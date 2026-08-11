import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';
import 'src/core/configs/local_notifications.dart';
import 'src/core/configs/network_listener.dart';
import 'src/core/di/injection_container.dart';
import 'src/core/global/settings_cubit.dart';
import 'src/core/global/settings_state.dart';
import 'src/core/theme/app_colors.dart';
import 'src/features/auth/presentation/bloc/auth_bloc.dart';
import 'src/features/auth/presentation/bloc/auth_event.dart';
import 'src/features/auth/presentation/bloc/auth_state.dart';
import 'src/features/auth/presentation/screens/login_screen.dart';
import 'src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'src/features/movie/presentation/bloc/movie_favorite/movie_favorite_bloc.dart';
import 'src/features/movie/presentation/bloc/movie_home/movie_home_bloc.dart';
import 'src/features/movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'src/features/movie/presentation/screens/home_screen.dart';

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
      final data = await MovieRemoteDataSourceImpl().newlyUpdatedMovies(1);

      if (data.isNotEmpty) {
        final title = "Phim ${data['items'][0]['name']}";
        const body = "Phim mới cập nhật 🎬. Vào xem ngay nào!";

        await LocalNotifications().showNotification(
          title: title,
          body: body,
          payload: data['items'][0]['slug'] ?? "",
        );
      }
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _cleanUpMediaKitTempFiles();
  await LocalNotifications().init();
  await EasyLocalization.ensureInitialized();
  await initDI();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MediaKit.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi', ''), Locale('en', '')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi', ''),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<SettingsCubit>()),
          BlocProvider(
              create: (_) =>
                  sl<AuthBloc>()..add(const AuthEvent.checkAuthStatus())),
          BlocProvider(create: (_) => sl<MovieHomeBloc>()),
          BlocProvider(create: (_) => sl<MovieSearchBloc>()),
          BlocProvider(create: (_) => sl<MovieFavoriteBloc>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final Widget homeScreen =
                authState.status == AuthStatus.authenticated
                    ? const HomeScreen()
                    : const LoginScreen();

            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Cinema',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: settingsState.locale,
              themeMode: settingsState.themeMode,
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
              home: NetworkListener(child: homeScreen),
            );
          },
        );
      },
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
