import 'package:movie_app/src/services/movie_service.dart';

class SeriesRecommendationController {
  String getBaseName(String name) {
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

  List uniqueList(List list) {
    var counts = <dynamic, int>{};

    for (var e in list) {
      counts[e['_id']] = (counts[e['_id']] ?? 0) + 1;
    }

    List uniqueObjects = [];
    for (var e in list) {
      if (counts[e['_id']] == 1) uniqueObjects.add(e);
    }

    return uniqueObjects;
  }

  Future<List> getRecommendedParts(Map movie) async {
    final MovieService movieService = MovieService();
    final String movieId = movie['movie']['_id'];
    final String baseOriginName = getBaseName(movie['movie']['name']);
    final Map dataSearch = await movieService.searchMovies(baseOriginName, 20);
    List dataItemsSearch = dataSearch['data']['items'];
    List seriesMoviesSearch = dataItemsSearch
        .where((e) =>
            getBaseName(e['name']) == baseOriginName && e['_id'] != movieId)
        .toList();

    final dataSearchOriginNameTwoSpace = await movieService.searchMovies(
        RegExp(r'^(.+?\s.+?)\b')
                .firstMatch(movie['movie']['origin_name'])
                ?.group(1)
                ?.trim() ??
            movie['movie']['origin_name'].trim(),
        20);
    final seriesMoviesOriginNameTwoSpace =
        (dataSearchOriginNameTwoSpace['data']['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();

    seriesMoviesSearch =
        uniqueList([...seriesMoviesSearch, ...seriesMoviesOriginNameTwoSpace]);

    if (seriesMoviesSearch.length <= 18) {
      final futures = [
        movieService.categoryDetailMovies(
            movie['movie']['category'][0]['slug'], 5, 10),
        movieService.countryDetailMovies(
            movie['movie']['country'][0]['slug'], 5, 10),
        movieService.yearDetailMovies(movie['movie']['year'].toString(), 5, 10),
      ];

      final results = await Future.wait(futures);

      List seriesMoviesCategory = [];
      List seriesMoviesCountry = [];
      List seriesMoviesYear = [];

      if (results[0]['data'] != "" && results[0]['data']['items'] != null) {
        seriesMoviesCategory = (results[0]['data']['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();
      } else {
        seriesMoviesCategory = [];
      }

      if (results[1]['data'] != "" && results[1]['data']['items'] != null) {
        seriesMoviesCountry = (results[1]['data']?['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();
      } else {
        seriesMoviesCountry = [];
      }

      if (results[2]['data'] != "" && results[2]['data']['items'] != null) {
        seriesMoviesYear = (results[2]['data']?['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();
      } else {
        seriesMoviesYear = [];
      }

      List allData = uniqueList([
        ...seriesMoviesCategory,
        ...seriesMoviesCountry,
        ...seriesMoviesYear
      ]);
      allData.shuffle();
      allData = uniqueList([...seriesMoviesSearch, ...allData.take(12)]);

      return allData;
    }
    return seriesMoviesSearch;
  }
}
