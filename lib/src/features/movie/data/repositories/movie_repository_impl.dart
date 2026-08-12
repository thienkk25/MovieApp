import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/movie_firestore_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';
import '../models/search_filter.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieFirestoreDataSource firestoreDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.firestoreDataSource,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> getNewlyUpdatedMovies(int page) async {
    try {
      final res = await remoteDataSource.newlyUpdatedMovies(page);
      final itemsList = res['items'] ?? res['data']?['items'];
      if (itemsList != null && itemsList is List) {
        final List<MovieEntity> movies = [];
        for (var item in itemsList) {
          final dataModel = MovieDataModel.fromJson(Map<String, dynamic>.from(item as Map));
          movies.add(dataModel.toEntity());
        }
        return Right(movies);
      }
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(String slug) async {
    try {
      final res = await remoteDataSource.singleDetailMovies(slug);
      if (res != null) {
        final movieModel = MovieModel.fromJson(Map<String, dynamic>.from(res));
        final detailEntity = movieModel.toEntity();
        if (detailEntity != null) {
          return Right(detailEntity);
        }
      }
      return const Left(ServerFailure('Không tìm thấy thông tin phim'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  }) async {
    try {
      final res = await remoteDataSource.searchMovies(
        keyword: keyword,
        limit: limit,
        filters: filters,
      );
      final itemsList = res['data']?['items'] ?? res['items'];
      if (itemsList != null && itemsList is List) {
        final List<MovieEntity> movies = [];
        for (var item in itemsList) {
          final dataModel = MovieDataModel.fromJson(Map<String, dynamic>.from(item as Map));
          movies.add(dataModel.toEntity());
        }
        return Right(movies);
      }
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getCategoryMovies({
    required String type,
    int page = 1,
    int limit = 20,
    String sortType = 'desc',
    String country = '',
    int year = 0,
  }) async {
    try {
      Map res;
      final normalizedType = type.trim().toLowerCase();

      if (normalizedType == 'phim mới cập nhật' ||
          normalizedType == 'phim mới' ||
          normalizedType == 'phim-moi-cap-nhat') {
        res = await remoteDataSource.newlyUpdatedMovies(page);
      } else if (normalizedType == 'phim lẻ' || normalizedType == 'phim-le') {
        res = await remoteDataSource.singleMovies(page, limit);
      } else if (normalizedType == 'phim bộ' || normalizedType == 'phim-bo') {
        res = await remoteDataSource.dramaMovies(page, limit);
      } else if (normalizedType == 'hoạt hình' ||
          normalizedType == 'phim hoạt hình' ||
          normalizedType == 'hoat-hinh') {
        res = await remoteDataSource.cartoonMovies(page, limit);
      } else if (normalizedType == 'tv shows' ||
          normalizedType == 'chương trình truyền hình' ||
          normalizedType == 'tv-shows') {
        res = await remoteDataSource.tvShowsMovies(page, limit);
      } else if (normalizedType == 'phim vietsub' ||
          normalizedType == 'vietsub') {
        res = await remoteDataSource.vietSubMovies(page, limit);
      } else if (normalizedType == 'phim thuyết minh' ||
          normalizedType == 'thuyet-minh') {
        res = await remoteDataSource.narratedMovies(page, limit);
      } else if (normalizedType == 'phim lồng tiếng' ||
          normalizedType == 'long-tieng') {
        res = await remoteDataSource.dubbedMovies(page, limit);
      } else {
        final slug = _slugifyCategory(type);
        res = await remoteDataSource.categoryDetailMovies(
          slug,
          page,
          limit,
          sortType,
          country,
          year,
        );
      }

      final itemsList = res['data']?['items'] ?? res['items'];
      if (itemsList != null && itemsList is List) {
        final List<MovieEntity> movies = [];
        for (var item in itemsList) {
          final dataModel =
              MovieDataModel.fromJson(Map<String, dynamic>.from(item as Map));
          movies.add(dataModel.toEntity());
        }
        return Right(movies);
      }
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCategories() async {
    try {
      final res = await remoteDataSource.categoryMovies();
      return Right({'categories': res});
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final res = await firestoreDataSource.getFavoriteMovies();
      final List<MovieEntity> movies = [];
      res.forEach((key, value) {
        final map = Map<String, dynamic>.from(value as Map);
        movies.add(MovieEntity(
          id: key.toString(),
          name: map['name'] ?? '',
          slug: map['slug'] ?? key.toString(),
          originName: '',
          posterUrl: map['poster_url'] ?? '',
          thumbUrl: map['poster_url'] ?? '',
          year: 0,
          quality: 'HD',
          lang: map['lang'] ?? 'Vietsub',
          time: '',
          episodeCurrent: map['episode_current'] ?? '',
          categories: const [],
          view: 0,
        ));
      });
      return Right(movies);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoriteMovie(MovieEntity movie) async {
    try {
      final success = await firestoreDataSource.addFavoriteMovies(
        movie.name,
        movie.slug,
        movie.posterUrl,
        movie.lang,
        movie.episodeCurrent,
      );
      if (success) return const Right(null);
      return const Left(CacheFailure('Không thể thêm phim vào yêu thích'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteMovie(String slug) async {
    try {
      final success = await firestoreDataSource.removeFavoriteMovie(slug);
      if (success) return const Right(null);
      return const Left(CacheFailure('Không thể xóa phim khỏi yêu thích'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  String _slugifyCategory(String title) {
    String str = title.toLowerCase().trim();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    str = str.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    str = str.replaceAll(RegExp(r'\s+'), '-');
    return str.isEmpty ? 'phim-le' : str;
  }
}
