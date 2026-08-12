import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/watch_history_entity.dart';

part 'watch_history_state.freezed.dart';

enum WatchHistoryStatus { initial, loading, loaded, failure }

@freezed
abstract class WatchHistoryState with _$WatchHistoryState {
  const factory WatchHistoryState({
    @Default(WatchHistoryStatus.initial) WatchHistoryStatus status,
    @Default([]) List<WatchHistoryEntity> history,
    String? errorMessage,
  }) = _WatchHistoryState;
}
