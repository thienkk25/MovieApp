import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/filter_sidebar_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/shimmer_loading.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class HomeBarScreen extends ConsumerStatefulWidget {
  const HomeBarScreen({super.key});

  @override
  ConsumerState<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends ConsumerState<HomeBarScreen> {
  final MovieController movieController = MovieController();
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

  final List<String> sections = [
    'app.title'.tr(),
    'movie.newlyUpdated'.tr(),
    'movie.single'.tr(),
    'movie.drama'.tr(),
    'movie.cartoon'.tr(),
    'movie.tvShows'.tr(),
    'movie.vietsub'.tr(),
    'movie.narrated'.tr(),
    'movie.dubbed'.tr(),
  ];

  final Map<String, GlobalKey> keys = {};

  @override
  void initState() {
    super.initState();
    futureCategoryMovies = movieController.categoryMovies();
    futureNewlyUpdatedMovies = movieController.newlyUpdatedMovies();
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
        ref.read(currentTitle.notifier).state = 'app.home'.tr();
      },
    );

    for (var sec in sections) {
      keys[sec] = GlobalKey();
    }
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
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
      futureNewlyUpdatedMovies = movieController.newlyUpdatedMovies();
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
    Future.wait([
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
    return Scaffold(
      key: ValueKey(ref.watch(isLanguageProvider)),
      appBar: AppBar(
        title: Consumer(
            builder: (context, ref, child) => Text(ref.watch(currentTitle))),
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Filter",
                    pageBuilder: (context, anim1, anim2) {
                      return FilterSidebarMovieScreen(
                        futureCategoryMovies: futureCategoryMovies,
                        pageMovie: pageMovie,
                        limitMovie: limitMovie,
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(anim1);
                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'movie.genre'.tr(),
                        key: keys['app.title'.tr()],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.filter_list_alt)
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: FutureBuilder(
                    future: futureCategoryMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        final categoryMovies = snapshot.data!;
                        return CarouselView(
                          onTap: (value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewMoreScreen(
                                    categoryMovies[value]['slug'],
                                    pageMovie,
                                    limitMovie,
                                    sortType,
                                    country,
                                    year),
                              ),
                            );
                          },
                          elevation: 2,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          itemExtent: MediaQuery.of(context).size.width / 3,
                          children: List.generate(
                            categoryMovies.length,
                            (index) => Container(
                              width: 60,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff30cfd0),
                                    Color(0xff330867)
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  categoryMovies[index]['name'],
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                    },
                  ),
                ),
                Text(
                  'movie.newlyUpdated'.tr(),
                  key: keys['movie.newlyUpdated'.tr()],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                    future: futureNewlyUpdatedMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        Map newlyUpdatedMovies = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: newlyUpdatedMovies['items']?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => InforMovieScreen(
                                              slugMovie:
                                                  newlyUpdatedMovies['items']
                                                      [index]['slug'])));
                                },
                                child: Container(
                                  width: 160,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff30cfd0),
                                          Color(0xff330867)
                                        ]),
                                  ),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: newlyUpdatedMovies['items']
                                            [index]['poster_url'],
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                        memCacheHeight: 400,
                                      ),
                                      Positioned(
                                          child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(5))),
                                        child: Text(
                                          newlyUpdatedMovies['items'][index]
                                                  ['year']
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                      Positioned(
                                          top: -5,
                                          right: 0,
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(50)),
                                            child: Image.asset(
                                              "assets/imgs/new-blinking.gif",
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: 260,
                                          padding: const EdgeInsets.all(10.0),
                                          color: Colors.black
                                              .withValues(alpha: .3),
                                          child: Text(
                                            newlyUpdatedMovies['items'][index]
                                                ['name'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                    },
                  ),
                ),
                InkWell(
                  key: keys['movie.single'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Lẻ", pageMovie,
                            limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureSingleMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.drama'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Bộ", pageMovie,
                            limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureDramaMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.cartoon'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Hoạt Hình",
                            pageMovie, limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureCartoonMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.tvShows'.tr()],
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureTvShowsMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.vietsub'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Vietsub",
                            pageMovie, limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureVietSubMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.narrated'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Thuyết Minh",
                            pageMovie, limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureNarratedMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                InkWell(
                  key: keys['movie.dubbed'.tr()],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewMoreScreen("Phim Lồng Tiếng",
                            pageMovie, limitMovie, sortType, country, year),
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
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                FutureBuilder(
                  future: futureDubbedMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
      itemCount: dataMovies['data']?['items'].length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveColumnCount,
        mainAxisExtent: 260,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => InforMovieScreen(
                        slugMovie: dataMovies['data']['items'][index]['slug'],
                      ))),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff30cfd0), Color(0xff330867)])),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://phimimg.com/${dataMovies['data']['items'][index]['poster_url']}",
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  memCacheHeight: 400,
                ),
                Positioned(
                    child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      )),
                  child: Text(
                    dataMovies['data']['items'][index]['lang'],
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                Positioned(
                    top: 35,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .4),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          )),
                      child: Text(
                        dataMovies['data']['items'][index]['episode_current'],
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.black.withValues(alpha: .4),
                    child: Text(
                      dataMovies['data']['items'][index]['name'],
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
