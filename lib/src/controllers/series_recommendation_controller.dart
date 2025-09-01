import 'package:movie_app/src/controllers/movie_controller.dart';

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

  Future<List> getRecommendedParts(Map movie) async {
    final MovieController movieService = MovieController();
    final String movieId = movie['movie']['_id'];
    final String baseOriginName = getBaseName(movie['movie']['origin_name']);
    final String baseName = getBaseName(movie['movie']['name']);

    final Map dataSearchOriginName =
        await movieService.searchMovies(baseOriginName, 20);
    List seriesMoviesSearchOriginName =
        (dataSearchOriginName['data']['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();

    final Map dataSearchOriginNameTwoSpace = await movieService.searchMovies(
        RegExp(r'^(.+?\s.+?)\b')
                .firstMatch(movie['movie']['origin_name'])
                ?.group(1)
                ?.trim() ??
            movie['movie']['origin_name'].trim(),
        10);
    final seriesMoviesOriginNameTwoSpace =
        (dataSearchOriginNameTwoSpace['data']['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();

    final Map dataSearchName = await movieService.searchMovies(baseName, 20);
    List seriesMoviesSearchName = (dataSearchName['data']['items'] as List)
        .where((e) => e['_id'] != movieId)
        .toList();

    final Map dataSearchNameTwoSpace = await movieService.searchMovies(
        RegExp(r'^(.+?\s.+?)\b')
                .firstMatch(movie['movie']['name'])
                ?.group(1)
                ?.trim() ??
            movie['movie']['name'].trim(),
        10);
    final seriesMoviesNameTwoSpace =
        (dataSearchNameTwoSpace['data']['items'] as List)
            .where((e) => e['_id'] != movieId)
            .toList();

    seriesMoviesSearchOriginName = uniqueList([
      ...seriesMoviesSearchName,
      ...seriesMoviesNameTwoSpace,
      ...seriesMoviesSearchOriginName,
      ...seriesMoviesOriginNameTwoSpace,
    ]);

    if (seriesMoviesSearchOriginName.length < 10) {
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
      allData =
          uniqueList([...seriesMoviesSearchOriginName, ...allData.take(12)]);

      return allData;
    }
    return seriesMoviesSearchOriginName;
  }
}
