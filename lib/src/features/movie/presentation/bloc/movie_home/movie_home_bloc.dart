import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/movie_usecases.dart';
import 'movie_home_event.dart';
import 'movie_home_state.dart';

class MovieHomeBloc extends Bloc<MovieHomeEvent, MovieHomeState> {
  final GetNewlyUpdatedMoviesUseCase getNewlyUpdatedMoviesUseCase;
  final GetCategoryMoviesUseCase getCategoryMoviesUseCase;

  MovieHomeBloc({
    required this.getNewlyUpdatedMoviesUseCase,
    required this.getCategoryMoviesUseCase,
  }) : super(const MovieHomeState()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<SelectCategory>(_onSelectCategory);
    on<LoadMoreNewlyUpdated>(_onLoadMoreNewlyUpdated);
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event, Emitter<MovieHomeState> emit) async {
    emit(state.copyWith(status: MovieHomeStatus.loading));

    final newlyResult =
        await getNewlyUpdatedMoviesUseCase(const NewlyUpdatedParams(page: 1));

    if (newlyResult.isLeft()) {
      final failure = newlyResult.fold((l) => l, (_) => null);
      emit(state.copyWith(
        status: MovieHomeStatus.failure,
        errorMessage: failure?.message,
      ));
      return;
    }

    final movies = newlyResult.getOrElse(() => []);
    final heroList = movies.take(5).toList();
    final newlyList = movies;

    final singleRes = await getCategoryMoviesUseCase(
        const CategoryMoviesParams(type: 'Phim Lẻ'));
    final dramaRes = await getCategoryMoviesUseCase(
        const CategoryMoviesParams(type: 'Phim Bộ'));

    final singleList = singleRes.getOrElse(() => []);
    final dramaList = dramaRes.getOrElse(() => []);

    emit(state.copyWith(
      status: MovieHomeStatus.success,
      heroCarousel: heroList,
      newlyUpdatedMovies: newlyList,
      singleMovies: singleList,
      dramaMovies: dramaList,
    ));
  }

  Future<void> _onSelectCategory(
      SelectCategory event, Emitter<MovieHomeState> emit) async {
    emit(state.copyWith(selectedCategorySlug: event.categorySlug));

    final categoryResult = await getCategoryMoviesUseCase(
        CategoryMoviesParams(type: event.categorySlug));

    final catMovies = categoryResult.getOrElse(() => []);
    emit(state.copyWith(categoryMovies: catMovies));
  }

  Future<void> _onLoadMoreNewlyUpdated(
      LoadMoreNewlyUpdated event, Emitter<MovieHomeState> emit) async {
    final nextPage = state.currentPage + 1;
    final newlyResult =
        await getNewlyUpdatedMoviesUseCase(NewlyUpdatedParams(page: nextPage));

    if (newlyResult.isRight()) {
      final newMovies = newlyResult.getOrElse(() => []);
      emit(state.copyWith(
        newlyUpdatedMovies: [...state.newlyUpdatedMovies, ...newMovies],
        currentPage: nextPage,
      ));
    }
  }
}
