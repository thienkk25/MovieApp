import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String posterUrl;
  final String thumbUrl;
  final int year;
  final String quality;
  final String lang;
  final String time;
  final String episodeCurrent;
  final List<String> categories;
  final int view;

  const MovieEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.year,
    required this.quality,
    required this.lang,
    required this.time,
    required this.episodeCurrent,
    required this.categories,
    required this.view,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        originName,
        posterUrl,
        thumbUrl,
        year,
        quality,
        lang,
        time,
        episodeCurrent,
        categories,
        view,
      ];
}

class ServerDataEntity extends Equatable {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3u8;

  const ServerDataEntity({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  @override
  List<Object?> get props => [name, slug, filename, linkEmbed, linkM3u8];
}

class EpisodeEntity extends Equatable {
  final String serverName;
  final List<ServerDataEntity> serverData;

  const EpisodeEntity({
    required this.serverName,
    required this.serverData,
  });

  @override
  List<Object?> get props => [serverName, serverData];
}

class MovieDetailEntity extends Equatable {
  final MovieEntity movie;
  final String content;
  final String trailerUrl;
  final List<String> actors;
  final List<String> directors;
  final List<EpisodeEntity> episodes;

  const MovieDetailEntity({
    required this.movie,
    required this.content,
    required this.trailerUrl,
    required this.actors,
    required this.directors,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
        movie,
        content,
        trailerUrl,
        actors,
        directors,
        episodes,
      ];
}
