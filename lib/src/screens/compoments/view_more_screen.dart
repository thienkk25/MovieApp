import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/shimmer_loading.dart';
import 'package:movie_app/src/services/riverpod_service.dart';
import 'package:shimmer/shimmer.dart';

class ViewMoreScreen extends ConsumerStatefulWidget {
  final String type;
  final int page;
  final int limit;
  final String sortType;
  final String country;
  final int year;
  const ViewMoreScreen(
      this.type, this.page, this.limit, this.sortType, this.country, this.year,
      {super.key});

  @override
  ConsumerState<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends ConsumerState<ViewMoreScreen> {
  MovieController movieController = MovieController();
  bool isView = false;
  ScrollController scrollController = ScrollController();
  late int currentPage;
  late String titleAppBar;
  late final int totalPages;
  @override
  void initState() {
    currentPage = widget.page + 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      scrollController.addListener(isLoadMore);
    });
    super.initState();
  }

  Future<void> loadData() async {
    Map? data = await getMovies(widget.type, widget.page + 1, widget.limit,
        widget.sortType, widget.country, widget.year);
    ref
        .read(viewMoreMoviesNotifierProvider.notifier)
        .initState(data?['data']?['items'] ?? []);
    titleAppBar = data?['data']?['titlePage'] ?? "Không rõ";
    isView = true;
    totalPages = data?['data']?['params']?['pagination']?['totalPages'] ?? 30;
  }

  void isLoadMore() {
    if (!ref.read(isLoadingMore) &&
        scrollController.hasClients &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      ref.read(isLoadingMore.notifier).state = true;
      loadDataMore();
    }
  }

  Future<void> loadDataMore() async {
    if (!mounted) return;
    currentPage++;
    Map? data = await getMovies(widget.type, currentPage, widget.limit,
        widget.sortType, widget.country, widget.year);
    if (!mounted) return;
    ref
        .read(viewMoreMoviesNotifierProvider.notifier)
        .addState(data?['data']?['items'] ?? []);
    ref.read(isLoadingMore.notifier).state = false;
  }

  getMovies(String type, int page, int limit, String sortType, String country,
      int year) {
    if (sortType != "desc" || country.isNotEmpty || year != 0) {
      return movieController.categoryDetailMovies(type, page - 1, limit,
          country: country, sortType: sortType, year: year);
    }
    switch (type) {
      case "Phim Lẻ":
        return movieController.singleMovies(page, limit);
      case "Phim Bộ":
        return movieController.dramaMovies(page, limit);
      case "Phim Hoạt Hình":
        return movieController.cartoonMovies(page, limit);
      case "Chương trình truyền hình":
        return movieController.tvShowsMovies(page, limit);
      case "Phim Vietsub":
        return movieController.vietSubMovies(page, limit);
      case "Phim Thuyết Minh":
        return movieController.narratedMovies(page, limit);
      case "Phim Lồng Tiếng":
        return movieController.dubbedMovies(page, limit);
      default:
        return movieController.categoryDetailMovies(type, page - 1, limit);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List dataMovies = ref.watch(viewMoreMoviesNotifierProvider);
    double sizeWidth = MediaQuery.of(context).size.width;
    int responsiveColumnCount;
    int? itemCount;

    if (sizeWidth < 600) {
      responsiveColumnCount = 2;
      itemCount = 6;
    } else if (sizeWidth <= 800) {
      responsiveColumnCount = 3;
      itemCount = 9;
    } else if (sizeWidth <= 1200) {
      responsiveColumnCount = 4;
      itemCount = 12;
    } else {
      responsiveColumnCount = 5;
      itemCount = 15;
    }
    return isView
        ? Scaffold(
            appBar: AppBar(
              title: Text(titleAppBar),
              centerTitle: true,
            ),
            body: GridView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: dataMovies.length +
                  (ref.watch(isLoadingMore) ? itemCount : 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: responsiveColumnCount,
                mainAxisExtent: 250,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (index < dataMovies.length) {
                  return MovieItemWidget(
                    id: dataMovies[index]['_id'],
                    slugMovie: dataMovies[index]['slug'],
                    imageUrl: dataMovies[index]['poster_url'],
                    lang: dataMovies[index]['lang'],
                    name: dataMovies[index]['name'],
                    episodeCurrent: dataMovies[index]['episode_current'],
                  );
                } else if (currentPage <= totalPages) {
                  return const SimpleLoading();
                }
                return null;
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Loading..."),
              centerTitle: true,
            ),
            body: const Padding(
              padding: EdgeInsets.all(10.0),
              child: ShimmerLoading(),
            ),
          );
  }
}

class SimpleLoading extends StatelessWidget {
  const SimpleLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: Colors.grey.shade300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieItemWidget extends StatelessWidget {
  final String id;
  final String slugMovie;
  final String imageUrl;
  final String lang;
  final String name;
  final String episodeCurrent;

  const MovieItemWidget({
    super.key,
    required this.id,
    required this.slugMovie,
    required this.imageUrl,
    required this.lang,
    required this.name,
    required this.episodeCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(id),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => InforMovieScreen(
                    slugMovie: slugMovie,
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
              imageUrl: "https://phimimg.com/$imageUrl",
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
                      bottomLeft: Radius.circular(5))),
              child: Text(
                lang,
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
                    episodeCurrent,
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
                  name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
