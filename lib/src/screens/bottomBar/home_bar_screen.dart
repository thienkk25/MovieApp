import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/shimmer_loading.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/widgets/card_movie.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class HomeBarScreen extends ConsumerStatefulWidget {
  const HomeBarScreen({super.key});

  @override
  ConsumerState<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends ConsumerState<HomeBarScreen> {
  final MovieController movieController = MovieController();
  final PageController pageController = PageController(viewportFraction: .7);
  late Future<List> futureCategoryMovies;
  late Future<Map> futureNewlyUpdatedMovies;
  late Future<Map> futureSingleMovies;
  late Future<Map> futureDramaMovies;
  late Future<Map> futureCartoonMovies;
  late Future<Map> futureTvShowsMovies;
  late Future<Map> futureVietSubMovies;
  late Future<Map> futureNarratedMovies;
  late Future<Map> futureDubbedMovies;
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
    futureCategoryMovies = movieController.categoryMovies();
    futureNewlyUpdatedMovies = movieController.newlyUpdatedMoviesV3();
    futureSingleMovies = movieController.singleMovies(pageMovie, limitMovie);
    futureDramaMovies = movieController.dramaMovies(pageMovie, limitMovie);
    futureCartoonMovies = movieController.cartoonMovies(pageMovie, limitMovie);
    futureTvShowsMovies = movieController.tvShowsMovies(pageMovie, limitMovie);
    futureVietSubMovies = movieController.vietSubMovies(pageMovie, limitMovie);
    futureNarratedMovies =
        movieController.narratedMovies(pageMovie, limitMovie);
    futureDubbedMovies = movieController.dubbedMovies(pageMovie, limitMovie);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(currentTitle.notifier).state = 'app.home';
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
    timer!.cancel();
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
    setState(() {
      futureCategoryMovies = movieController.categoryMovies();
      futureNewlyUpdatedMovies = movieController.newlyUpdatedMoviesV3();
      futureSingleMovies = movieController.singleMovies(pageMovie, limitMovie);
      futureDramaMovies = movieController.dramaMovies(pageMovie, limitMovie);
      futureCartoonMovies =
          movieController.cartoonMovies(pageMovie, limitMovie);
      futureTvShowsMovies =
          movieController.tvShowsMovies(pageMovie, limitMovie);
      futureVietSubMovies =
          movieController.vietSubMovies(pageMovie, limitMovie);
      futureNarratedMovies =
          movieController.narratedMovies(pageMovie, limitMovie);
      futureDubbedMovies = movieController.dubbedMovies(pageMovie, limitMovie);
    });
    await Future.wait([
      futureCategoryMovies,
      futureNewlyUpdatedMovies,
      futureSingleMovies,
      futureDramaMovies,
      futureCartoonMovies,
      futureTvShowsMovies,
      futureVietSubMovies,
      futureNarratedMovies,
      futureDubbedMovies
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final hasPadingBottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      key: ValueKey(ref.watch(isLanguageProvider)),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
            ),
          ),
        ),
        title: Consumer(
          builder: (context, ref, _) => Text(
            ref.watch(currentTitle).tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
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
                  child: FutureBuilder(
                    future: futureNewlyUpdatedMovies,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      Map newlyUpdatedMovies = asyncSnapshot.data!;
                      final items = newlyUpdatedMovies['items'] ?? [];

                      return StatefulBuilder(
                        builder: (context, StateSetter stateSetter) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              if (items.isNotEmpty)
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
                                      Colors.black.withValues(alpha: .7),
                                      Colors.black.withValues(alpha: .9),
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
                                        value = pageController.page! - index;
                                      }
                                      double scale = (1 - (value.abs() * 0.3))
                                          .clamp(0.8, 1.0);
                                      double angle = value * (-0.25);
                                      return Center(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  1.8,
                                          height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  2 -
                                              40,
                                          child: Transform.scale(
                                            scale:
                                                Curves.easeOut.transform(scale),
                                            child: Transform.rotate(
                                              angle: angle,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: .3),
                                                      blurRadius: 12,
                                                      offset:
                                                          const Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CardMovie(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              InforMovieScreen(
                                                            slugMovie:
                                                                items[index]
                                                                    ['slug'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    movie: MovieData.fromJson(
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        key: keys['movie.single'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.single'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureSingleMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.drama'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.drama'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureDramaMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.cartoon'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.cartoon'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureCartoonMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.tvShows'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.tvShows'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureTvShowsMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.vietsub'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.vietsub'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureVietSubMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.narrated'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.narrated'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureNarratedMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        key: keys['movie.dubbed'],
                        onTap: () {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'movie.dubbed'.tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: futureDubbedMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridViewScreen(dataMovies: dataMovies);
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
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
