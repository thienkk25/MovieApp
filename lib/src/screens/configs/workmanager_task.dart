import 'package:movie_app/src/screens/configs/local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class WorkmanagerTask {
  static Future<void> registerNotificationTasks() async {
    await Workmanager().registerPeriodicTask(
      "fetchApiNewlyUpdatedMovies",
      "fetch_api_newlyUpdatedMovies",
      frequency: const Duration(hours: 4),
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    await Workmanager().registerPeriodicTask(
      "randomNotificationApp",
      "random_notification_app",
      frequency: const Duration(hours: 3),
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  static Future<void> cancelNotificationTasks() async {
    await Workmanager().cancelAll();
    await LocalNotifications().cancelAll();
  }
}
