import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/src/features/movie/data/models/search_filter.dart';

abstract class MovieRemoteDataSource {
  Future<List> categoryMovies();
  Future<Map> categoryDetailMovies(
    String type,
    int page,
    int limit,
    String sortType,
    String country,
    int year,
  );
  Future<List> countryMovies();
  Future<Map> countryDetailMovies(String country, int page, int limit);
  Future<Map> yearDetailMovies(String year, int page, int limit);
  Future<Map> newlyUpdatedMovies(int page);
  Future<Map> newlyUpdatedMoviesV3(int page);
  Future<Map> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  });
  Future<Map> dramaMovies(int page, int limit);
  Future<Map> singleMovies(int page, int limit);
  Future<Map> cartoonMovies(int page, int limit);
  Future<Map> tvShowsMovies(int page, int limit);
  Future<Map> vietSubMovies(int page, int limit);
  Future<Map> narratedMovies(int page, int limit);
  Future<Map> dubbedMovies(int page, int limit);
  Future<Map?> singleDetailMovies(String nameMovie);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client _client;

  MovieRemoteDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<List> categoryMovies() async {
    final response =
        await _client.get(Uri.parse("https://phimapi.com/the-loai"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load category movies');
  }

  @override
  Future<Map> categoryDetailMovies(
    String type,
    int page,
    int limit,
    String sortType,
    String country,
    int year,
  ) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/the-loai/$type?page=$page&sort_type=$sortType&country=$country&year=$year&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load category detail movies');
  }

  @override
  Future<List> countryMovies() async {
    final response =
        await _client.get(Uri.parse("https://phimapi.com/quoc-gia"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load country movies');
  }

  @override
  Future<Map> countryDetailMovies(
    String country,
    int page,
    int limit,
  ) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/quoc-gia/$country?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load country detail movies');
  }

  @override
  Future<Map> yearDetailMovies(String year, int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/nam/$year?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load year detail movies');
  }

  @override
  Future<Map> newlyUpdatedMovies(int page) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/danh-sach/phim-moi-cap-nhat?page=$page"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load newly updated movies');
  }

  @override
  Future<Map> newlyUpdatedMoviesV3(int page) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/danh-sach/phim-moi-cap-nhat-v3?page=$page"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load newly updated movies v3');
  }

  @override
  Future<Map> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  }) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/tim-kiem?keyword=$keyword&limit=$limit&${filters?.toQueryString()}"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to search movies');
  }

  @override
  Future<Map> dramaMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/phim-bo?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load drama movies');
  }

  @override
  Future<Map> singleMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/phim-le?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load single movies');
  }

  @override
  Future<Map> cartoonMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/hoat-hinh?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load cartoon movies');
  }

  @override
  Future<Map> tvShowsMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/tv-shows?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load tv shows movies');
  }

  @override
  Future<Map> vietSubMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/phim-vietsub?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load vietsub movies');
  }

  @override
  Future<Map> narratedMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/phim-thuyet-minh?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load narrated movies');
  }

  @override
  Future<Map> dubbedMovies(int page, int limit) async {
    final response = await _client.get(Uri.parse(
        "https://phimapi.com/v1/api/danh-sach/phim-long-tieng?page=$page&limit=$limit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load dubbed movies');
  }

  @override
  Future<Map?> singleDetailMovies(String nameMovie) async {
    final response =
        await _client.get(Uri.parse("https://phimapi.com/phim/$nameMovie"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
