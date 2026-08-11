import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/search_filter.dart';
import '../../../domain/usecases/movie_usecases.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  MovieSearchBloc({required this.searchMoviesUseCase})
      : super(const MovieSearchState()) {
    on<KeywordChanged>(_onKeywordChanged);
    on<FilterChanged>(_onFilterChanged);
    on<ExecuteSearch>(_onExecuteSearch);
    on<ResetFilter>(_onResetFilter);
  }

  void _onKeywordChanged(
      KeywordChanged event, Emitter<MovieSearchState> emit) {
    emit(state.copyWith(keyword: event.keyword));
  }

  void _onFilterChanged(
      FilterChanged event, Emitter<MovieSearchState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onResetFilter(
      ResetFilter event, Emitter<MovieSearchState> emit) {
    emit(state.copyWith(filter: const SearchFilter()));
  }

  Future<void> _onExecuteSearch(
      ExecuteSearch event, Emitter<MovieSearchState> emit) async {
    emit(state.copyWith(status: MovieSearchStatus.loading));

    final result = await searchMoviesUseCase(SearchMoviesParams(
      keyword: state.keyword,
      limit: 30,
      filters: state.filter,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieSearchStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: MovieSearchStatus.success,
        searchResults: movies,
      )),
    );
  }
}
