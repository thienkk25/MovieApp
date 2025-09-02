import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/controllers/series_recommendation_controller.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/compoments/watch_movie_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:readmore/readmore.dart';

class InforMovieScreen extends ConsumerStatefulWidget {
  final String slugMovie;
  const InforMovieScreen({super.key, required this.slugMovie});

  @override
  ConsumerState<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends ConsumerState<InforMovieScreen> {
  final MovieController movieController = MovieController();
  final ScrollController scrollController = ScrollController();
  bool isIconFavorite = false;
  int currentPage = 0;
  final int pageMovie = 1;
  final int limitMovie = 12;
  final String sortType = "desc";
  final String country = "";
  final int year = 0;
  bool isServer = true;
  late Future<Map?> singleDetailMovies;
  late Future<Map?> episodeHistoryMovies;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    singleDetailMovies =
        movieController.singleDetailMovies(widget.slugMovie, ref);
    episodeHistoryMovies =
        movieController.getHistoryWatchMovies(widget.slugMovie).then((data) {
      if (data != null) {
        ref.read(wasWatchEpisodeMovies.notifier).state = data['episode'];
      } else {
        ref.read(wasWatchEpisodeMovies.notifier).state = -1;
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map dataFavorites = ref.read(getFavoriteMoviesNotifierProvider);
    return FutureBuilder<Map?>(
      future: singleDetailMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Icon(Icons.error),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error),
                  const Text('errors.generic').tr(),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
              body: Center(child: const Text('errors.notFound').tr()));
        }

        Map? dataInforMovie = snapshot.data;
        if (dataFavorites.containsKey(widget.slugMovie)) {
          isIconFavorite = true;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "${dataInforMovie?['movie']['name']} (${dataInforMovie?['movie']['origin_name']})",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              StatefulBuilder(
                builder: (context, StateSetter stateSetter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: isIconFavorite
                        ? GestureDetector(
                            onTap: () {
                              removeFavoriteMovie(
                                  dataInforMovie?['movie']['slug']);
                              stateSetter(() {
                                isIconFavorite = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.orange,
                            ))
                        : GestureDetector(
                            onTap: () {
                              addFavoriteMovie(
                                  dataInforMovie?['movie']['name'],
                                  dataInforMovie?['movie']['slug'],
                                  dataInforMovie?['movie']['poster_url']);
                              stateSetter(() {
                                isIconFavorite = true;
                              });
                            },
                            child: const Icon(Icons.favorite_border)),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, child) => ref
                          .watch(isClickWatchEpisodeMovies)
                      ? Column(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                                height: 200, child: WatchMovieScreen()),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (ref.read(wasWatchEpisodeMovies) !=
                                              -1 &&
                                          ref.read(wasWatchEpisodeMovies) - 1 >
                                              0) {
                                        int episode =
                                            ref.read(wasWatchEpisodeMovies) - 2;
                                        ref
                                            .read(
                                                wasWatchEpisodeMovies.notifier)
                                            .state = episode + 1;
                                        ref
                                                .read(
                                                    isClickLWatchEpisodeLinkMovies
                                                        .notifier)
                                                .state =
                                            isServer
                                                ? dataInforMovie!['episodes'][0]
                                                        ['server_data'][episode]
                                                    ['link_m3u8']
                                                : dataInforMovie!['episodes'][0]
                                                        ['server_data'][episode]
                                                    ['link_embed'];

                                        movieController.addHistoryWatchMovies(
                                            dataInforMovie['movie']['name'],
                                            widget.slugMovie,
                                            dataInforMovie['movie']
                                                ['poster_url'],
                                            episode + 1);
                                        addHistoryWatchMovies(
                                            dataInforMovie['movie']['name'],
                                            widget.slugMovie,
                                            dataInforMovie['movie']
                                                ['poster_url'],
                                            episode + 1);
                                      } else {
                                        OverlayScreen().showOverlay(
                                            context,
                                            'player.alreadyFirstEpisode'.tr(),
                                            Colors.blueGrey,
                                            duration: 2);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.arrow_back_ios,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'player.previousEpisode'.tr(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'movie.episode'.plural(
                                        ref.watch(wasWatchEpisodeMovies)),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final int size =
                                          dataInforMovie!['episodes'][0]
                                                  ['server_data']
                                              .length;
                                      if (ref.read(wasWatchEpisodeMovies) !=
                                              -1 &&
                                          ref.read(wasWatchEpisodeMovies) <
                                              size) {
                                        int episode =
                                            ref.read(wasWatchEpisodeMovies)!;
                                        ref
                                            .read(
                                                wasWatchEpisodeMovies.notifier)
                                            .state = episode + 1;
                                        ref
                                                .read(
                                                    isClickLWatchEpisodeLinkMovies
                                                        .notifier)
                                                .state =
                                            isServer
                                                ? dataInforMovie['episodes'][0]
                                                        ['server_data'][episode]
                                                    ['link_m3u8']
                                                : dataInforMovie['episodes'][0]
                                                        ['server_data'][episode]
                                                    ['link_embed'];
                                        movieController.addHistoryWatchMovies(
                                            dataInforMovie['movie']['name'],
                                            widget.slugMovie,
                                            dataInforMovie['movie']
                                                ['poster_url'],
                                            episode + 1);
                                        addHistoryWatchMovies(
                                            dataInforMovie['movie']['name'],
                                            widget.slugMovie,
                                            dataInforMovie['movie']
                                                ['poster_url'],
                                            episode + 1);
                                      } else {
                                        OverlayScreen().showOverlay(
                                            context,
                                            'player.alreadyLatestEpisode'.tr(),
                                            Colors.blueGrey,
                                            duration: 2);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'player.nextEpisode'.tr(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              height: 40,
                              child: StatefulBuilder(
                                builder: (context, StateSetter stateSetter) {
                                  return Row(
                                    spacing: 5,
                                    children: [
                                      const Text('player.server').tr(),
                                      GestureDetector(
                                        onTap: () {
                                          stateSetter(() {
                                            isServer = true;
                                          });
                                          if (ref.read(wasWatchEpisodeMovies) !=
                                              -1) {
                                            ref.read(isClickLWatchEpisodeLinkMovies.notifier).state = isServer
                                                ? dataInforMovie!['episodes'][0]
                                                    ['server_data'][ref.read(
                                                        wasWatchEpisodeMovies) -
                                                    1]['link_m3u8']
                                                : dataInforMovie!['episodes'][0]
                                                        ['server_data'][
                                                    ref.read(wasWatchEpisodeMovies) -
                                                        1]['link_embed'];
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadiusDirectional
                                                    .all(Radius.circular(5)),
                                            color: isServer
                                                ? Colors.orange
                                                : Colors.grey[400],
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "M3u8",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          stateSetter(() {
                                            isServer = false;
                                          });
                                          if (ref.read(wasWatchEpisodeMovies) !=
                                              -1) {
                                            ref.read(isClickLWatchEpisodeLinkMovies.notifier).state = isServer
                                                ? dataInforMovie!['episodes'][0]
                                                    ['server_data'][ref.read(
                                                        wasWatchEpisodeMovies) -
                                                    1]['link_m3u8']
                                                : dataInforMovie!['episodes'][0]
                                                        ['server_data'][
                                                    ref.read(wasWatchEpisodeMovies) -
                                                        1]['link_embed'];
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadiusDirectional
                                                    .all(Radius.circular(5)),
                                            color: isServer
                                                ? Colors.grey[400]
                                                : Colors.orange,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Embed",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              PageView.builder(
                                physics: const BouncingScrollPhysics(),
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPage = value;
                                  });
                                },
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onDoubleTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GestureDetector(
                                            onDoubleTap: () =>
                                                Navigator.pop(context),
                                            child: InteractiveViewer(
                                              child: Hero(
                                                tag: dataInforMovie?['movie']
                                                    ['_id'],
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      dataInforMovie?['movie']
                                                          ['thumb_url'],
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.contain,
                                                  memCacheWidth: 800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(5),
                                      child: Hero(
                                        tag: dataInforMovie?['movie']['_id'],
                                        child: CachedNetworkImage(
                                          imageUrl: dataInforMovie?['movie']
                                              ['thumb_url'],
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          memCacheWidth: 800,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...List.generate(
                                      1,
                                      (index) => Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CircleAvatar(
                                          backgroundColor: currentPage == index
                                              ? Colors.white
                                              : Colors.grey[500],
                                          radius: 4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${'movieDetail.title.main'.tr()} ${dataInforMovie?['movie']['name']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${'movieDetail.title.original'.tr()} ${dataInforMovie?['movie']['origin_name']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${'movieDetail.totalEpisodes'.tr()} ${dataInforMovie?['movie']['episode_total']}"),
                          Text(dataInforMovie?['movie']['time']),
                        ],
                      ),
                      Text(
                          "${'movieDetail.status'.tr()} ${dataInforMovie?['movie']['episode_current']}"),
                      SizedBox(
                        height: 30,
                        child: Row(
                          spacing: 5,
                          children: [
                            const Text('movieDetail.genre').tr(),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    dataInforMovie?['movie']['category'].length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewMoreScreen(
                                              dataInforMovie?['movie']
                                                  ['category'][index]['slug'],
                                              pageMovie,
                                              limitMovie,
                                              sortType,
                                              country,
                                              year),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.all(
                                                Radius.circular(5)),
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
                                          dataInforMovie?['movie']['category']
                                              [index]['name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${'movieDetail.quality'.tr()} ${dataInforMovie?['movie']['quality']}"),
                          Text(dataInforMovie?['movie']['lang']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('movieDetail.release').tr(),
                          Text(
                              "${dataInforMovie?['movie']['country'][0]['name']} / ${dataInforMovie?['movie']['year']}"),
                        ],
                      ),
                      const Text('movieDetail.description').tr(),
                      ReadMoreText(
                        dataInforMovie?['movie']['content'],
                        style: const TextStyle(color: Colors.grey),
                        trimMode: TrimMode.Line,
                        trimLines: 3,
                        colorClickableText: Colors.black,
                        trimCollapsedText: 'movieDetail.seeMore'.tr(),
                        trimExpandedText: 'movieDetail.seeLess'.tr(),
                        moreStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold),
                        lessStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                scrollController.position.animateTo(0,
                                    duration: Durations.long1,
                                    curve: Curves.linear);
                                ref.read(wasWatchEpisodeMovies.notifier).state =
                                    1;
                                ref
                                    .read(isClickWatchEpisodeMovies.notifier)
                                    .state = true;

                                ref
                                        .read(isClickLWatchEpisodeLinkMovies
                                            .notifier)
                                        .state =
                                    isServer
                                        ? dataInforMovie!['episodes'][0]
                                            ['server_data'][0]['link_m3u8']
                                        : dataInforMovie!['episodes'][0]
                                            ['server_data'][0]['link_embed'];

                                movieController.addHistoryWatchMovies(
                                    dataInforMovie['movie']['name'],
                                    widget.slugMovie,
                                    dataInforMovie['movie']['poster_url'],
                                    1);
                                addHistoryWatchMovies(
                                    dataInforMovie['movie']['name'],
                                    widget.slugMovie,
                                    dataInforMovie['movie']['poster_url'],
                                    1);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'movieDetail.watchFromStart'.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                scrollController.position.animateTo(0,
                                    duration: Durations.long1,
                                    curve: Curves.linear);
                                final int size = dataInforMovie!['episodes'][0]
                                        ['server_data']
                                    .length;
                                ref.read(wasWatchEpisodeMovies.notifier).state =
                                    size;
                                ref
                                    .read(isClickWatchEpisodeMovies.notifier)
                                    .state = true;

                                ref
                                        .read(isClickLWatchEpisodeLinkMovies
                                            .notifier)
                                        .state =
                                    isServer
                                        ? dataInforMovie['episodes'][0]
                                                ['server_data'][size - 1]
                                            ['link_m3u8']
                                        : dataInforMovie['episodes'][0]
                                                ['server_data'][size - 1]
                                            ['link_embed'];
                                movieController.addHistoryWatchMovies(
                                    dataInforMovie['movie']['name'],
                                    widget.slugMovie,
                                    dataInforMovie['movie']['poster_url'],
                                    size);
                                addHistoryWatchMovies(
                                    dataInforMovie['movie']['name'],
                                    widget.slugMovie,
                                    dataInforMovie['movie']['poster_url'],
                                    size);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'movieDetail.watchLatest'.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<Map?>(
                          future: episodeHistoryMovies,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const SizedBox();
                            }
                            return Consumer(
                              builder: (context, ref, child) => Text(
                                  'historyScreen.watchedEpisode'.tr(args: [
                                'movie.episode'
                                    .plural(ref.watch(wasWatchEpisodeMovies))
                              ])),
                            );
                          }),
                      const Text('movieDetail.episodeList').tr(),
                      Consumer(
                        builder: (context, ref, child) => GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataInforMovie?['episodes'][0]
                                      ['server_data']
                                  .length ??
                              0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 40),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              scrollController.position.animateTo(0,
                                  duration: Durations.long1,
                                  curve: Curves.linear);
                              ref.read(wasWatchEpisodeMovies.notifier).state =
                                  index + 1;
                              ref
                                  .read(isClickWatchEpisodeMovies.notifier)
                                  .state = true;

                              ref
                                      .read(isClickLWatchEpisodeLinkMovies.notifier)
                                      .state =
                                  isServer
                                      ? dataInforMovie!['episodes'][0]
                                          ['server_data'][index]['link_m3u8']
                                      : dataInforMovie!['episodes'][0]
                                          ['server_data'][index]['link_embed'];
                              movieController.addHistoryWatchMovies(
                                  dataInforMovie['movie']['name'],
                                  widget.slugMovie,
                                  dataInforMovie['movie']['poster_url'],
                                  index + 1);
                              addHistoryWatchMovies(
                                  dataInforMovie['movie']['name'],
                                  widget.slugMovie,
                                  dataInforMovie['movie']['poster_url'],
                                  index + 1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadiusDirectional.all(
                                    Radius.circular(5)),
                                color: ref.watch(wasWatchEpisodeMovies) - 1 ==
                                        index
                                    ? Colors.orange
                                    : Colors.grey[400],
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'movieDetail.relatedMovies'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        future: SeriesRecommendationController()
                            .getRecommendedParts(dataInforMovie!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            List dataMovies = snapshot.data!;

                            double sizeWidth =
                                MediaQuery.of(context).size.width;

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
                              itemCount: dataMovies.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: responsiveColumnCount,
                                mainAxisExtent: 250,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InforMovieScreen(
                                        slugMovie: dataMovies[index]['slug'],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xff30cfd0),
                                              Color(0xff330867)
                                            ])),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://phimimg.com/${dataMovies[index]['poster_url']}",
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
                                                bottomRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              )),
                                          child: Text(
                                            dataMovies[index]['lang'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                        Positioned(
                                            top: 35,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(alpha: .4),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  )),
                                              child: Text(
                                                dataMovies[index]
                                                    ['episode_current'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            width: 300,
                                            padding: const EdgeInsets.all(10.0),
                                            color: Colors.black
                                                .withValues(alpha: .4),
                                            child: Text(
                                              dataMovies[index]['name'],
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
                    ].animate(interval: 50.ms).scale(duration: 200.ms),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addFavoriteMovie(
      String name, String slug, String posterUrl) async {
    final result =
        await movieController.addFavoriteMovies(name, slug, posterUrl);
    if (!mounted) return;
    if (result) {
      ref
          .read(getFavoriteMoviesNotifierProvider.notifier)
          .addState({"name": name, "slug": slug, "poster_url": posterUrl});
      OverlayScreen().showOverlay(
          context, 'success.addFavorite'.tr(), Colors.orange,
          duration: 3);
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.generic'.tr(), Colors.red, duration: 3);
    }
  }

  Future<void> removeFavoriteMovie(String slug) async {
    final result = await movieController.removeFavoriteMovie(slug);
    if (!mounted) return;
    if (result) {
      ref.read(getFavoriteMoviesNotifierProvider.notifier).removeState(slug);
      OverlayScreen().showOverlay(
          context, 'errors.addFavorite'.tr(), Colors.grey,
          duration: 3);
    } else {
      OverlayScreen()
          .showOverlay(context, 'errors.generic'.tr(), Colors.red, duration: 3);
    }
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
}
