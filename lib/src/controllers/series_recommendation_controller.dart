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
    final movieService = MovieController();
    final movieData = movie['movie'];
    final movieId = movieData['_id'];

    Future<List> searchAndFilter(String query, int limit) async {
      final res = await movieService.searchMovies(keyword: query, limit: limit);
      final items = res['data']?['items'] as List? ?? [];
      return items.where((e) => e['_id'] != movieId).toList();
    }

    final baseName = getBaseName(movieData['name']);
    final baseOriginName = getBaseName(movieData['origin_name']);
    String getFirstTwoWords(String str) {
      return RegExp(r'^(.+?\s.+?)\b').firstMatch(str)?.group(1)?.trim() ??
          str.trim();
    }

    final List<List> searchResults = await Future.wait([
      searchAndFilter(baseOriginName, 20),
      searchAndFilter(getFirstTwoWords(movieData['origin_name']), 10),
      searchAndFilter(baseName, 20),
      searchAndFilter(getFirstTwoWords(movieData['name']), 10),
    ]);

    List allSearchMovies = uniqueList([
      ...searchResults[0],
      ...searchResults[1],
      ...searchResults[2],
      ...searchResults[3],
    ]);

    if (allSearchMovies.length < 10) {
      final futures = [
        movieService.categoryDetailMovies(
            movieData['category'][0]['slug'], 5, 10),
        movieService.countryDetailMovies(
            movieData['country'][0]['slug'], 5, 10),
        movieService.yearDetailMovies(movieData['year'].toString(), 5, 10),
      ];

      final results = await Future.wait(futures);

      List<List> extraLists = results.map((res) {
        final items = res['data']?['items'] as List? ?? [];
        return items.where((e) => e['_id'] != movieId).toList();
      }).toList();

      List extraData = uniqueList(extraLists.expand((e) => e).toList())
        ..shuffle();

      allSearchMovies = uniqueList([...allSearchMovies, ...extraData.take(12)]);
    }

    return allSearchMovies;
  }
}
