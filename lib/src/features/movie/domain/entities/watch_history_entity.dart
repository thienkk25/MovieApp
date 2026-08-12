import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Represents a movie the user has watched or is watching.
class WatchHistoryEntity extends Equatable {
  final String slug;
  final String name;
  final String originName;
  final String posterUrl;
  final String thumbUrl;
  final String quality;
  final String episodeCurrent;
  final int lastServerIndex;
  final int lastEpisodeIndex;
  final String lastEpisodeName;
  final DateTime watchedAt;

  const WatchHistoryEntity({
    required this.slug,
    required this.name,
    required this.originName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.quality,
    required this.episodeCurrent,
    required this.lastServerIndex,
    required this.lastEpisodeIndex,
    required this.lastEpisodeName,
    required this.watchedAt,
  });

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'name': name,
        'originName': originName,
        'posterUrl': posterUrl,
        'thumbUrl': thumbUrl,
        'quality': quality,
        'episodeCurrent': episodeCurrent,
        'lastServerIndex': lastServerIndex,
        'lastEpisodeIndex': lastEpisodeIndex,
        'lastEpisodeName': lastEpisodeName,
        'watchedAt': watchedAt.toIso8601String(),
      };

  factory WatchHistoryEntity.fromJson(Map<String, dynamic> json) {
    return WatchHistoryEntity(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      originName: json['originName'] as String? ?? '',
      posterUrl: json['posterUrl'] as String? ?? '',
      thumbUrl: json['thumbUrl'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
      episodeCurrent: json['episodeCurrent'] as String? ?? '',
      lastServerIndex: json['lastServerIndex'] as int? ?? 0,
      lastEpisodeIndex: json['lastEpisodeIndex'] as int? ?? 0,
      lastEpisodeName: json['lastEpisodeName'] as String? ?? '',
      watchedAt: json['watchedAt'] != null
          ? DateTime.parse(json['watchedAt'] as String)
          : DateTime.now(),
    );
  }

  static String encodeList(List<WatchHistoryEntity> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }

  static List<WatchHistoryEntity> decodeList(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => WatchHistoryEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [
        slug,
        name,
        originName,
        posterUrl,
        thumbUrl,
        quality,
        episodeCurrent,
        lastServerIndex,
        lastEpisodeIndex,
        lastEpisodeName,
        watchedAt,
      ];
}
