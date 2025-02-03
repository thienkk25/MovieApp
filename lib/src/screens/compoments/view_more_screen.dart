import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class ViewMoreScreen extends ConsumerStatefulWidget {
  final String type;
  final int page;
  final int limit;
  const ViewMoreScreen(this.type, this.page, this.limit, {super.key});

  @override
  ConsumerState<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends ConsumerState<ViewMoreScreen> {
  MovieController movieController = MovieController();
  bool isView = false;
  ScrollController scrollController = ScrollController();
  bool isLoad = false;
  late int currentPage;
  late String titleAppBar;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      scrollController.addListener(isLoadMore);
      currentPage = widget.page;
    });
    super.initState();
  }

  Future<void> loadData() async {
    Map? data = await getMovies(widget.type, widget.page, widget.limit);
    ref
        .read(viewMoreMoviesNotifierProvider.notifier)
        .initState(data?['data']?['items'] ?? []);
    titleAppBar = data?['data']?['titlePage'] ?? "Không rõ";
    isView = true;
  }

  void isLoadMore() {
    if (!isLoad &&
        scrollController.hasClients &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
      setState(() {
        isLoad = true;
      });
      loadDataMore();
    }
  }

  Future<void> loadDataMore() async {
    currentPage++;
    Map? data = await getMovies(widget.type, currentPage, widget.limit);
    ref
        .read(viewMoreMoviesNotifierProvider.notifier)
        .addState(data?['data']?['items'] ?? []);
    setState(() {
      isLoad = false;
    });
  }

  getMovies(String type, int page, int limit) {
    switch (type) {
      case "Phim Lẻ":
        return movieController.singleMovies(page, limit);
      case "Phim Bộ":
        return movieController.dramaMovies(page, limit);
      case "Phim Hoạt Hình":
        return movieController.cartoonMovies(page, limit);
      case "Chương trình truyền hình":
        return movieController.tvShowsMovies(page, limit);
      default:
        return movieController.categoryDetailMovies(type, page, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    List dataMovies = ref.watch(viewMoreMoviesNotifierProvider);
    return isView
        ? Scaffold(
            appBar: AppBar(
              title: Text(titleAppBar),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataMovies.length,
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
                                        slugMovie: dataMovies[index]['slug'],
                                      ))),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff30cfd0),
                                      Color(0xff330867)
                                    ])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://phimimg.com/${dataMovies[index]['poster_url']}",
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
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    dataMovies[index]['name'],
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  isLoad
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
