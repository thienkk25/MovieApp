import 'package:movie_app/src/services/movie_service.dart';

class SeriesRecommendationController {
  String getBaseOriginName(String originName) {
    final match = RegExp(r'^(.*?)\s*\(.*\)$').firstMatch(originName);
    if (match != null) return match.group(1)!.trim();
    return originName.trim();
  }

  Future<List> getRecommendedParts(Map movie) async {
    final MovieService movieService = MovieService();
    final String movieId = movie['movie']['_id'];
    final String baseOriginName =
        getBaseOriginName(movie['movie']['origin_name']);
    final Map dataSearch = await movieService.searchMovies(baseOriginName, 10);
    List dataItemsSearch = dataSearch['data']['items'];
    final seriesMoviesSearch = dataItemsSearch
        .where((e) =>
            getBaseOriginName(e['origin_name']) == baseOriginName &&
            e['_id'] != movieId)
        .toList();

    if (seriesMoviesSearch.length <= 10) {
      final futures = [
        movieService.categoryDetailMovies(
            movie['movie']['category'][0]['slug'], 5, 10),
        movieService.countryDetailMovies(
            movie['movie']['country'][0]['slug'], 5, 10),
        movieService.yearDetailMovies(movie['movie']['year'].toString(), 5, 10),
      ];

      final results = await Future.wait(futures);

      final seriesMoviesCategory = (results[0]['data']['items'] as List)
          .where((e) => e['_id'] != movieId)
          .toList();

      final seriesMoviesCountry = (results[1]['data']['items'] as List)
          .where((e) => e['_id'] != movieId)
          .toList();

      final seriesMoviesYear = (results[2]['data']['items'] as List)
          .where((e) => e['_id'] != movieId)
          .toList();

      List allData = [
        ...seriesMoviesCategory,
        ...seriesMoviesCountry,
        ...seriesMoviesYear
      ];
      allData.shuffle();
      return [...seriesMoviesSearch, ...allData.take(12)];
    }
    return seriesMoviesSearch;
  }
}
