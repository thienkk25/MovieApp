import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/watch_history_local_data_source.dart';
import 'watch_history_event.dart';
import 'watch_history_state.dart';

class WatchHistoryBloc extends Bloc<WatchHistoryEvent, WatchHistoryState> {
  final WatchHistoryLocalDataSource localDataSource;

  WatchHistoryBloc({required this.localDataSource})
      : super(const WatchHistoryState()) {
    on<LoadWatchHistory>(_onLoad);
    on<AddToWatchHistory>(_onAdd);
    on<RemoveFromWatchHistory>(_onRemove);
    on<ClearWatchHistory>(_onClear);
  }

  Future<void> _onLoad(
      LoadWatchHistory event, Emitter<WatchHistoryState> emit) async {
    emit(state.copyWith(status: WatchHistoryStatus.loading));
    try {
      final history = await localDataSource.getWatchHistory();
      emit(state.copyWith(
        status: WatchHistoryStatus.loaded,
        history: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WatchHistoryStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAdd(
      AddToWatchHistory event, Emitter<WatchHistoryState> emit) async {
    await localDataSource.addToWatchHistory(event.entry);
    final history = await localDataSource.getWatchHistory();
    emit(state.copyWith(
      status: WatchHistoryStatus.loaded,
      history: history,
    ));
  }

  Future<void> _onRemove(
      RemoveFromWatchHistory event, Emitter<WatchHistoryState> emit) async {
    await localDataSource.removeFromWatchHistory(event.slug);
    final history = await localDataSource.getWatchHistory();
    emit(state.copyWith(
      status: WatchHistoryStatus.loaded,
      history: history,
    ));
  }

  Future<void> _onClear(
      ClearWatchHistory event, Emitter<WatchHistoryState> emit) async {
    await localDataSource.clearWatchHistory();
    emit(state.copyWith(
      status: WatchHistoryStatus.loaded,
      history: [],
    ));
  }
}
