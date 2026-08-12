// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => _MovieModel(
      status: json['status'],
      msg: _parseStringNullable(json['msg']),
      movie: json['movie'] == null
          ? null
          : MovieDataModel.fromJson(json['movie'] as Map<String, dynamic>),
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieModelToJson(_MovieModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'movie': instance.movie,
      'episodes': instance.episodes,
    };

_MovieDataModel _$MovieDataModelFromJson(Map<String, dynamic> json) =>
    _MovieDataModel(
      id: _parseStringNullable(json['_id']),
      name: _parseStringNullable(json['name']),
      slug: _parseStringNullable(json['slug']),
      originName: _parseStringNullable(json['origin_name']),
      content: _parseStringNullable(json['content']),
      type: _parseStringNullable(json['type']),
      status: json['status'],
      posterUrl: _parseStringNullable(json['poster_url']),
      thumbUrl: _parseStringNullable(json['thumb_url']),
      trailerUrl: _parseStringNullable(json['trailer_url']),
      time: _parseStringNullable(json['time']),
      episodeCurrent: _parseStringNullable(json['episode_current']),
      episodeTotal: _parseStringNullable(json['episode_total']),
      quality: _parseStringNullable(json['quality']),
      lang: _parseStringNullable(json['lang']),
      year: _parseIntNullable(json['year']),
      view: _parseIntNullable(json['view']),
      actor: _parseStringListNullable(json['actor']),
      director: _parseStringListNullable(json['director']),
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      country: (json['country'] as List<dynamic>?)
          ?.map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDataModelToJson(_MovieDataModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'origin_name': instance.originName,
      'content': instance.content,
      'type': instance.type,
      'status': instance.status,
      'poster_url': instance.posterUrl,
      'thumb_url': instance.thumbUrl,
      'trailer_url': instance.trailerUrl,
      'time': instance.time,
      'episode_current': instance.episodeCurrent,
      'episode_total': instance.episodeTotal,
      'quality': instance.quality,
      'lang': instance.lang,
      'year': instance.year,
      'view': instance.view,
      'actor': instance.actor,
      'director': instance.director,
      'category': instance.category,
      'country': instance.country,
    };

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: _parseStringNullable(json['id']),
      name: _parseStringNullable(json['name']),
      slug: _parseStringNullable(json['slug']),
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_CountryModel _$CountryModelFromJson(Map<String, dynamic> json) =>
    _CountryModel(
      id: _parseStringNullable(json['id']),
      name: _parseStringNullable(json['name']),
      slug: _parseStringNullable(json['slug']),
    );

Map<String, dynamic> _$CountryModelToJson(_CountryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) =>
    _EpisodeModel(
      serverName: _parseStringNullable(json['server_name']),
      serverData: (json['server_data'] as List<dynamic>?)
          ?.map((e) => ServerDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EpisodeModelToJson(_EpisodeModel instance) =>
    <String, dynamic>{
      'server_name': instance.serverName,
      'server_data': instance.serverData,
    };

_ServerDataModel _$ServerDataModelFromJson(Map<String, dynamic> json) =>
    _ServerDataModel(
      name: _parseStringNullable(json['name']),
      slug: _parseStringNullable(json['slug']),
      filename: _parseStringNullable(json['filename']),
      linkEmbed: _parseStringNullable(json['link_embed']),
      linkM3u8: _parseStringNullable(json['link_m3u8']),
    );

Map<String, dynamic> _$ServerDataModelToJson(_ServerDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'filename': instance.filename,
      'link_embed': instance.linkEmbed,
      'link_m3u8': instance.linkM3u8,
    };
