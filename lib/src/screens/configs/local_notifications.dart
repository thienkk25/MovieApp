import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/src/controllers/user_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/home_screen.dart';
import 'package:movie_app/src/screens/login_screen.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  Future<void> init() async {
    // Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          UserController().isUser()
              ? navigatorKey.currentState
                  ?.push(
                    MaterialPageRoute(
                      builder: (_) => InforMovieScreen(
                        slugMovie: response.payload.toString(),
                      ),
                    ),
                  )
                  .then(
                    (_) => MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  )
              : navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Thông báo',
      channelDescription: 'Thông báo',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    int hoursEveryDay = 7,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime = tz.TZDateTime(
                tz.local, now.year, now.month, now.day, hoursEveryDay)
            .isBefore(now)
        ? tz.TZDateTime(
            tz.local, now.year, now.month, now.day + 1, hoursEveryDay)
        : tz.TZDateTime(tz.local, now.year, now.month, now.day, hoursEveryDay);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        scheduleTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'schedule_channel_id',
            'Thông báo hàng ngày',
            channelDescription: 'Thông báo phim',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
