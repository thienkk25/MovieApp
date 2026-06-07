import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/src/features/movie/data/datasources/movie_firestore_data_source.dart';
import 'package:movie_app/src/features/movie/data/models/search_filter.dart';
import 'package:movie_app/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/src/features/movie/domain/repositories/movie_repository.dart';
import 'package:movie_app/src/features/movie/domain/usecases/movie_usecases.dart';

// --- DataSource Providers ---
final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>((ref) {
  return MovieRemoteDataSourceImpl();
});

final movieFirestoreDataSourceProvider = Provider<MovieFirestoreDataSource>((ref) {
  return MovieFirestoreDataSourceImpl();
});

// --- Repository Provider ---
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(
    remoteDataSource: ref.watch(movieRemoteDataSourceProvider),
    firestoreDataSource: ref.watch(movieFirestoreDataSourceProvider),
  );
});

// --- UseCase Providers ---
final getCategoryMoviesUseCaseProvider = Provider((ref) {
  return GetCategoryMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getCategoryDetailMoviesUseCaseProvider = Provider((ref) {
  return GetCategoryDetailMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getCountryMoviesUseCaseProvider = Provider((ref) {
  return GetCountryMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getCountryDetailMoviesUseCaseProvider = Provider((ref) {
  return GetCountryDetailMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getYearDetailMoviesUseCaseProvider = Provider((ref) {
  return GetYearDetailMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getNewlyUpdatedMoviesUseCaseProvider = Provider((ref) {
  return GetNewlyUpdatedMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getNewlyUpdatedMoviesV3UseCaseProvider = Provider((ref) {
  return GetNewlyUpdatedMoviesV3UseCase(ref.watch(movieRepositoryProvider));
});

final searchMoviesUseCaseProvider = Provider((ref) {
  return SearchMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getDramaMoviesUseCaseProvider = Provider((ref) {
  return GetDramaMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getSingleMoviesUseCaseProvider = Provider((ref) {
  return GetSingleMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getCartoonMoviesUseCaseProvider = Provider((ref) {
  return GetCartoonMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getTvShowsMoviesUseCaseProvider = Provider((ref) {
  return GetTvShowsMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getVietSubMoviesUseCaseProvider = Provider((ref) {
  return GetVietSubMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getNarratedMoviesUseCaseProvider = Provider((ref) {
  return GetNarratedMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getDubbedMoviesUseCaseProvider = Provider((ref) {
  return GetDubbedMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getMovieDetailUseCaseProvider = Provider((ref) {
  return GetMovieDetailUseCase(ref.watch(movieRepositoryProvider));
});

final getFavoriteMoviesUseCaseProvider = Provider((ref) {
  return GetFavoriteMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final addFavoriteMovieUseCaseProvider = Provider((ref) {
  return AddFavoriteMovieUseCase(ref.watch(movieRepositoryProvider));
});

final removeFavoriteMovieUseCaseProvider = Provider((ref) {
  return RemoveFavoriteMovieUseCase(ref.watch(movieRepositoryProvider));
});

final getHistoryMoviesUseCaseProvider = Provider((ref) {
  return GetHistoryMoviesUseCase(ref.watch(movieRepositoryProvider));
});

final getHistoryWatchMovieUseCaseProvider = Provider((ref) {
  return GetHistoryWatchMovieUseCase(ref.watch(movieRepositoryProvider));
});

final addHistoryWatchMovieUseCaseProvider = Provider((ref) {
  return AddHistoryWatchMovieUseCase(ref.watch(movieRepositoryProvider));
});

final removeHistoryWatchMovieUseCaseProvider = Provider((ref) {
  return RemoveHistoryWatchMovieUseCase(ref.watch(movieRepositoryProvider));
});

final getRecommendedPartsUseCaseProvider = Provider((ref) {
  return GetRecommendedPartsUseCase(ref.watch(movieRepositoryProvider));
});

// --- Future Providers (Cached APIs) ---
final categoryMoviesProvider = FutureProvider<List>((ref) async {
  return ref.watch(getCategoryMoviesUseCaseProvider).call();
});

final countryMoviesProvider = FutureProvider<List>((ref) async {
  return ref.watch(getCountryMoviesUseCaseProvider).call();
});

final newlyUpdatedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getNewlyUpdatedMoviesV3UseCaseProvider).call();
});

final singleMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getSingleMoviesUseCaseProvider).call(1, 12);
});

final dramaMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getDramaMoviesUseCaseProvider).call(1, 12);
});

final cartoonMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getCartoonMoviesUseCaseProvider).call(1, 12);
});

final tvShowsMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getTvShowsMoviesUseCaseProvider).call(1, 12);
});

final vietSubMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getVietSubMoviesUseCaseProvider).call(1, 12);
});

final narratedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getNarratedMoviesUseCaseProvider).call(1, 12);
});

final dubbedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(getDubbedMoviesUseCaseProvider).call(1, 12);
});

// --- State Providers ---
final isLoadingMore = StateProvider<bool>((ref) => false);
final wasWatchEpisodeMovies = StateProvider<int>((ref) => -1);
final isClickWatchEpisodeMovies = StateProvider<bool>((ref) => false);
final isClickLWatchEpisodeLinkMovies = StateProvider<String?>((ref) => null);
final isCollapsedReadMore = StateProvider<bool>((ref) => true);
final isAutoNextMovie = StateProvider<bool>((ref) => false);
final currentNameUser = StateProvider<String>((ref) => '');

// --- StateNotifiers ---
class GetFavoriteMoviesNotifier extends StateNotifier<Map> {
  GetFavoriteMoviesNotifier() : super({});
  void initState(Map data) {
    state = data;
  }

  void addState(Map data) {
    String slug = data['slug'];
    state = {slug: data, ...state};
  }

  void removeState(String slug) {
    final newState = Map.from(state);
    newState.remove(slug);
    state = newState;
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, Map>(
        (ref) => GetFavoriteMoviesNotifier());

class HistoryMoviesNotifier extends StateNotifier<Map> {
  HistoryMoviesNotifier() : super({});
  void initState(Map data) {
    state = data;
  }

  void addState(Map data) {
    String slug = data['slug'];
    state = {slug: data, ...state};
  }

  void removeState(String slug) {
    final newState = Map.from(state);
    newState.remove(slug);
    state = newState;
  }
}

final historyMoviesNotifierProvider =
    StateNotifierProvider<HistoryMoviesNotifier, Map>(
        (ref) => HistoryMoviesNotifier());

class ViewMoreMoviesNotifier extends StateNotifier<List> {
  ViewMoreMoviesNotifier() : super([]);

  void initState(List data) {
    state = [...data];
  }

  void addState(List data) {
    state = [...state, ...data];
  }
}

final viewMoreMoviesNotifierProvider =
    StateNotifierProvider<ViewMoreMoviesNotifier, List>(
        (ref) => ViewMoreMoviesNotifier());

class SearchFilterNotifier extends StateNotifier<SearchFilter> {
  SearchFilterNotifier() : super(SearchFilter());

  void setCategory(String? value) => state = state.copyWith(category: value);
  void setCountry(String? value) => state = state.copyWith(country: value);
  void setYear(int? value) => state = state.copyWith(year: value);
  void setSortField(String value) => state = state.copyWith(sortField: value);
  void setSortType(String value) => state = state.copyWith(sortType: value);
  void setSortLang(String? value) => state = state.copyWith(sortLang: value);
  void setKeyword(String? value) => state = state.copyWith(keyword: value);
  void clear() => state = SearchFilter();
}

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilter>(
  (ref) => SearchFilterNotifier(),
);
