import 'dart:convert';

class Movie {
  final Modified modified;
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String type;
  final String posterUrl;
  final String thumbUrl;
  final bool subDocquyen;
  final bool chieurap;
  final String time;
  final String episodeCurrent;
  final String quality;
  final String lang;
  final int year;
  final List<Category> category;
  final List<Category> country;

  Movie({
    required this.modified,
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.type,
    required this.posterUrl,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.chieurap,
    required this.time,
    required this.episodeCurrent,
    required this.quality,
    required this.lang,
    required this.year,
    required this.category,
    required this.country,
  });

  Movie copyWith({
    Modified? modified,
    String? id,
    String? name,
    String? slug,
    String? originName,
    String? type,
    String? posterUrl,
    String? thumbUrl,
    bool? subDocquyen,
    bool? chieurap,
    String? time,
    String? episodeCurrent,
    String? quality,
    String? lang,
    int? year,
    List<Category>? category,
    List<Category>? country,
  }) =>
      Movie(
        modified: modified ?? this.modified,
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        originName: originName ?? this.originName,
        type: type ?? this.type,
        posterUrl: posterUrl ?? this.posterUrl,
        thumbUrl: thumbUrl ?? this.thumbUrl,
        subDocquyen: subDocquyen ?? this.subDocquyen,
        chieurap: chieurap ?? this.chieurap,
        time: time ?? this.time,
        episodeCurrent: episodeCurrent ?? this.episodeCurrent,
        quality: quality ?? this.quality,
        lang: lang ?? this.lang,
        year: year ?? this.year,
        category: category ?? this.category,
        country: country ?? this.country,
      );

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        modified: Modified.fromJson(json["modified"]),
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        originName: json["origin_name"],
        type: json["type"],
        posterUrl: json["poster_url"],
        thumbUrl: json["thumb_url"],
        subDocquyen: json["sub_docquyen"],
        chieurap: json["chieurap"],
        time: json["time"],
        episodeCurrent: json["episode_current"],
        quality: json["quality"],
        lang: json["lang"],
        year: json["year"],
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
        country: List<Category>.from(
            json["country"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "modified": modified.toJson(),
        "_id": id,
        "name": name,
        "slug": slug,
        "origin_name": originName,
        "type": type,
        "poster_url": posterUrl,
        "thumb_url": thumbUrl,
        "sub_docquyen": subDocquyen,
        "chieurap": chieurap,
        "time": time,
        "episode_current": episodeCurrent,
        "quality": quality,
        "lang": lang,
        "year": year,
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

class Modified {
  final DateTime time;

  Modified({
    required this.time,
  });

  Modified copyWith({
    DateTime? time,
  }) =>
      Modified(
        time: time ?? this.time,
      );

  factory Modified.fromRawJson(String str) =>
      Modified.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Modified.fromJson(Map<String, dynamic> json) => Modified(
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "time": time.toIso8601String(),
      };
}
