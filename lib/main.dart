import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/configs/network_listener.dart';
import 'package:movie_app/src/screens/home_screen.dart';
import 'package:movie_app/src/screens/login_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserController userController = UserController();
    Widget home =
        userController.isUser() ? const HomeScreen() : const LoginScreen();

    Future<void> loadDeault() async {
      final pref = await SharedPreferences.getInstance();
      String isThemeMode = pref.getString("themeMode") ?? "auto";
      if (isThemeMode == "auto") {
        ref.read(themeModeProvider.notifier).state = ThemeMode.system;
      } else if (isThemeMode == "light") {
        ref.read(themeModeProvider.notifier).state = ThemeMode.light;
      } else {
        ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
      }
    }

    loadDeault();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie',
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
