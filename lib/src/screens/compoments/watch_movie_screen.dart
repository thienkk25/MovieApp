import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
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
  final MovieController movieController = MovieController();
  String? _currentVideoUrl;
  final ValueNotifier<bool> _isAutoNexting = ValueNotifier(false);
  final ValueNotifier<int> _countdown = ValueNotifier<int>(3);
  @override
  void initState() {
    _player = Player(
        configuration: const PlayerConfiguration(bufferSize: 64 * 1024 * 1024));
    _videoController = VideoController(_player);

    _player.stream.playing.listen((event) {
      if (event) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    });

    _player.stream.duration.listen(
      (event) {
        totalDurationVideo = event;
      },
    );
    _player.stream.completed.listen((_) async {
      if (!mounted || _isAutoNexting.value) return;

      if (ref.read(isAutoNextMovie) && totalDurationVideo > Duration.zero) {
        _isAutoNexting.value = true;
        _countdown.value = 3;

        Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (_countdown.value > 1) {
            _countdown.value -= 1;
          } else {
            timer.cancel();

            final int size =
                widget.dataInforMovie['episodes'][0]['server_data'].length;
            if (ref.read(wasWatchEpisodeMovies) != -1 &&
                ref.read(wasWatchEpisodeMovies) < size) {
              int episode = ref.read(wasWatchEpisodeMovies);
              ref.read(wasWatchEpisodeMovies.notifier).state = episode + 1;
              ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                  widget.dataInforMovie['episodes'][0]['server_data'][episode]
                      ['link_m3u8'];
              movieController.addHistoryWatchMovies(
                  widget.dataInforMovie['movie']['name'],
                  widget.slugMovie,
                  widget.dataInforMovie['movie']['poster_url'],
                  episode + 1);
              addHistoryWatchMovies(
                  widget.dataInforMovie['movie']['name'],
                  widget.slugMovie,
                  widget.dataInforMovie['movie']['poster_url'],
                  episode + 1);

              await Future.delayed(const Duration(milliseconds: 500));
            } else {
              OverlayScreen().showOverlay(
                context,
                'player.alreadyLatestEpisode'.tr(),
                Colors.blueGrey,
                duration: 2,
              );
            }

            _isAutoNexting.value = false;
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    _isAutoNexting.dispose();
    _countdown.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> addHistoryWatchMovies(
      String name, String slug, String posterUrl, int episode) async {
    await movieController.addHistoryWatchMovies(name, slug, posterUrl, episode);
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _player.open(Media(videoUrl), play: true);
      });
    }
    return Stack(
      children: [
        Video(controller: _videoController),
        Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isAutoNexting,
            builder: (context, isNexting, child) {
              if (!isNexting) return const SizedBox();

              return IgnorePointer(
                ignoring: true,
                child: Container(
                  color: Colors.black45,
                  alignment: Alignment.center,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _countdown,
                    builder: (context, count, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Next...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$count",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
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
