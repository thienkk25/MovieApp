import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WatchMovieScreen extends ConsumerStatefulWidget {
  final String slugMovie;
  final Map<dynamic, dynamic> dataInforMovie;
  const WatchMovieScreen(this.slugMovie, this.dataInforMovie, {super.key});

  @override
  ConsumerState<WatchMovieScreen> createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends ConsumerState<WatchMovieScreen> {
  late Player _player;
  late VideoController _videoController;
  Duration totalDurationVideo = Duration.zero;
  String? _currentVideoUrl;
  final ValueNotifier<bool> _isAutoNexting = ValueNotifier(false);
  final ValueNotifier<int> _countdown = ValueNotifier<int>(3);
  Timer? _autoNextTimer;
  bool _isFirstLoad = true;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _completedSubscription;

  @override
  void initState() {
    _player = Player(
        configuration: const PlayerConfiguration(bufferSize: 64 * 1024 * 1024));
    _videoController = VideoController(_player);

    final platform = _player.platform;
    try {
      if (platform.runtimeType.toString().contains('NativePlayer')) {
        (platform as dynamic).setProperty('hr-seek', 'no');
      }
    } catch (_) {}

    _playingSubscription = _player.stream.playing.listen((event) {
      if (event) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    });

    _durationSubscription = _player.stream.duration.listen(
      (event) {
        totalDurationVideo = event;
      },
    );
    _completedSubscription = _player.stream.completed.listen((_) {
      if (!mounted || _isAutoNexting.value) return;

      if (ref.read(isAutoNextMovie) && totalDurationVideo > Duration.zero) {
        _isAutoNexting.value = true;
        _countdown.value = 3;
        _autoNextTimer?.cancel();
        _autoNextTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          if (_countdown.value > 1) {
            _countdown.value -= 1;
          } else {
            timer.cancel();
            _playNextEpisode();
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    _playingSubscription?.cancel();
    _durationSubscription?.cancel();
    _completedSubscription?.cancel();

    // Immediately halt decoding and audio output to stop native streams.
    try {
      _player.stop();
    } catch (_) {}

    final playerToDispose = _player;
    // Delay the FFI disposal to allow the GPU/native surface cleanup callbacks to settle.
    Future.delayed(const Duration(milliseconds: 1000), () async {
      try {
        await playerToDispose.dispose();
      } catch (_) {}
    });

    _isAutoNexting.dispose();
    _countdown.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _cancelAutoNext() {
    _autoNextTimer?.cancel();
    if (mounted) {
      _isAutoNexting.value = false;
    }
  }

  Future<void> _playNextEpisode() async {
    _autoNextTimer?.cancel();
    if (mounted) {
      _isAutoNexting.value = false;
    }
    if (!mounted) return;

    final int size =
        widget.dataInforMovie['episodes'][0]['server_data'].length;
    if (ref.read(wasWatchEpisodeMovies) != -1 &&
        ref.read(wasWatchEpisodeMovies) < size) {
      int episode = ref.read(wasWatchEpisodeMovies);
      ref.read(wasWatchEpisodeMovies.notifier).state = episode + 1;
      ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
          widget.dataInforMovie['episodes'][0]['server_data'][episode]
              ['link_m3u8'];
      addHistoryWatchMovies(
          widget.dataInforMovie['movie']['name'],
          widget.slugMovie,
          widget.dataInforMovie['movie']['poster_url'],
          episode + 1);
    } else {
      if (mounted) {
        OverlayScreen().showOverlay(
          context,
          'player.alreadyLatestEpisode'.tr(),
          Colors.blueGrey,
          duration: 2,
        );
      }
    }
  }

  Future<void> _reloadVideo() async {
    if (_currentVideoUrl != null) {
      final position = _player.state.position;
      await _player.open(Media(_currentVideoUrl!), play: true);
      if (position > Duration.zero) {
        _player.seek(position);
      }
    }
  }

  Future<void> addHistoryWatchMovies(
      String name, String slug, String posterUrl, int episode) async {
    await ref.read(addHistoryWatchMovieUseCaseProvider).call(name, slug, posterUrl, episode);
    ref.read(historyMoviesNotifierProvider.notifier).removeState(slug);
    ref.read(historyMoviesNotifierProvider.notifier).addState({
      "name": name,
      "slug": slug,
      "poster_url": posterUrl,
      "episode": episode
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = ref.watch(isClickLWatchEpisodeLinkMovies);
    if (videoUrl != null && videoUrl != _currentVideoUrl) {
      _currentVideoUrl = videoUrl;
      final isFirst = _isFirstLoad;
      _isFirstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        if (isFirst) {
          // Give native player configuration and texture/surface attachments time to warm up
          await Future.delayed(const Duration(milliseconds: 300));
        }
        if (!mounted) return;
        _player.open(Media(videoUrl), play: true);
      });
    }
    return Stack(
      children: [
        MaterialVideoControlsTheme(
          normal: MaterialVideoControlsThemeData(
            seekBarPositionColor: Colors.orange,
            seekBarThumbColor: Colors.orange,
            seekBarBufferColor: Colors.white.withValues(alpha: 0.3),
            buttonBarButtonColor: Colors.white,
            buttonBarButtonSize: 32,
            primaryButtonBar: [
              IconButton(
                icon: const Icon(Icons.replay_10, size: 36, color: Colors.white),
                onPressed: () {
                  final position = _player.state.position;
                  _player.seek(position - const Duration(seconds: 10));
                },
              ),
              const SizedBox(width: 30),
              const MaterialPlayOrPauseButton(),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(Icons.forward_10, size: 36, color: Colors.white),
                onPressed: () {
                  final position = _player.state.position;
                  _player.seek(position + const Duration(seconds: 10));
                },
              ),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(Icons.refresh, size: 36, color: Colors.white),
                onPressed: _reloadVideo,
              ),
            ],
          ),
          fullscreen: MaterialVideoControlsThemeData(
            seekBarPositionColor: Colors.orange,
            seekBarThumbColor: Colors.orange,
            seekBarBufferColor: Colors.white.withValues(alpha: 0.3),
            buttonBarButtonColor: Colors.white,
            buttonBarButtonSize: 48,
            primaryButtonBar: [
              IconButton(
                icon: const Icon(Icons.replay_10, size: 48, color: Colors.white),
                onPressed: () {
                  final position = _player.state.position;
                  _player.seek(position - const Duration(seconds: 10));
                },
              ),
              const SizedBox(width: 45),
              const MaterialPlayOrPauseButton(),
              const SizedBox(width: 45),
              IconButton(
                icon: const Icon(Icons.forward_10, size: 48, color: Colors.white),
                onPressed: () {
                  final position = _player.state.position;
                  _player.seek(position + const Duration(seconds: 10));
                },
              ),
              const SizedBox(width: 45),
              IconButton(
                icon: const Icon(Icons.refresh, size: 48, color: Colors.white),
                onPressed: _reloadVideo,
              ),
            ],
          ),
          child: Video(
            controller: _videoController,
            controls: MaterialVideoControls,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isAutoNexting,
            builder: (context, isNexting, child) {
              if (!isNexting) return const SizedBox();

              return Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
                      alignment: Alignment.center,
                      child: ValueListenableBuilder<int>(
                        valueListenable: _countdown,
                        builder: (context, count, _) {
                          final isVi = EasyLocalization.of(context)?.locale.languageCode == 'vi';
                          final title = isVi ? "Tập tiếp theo sẽ phát sau..." : "Next episode starts in...";
                          final cancelLabel = isVi ? "Hủy" : "Cancel";
                          final playNowLabel = isVi ? "Phát ngay" : "Play Now";

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: CircularProgressIndicator(
                                      value: count / 3.0,
                                      strokeWidth: 6,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                                      backgroundColor: Colors.white12,
                                    ),
                                  ),
                                  Text(
                                    "$count",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: _cancelAutoNext,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white38, width: 1.5),
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      cancelLabel,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: _playNextEpisode,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.black,
                                      elevation: 4,
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      playNowLabel,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
