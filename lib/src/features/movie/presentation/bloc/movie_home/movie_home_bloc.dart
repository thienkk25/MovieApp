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

    // Fetch all sections in parallel
    final results = await Future.wait([
      getCategoryMoviesUseCase(
          const CategoryMoviesParams(type: 'Phim Lẻ')),
      getCategoryMoviesUseCase(
          const CategoryMoviesParams(type: 'Phim Bộ')),
      getCategoryMoviesUseCase(
          const CategoryMoviesParams(type: 'Hoạt Hình')),
      getCategoryMoviesUseCase(
          const CategoryMoviesParams(type: 'TV Shows')),
    ]);

    final singleList = results[0].getOrElse(() => []);
    final dramaList = results[1].getOrElse(() => []);
    final cartoonList = results[2].getOrElse(() => []);
    final tvShowsList = results[3].getOrElse(() => []);

    emit(state.copyWith(
      status: MovieHomeStatus.success,
      heroCarousel: heroList,
      newlyUpdatedMovies: newlyList,
      singleMovies: singleList,
      dramaMovies: dramaList,
      cartoonMovies: cartoonList,
      tvShowsMovies: tvShowsList,
    ));
  }

  Future<void> _onSelectCategory(
      SelectCategory event, Emitter<MovieHomeState> emit) async {
    emit(state.copyWith(
      selectedCategorySlug: event.categorySlug,
      isCategoryLoading: true,
    ));

    final categoryResult = await getCategoryMoviesUseCase(
        CategoryMoviesParams(type: event.categorySlug));

    final catMovies = categoryResult.getOrElse(() => []);
    emit(state.copyWith(
      categoryMovies: catMovies,
      isCategoryLoading: false,
    ));
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
