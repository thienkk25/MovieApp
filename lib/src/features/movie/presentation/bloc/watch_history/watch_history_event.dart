import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/watch_history_entity.dart';

part 'watch_history_event.freezed.dart';

@freezed
sealed class WatchHistoryEvent with _$WatchHistoryEvent {
  const factory WatchHistoryEvent.loadHistory() = LoadWatchHistory;
  const factory WatchHistoryEvent.addToHistory(WatchHistoryEntity entry) =
      AddToWatchHistory;
  const factory WatchHistoryEvent.removeFromHistory(String slug) =
      RemoveFromWatchHistory;
  const factory WatchHistoryEvent.clearHistory() = ClearWatchHistory;
}
