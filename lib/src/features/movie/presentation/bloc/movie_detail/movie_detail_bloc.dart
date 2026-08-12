import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/usecase/usecase.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/domain/usecases/movie_usecases.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailUseCase getMovieDetailUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  final AddFavoriteMovieUseCase addFavoriteMovieUseCase;
  final RemoveFavoriteMovieUseCase removeFavoriteMovieUseCase;
  final GetCategoryMoviesUseCase getCategoryMoviesUseCase;

  MovieDetailBloc({
    required this.getMovieDetailUseCase,
    required this.getFavoriteMoviesUseCase,
    required this.addFavoriteMovieUseCase,
    required this.removeFavoriteMovieUseCase,
    required this.getCategoryMoviesUseCase,
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

    // Fetch Related Movies by Category / Type
    List<MovieEntity> relatedList = [];
    String categoryType = 'phim-le';
    final isSeries = detail.movie.quality.contains('Bộ') ||
        detail.movie.episodeCurrent.toLowerCase().contains('tập');

    if (detail.movie.categories.isNotEmpty) {
      categoryType = _slugifyCategory(detail.movie.categories.first);
    } else if (isSeries) {
      categoryType = 'phim-bo';
    }

    var relatedRes = await getCategoryMoviesUseCase(CategoryMoviesParams(
      type: categoryType,
      limit: 12,
    ));

    if (relatedRes.isRight()) {
      relatedList = relatedRes
          .getOrElse(() => [])
          .where((m) => m.slug != event.slug)
          .toList();
    }

    // Fallback if category slug returned empty
    if (relatedList.isEmpty) {
      final fallbackType = isSeries ? 'phim-bo' : 'phim-le';
      relatedRes = await getCategoryMoviesUseCase(CategoryMoviesParams(
        type: fallbackType,
        limit: 12,
      ));
      if (relatedRes.isRight()) {
        relatedList = relatedRes
            .getOrElse(() => [])
            .where((m) => m.slug != event.slug)
            .toList();
      }
    }

    emit(state.copyWith(
      status: MovieDetailStatus.success,
      movieDetail: detail,
      relatedMovies: relatedList,
      isFavorite: isFav,
      selectedServerIndex: 0,
      selectedEpisodeIndex: 0,
    ));
  }

  String _slugifyCategory(String text) {
    var str = text.trim().toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    str = str.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    str = str.replaceAll(RegExp(r'\s+'), '-');
    return str.isEmpty ? 'phim-le' : str;
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
