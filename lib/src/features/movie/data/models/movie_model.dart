import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

String? _parseStringNullable(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

List<String>? _parseStringListNullable(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
  }
  if (value is String && value.isNotEmpty) {
    return [value];
  }
  return null;
}

@freezed
abstract class MovieModel with _$MovieModel {
  const MovieModel._();

  const factory MovieModel({
    dynamic status,
    @JsonKey(fromJson: _parseStringNullable) String? msg,
    MovieDataModel? movie,
    List<EpisodeModel>? episodes,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  MovieDetailEntity? toEntity() {
    if (movie == null) return null;
    final movieEntity = movie!.toEntity();
    return MovieDetailEntity(
      movie: movieEntity,
      content: movie?.content ?? '',
      trailerUrl: movie?.trailerUrl ?? '',
      actors: movie?.actor ?? [],
      directors: movie?.director ?? [],
      episodes: episodes?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

@freezed
abstract class MovieDataModel with _$MovieDataModel {
  const MovieDataModel._();

  const factory MovieDataModel({
    @JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
    @JsonKey(fromJson: _parseStringNullable) String? name,
    @JsonKey(fromJson: _parseStringNullable) String? slug,
    @JsonKey(name: 'origin_name', fromJson: _parseStringNullable) String? originName,
    @JsonKey(fromJson: _parseStringNullable) String? content,
    @JsonKey(fromJson: _parseStringNullable) String? type,
    dynamic status,
    @JsonKey(name: 'poster_url', fromJson: _parseStringNullable) String? posterUrl,
    @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable) String? thumbUrl,
    @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable) String? trailerUrl,
    @JsonKey(fromJson: _parseStringNullable) String? time,
    @JsonKey(name: 'episode_current', fromJson: _parseStringNullable) String? episodeCurrent,
    @JsonKey(name: 'episode_total', fromJson: _parseStringNullable) String? episodeTotal,
    @JsonKey(fromJson: _parseStringNullable) String? quality,
    @JsonKey(fromJson: _parseStringNullable) String? lang,
    @JsonKey(fromJson: _parseIntNullable) int? year,
    @JsonKey(fromJson: _parseIntNullable) int? view,
    @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
    @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
    List<CategoryModel>? category,
    List<CountryModel>? country,
  }) = _MovieDataModel;

  factory MovieDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDataModelFromJson(json);

  MovieEntity toEntity() {
    return MovieEntity(
      id: id ?? '',
      name: name ?? '',
      slug: slug ?? '',
      originName: originName ?? '',
      posterUrl: posterUrl ?? '',
      thumbUrl: thumbUrl ?? '',
      year: year ?? 0,
      quality: quality ?? '',
      lang: lang ?? '',
      time: time ?? '',
      episodeCurrent: episodeCurrent ?? '',
      categories: category?.map((c) => c.name ?? '').where((n) => n.isNotEmpty).toList() ?? [],
      view: view ?? 0,
    );
  }
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(fromJson: _parseStringNullable) String? id,
    @JsonKey(fromJson: _parseStringNullable) String? name,
    @JsonKey(fromJson: _parseStringNullable) String? slug,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
abstract class CountryModel with _$CountryModel {
  const factory CountryModel({
    @JsonKey(fromJson: _parseStringNullable) String? id,
    @JsonKey(fromJson: _parseStringNullable) String? name,
    @JsonKey(fromJson: _parseStringNullable) String? slug,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);
}

@freezed
abstract class EpisodeModel with _$EpisodeModel {
  const EpisodeModel._();

  const factory EpisodeModel({
    @JsonKey(name: 'server_name', fromJson: _parseStringNullable) String? serverName,
    @JsonKey(name: 'server_data') List<ServerDataModel>? serverData,
  }) = _EpisodeModel;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  EpisodeEntity toEntity() {
    return EpisodeEntity(
      serverName: serverName ?? '',
      serverData: serverData?.map((s) => s.toEntity()).toList() ?? [],
    );
  }
}

@freezed
abstract class ServerDataModel with _$ServerDataModel {
  const ServerDataModel._();

  const factory ServerDataModel({
    @JsonKey(fromJson: _parseStringNullable) String? name,
    @JsonKey(fromJson: _parseStringNullable) String? slug,
    @JsonKey(fromJson: _parseStringNullable) String? filename,
    @JsonKey(name: 'link_embed', fromJson: _parseStringNullable) String? linkEmbed,
    @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable) String? linkM3u8,
  }) = _ServerDataModel;

  factory ServerDataModel.fromJson(Map<String, dynamic> json) =>
      _$ServerDataModelFromJson(json);

  ServerDataEntity toEntity() {
    return ServerDataEntity(
      name: name ?? '',
      slug: slug ?? '',
      filename: filename ?? '',
      linkEmbed: linkEmbed ?? '',
      linkM3u8: linkM3u8 ?? '',
    );
  }
}
