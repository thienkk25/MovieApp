import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/configs/my_cache_manager.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class FavoriteBarScreen extends ConsumerStatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  ConsumerState<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends ConsumerState<FavoriteBarScreen> {
  MovieController movieController = MovieController();
  ScrollController favoriteScrollController = ScrollController();
  late double favoriteOffset; // late
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadData();
      },
    );
    favoriteScrollController.addListener(listenScrollControllers);
    super.initState();
  }

  void listenScrollControllers() {
    setState(() {
      favoriteOffset = favoriteScrollController.offset;
    });
  }

  Future<void> loadData() async {
    await movieController.getFavoriteMovies(ref);
  }

  @override
  void dispose() {
    favoriteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List dataFavorites = ref.watch(getFavoriteMoviesNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yêu thích"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: SearchAnchor.bar(
                  isFullScreen: false,
                  barElevation: const WidgetStatePropertyAll(0),
                  barHintText: "Tìm kiếm ...",
                  suggestionsBuilder: (context, controller) {
                    String search = controller.text.toLowerCase();
                    List dataSearch = dataFavorites
                        .where((element) =>
                            element['name'].toLowerCase().contains(search))
                        .toList();

                    return dataSearch.isNotEmpty
                        ? [
                            ...List.generate(
                                dataSearch.length,
                                (index) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    InforMovieScreen(
                                                        slugMovie:
                                                            dataSearch[index]
                                                                ['slug'])));
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: CachedNetworkImage(
                                            imageUrl: dataFavorites[index]
                                                ['poster_url'],
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.fill,
                                            cacheManager: MyCacheManager(),
                                          ),
                                          title: Text(
                                            dataSearch[index]['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ))
                          ]
                        : [
                            const ListTile(
                              title: Text("Không tìm thấy ..."),
                            )
                          ];
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: dataFavorites.isNotEmpty
                ? ListView.builder(
                    controller: favoriteScrollController,
                    shrinkWrap: true,
                    itemCount: dataFavorites.length,
                    itemBuilder: (context, index) {
                      double height = 180;
                      double itemY = index * height / 1.4;
                      double difirence =
                          favoriteScrollController.offset - itemY;
                      double percent = 1 - difirence / height;
                      double opacity = percent;
                      double scale = percent;
                      if (opacity > 1) opacity = 1.0;
                      if (opacity < 0) opacity = 0.0;
                      if (scale > 1) scale = 1.0;

                      return Align(
                        heightFactor: .8,
                        child: Opacity(
                          opacity: opacity,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scale(scale, 1.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => InforMovieScreen(
                                              slugMovie: dataFavorites[index]
                                                  ['slug'])));
                                },
                                child: Container(
                                  height: 160,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xff30cfd0),
                                      Color(0xff330867)
                                    ]),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dataFavorites[index]['name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      CachedNetworkImage(
                                        imageUrl: dataFavorites[index]
                                            ['poster_url'],
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        height: 160,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        fit: BoxFit.fill,
                                        cacheManager: MyCacheManager(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text("Bạn không có phim yêu thích"),
                  ),
          )
        ],
      ),
    );
  }
}
