import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/compoments/watch_movie_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:readmore/readmore.dart';

class InforMovieScreen extends ConsumerStatefulWidget {
  final String slugMovie;
  const InforMovieScreen({super.key, required this.slugMovie});

  @override
  ConsumerState<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends ConsumerState<InforMovieScreen> {
  bool isIconFavorite = false;
  MovieController movieController = MovieController();
  int currentPage = 0;
  int isEpisode = -1;
  int pageMovie = 1;
  int limitMovie = 12;
  Future<MovieModel> loadData() async {
    return (await movieController.singleDetailMovies(widget.slugMovie))!;
  }

  @override
  Widget build(BuildContext context) {
    List dataFavorites = ref.read(getFavoriteMoviesNotifierProvider);

    return FutureBuilder<MovieModel>(
      future: loadData(),
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
              body: const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.error), Text("Phim hiện tại lỗi!")],
              )));
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Không có dữ liệu')));
        }

        MovieModel movieModel = snapshot.data!;
        if (dataFavorites
            .any((element) => element['slug'] == movieModel.movie.slug)) {
          isIconFavorite = true;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "${movieModel.movie.name} (${movieModel.movie.originName})",
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
                              removeFavoriteMovie(movieModel.movie.slug);
                              stateSetter(() {
                                isIconFavorite = false;
                              });
                            },
                            child: const Icon(Icons.favorite))
                        : GestureDetector(
                            onTap: () {
                              addFavoriteMovie(
                                  movieModel.movie.name,
                                  movieModel.movie.slug,
                                  movieModel.movie.posterUrl);
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                          return ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: movieModel.movie.thumbUrl,
                              progressIndicatorBuilder:
                                  (context, url, progress) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fill,
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tên phim: ${movieModel.movie.name}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Tên gốc: ${movieModel.movie.originName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tổng số tập: ${movieModel.movie.episodeTotal}"),
                          Text(movieModel.movie.time),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Trạng thái: ${movieModel.movie.episodeCurrent}"),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            const Text("Thể loại: "),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: movieModel.movie.category.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewMoreScreen(
                                            movieModel
                                                .movie.category[index].slug,
                                            pageMovie,
                                            limitMovie,
                                          ),
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
                                          movieModel.movie.category[index].name,
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
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Chất lượng: ${movieModel.movie.quality}"),
                          Text(movieModel.movie.lang),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Phát hành:"),
                          Text(
                              "${movieModel.movie.country[0].name} / ${movieModel.movie.year}"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Nội dung:"),
                      ReadMoreText(
                        movieModel.movie.content,
                        style: const TextStyle(color: Colors.grey),
                        trimMode: TrimMode.Line,
                        trimLines: 3,
                        colorClickableText: Colors.black,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold),
                        lessStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WatchMovieScreen(
                                          episode: 0,
                                          linkMovie: movieModel.episodes[0]
                                              .serverData[0].linkM3U8),
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                  child: Text(
                                    "Xem từ đầu",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WatchMovieScreen(
                                          episode: movieModel.episodes[0]
                                                  .serverData.length -
                                              1,
                                          linkMovie: movieModel
                                              .episodes[0]
                                              .serverData[movieModel.episodes[0]
                                                      .serverData.length -
                                                  1]
                                              .linkM3U8),
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                  child: Text(
                                    "Xem mới nhất",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Danh sách tập:"),
                      const SizedBox(
                        height: 10,
                      ),
                      StatefulBuilder(
                        builder: (context, StateSetter stateSetter) =>
                            GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: movieModel.episodes[0].serverData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 40),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              stateSetter(
                                () {
                                  isEpisode = index;
                                },
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WatchMovieScreen(
                                        episode: index,
                                        linkMovie: movieModel.episodes[0]
                                            .serverData[index].linkM3U8),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadiusDirectional.all(
                                    Radius.circular(5)),
                                // color: Colors.orange,
                                color: isEpisode == index
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Phim khác:",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: movieController.searchMovies(
                            movieModel.movie.name.substring(1, 5), 20),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            Map dataMovies = snapshot.data!;
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dataMovies['data']['items'].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 250,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 4.0),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => InforMovieScreen(
                                                slugMovie: dataMovies['data']
                                                    ['items'][index]['slug'],
                                              ))),
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          clipBehavior: Clip.antiAlias,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              topLeft: Radius.circular(5)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://phimimg.com/${dataMovies['data']['items'][index]['poster_url']}",
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            dataMovies['data']['items'][index]
                                                ['name'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
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
                    ].animate(interval: 100.ms).scale(duration: 300.ms),
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
    if (result[1]) {
      ref
          .read(getFavoriteMoviesNotifierProvider.notifier)
          .addState({"name": name, "slug": slug, "poster_url": posterUrl});
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result[0]),
      duration: const Duration(milliseconds: 800),
    ));
  }

  Future<void> removeFavoriteMovie(String slug) async {
    final result = await movieController.removeFavoriteMovie(slug);
    if (result[1]) {
      ref.read(getFavoriteMoviesNotifierProvider.notifier).removeState(slug);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result[0]),
      duration: const Duration(milliseconds: 800),
    ));
  }
}
