import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/usecase/usecase.dart';
import 'package:movie_app/src/features/movie/domain/usecases/movie_usecases.dart';
import 'movie_favorite_event.dart';
import 'movie_favorite_state.dart';

class MovieFavoriteBloc extends Bloc<MovieFavoriteEvent, MovieFavoriteState> {
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  final RemoveFavoriteMovieUseCase removeFavoriteMovieUseCase;

  MovieFavoriteBloc({
    required this.getFavoriteMoviesUseCase,
    required this.removeFavoriteMovieUseCase,
  }) : super(const MovieFavoriteState()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onFetchFavorites(
      FetchFavorites event, Emitter<MovieFavoriteState> emit) async {
    emit(state.copyWith(status: MovieFavoriteStatus.loading));

    final result = await getFavoriteMoviesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieFavoriteStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: MovieFavoriteStatus.success,
        favoriteMovies: movies,
      )),
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<MovieFavoriteState> emit) async {
    final result = await removeFavoriteMovieUseCase(event.slug);

    result.fold(
      (_) {},
      (_) {
        final updatedList = state.favoriteMovies
            .where((m) => m.slug != event.slug)
            .toList();
        emit(state.copyWith(favoriteMovies: updatedList));
      },
    );
  }
}
