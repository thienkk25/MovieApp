import 'package:movie_app/src/features/movie/data/models/search_filter.dart';
import 'package:movie_app/src/features/movie/domain/repositories/movie_repository.dart';

class GetCategoryMoviesUseCase {
  final MovieRepository _repository;
  GetCategoryMoviesUseCase(this._repository);
  Future<List> call() => _repository.categoryMovies();
}

class GetCategoryDetailMoviesUseCase {
  final MovieRepository _repository;
  GetCategoryDetailMoviesUseCase(this._repository);
  Future<Map> call(String type, int page, int limit,
      {String sortType = "desc", String country = "", int year = 0}) {
    return _repository.categoryDetailMovies(type, page, limit, sortType, country, year);
  }
}

class GetCountryMoviesUseCase {
  final MovieRepository _repository;
  GetCountryMoviesUseCase(this._repository);
  Future<List> call() => _repository.countryMovies();
}

class GetCountryDetailMoviesUseCase {
  final MovieRepository _repository;
  GetCountryDetailMoviesUseCase(this._repository);
  Future<Map> call(String country, int page, int limit) {
    return _repository.countryDetailMovies(country, page, limit);
  }
}

class GetYearDetailMoviesUseCase {
  final MovieRepository _repository;
  GetYearDetailMoviesUseCase(this._repository);
  Future<Map> call(String year, int page, int limit) {
    return _repository.yearDetailMovies(year, page, limit);
  }
}

class GetNewlyUpdatedMoviesUseCase {
  final MovieRepository _repository;
  GetNewlyUpdatedMoviesUseCase(this._repository);
  Future<Map> call({int page = 1}) => _repository.newlyUpdatedMovies(page);
}

class GetNewlyUpdatedMoviesV3UseCase {
  final MovieRepository _repository;
  GetNewlyUpdatedMoviesV3UseCase(this._repository);
  Future<Map> call({int page = 1}) => _repository.newlyUpdatedMoviesV3(page);
}

class SearchMoviesUseCase {
  final MovieRepository _repository;
  SearchMoviesUseCase(this._repository);
  Future<Map> call({required String keyword, required int limit, SearchFilter? filters}) {
    return _repository.searchMovies(keyword: keyword, limit: limit, filters: filters);
  }
}

class GetDramaMoviesUseCase {
  final MovieRepository _repository;
  GetDramaMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.dramaMovies(page, limit);
}

class GetSingleMoviesUseCase {
  final MovieRepository _repository;
  GetSingleMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.singleMovies(page, limit);
}

class GetCartoonMoviesUseCase {
  final MovieRepository _repository;
  GetCartoonMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.cartoonMovies(page, limit);
}

class GetTvShowsMoviesUseCase {
  final MovieRepository _repository;
  GetTvShowsMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.tvShowsMovies(page, limit);
}

class GetVietSubMoviesUseCase {
  final MovieRepository _repository;
  GetVietSubMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.vietSubMovies(page, limit);
}

class GetNarratedMoviesUseCase {
  final MovieRepository _repository;
  GetNarratedMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.narratedMovies(page, limit);
}

class GetDubbedMoviesUseCase {
  final MovieRepository _repository;
  GetDubbedMoviesUseCase(this._repository);
  Future<Map> call(int page, int limit) => _repository.dubbedMovies(page, limit);
}

class GetMovieDetailUseCase {
  final MovieRepository _repository;
  GetMovieDetailUseCase(this._repository);
  Future<Map?> call(String nameMovie) => _repository.singleDetailMovies(nameMovie);
}

class GetFavoriteMoviesUseCase {
  final MovieRepository _repository;
  GetFavoriteMoviesUseCase(this._repository);
  Future<Map> call() => _repository.getFavoriteMovies();
}

class AddFavoriteMovieUseCase {
  final MovieRepository _repository;
  AddFavoriteMovieUseCase(this._repository);
  Future<bool> call(String name, String slug, String posterUrl,
      String lang, String episodeCurrent) {
    return _repository.addFavoriteMovies(name, slug, posterUrl, lang, episodeCurrent);
  }
}

class RemoveFavoriteMovieUseCase {
  final MovieRepository _repository;
  RemoveFavoriteMovieUseCase(this._repository);
  Future<bool> call(String slug) => _repository.removeFavoriteMovie(slug);
}

class GetHistoryMoviesUseCase {
  final MovieRepository _repository;
  GetHistoryMoviesUseCase(this._repository);
  Future<Map> call() => _repository.historyWatchMovies();
}

class GetHistoryWatchMovieUseCase {
  final MovieRepository _repository;
  GetHistoryWatchMovieUseCase(this._repository);
  Future<Map?> call(String slug) => _repository.getHistoryWatchMovies(slug);
}

class AddHistoryWatchMovieUseCase {
  final MovieRepository _repository;
  AddHistoryWatchMovieUseCase(this._repository);
  Future<void> call(String name, String slug, String posterUrl, int episode) {
    return _repository.addHistoryWatchMovies(name, slug, posterUrl, episode);
  }
}

class RemoveHistoryWatchMovieUseCase {
  final MovieRepository _repository;
  RemoveHistoryWatchMovieUseCase(this._repository);
  Future<bool> call(String slug) => _repository.removeHistoryWatchMovies(slug);
}

class GetRecommendedPartsUseCase {
  final MovieRepository _repository;
  GetRecommendedPartsUseCase(this._repository);

  String _getBaseName(String name) {
    if (name.contains(':') && RegExp(r'\d+:|:').firstMatch(name) != null) {
      return RegExp(r'^(\S+\s\S+)\b').firstMatch(name)?.group(1)?.trim() ??
          name.trim();
    } else {
      final match =
          RegExp(r'^(.*?)(?:\s*\((?=.*\d)[^\)]*\)|\s+\d+)?$').firstMatch(name);
      final base = match?.group(1)?.trim() ?? name.trim();
      if (base == name.trim()) {
        return RegExp(r'^(\S+\s\S+)\b').firstMatch(name)?.group(1)?.trim() ??
            base;
      }
      return base;
    }
  }

  List _uniqueList(List list) {
    final seen = <dynamic>{};
    final uniqueObjects = <dynamic>[];

    for (var e in list) {
      if (!seen.contains(e['_id'])) {
        seen.add(e['_id']);
        uniqueObjects.add(e);
      }
    }
    return uniqueObjects;
  }

  Future<List> call(Map movie) async {
    final movieData = movie['movie'];
    final movieId = movieData['_id'];

    Future<List> searchAndFilter(String query, int limit) async {
      if (query.trim().isEmpty) return [];
      try {
        final res = await _repository.searchMovies(keyword: query, limit: limit);
        final items = res['data']?['items'] as List? ?? [];
        return items.where((e) => e['_id'] != movieId).toList();
      } catch (_) {
        return [];
      }
    }

    final baseName = _getBaseName(movieData['name'] ?? '');
    final baseOriginName = _getBaseName(movieData['origin_name'] ?? '');

    // Optimize: Collect unique and relevant search terms to minimize parallel HTTP requests
    final searchTerms = <String>{};
    if (baseOriginName.isNotEmpty) searchTerms.add(baseOriginName);
    if (baseName.isNotEmpty) searchTerms.add(baseName);

    List allSearchMovies = [];
    if (searchTerms.isNotEmpty) {
      final List<List> searchResults = await Future.wait(
        searchTerms.map((term) => searchAndFilter(term, 12)).toList(),
      );
      allSearchMovies = _uniqueList(searchResults.expand((e) => e).toList());
    }

    // Optimize: If search yields few results, fetch from a single highly-relevant fallback
    if (allSearchMovies.length < 10) {
      final categoryList = movieData['category'] as List?;
      final countryList = movieData['country'] as List?;
      
      Map? res;
      try {
        if (categoryList != null && categoryList.isNotEmpty && categoryList[0]['slug'] != null) {
          res = await _repository.categoryDetailMovies(
              categoryList[0]['slug'], 1, 12, "desc", "", 0);
        } else if (countryList != null && countryList.isNotEmpty && countryList[0]['slug'] != null) {
          res = await _repository.countryDetailMovies(
              countryList[0]['slug'], 1, 12);
        }
      } catch (_) {}

      if (res != null) {
        final items = res['data']?['items'] as List? ?? [];
        final extraData = items.where((e) => e['_id'] != movieId).toList();
        allSearchMovies = _uniqueList([...allSearchMovies, ...extraData]);
      }
    }

    return allSearchMovies;
  }
}
