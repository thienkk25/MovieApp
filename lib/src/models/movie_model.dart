import 'dart:convert';

class MovieModel {
  final bool status;
  final String msg;
  final Movie movie;
  final List<Episode> episodes;

  MovieModel({
    required this.status,
    required this.msg,
    required this.movie,
    required this.episodes,
  });

  MovieModel copyWith({
    bool? status,
    String? msg,
    Movie? movie,
    List<Episode>? episodes,
  }) =>
      MovieModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        movie: movie ?? this.movie,
        episodes: episodes ?? this.episodes,
      );

  factory MovieModel.fromRawJson(String str) =>
      MovieModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        status: json["status"],
        msg: json["msg"],
        movie: Movie.fromJson(json["movie"]),
        episodes: List<Episode>.from(
            json["episodes"].map((x) => Episode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "movie": movie.toJson(),
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
      };
}

class Episode {
  final String serverName;
  final List<ServerDatum> serverData;

  Episode({
    required this.serverName,
    required this.serverData,
  });

  Episode copyWith({
    String? serverName,
    List<ServerDatum>? serverData,
  }) =>
      Episode(
        serverName: serverName ?? this.serverName,
        serverData: serverData ?? this.serverData,
      );

  factory Episode.fromRawJson(String str) => Episode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        serverName: json["server_name"],
        serverData: List<ServerDatum>.from(
            json["server_data"].map((x) => ServerDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "server_name": serverName,
        "server_data": List<dynamic>.from(serverData.map((x) => x.toJson())),
      };
}

class ServerDatum {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3U8;

  ServerDatum({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3U8,
  });

  ServerDatum copyWith({
    String? name,
    String? slug,
    String? filename,
    String? linkEmbed,
    String? linkM3U8,
  }) =>
      ServerDatum(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        filename: filename ?? this.filename,
        linkEmbed: linkEmbed ?? this.linkEmbed,
        linkM3U8: linkM3U8 ?? this.linkM3U8,
      );

  factory ServerDatum.fromRawJson(String str) =>
      ServerDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerDatum.fromJson(Map<String, dynamic> json) => ServerDatum(
        name: json["name"],
        slug: json["slug"],
        filename: json["filename"],
        linkEmbed: json["link_embed"],
        linkM3U8: json["link_m3u8"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "filename": filename,
        "link_embed": linkEmbed,
        "link_m3u8": linkM3U8,
      };
}

class Movie {
  final Tmdb tmdb;
  final Imdb imdb;
  final Created created;
  final Created modified;
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String content;
  final String type;
  final String status;
  final String posterUrl;
  final String thumbUrl;
  final bool isCopyright;
  final bool subDocquyen;
  final bool chieurap;
  final String trailerUrl;
  final String time;
  final String episodeCurrent;
  final String episodeTotal;
  final String quality;
  final String lang;
  final String notify;
  final String showtimes;
  final int year;
  final int view;
  final List<String> actor;
  final List<String> director;
  final List<Category> category;
  final List<Category> country;

  Movie({
    required this.tmdb,
    required this.imdb,
    required this.created,
    required this.modified,
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.posterUrl,
    required this.thumbUrl,
    required this.isCopyright,
    required this.subDocquyen,
    required this.chieurap,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.notify,
    required this.showtimes,
    required this.year,
    required this.view,
    required this.actor,
    required this.director,
    required this.category,
    required this.country,
  });

  Movie copyWith({
    Tmdb? tmdb,
    Imdb? imdb,
    Created? created,
    Created? modified,
    String? id,
    String? name,
    String? slug,
    String? originName,
    String? content,
    String? type,
    String? status,
    String? posterUrl,
    String? thumbUrl,
    bool? isCopyright,
    bool? subDocquyen,
    bool? chieurap,
    String? trailerUrl,
    String? time,
    String? episodeCurrent,
    String? episodeTotal,
    String? quality,
    String? lang,
    String? notify,
    String? showtimes,
    int? year,
    int? view,
    List<String>? actor,
    List<String>? director,
    List<Category>? category,
    List<Category>? country,
  }) =>
      Movie(
        tmdb: tmdb ?? this.tmdb,
        imdb: imdb ?? this.imdb,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        originName: originName ?? this.originName,
        content: content ?? this.content,
        type: type ?? this.type,
        status: status ?? this.status,
        posterUrl: posterUrl ?? this.posterUrl,
        thumbUrl: thumbUrl ?? this.thumbUrl,
        isCopyright: isCopyright ?? this.isCopyright,
        subDocquyen: subDocquyen ?? this.subDocquyen,
        chieurap: chieurap ?? this.chieurap,
        trailerUrl: trailerUrl ?? this.trailerUrl,
        time: time ?? this.time,
        episodeCurrent: episodeCurrent ?? this.episodeCurrent,
        episodeTotal: episodeTotal ?? this.episodeTotal,
        quality: quality ?? this.quality,
        lang: lang ?? this.lang,
        notify: notify ?? this.notify,
        showtimes: showtimes ?? this.showtimes,
        year: year ?? this.year,
        view: view ?? this.view,
        actor: actor ?? this.actor,
        director: director ?? this.director,
        category: category ?? this.category,
        country: country ?? this.country,
      );

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        tmdb: Tmdb.fromJson(json["tmdb"]),
        imdb: Imdb.fromJson(json["imdb"]),
        created: Created.fromJson(json["created"]),
        modified: Created.fromJson(json["modified"]),
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        originName: json["origin_name"],
        content: json["content"],
        type: json["type"],
        status: json["status"],
        posterUrl: json["poster_url"],
        thumbUrl: json["thumb_url"],
        isCopyright: json["is_copyright"],
        subDocquyen: json["sub_docquyen"],
        chieurap: json["chieurap"],
        trailerUrl: json["trailer_url"],
        time: json["time"],
        episodeCurrent: json["episode_current"],
        episodeTotal: json["episode_total"],
        quality: json["quality"],
        lang: json["lang"],
        notify: json["notify"],
        showtimes: json["showtimes"],
        year: json["year"],
        view: json["view"],
        actor: List<String>.from(json["actor"].map((x) => x)),
        director: List<String>.from(json["director"].map((x) => x)),
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
        country: List<Category>.from(
            json["country"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tmdb": tmdb.toJson(),
        "imdb": imdb.toJson(),
        "created": created.toJson(),
        "modified": modified.toJson(),
        "_id": id,
        "name": name,
        "slug": slug,
        "origin_name": originName,
        "content": content,
        "type": type,
        "status": status,
        "poster_url": posterUrl,
        "thumb_url": thumbUrl,
        "is_copyright": isCopyright,
        "sub_docquyen": subDocquyen,
        "chieurap": chieurap,
        "trailer_url": trailerUrl,
        "time": time,
        "episode_current": episodeCurrent,
        "episode_total": episodeTotal,
        "quality": quality,
        "lang": lang,
        "notify": notify,
        "showtimes": showtimes,
        "year": year,
        "view": view,
        "actor": List<dynamic>.from(actor.map((x) => x)),
        "director": List<dynamic>.from(director.map((x) => x)),
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
        "country": List<dynamic>.from(country.map((x) => x.toJson())),
      };
}

class Category {
  final String id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  Category copyWith({
    String? id,
    String? name,
    String? slug,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
      );

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

class Created {
  final DateTime time;

  Created({
    required this.time,
  });

  Created copyWith({
    DateTime? time,
  }) =>
      Created(
        time: time ?? this.time,
      );

  factory Created.fromRawJson(String str) => Created.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Created.fromJson(Map<String, dynamic> json) => Created(
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "time": time.toIso8601String(),
      };
}

class Imdb {
  final dynamic id;

  Imdb({
    required this.id,
  });

  Imdb copyWith({
    dynamic id,
  }) =>
      Imdb(
        id: id ?? this.id,
      );

  factory Imdb.fromRawJson(String str) => Imdb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Imdb.fromJson(Map<String, dynamic> json) => Imdb(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Tmdb {
  final dynamic type;
  final dynamic id;
  final dynamic season;
  final int voteAverage;
  final int voteCount;

  Tmdb({
    required this.type,
    required this.id,
    required this.season,
    required this.voteAverage,
    required this.voteCount,
  });

  Tmdb copyWith({
    dynamic type,
    dynamic id,
    dynamic season,
    int? voteAverage,
    int? voteCount,
  }) =>
      Tmdb(
        type: type ?? this.type,
        id: id ?? this.id,
        season: season ?? this.season,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  factory Tmdb.fromRawJson(String str) => Tmdb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tmdb.fromJson(Map<String, dynamic> json) => Tmdb(
        type: json["type"],
        id: json["id"],
        season: json["season"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "season": season,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
