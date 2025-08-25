import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/shimmer_loading.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/configs/my_cache_manager.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class HomeBarScreen extends ConsumerStatefulWidget {
  const HomeBarScreen({super.key});

  @override
  ConsumerState<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends ConsumerState<HomeBarScreen> {
  MovieController movieController = MovieController();
  int pageMovie = 1;
  int limitMovie = 20;
  final ScrollController scrollController = ScrollController();

  final List<String> sections = [
    "Trang chủ",
    "Phim mới cập nhật",
    "Phim Lẻ",
    "Phim Bộ",
    "Phim Hoạt Hình",
    "Chương trình truyền hình",
  ];

  final Map<String, GlobalKey> keys = {};

  @override
  void initState() {
    super.initState();
    for (var sec in sections) {
      keys[sec] = GlobalKey();
    }

    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
            builder: (context, ref, child) => Text(ref.watch(currentTitle))),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thể loại",
                key: keys["Trang chủ"],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: FutureBuilder(
                  future: movieController.categoryMovies(),
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
                              ),
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
                                colors: [Color(0xff30cfd0), Color(0xff330867)],
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
              const SizedBox(
                height: 10,
              ),
              Text(
                "Phim mới cập nhật",
                key: keys["Phim mới cập nhật"],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: movieController.newlyUpdatedMovies(),
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
                                      cacheManager: MyCacheManager(),
                                    ),
                                    Positioned(
                                        child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(5))),
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
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(50)),
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
                                        color:
                                            Colors.black.withValues(alpha: .3),
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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                key: keys["Phim Lẻ"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewMoreScreen(
                        "Phim Lẻ",
                        pageMovie,
                        limitMovie,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phim Lẻ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: movieController.singleMovies(pageMovie, limitMovie),
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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                key: keys["Phim Bộ"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewMoreScreen(
                        "Phim Bộ",
                        pageMovie,
                        limitMovie,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phim Bộ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: movieController.dramaMovies(pageMovie, limitMovie),
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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                key: keys["Phim Hoạt Hình"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewMoreScreen(
                        "Phim Hoạt Hình",
                        pageMovie,
                        limitMovie,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phim Hoạt Hình",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: movieController.cartoonMovies(pageMovie, limitMovie),
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
              const SizedBox(
                height: 10,
              ),
              InkWell(
                key: keys["Chương trình truyền hình"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewMoreScreen(
                        "Chương trình truyền hình",
                        pageMovie,
                        limitMovie,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chương trình truyền hình",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: movieController.tvShowsMovies(pageMovie, limitMovie),
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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataMovies['data']?['items'].length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 260,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 4.0),
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
                  cacheManager: MyCacheManager(),
                ),
                Positioned(
                    child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(5))),
                  child: Text(
                    dataMovies['data']['items'][index]['lang'],
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 260,
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
