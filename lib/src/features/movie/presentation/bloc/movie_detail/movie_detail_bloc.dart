import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/usecase/usecase.dart';
import 'package:movie_app/src/features/movie/domain/usecases/movie_usecases.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailUseCase getMovieDetailUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  final AddFavoriteMovieUseCase addFavoriteMovieUseCase;
  final RemoveFavoriteMovieUseCase removeFavoriteMovieUseCase;

  MovieDetailBloc({
    required this.getMovieDetailUseCase,
    required this.getFavoriteMoviesUseCase,
    required this.addFavoriteMovieUseCase,
    required this.removeFavoriteMovieUseCase,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SelectEpisode>(_onSelectEpisode);
  }

  Future<void> _onFetchMovieDetail(
      FetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(state.copyWith(status: MovieDetailStatus.loading));

    final result =
        await getMovieDetailUseCase(MovieDetailParams(slug: event.slug));

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => null);
      emit(state.copyWith(
        status: MovieDetailStatus.failure,
        errorMessage: failure?.message,
      ));
      return;
    }

    final detail = result.getOrElse(() => throw Exception());

    // Check if favorite
    bool isFav = false;
    final favsRes = await getFavoriteMoviesUseCase(NoParams());
    if (favsRes.isRight()) {
      final favs = favsRes.getOrElse(() => []);
      isFav = favs.any((m) => m.slug == event.slug);
    }

    emit(state.copyWith(
      status: MovieDetailStatus.success,
      movieDetail: detail,
      isFavorite: isFav,
      selectedServerIndex: 0,
      selectedEpisodeIndex: 0,
    ));
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<MovieDetailState> emit) async {
    if (state.movieDetail == null) return;
    final movie = state.movieDetail!.movie;

    if (state.isFavorite) {
      final res = await removeFavoriteMovieUseCase(movie.slug);
      if (res.isRight()) {
        emit(state.copyWith(isFavorite: false));
      }
    } else {
      final res = await addFavoriteMovieUseCase(movie);
      if (res.isRight()) {
        emit(state.copyWith(isFavorite: true));
      }
    }
  }

  void _onSelectEpisode(
      SelectEpisode event, Emitter<MovieDetailState> emit) {
    emit(state.copyWith(
      selectedServerIndex: event.serverIndex,
      selectedEpisodeIndex: event.episodeIndex,
    ));
  }
}
