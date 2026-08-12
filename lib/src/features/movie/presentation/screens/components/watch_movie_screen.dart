import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
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

  void _seekRelative(Duration offset) {
    final currentPosition = _player.state.position;
    final target = currentPosition + offset;
    final duration = _player.state.duration;
    if (target < Duration.zero) {
      _player.seek(Duration.zero);
    } else if (target > duration) {
      _player.seek(duration);
    } else {
      _player.seek(target);
    }
  }

  String _getEpisodeTitle() {
    if (widget.detail.episodes.isEmpty) return widget.detail.movie.name;
    final server = widget.detail.episodes[widget.serverIndex];
    if (widget.episodeIndex < server.serverData.length) {
      final ep = server.serverData[widget.episodeIndex];
      final epName = ep.name.isNotEmpty ? ep.name : 'Tập ${widget.episodeIndex + 1}';
      return '${widget.detail.movie.name} - $epName';
    }
    return widget.detail.movie.name;
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
    final colors = context.appColors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(
          seekBarPositionColor: colors.accentPrimary,
          seekBarThumbColor: colors.accentPrimary,
          seekBarBufferColor: Colors.white.withValues(alpha: 0.35),
          seekBarColor: Colors.white.withValues(alpha: 0.2),
          buttonBarButtonColor: Colors.white,
          volumeGesture: true,
          brightnessGesture: true,
          seekGesture: true,
          seekOnDoubleTap: true,
          speedUpOnLongPress: true,
          speedUpFactor: 2.0,
          seekBarMargin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 20.0),
          bottomButtonBarMargin: const EdgeInsets.only(left: 12.0, right: 6.0, bottom: 20.0),
          topButtonBarMargin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          topButtonBar: [
            Expanded(
              child: Text(
                _getEpisodeTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Tải lại video',
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
              onPressed: _loadEpisode,
            ),
          ],
          primaryButtonBar: [
            const Spacer(flex: 2),
            IconButton(
              tooltip: 'Lùi 10 giây',
              icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 36),
              onPressed: () => _seekRelative(const Duration(seconds: -10)),
            ),
            const Spacer(),
            const MaterialPlayOrPauseButton(iconSize: 48.0),
            const Spacer(),
            IconButton(
              tooltip: 'Tới 10 giây',
              icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 36),
              onPressed: () => _seekRelative(const Duration(seconds: 10)),
            ),
            const Spacer(flex: 2),
          ],
          bottomButtonBar: const [
            MaterialPositionIndicator(),
            Spacer(),
            MaterialFullscreenButton(),
          ],
        ),
        fullscreen: MaterialVideoControlsThemeData(
          seekBarPositionColor: colors.accentPrimary,
          seekBarThumbColor: colors.accentPrimary,
          seekBarBufferColor: Colors.white.withValues(alpha: 0.35),
          seekBarColor: Colors.white.withValues(alpha: 0.2),
          buttonBarButtonColor: Colors.white,
          volumeGesture: true,
          brightnessGesture: true,
          seekGesture: true,
          seekOnDoubleTap: true,
          speedUpOnLongPress: true,
          speedUpFactor: 2.0,
          seekBarMargin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 42.0),
          bottomButtonBarMargin: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 42.0),
          topButtonBarMargin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          topButtonBar: [
            Expanded(
              child: Text(
                _getEpisodeTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Tải lại video',
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 24),
              onPressed: _loadEpisode,
            ),
          ],
          primaryButtonBar: [
            const Spacer(flex: 2),
            IconButton(
              tooltip: 'Lùi 10 giây',
              icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 42),
              onPressed: () => _seekRelative(const Duration(seconds: -10)),
            ),
            const Spacer(),
            const MaterialPlayOrPauseButton(iconSize: 58.0),
            const Spacer(),
            IconButton(
              tooltip: 'Tới 10 giây',
              icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 42),
              onPressed: () => _seekRelative(const Duration(seconds: 10)),
            ),
            const Spacer(flex: 2),
          ],
          bottomButtonBar: const [
            MaterialPositionIndicator(),
            Spacer(),
            MaterialFullscreenButton(),
          ],
        ),
        child: Video(
          controller: _videoController,
          controls: MaterialVideoControls,
        ),
      ),
    );
  }
}
