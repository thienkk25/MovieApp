import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/movie/data/models/movie_model.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/view_more_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/watch_movie_screen.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';

class InforMovieScreen extends ConsumerStatefulWidget {
  final String slugMovie;
  const InforMovieScreen({super.key, required this.slugMovie});

  @override
  ConsumerState<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends ConsumerState<InforMovieScreen> {
  final ScrollController scrollController = ScrollController();
  final Map<int, double> itemEpisodeOffsets = {};
  int currentPage = 0;
  final int pageMovie = 1;
  final int limitMovie = 12;
  final String sortType = "desc";
  final String country = "";
  final int year = 0;
  late Future<Map?> singleDetailMovies;
  late Future<Map?> episodeHistoryMovies;
  late Future<List> recommendedMovies;

  @override
  void initState() {
    loadData();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ref.read(isAutoNextMovie.notifier).state = false;
        ref.read(isCollapsedReadMore.notifier).state = true;
      },
    );
    super.initState();
  }

  void loadData() {
    Future.microtask(() {
      if (mounted) {
        ref.read(wasWatchEpisodeMovies.notifier).state = -1;
      }
    });
    singleDetailMovies =
        ref.read(getMovieDetailUseCaseProvider).call(widget.slugMovie);
    episodeHistoryMovies =
        ref.read(getHistoryWatchMovieUseCaseProvider).call(widget.slugMovie).then((data) {
      if (mounted) {
        if (data != null) {
          ref.read(wasWatchEpisodeMovies.notifier).state = data['episode'];
        } else {
          ref.read(wasWatchEpisodeMovies.notifier).state = -1;
        }
      }
      return data;
    });
    recommendedMovies = singleDetailMovies.then<List<dynamic>>((movie) {
      if (movie != null) {
        return ref.read(getRecommendedPartsUseCaseProvider).call(movie);
      }
      return <dynamic>[];
    }).catchError((_) => <dynamic>[]);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(isClickLWatchEpisodeLinkMovies);
    final double height = MediaQuery.of(context).size.width / (16 / 9);

    final dataFavorites = ref.watch(getFavoriteMoviesNotifierProvider);
    final isFavorite = dataFavorites.containsKey(widget.slugMovie);

    return FutureBuilder<Map?>(
      future: singleDetailMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: Color(0xFF0A0B10),
              body: Center(child: CircularProgressIndicator(color: Colors.orange)));
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0B10),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Icon(Icons.error, color: Colors.redAccent),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.redAccent, size: 40),
                  const SizedBox(height: 10),
                  const Text('errors.generic', style: TextStyle(color: Colors.white70)).tr(),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
              backgroundColor: const Color(0xFF0A0B10),
              body: Center(child: const Text('errors.notFound', style: TextStyle(color: Colors.white70)).tr()));
        }

        final Map dataInforMovie = snapshot.data!;
        final episodes = dataInforMovie['episodes'];
        final hasEpisodes = episodes != null && episodes.isNotEmpty;
        final serverData = hasEpisodes ? episodes[0]['server_data'] : null;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0B10),
          body: Stack(
            children: [
              // Immersive Blurred Poster Backdrop
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Opacity(
                  opacity: 0.2,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30, tileMode: TileMode.decal),
                    child: CachedNetworkImage(
                      imageUrl: dataInforMovie['movie']['poster_url'] ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                  ),
                ),
              ),
              // Linear Gradient overlay to blend backdrop to deep dark background
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xFF0A0B10),
                      ],
                      stops: [0.0, 0.45],
                    ),
                  ),
                ),
              ),
              // Foreground Scrollable Contents
              SafeArea(
                bottom: false,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: innerBoxIsScrolled ? const Color(0xFF0A0B10) : Colors.transparent,
                        pinned: true,
                        elevation: 0,
                        title: Text(
                          "${dataInforMovie['movie']['name']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        centerTitle: true,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                if (isFavorite) {
                                  removeFavoriteMovie(dataInforMovie['movie']['slug']);
                                } else {
                                  addFavoriteMovie(
                                    dataInforMovie['movie']['name'],
                                    dataInforMovie['movie']['slug'],
                                    dataInforMovie['movie']['poster_url'],
                                    dataInforMovie['movie']['lang'],
                                    dataInforMovie['movie']['episode_current'],
                                  );
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isFavorite
                                      ? Colors.orange.withValues(alpha: .2)
                                      : Colors.white.withValues(alpha: .1),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) => ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey<bool>(isFavorite),
                                    color: isFavorite ? Colors.orange : Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Player (when active) or Banner with Play Button
                        Consumer(
                          builder: (context, ref, child) {
                            final isWatchMode = ref.watch(isClickWatchEpisodeMovies);
                            if (isWatchMode) {
                              return Column(
                                spacing: 8,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: WatchMovieScreen(widget.slugMovie, dataInforMovie),
                                  ),
                                  // Prev/Next buttons
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final currentWatched = ref.read(wasWatchEpisodeMovies);
                                            if (currentWatched != -1 && currentWatched - 1 > 0) {
                                              int prevEpisodeIndex = currentWatched - 2;
                                              ref.read(wasWatchEpisodeMovies.notifier).state = prevEpisodeIndex + 1;
                                              if (serverData != null && prevEpisodeIndex < serverData.length) {
                                                ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                                    serverData[prevEpisodeIndex]['link_m3u8'];
                                                addHistoryWatchMovies(
                                                    dataInforMovie['movie']['name'],
                                                    widget.slugMovie,
                                                    dataInforMovie['movie']['poster_url'],
                                                    prevEpisodeIndex + 1);
                                              }
                                            } else {
                                              OverlayScreen().showOverlay(
                                                  context,
                                                  'player.alreadyFirstEpisode'.tr(),
                                                  Colors.blueGrey,
                                                  duration: 2);
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: .08),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.white.withValues(alpha: .1)),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
                                                const SizedBox(width: 4),
                                                Text('player.previousEpisode'.tr(), style: const TextStyle(color: Colors.white, fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'movie.episode'.plural(ref.watch(wasWatchEpisodeMovies)),
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            final currentWatched = ref.read(wasWatchEpisodeMovies);
                                            if (serverData != null && currentWatched != -1 && currentWatched < serverData.length) {
                                              ref.read(wasWatchEpisodeMovies.notifier).state = currentWatched + 1;
                                              ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                                  serverData[currentWatched]['link_m3u8'];
                                              addHistoryWatchMovies(
                                                  dataInforMovie['movie']['name'],
                                                  widget.slugMovie,
                                                  dataInforMovie['movie']['poster_url'],
                                                  currentWatched + 1);
                                            } else {
                                              OverlayScreen().showOverlay(
                                                  context,
                                                  'player.alreadyLatestEpisode'.tr(),
                                                  Colors.blueGrey,
                                                  duration: 2);
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: .08),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.white.withValues(alpha: .1)),
                                            ),
                                            child: Row(
                                              children: [
                                                Text('player.nextEpisode'.tr(), style: const TextStyle(color: Colors.white, fontSize: 13)),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Server / Auto-next configurations
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: .04),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white.withValues(alpha: .06)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('player.server', style: TextStyle(color: Colors.white70, fontSize: 13)).tr(),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  final currentEpisode = ref.read(wasWatchEpisodeMovies);
                                                  if (currentEpisode != -1 && serverData != null) {
                                                    ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                                        serverData[currentEpisode - 1]['link_m3u8'];
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    color: Colors.orange,
                                                  ),
                                                  child: const Text("M3u8", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // Display movie banner with Play Button
                              return AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: dataInforMovie['movie']['thumb_url'] ?? '',
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, progress) => const Center(
                                        child: CircularProgressIndicator(color: Colors.orange),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.grey),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: .3),
                                            const Color(0xFF0A0B10).withValues(alpha: .8),
                                            const Color(0xFF0A0B10),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: ClipOval(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              int episodeToPlay = ref.read(wasWatchEpisodeMovies);
                                              if (episodeToPlay == -1) episodeToPlay = 1;
                                              ref.read(wasWatchEpisodeMovies.notifier).state = episodeToPlay;

                                              if (serverData != null && episodeToPlay - 1 < serverData.length) {
                                                ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                                    serverData[episodeToPlay - 1]['link_m3u8'];
                                                ref.read(isClickWatchEpisodeMovies.notifier).state = true;
                                                addHistoryWatchMovies(
                                                    dataInforMovie['movie']['name'],
                                                    widget.slugMovie,
                                                    dataInforMovie['movie']['poster_url'],
                                                    episodeToPlay);
                                              }
                                            },
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.orange.withValues(alpha: .85),
                                                border: Border.all(color: Colors.white30, width: 1.5),
                                              ),
                                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        // Main info block inside a modern floating card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: .06), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: dataInforMovie['movie']['poster_url'] ?? '',
                                      width: 80,
                                      height: 115,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Container(
                                        width: 80,
                                        height: 115,
                                        color: Colors.grey[900],
                                        child: const Icon(Icons.movie, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dataInforMovie['movie']['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          dataInforMovie['movie']['origin_name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(alpha: .5),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: .08),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "${dataInforMovie['movie']['year'] ?? ''}",
                                                style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            if (dataInforMovie['movie']['quality'] != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueAccent.withValues(alpha: .15),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: Colors.blueAccent.withValues(alpha: .3)),
                                                ),
                                                child: Text(
                                                  dataInforMovie['movie']['quality'].toString().toUpperCase(),
                                                  style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            if (dataInforMovie['movie']['lang'] != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.orangeAccent.withValues(alpha: .15),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: .3)),
                                                ),
                                                child: Text(
                                                  dataInforMovie['movie']['lang'],
                                                  style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildMetaInfoItem(
                                    Icons.video_library_rounded,
                                    'movieDetail.totalEpisodes'.tr(),
                                    "${dataInforMovie['movie']['episode_total'] ?? ''}",
                                  ),
                                  _buildMetaInfoItem(
                                    Icons.info_outline_rounded,
                                    'movieDetail.status'.tr(),
                                    "${dataInforMovie['movie']['episode_current'] ?? ''}",
                                  ),
                                  _buildMetaInfoItem(
                                    Icons.access_time_rounded,
                                    'Time',
                                    "${dataInforMovie['movie']['time'] ?? ''}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 28,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: dataInforMovie['movie']['category'].length ?? 0,
                                  itemBuilder: (context, index) {
                                    final genre = dataInforMovie['movie']['category'][index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ViewMoreScreen(
                                                genre['slug'],
                                                pageMovie,
                                                limitMovie,
                                                sortType,
                                                country,
                                                year,
                                              ),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: .06),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.white.withValues(alpha: .08)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              genre['name'],
                                              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(height: 24, color: Colors.white12),
                              const Text(
                                'movieDetail.description',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ).tr(),
                              const SizedBox(height: 6),
                              Consumer(
                                builder: (context, ref, child) {
                                  final isCollapsed = ref.watch(isCollapsedReadMore);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataInforMovie['movie']['content'] ?? '',
                                        maxLines: isCollapsed ? 3 : null,
                                        overflow: isCollapsed ? TextOverflow.ellipsis : TextOverflow.visible,
                                        style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 13, height: 1.4),
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          ref.read(isCollapsedReadMore.notifier).state = !isCollapsed;
                                        },
                                        child: Text(
                                          isCollapsed ? 'movieDetail.seeMore'.tr() : 'movieDetail.seeLess'.tr(),
                                          style: const TextStyle(
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms),
                        // Primary play buttons (Watch from Start / Watch Latest)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(0, duration: Durations.long1, curve: Curves.linear);
                                    }
                                    ref.read(wasWatchEpisodeMovies.notifier).state = 1;
                                    if (serverData != null && serverData.isNotEmpty) {
                                      ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                          serverData[0]['link_m3u8'];
                                      ref.read(isClickWatchEpisodeMovies.notifier).state = true;
                                      addHistoryWatchMovies(
                                          dataInforMovie['movie']['name'],
                                          widget.slugMovie,
                                          dataInforMovie['movie']['poster_url'],
                                          1);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [Colors.blueAccent, Color(0xFF0052D4)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent.withValues(alpha: .3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'movieDetail.watchFromStart'.tr(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(0, duration: Durations.long1, curve: Curves.linear);
                                    }
                                    if (serverData != null && serverData.isNotEmpty) {
                                      final int size = serverData.length;
                                      ref.read(wasWatchEpisodeMovies.notifier).state = size;
                                      ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                          serverData[size - 1]['link_m3u8'];
                                      ref.read(isClickWatchEpisodeMovies.notifier).state = true;
                                      addHistoryWatchMovies(
                                          dataInforMovie['movie']['name'],
                                          widget.slugMovie,
                                          dataInforMovie['movie']['poster_url'],
                                          size);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [Colors.orangeAccent, Colors.deepOrange],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orangeAccent.withValues(alpha: .3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.movie_creation_rounded, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'movieDetail.watchLatest'.tr(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0, duration: 400.ms),
                        // History Watch Resume Banner
                        Consumer(
                          builder: (context, ref, child) {
                            final watchedEpisode = ref.watch(wasWatchEpisodeMovies);
                            if (watchedEpisode == -1) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: InkWell(
                                onTap: () {
                                  ref.read(isCollapsedReadMore.notifier).state = true;
                                  final episodeIndex = watchedEpisode - 1;
                                  final targetOffset = itemEpisodeOffsets[episodeIndex] ?? 0.0;
                                  if (scrollController.hasClients) {
                                    scrollController.animateTo(
                                      targetOffset,
                                      duration: Durations.long1,
                                      curve: Curves.linear,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: .1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange.withValues(alpha: .3), width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orange.withValues(alpha: .2),
                                        ),
                                        child: const Icon(Icons.history_rounded, color: Colors.orange, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Lịch sử xem gần đây",
                                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'historyScreen.watchedEpisode'.tr(args: [
                                                'movie.episode'.plural(watchedEpisode)
                                              ]),
                                              style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Cuộn tới tập".toUpperCase(),
                                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.orangeAccent, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1, end: 0, duration: 400.ms);
                          },
                        ),
                        // Episode Title & List
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.play_circle_outline, color: Colors.orangeAccent, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                'movieDetail.episodeList',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                              ).tr(),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            padding: EdgeInsets.zero, // REMOVE default GridView padding to fix spacing issue
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: serverData?.length ?? 0,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                mainAxisExtent: 40),
                            itemBuilder: (context, index) {
                              double itemHeight = 40 + 8;
                              int rowIndex = index ~/ 5;
                              double baseOffset = height + 480.0;
                              itemEpisodeOffsets[index] = rowIndex * itemHeight + baseOffset;

                              return Consumer(
                                builder: (context, ref, child) {
                                  final isCurrent = ref.watch(wasWatchEpisodeMovies) - 1 == index;
                                  return InkWell(
                                    onTap: () {
                                      if (scrollController.hasClients) {
                                        scrollController.animateTo(0, duration: Durations.long1, curve: Curves.linear);
                                      }
                                      ref.read(wasWatchEpisodeMovies.notifier).state = index + 1;
                                      if (serverData != null) {
                                        ref.read(isClickLWatchEpisodeLinkMovies.notifier).state =
                                            serverData[index]['link_m3u8'];
                                        ref.read(isClickWatchEpisodeMovies.notifier).state = true;
                                        addHistoryWatchMovies(
                                            dataInforMovie['movie']['name'],
                                            widget.slugMovie,
                                            dataInforMovie['movie']['poster_url'],
                                            index + 1);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: isCurrent
                                            ? const LinearGradient(
                                                colors: [Colors.orangeAccent, Colors.deepOrange],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : null,
                                        color: isCurrent ? null : Colors.white.withValues(alpha: .05),
                                        border: Border.all(
                                          color: isCurrent ? Colors.orangeAccent.withValues(alpha: .5) : Colors.white.withValues(alpha: .08),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          if (isCurrent)
                                            BoxShadow(
                                              color: Colors.orange.withValues(alpha: .3),
                                              offset: const Offset(0, 2),
                                              blurRadius: 6,
                                            ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: isCurrent ? Colors.white : Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.05, end: 0, duration: 400.ms),
                        const SizedBox(height: 16), // controlled spacing under the episode grid
                        // Related movies Title & Grid
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.dashboard_rounded, color: Colors.blueAccent, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'movieDetail.relatedMovies'.tr(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: FutureBuilder(
                            future: recommendedMovies,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: CircularProgressIndicator(color: Colors.orange),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                List rawMovies = snapshot.data!;
                                List dataMovies = rawMovies.take(12).toList();
                                double sizeWidth = MediaQuery.of(context).size.width;
                                int responsiveColumnCount = sizeWidth < 600
                                    ? 2
                                    : sizeWidth <= 800
                                        ? 3
                                        : sizeWidth <= 1200
                                            ? 4
                                            : 5;
                                return GridView.builder(
                                  padding: EdgeInsets.zero, // REMOVE default GridView padding to fix spacing issue
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dataMovies.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: responsiveColumnCount,
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return CardMovie(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => InforMovieScreen(
                                            slugMovie: dataMovies[index]['slug'],
                                          ),
                                        ),
                                      ),
                                      movie: MovieData.fromJson(dataMovies[index]),
                                      isLink: false,
                                    );
                                  },
                                );
                              } else {
                                return const Center(child: Icon(Icons.error, color: Colors.grey));
                              }
                            },
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 350.ms).slideY(begin: 0.05, end: 0, duration: 400.ms),
                        const SizedBox(height: 24), // spacing at the bottom of the whole scrollable
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetaInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white30, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: .4), fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> addFavoriteMovie(String name, String slug, String posterUrl,
      String lang, String episodeCurrent) async {
    final result = await ref.read(addFavoriteMovieUseCaseProvider).call(
        name, slug, posterUrl, lang, episodeCurrent);
    if (!mounted) return;
    if (result) {
      ref.read(getFavoriteMoviesNotifierProvider.notifier).addState(MovieData(
              name: name,
              slug: slug,
              posterUrl: posterUrl,
              lang: lang,
              episodeCurrent: episodeCurrent)
          .toJson());
      OverlayScreen().showOverlay(
          context, 'success.addFavorite'.tr(), Colors.orange,
          duration: 3);
    } else {
      OverlayScreen().showOverlay(
          context, 'errors.addFavorite'.tr(), Colors.red,
          duration: 3);
    }
  }

  Future<void> removeFavoriteMovie(String slug) async {
    final result = await ref.read(removeFavoriteMovieUseCaseProvider).call(slug);
    if (!mounted) return;
    if (result) {
      ref.read(getFavoriteMoviesNotifierProvider.notifier).removeState(slug);
      OverlayScreen().showOverlay(
          context, 'success.removeFavorite'.tr(), Colors.grey,
          duration: 3);
    } else {
      OverlayScreen().showOverlay(
          context, 'errors.removeFavorite'.tr(), Colors.red,
          duration: 3);
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
}
