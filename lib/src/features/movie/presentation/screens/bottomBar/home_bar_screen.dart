import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/movie/data/models/movie_model.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/core/widgets/shimmer_loading.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/view_more_screen.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';
import 'package:movie_app/src/core/providers/core_providers.dart';

class HomeBarScreen extends ConsumerStatefulWidget {
  const HomeBarScreen({super.key});

  @override
  ConsumerState<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends ConsumerState<HomeBarScreen> {
  final PageController pageController = PageController(viewportFraction: .7);
  final int pageMovie = 1;
  final int limitMovie = 12;
  final String sortType = "desc";
  final String country = "";
  final int year = 0;
  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  Timer? timer;

  List<String> sections = [
    'app.home',
    'movie.single',
    'movie.drama',
    'movie.cartoon',
    'movie.tvShows',
    'movie.vietsub',
    'movie.narrated',
    'movie.dubbed',
  ];

  final Map<String, GlobalKey> keys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ref.read(currentTitle.notifier).state = 'app.home';
        final data = await ref.read(getHistoryMoviesUseCaseProvider).call();
        ref.read(historyMoviesNotifierProvider.notifier).initState(data);
      },
    );

    for (var sec in sections) {
      keys[sec] = GlobalKey();
    }
    scrollController.addListener(onScroll);
    timer = Timer.periodic(
      const Duration(seconds: 15),
      (timer) {
        if (pageController.hasClients) {
          int nextPage = pageController.page!.round() + 1;
          if (nextPage >= 10) {
            nextPage = 0;
          }
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void onScroll() {
    String? activeSec;
    double minOffset = double.infinity;

    for (var sec in sections) {
      final ctx = keys[sec]?.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);

        final offset = (pos.dy - kToolbarHeight).abs();

        if (pos.dy < MediaQuery.of(ctx).size.height && offset < minOffset) {
          minOffset = offset;
          activeSec = sec;
        }
      }
    }

    if (activeSec != null && ref.read(currentTitle) != activeSec) {
      ref.read(currentTitle.notifier).state = activeSec;
    }
  }

  Future<void> refresh() async {
    ref.invalidate(categoryMoviesProvider);
    ref.invalidate(newlyUpdatedMoviesProvider);
    ref.invalidate(singleMoviesProvider);
    ref.invalidate(dramaMoviesProvider);
    ref.invalidate(cartoonMoviesProvider);
    ref.invalidate(tvShowsMoviesProvider);
    ref.invalidate(vietSubMoviesProvider);
    ref.invalidate(narratedMoviesProvider);
    ref.invalidate(dubbedMoviesProvider);

    final data = await ref.read(getHistoryMoviesUseCaseProvider).call();
    ref.read(historyMoviesNotifierProvider.notifier).initState(data);
    try {
      await ref.read(newlyUpdatedMoviesProvider.future);
    } catch (_) {}
  }

  Widget _buildSectionHeader(String titleKey, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titleKey.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "movie.genre".tr(), // Localized or general view all
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatching() {
    final historyMap = ref.watch(historyMoviesNotifierProvider);
    final historyList = historyMap.values.toList();
    if (historyList.isEmpty) return const SizedBox();

    const titleColor = Colors.white;
    final cardBg = Colors.white.withValues(alpha: .04);
    final borderColor = Colors.white.withValues(alpha: .08);
    const textColor = Colors.white;
    const iconColor = Colors.white30;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'historyScreen.title'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: historyList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final movie = historyList[index];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InforMovieScreen(slugMovie: movie['slug']),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 75,
                          height: 110,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: movie['poster_url'],
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: iconColor),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.orangeAccent,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  movie['name'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: .2),
                                    border: Border.all(
                                      color: Colors.orangeAccent
                                          .withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'historyScreen.watchedEpisode'.tr(args: [
                                      'movie.episode'.plural(movie['episode'])
                                    ]),
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPadingBottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      key: ValueKey(ref.watch(isLanguageProvider)),
      backgroundColor: const Color(0xFF090A0F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF090A0F),
                Color(0xFF10121D),
              ],
            ),
          ),
        ),
        title: Consumer(
          builder: (context, ref, _) => Text(
            ref.watch(currentTitle).tr(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: hasPadingBottom + 10),
            child: Column(
              spacing: 10,
              children: [
                SizedBox(
                  key: keys['app.home'],
                  height: MediaQuery.sizeOf(context).height / 1.7,
                  child: ref.watch(newlyUpdatedMoviesProvider).when(
                        data: (newlyUpdatedMovies) {
                          final items = newlyUpdatedMovies['items'] ?? [];
                          if (items.isEmpty) return const SizedBox();

                          return StatefulBuilder(
                            builder: (context, StateSetter stateSetter) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: items[currentPage]['poster_url'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: .5),
                                          const Color(0xFF090A0F),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PageView.builder(
                                    controller: pageController,
                                    itemCount: items.length,
                                    onPageChanged: (page) =>
                                        stateSetter(() => currentPage = page),
                                    itemBuilder: (context, index) {
                                      return AnimatedBuilder(
                                        animation: pageController,
                                        builder: (context, child) {
                                          double value = 0;
                                          if (pageController
                                              .position.haveDimensions) {
                                            value =
                                                pageController.page! - index;
                                          }
                                          double scale =
                                              (1 - (value.abs() * 0.3))
                                                  .clamp(0.8, 1.0);
                                          double angle = value * (-0.25);
                                          return Center(
                                            child: SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  1.8,
                                              height: MediaQuery.sizeOf(context)
                                                          .height /
                                                      2 -
                                                  40,
                                              child: Transform.scale(
                                                scale: Curves.easeOut
                                                    .transform(scale),
                                                child: Transform.rotate(
                                                  angle: angle,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: .4),
                                                          blurRadius: 16,
                                                          offset: const Offset(
                                                              0, 8),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: CardMovie(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  InforMovieScreen(
                                                                slugMovie:
                                                                    items[index]
                                                                        [
                                                                        'slug'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        movie:
                                                            MovieData.fromJson(
                                                                items[index]),
                                                        isLink: true,
                                                        isNewMovie: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => const Center(
                            child: Icon(Icons.error, color: Colors.white30)),
                      ),
                ),
                _buildContinueWatching(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    spacing: 10,
                    children: [
                      _buildSectionHeader(
                        'movie.single',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Lẻ",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(singleMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.drama',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Bộ",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(dramaMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.cartoon',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Hoạt Hình",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(cartoonMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.tvShows',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Chương trình truyền hình",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(tvShowsMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.vietsub',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Vietsub",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(vietSubMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.narrated',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Thuyết Minh",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(narratedMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                      _buildSectionHeader(
                        'movie.dubbed',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                  "Phim Lồng Tiếng",
                                  pageMovie,
                                  limitMovie,
                                  sortType,
                                  country,
                                  year),
                            ),
                          );
                        },
                      ),
                      ref.watch(dubbedMoviesProvider).when(
                            data: (dataMovies) =>
                                GridViewScreen(dataMovies: dataMovies),
                            loading: () => const ShimmerLoading(),
                            error: (err, stack) => const Center(
                                child:
                                    Icon(Icons.error, color: Colors.white30)),
                          ),
                    ].animate(interval: 200.ms).fadeIn(duration: 500.ms),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({
    super.key,
    required this.dataMovies,
  });

  final Map dataMovies;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;

    int responsiveColumnCount;

    if (sizeWidth < 600) {
      responsiveColumnCount = 2;
    } else if (sizeWidth <= 800) {
      responsiveColumnCount = 3;
    } else if (sizeWidth <= 1200) {
      responsiveColumnCount = 4;
    } else {
      responsiveColumnCount = 5;
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: dataMovies['data']?['items'].length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveColumnCount,
        mainAxisExtent: 260,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return CardMovie(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InforMovieScreen(
                  slugMovie: dataMovies['data']['items'][index]['slug'],
                ),
              ),
            ),
          },
          movie: MovieData.fromJson(dataMovies['data']['items'][index]),
          isLink: false,
        );
      },
    );
  }
}
