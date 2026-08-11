import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WatchMovieWidget extends StatefulWidget {
  final MovieDetailEntity detail;
  final int serverIndex;
  final int episodeIndex;

  const WatchMovieWidget({
    super.key,
    required this.detail,
    required this.serverIndex,
    required this.episodeIndex,
  });

  @override
  State<WatchMovieWidget> createState() => _WatchMovieWidgetState();
}

class _WatchMovieWidgetState extends State<WatchMovieWidget> {
  late Player _player;
  late VideoController _videoController;
  StreamSubscription? _playingSubscription;

  @override
  void initState() {
    super.initState();
    _player = Player(
      configuration: const PlayerConfiguration(bufferSize: 64 * 1024 * 1024),
    );
    _videoController = VideoController(_player);

    _playingSubscription = _player.stream.playing.listen((playing) {
      if (playing) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    });

    _loadEpisode();
  }

  @override
  void didUpdateWidget(covariant WatchMovieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serverIndex != widget.serverIndex ||
        oldWidget.episodeIndex != widget.episodeIndex) {
      _loadEpisode();
    }
  }

  void _loadEpisode() {
    if (widget.detail.episodes.isEmpty) return;
    final server = widget.detail.episodes[widget.serverIndex];
    if (widget.episodeIndex < server.serverData.length) {
      final ep = server.serverData[widget.episodeIndex];
      final url = ep.linkM3u8.isNotEmpty ? ep.linkM3u8 : ep.linkEmbed;
      if (url.isNotEmpty) {
        _player.open(Media(url), play: true);
      }
    }
  }

  @override
  void dispose() {
    _playingSubscription?.cancel();
    WakelockPlus.disable();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialVideoControlsTheme(
        normal: const MaterialVideoControlsThemeData(
          seekBarPositionColor: Colors.amber,
          seekBarThumbColor: Colors.amber,
          buttonBarButtonColor: Colors.white,
        ),
        fullscreen: const MaterialVideoControlsThemeData(
          seekBarPositionColor: Colors.amber,
          seekBarThumbColor: Colors.amber,
          buttonBarButtonColor: Colors.white,
        ),
        child: Video(
          controller: _videoController,
          controls: MaterialVideoControls,
        ),
      ),
    );
  }
}
