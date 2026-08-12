import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/watch_history_entity.dart';

/// Local data source for watch history using SharedPreferences.
abstract class WatchHistoryLocalDataSource {
  Future<List<WatchHistoryEntity>> getWatchHistory();
  Future<void> addToWatchHistory(WatchHistoryEntity entry);
  Future<void> removeFromWatchHistory(String slug);
  Future<void> clearWatchHistory();
}

class WatchHistoryLocalDataSourceImpl implements WatchHistoryLocalDataSource {
  static const String _key = 'watch_history';
  static const int _maxItems = 50;

  @override
  Future<List<WatchHistoryEntity>> getWatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = WatchHistoryEntity.decodeList(jsonStr);
      // Return sorted by most recent first
      list.sort((a, b) => b.watchedAt.compareTo(a.watchedAt));
      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addToWatchHistory(WatchHistoryEntity entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWatchHistory();

    // Remove existing entry for same slug (will be re-added at top)
    history.removeWhere((e) => e.slug == entry.slug);

    // Add to beginning
    history.insert(0, entry);

    // Cap at max items
    final trimmed = history.take(_maxItems).toList();

    await prefs.setString(_key, WatchHistoryEntity.encodeList(trimmed));
  }

  @override
  Future<void> removeFromWatchHistory(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWatchHistory();
    history.removeWhere((e) => e.slug == slug);
    await prefs.setString(_key, WatchHistoryEntity.encodeList(history));
  }

  @override
  Future<void> clearWatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
