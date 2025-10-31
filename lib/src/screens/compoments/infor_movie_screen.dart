import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/controllers/series_recommendation_controller.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/compoments/watch_movie_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/screens/widgets/card_movie.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InforMovieScreen extends ConsumerStatefulWidget {
  final String slugMovie;
  const InforMovieScreen({super.key, required this.slugMovie});

  @override
  ConsumerState<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends ConsumerState<InforMovieScreen> {
  final MovieController movieController = MovieController();
  final ScrollController scrollController = ScrollController();
  final Map<int, double> itemEpisodeOffsets = {};
  bool isIconFavorite = false;
  int currentPage = 0;
  final int pageMovie = 1;
  final int limitMovie = 12;
  final String sortType = "desc";
  final String country = "";
  final int year = 0;
  late Future<Map?> singleDetailMovies;
  late Future<Map?> episodeHistoryMovies;
  late SharedPreferences pref;

  @override
  void initState() {
    loadData();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        pref = await SharedPreferences.getInstance();
        ref.read(isAutoNextMovie.notifier).state =
            pref.getBool("isAutoNextMovie") ?? false;
        ref.read(isCollapsedReadMore.notifier).state = true;
      },
    );
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.width / (16 / 9);

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
                    child: GestureDetector(
                      onTap: () {
                        if (isIconFavorite) {
                          removeFavoriteMovie(dataInforMovie?['movie']['slug']);
                        } else {
                          addFavoriteMovie(
                            dataInforMovie?['movie']['name'],
                            dataInforMovie?['movie']['slug'],
                            dataInforMovie?['movie']['poster_url'],
                            dataInforMovie?['movie']['lang'],
                            dataInforMovie?['movie']['episode_current'],
                          );
                        }
                        stateSetter(() {
                          isIconFavorite = !isIconFavorite;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isIconFavorite
                              ? Colors.orange.withValues(alpha: .2)
                              : Colors.grey.withValues(alpha: .1),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Icon(
                            isIconFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey<bool>(isIconFavorite),
                            color: isIconFavorite ? Colors.orange : Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
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
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: WatchMovieScreen(
                                  widget.slugMovie, dataInforMovie!),
                            ),
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
                                            .read(isClickLWatchEpisodeLinkMovies
                                                .notifier)
                                            .state = dataInforMovie['episodes']
                                                [0]['server_data'][episode]
                                            ['link_m3u8'];

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
                                          dataInforMovie['episodes'][0]
                                                  ['server_data']
                                              .length;
                                      if (ref.read(wasWatchEpisodeMovies) !=
                                              -1 &&
                                          ref.read(wasWatchEpisodeMovies) <
                                              size) {
                                        int episode =
                                            ref.read(wasWatchEpisodeMovies);
                                        ref
                                            .read(
                                                wasWatchEpisodeMovies.notifier)
                                            .state = episode + 1;
                                        ref
                                            .read(isClickLWatchEpisodeLinkMovies
                                                .notifier)
                                            .state = dataInforMovie['episodes']
                                                [0]['server_data'][episode]
                                            ['link_m3u8'];
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
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('player.server').tr(),
                                          GestureDetector(
                                            onTap: () {
                                              if (ref.read(
                                                      wasWatchEpisodeMovies) !=
                                                  -1) {
                                                ref
                                                    .read(
                                                        isClickLWatchEpisodeLinkMovies
                                                            .notifier)
                                                    .state = dataInforMovie[
                                                        'episodes'][0]
                                                    ['server_data'][ref.read(
                                                        wasWatchEpisodeMovies) -
                                                    1]['link_m3u8'];
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusDirectional.all(
                                                        Radius.circular(5)),
                                                color: Colors.orange,
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
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            ref.watch(isAutoNextMovie)
                                                ? Icons.play_circle
                                                : Icons.pause_circle,
                                            color: ref.watch(isAutoNextMovie)
                                                ? Colors.blue
                                                : Colors.grey[600],
                                            size: 28,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Auto Next',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: ref.watch(isAutoNextMovie)
                                                  ? Colors.blue[700]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 60,
                                            child: Switch(
                                              value: ref.watch(isAutoNextMovie),
                                              onChanged: (value) async {
                                                ref
                                                    .read(isAutoNextMovie
                                                        .notifier)
                                                    .state = value;

                                                await pref.setBool(
                                                    "isAutoNextMovie", value);
                                              },
                                              activeThumbColor: Colors.blue,
                                              activeTrackColor:
                                                  Colors.blue[200],
                                              inactiveThumbColor:
                                                  Colors.grey[400],
                                              inactiveTrackColor:
                                                  Colors.grey[300],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : AspectRatio(
                          aspectRatio: 16 / 9,
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
                                      Navigator.push(
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
                          Row(
                            children: [
                              Text('movieDetail.quality'.tr()),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blueAccent,
                                ),
                                child: Text(
                                  "${dataInforMovie?['movie']['quality'] ?? ''}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.orangeAccent,
                            ),
                            child: Text(
                              dataInforMovie?['movie']['lang'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
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
                      Consumer(
                        builder: (context, ref, child) {
                          final isCollapsed = ref.watch(isCollapsedReadMore);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataInforMovie?['movie']['content'] ?? '',
                                maxLines: isCollapsed ? 3 : null,
                                overflow: isCollapsed
                                    ? TextOverflow.ellipsis
                                    : TextOverflow.visible,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  ref.read(isCollapsedReadMore.notifier).state =
                                      !isCollapsed;
                                },
                                child: Text(
                                  isCollapsed
                                      ? 'movieDetail.seeMore'.tr()
                                      : 'movieDetail.seeLess'.tr(),
                                  style: TextStyle(
                                    color: isCollapsed
                                        ? Colors.lightBlueAccent
                                        : Theme.of(context)
                                            .appBarTheme
                                            .foregroundColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
                                    dataInforMovie!['episodes'][0]
                                        ['server_data'][0]['link_m3u8'];

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
                                    dataInforMovie['episodes'][0]['server_data']
                                        [size - 1]['link_m3u8'];
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
                              builder: (context, ref, child) => TextButton(
                                onPressed: () => {
                                  ref.read(isCollapsedReadMore.notifier).state =
                                      true,
                                  scrollController.position.animateTo(
                                      itemEpisodeOffsets[
                                          ref.watch(wasWatchEpisodeMovies) -
                                              1]!,
                                      duration: Durations.long1,
                                      curve: Curves.linear)
                                },
                                style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsetsGeometry.all(0))),
                                child: Text('historyScreen.watchedEpisode'
                                    .tr(args: [
                                  'movie.episode'
                                      .plural(ref.watch(wasWatchEpisodeMovies))
                                ])),
                              ),
                            );
                          }),
                      const Text('movieDetail.episodeList').tr(),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataInforMovie?['episodes'][0]['server_data']
                                .length ??
                            0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                mainAxisExtent: 40),
                        itemBuilder: (context, index) {
                          double itemHeight = 40 + 5;

                          int rowIndex = index ~/ 5;

                          if (rowIndex == 0) {
                            double offset = itemHeight;

                            itemEpisodeOffsets[index] = offset + 115 + height;
                          } else {
                            double offset =
                                rowIndex * itemHeight + 115 + height;

                            itemEpisodeOffsets[index] = offset;
                          }

                          return Consumer(
                            builder: (context, ref, child) => InkWell(
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
                                        .read(isClickLWatchEpisodeLinkMovies
                                            .notifier)
                                        .state =
                                    dataInforMovie!['episodes'][0]
                                        ['server_data'][index]['link_m3u8'];
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
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: ref.watch(wasWatchEpisodeMovies) -
                                              1 ==
                                          index
                                      ? const LinearGradient(
                                          colors: [
                                            Colors.orangeAccent,
                                            Colors.deepOrange
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : const LinearGradient(
                                          colors: [Colors.grey, Colors.grey],
                                        ),
                                  boxShadow: [
                                    if (ref.watch(wasWatchEpisodeMovies) - 1 ==
                                        index)
                                      BoxShadow(
                                        color:
                                            Colors.orange.withValues(alpha: .5),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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

  Future<void> addFavoriteMovie(String name, String slug, String posterUrl,
      String lang, String episodeCurrent) async {
    final result = await movieController.addFavoriteMovies(
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
    final result = await movieController.removeFavoriteMovie(slug);
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
