class MovieModel {
  final bool? status;
  final String? msg;
  final MovieData? movie;
  final List<Episode>? episodes;

  MovieModel({
    this.status,
    this.msg,
    this.movie,
    this.episodes,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        status: json["status"],
        msg: json["msg"],
        movie: json["movie"] != null ? MovieData.fromJson(json["movie"]) : null,
        episodes: json["episodes"] != null
            ? List<Episode>.from(
                json["episodes"].map((x) => Episode.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "movie": movie?.toJson(),
        "episodes": episodes != null
            ? List<dynamic>.from(episodes!.map((x) => x.toJson()))
            : null,
      };
}

class MovieData {
  final TMDB? tmdb;
  final IMDB? imdb;
  final CreatedModified? created;
  final CreatedModified? modified;
  final String? id;
  final String? name;
  final String? slug;
  final String? originName;
  final String? content;
  final String? type;
  final String? status;
  final String? posterUrl;
  final String? thumbUrl;
  final bool? isCopyright;
  final bool? subDocquyen;
  final bool? chieurap;
  final String? trailerUrl;
  final String? time;
  final String? episodeCurrent;
  final String? episodeTotal;
  final String? quality;
  final String? lang;
  final String? notify;
  final String? showtimes;
  final int? year;
  final int? view;
  final List<String>? actor;
  final List<String>? director;
  final List<Category>? category;
  final List<Country>? country;

  MovieData({
    this.tmdb,
    this.imdb,
    this.created,
    this.modified,
    this.id,
    this.name,
    this.slug,
    this.originName,
    this.content,
    this.type,
    this.status,
    this.posterUrl,
    this.thumbUrl,
    this.isCopyright,
    this.subDocquyen,
    this.chieurap,
    this.trailerUrl,
    this.time,
    this.episodeCurrent,
    this.episodeTotal,
    this.quality,
    this.lang,
    this.notify,
    this.showtimes,
    this.year,
    this.view,
    this.actor,
    this.director,
    this.category,
    this.country,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) => MovieData(
        tmdb: json["tmdb"] != null ? TMDB.fromJson(json["tmdb"]) : null,
        imdb: json["imdb"] != null ? IMDB.fromJson(json["imdb"]) : null,
        created: json["created"] != null
            ? CreatedModified.fromJson(json["created"])
            : null,
        modified: json["modified"] != null
            ? CreatedModified.fromJson(json["modified"])
            : null,
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        slug: json["slug"] ?? "",
        originName: json["origin_name"] ?? "",
        content: json["content"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? "",
        posterUrl: json["poster_url"] ?? "",
        thumbUrl: json["thumb_url"] ?? "",
        isCopyright: json["is_copyright"] ?? false,
        subDocquyen: json["sub_docquyen"] ?? false,
        chieurap: json["chieurap"] ?? false,
        trailerUrl: json["trailer_url"] ?? "",
        time: json["time"] ?? "",
        episodeCurrent: json["episode_current"] ?? "",
        episodeTotal: json["episode_total"] ?? "",
        quality: json["quality"] ?? "",
        lang: json["lang"] ?? "",
        notify: json["notify"] ?? "",
        showtimes: json["showtimes"] ?? "",
        year: json["year"] ?? 0,
        view: json["view"] ?? 0,
        actor: json["actor"] != null
            ? List<String>.from(json["actor"].map((x) => x))
            : [],
        director: json["director"] != null
            ? List<String>.from(json["director"].map((x) => x))
            : [],
        category: json["category"] != null
            ? List<Category>.from(
                json["category"].map((x) => Category.fromJson(x)))
            : [],
        country: json["country"] != null
            ? List<Country>.from(
                json["country"].map((x) => Country.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "tmdb": tmdb?.toJson(),
        "imdb": imdb?.toJson(),
        "created": created?.toJson(),
        "modified": modified?.toJson(),
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
        "actor": actor,
        "director": director,
        "category": List<dynamic>.from(
            category == null ? {} : category!.map((x) => x.toJson())),
        "country": List<dynamic>.from(
            country == null ? {} : country!.map((x) => x.toJson())),
      };
}

class TMDB {
  final String? type;
  final String? id;
  final dynamic season;
  final double? voteAverage;
  final int? voteCount;

  TMDB({this.type, this.id, this.season, this.voteAverage, this.voteCount});

  factory TMDB.fromJson(Map<String, dynamic> json) => TMDB(
        type: json["type"],
        id: json["id"],
        season: json["season"],
        voteAverage: json["vote_average"] != null
            ? json["vote_average"].toDouble()
            : 0.0,
        voteCount: json["vote_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "season": season,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

class IMDB {
  final String? id;

  IMDB({this.id});

  factory IMDB.fromJson(Map<String, dynamic> json) => IMDB(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}

class CreatedModified {
  final DateTime? time;

  CreatedModified({this.time});

  factory CreatedModified.fromJson(Map<String, dynamic> json) =>
      CreatedModified(
          time: json["time"] != null ? DateTime.parse(json["time"]) : null);

  Map<String, dynamic> toJson() => {"time": time?.toIso8601String()};
}

class Category {
  final String? id;
  final String? name;
  final String? slug;

  Category({this.id, this.name, this.slug});

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

class Country {
  final String? id;
  final String? name;
  final String? slug;

  Country({this.id, this.name, this.slug});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
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

class Episode {
  final String? serverName;
  final List<ServerData>? serverData;

  Episode({this.serverName, this.serverData});

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        serverName: json["server_name"],
        serverData: json["server_data"] != null
            ? List<ServerData>.from(
                json["server_data"].map((x) => ServerData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "server_name": serverName,
        "server_data": serverData != null
            ? List<dynamic>.from(serverData!.map((x) => x.toJson()))
            : [],
      };
}

class ServerData {
  final String? name;
  final String? slug;
  final String? filename;
  final String? linkEmbed;
  final String? linkM3u8;

  ServerData(
      {this.name, this.slug, this.filename, this.linkEmbed, this.linkM3u8});

  factory ServerData.fromJson(Map<String, dynamic> json) => ServerData(
        name: json["name"],
        slug: json["slug"],
        filename: json["filename"],
        linkEmbed: json["link_embed"],
        linkM3u8: json["link_m3u8"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "filename": filename,
        "link_embed": linkEmbed,
        "link_m3u8": linkM3u8,
      };
}
