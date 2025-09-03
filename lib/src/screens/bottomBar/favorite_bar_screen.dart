import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class FavoriteBarScreen extends ConsumerStatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  ConsumerState<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends ConsumerState<FavoriteBarScreen> {
  final MovieController movieController = MovieController();
  final ScrollController favoriteScrollController = ScrollController();
  late double favoriteOffset;
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
    Map data = ref.watch(getFavoriteMoviesNotifierProvider);
    List dataFavorites = data.values.toList();
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
    return Scaffold(
      key: ValueKey(ref.watch(isLanguageProvider)),
      appBar: AppBar(
        title: const Text('favoritesScreen.title').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: SearchAnchor.bar(
                    onClose: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    isFullScreen: false,
                    barElevation: const WidgetStatePropertyAll(0),
                    barHintText: 'search.hint'.tr(),
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
                                              memCacheHeight: 100,
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
                              ListTile(
                                title: const Text('search.noResult').tr(),
                              )
                            ];
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: dataFavorites.isNotEmpty
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataFavorites.length,
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
                                        slugMovie: dataFavorites[index]['slug'],
                                      ))),
                          child: Container(
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
                                    ])),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: dataFavorites[index]['poster_url'],
                                  progressIndicatorBuilder:
                                      (context, url, progress) => const Center(
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
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text(
                                                    'settingsScreen.notifications.title')
                                                .tr(),
                                            content: const Text(
                                                    'dialog.confirmFavorite')
                                                .tr(),
                                            actions: [
                                              CupertinoDialogAction(
                                                  child: const Text(
                                                          'navigation.cancel')
                                                      .tr(),
                                                  onPressed: () =>
                                                      Navigator.pop(context)),
                                              CupertinoDialogAction(
                                                  child: const Text(
                                                          'navigation.confirm')
                                                      .tr(),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    removeFavoriteMovie(
                                                        dataFavorites[index]
                                                            ['slug']);
                                                  }),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.orange,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(10.0),
                                    color: Colors.black.withValues(alpha: .4),
                                    child: Text(
                                      dataFavorites[index]['name'],
                                      style:
                                          const TextStyle(color: Colors.white),
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
                    )
                  : Center(
                      child: const Text('favoritesScreen.emptyMessage').tr(),
                    ),
            )
          ],
        ),
      ),
    );
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
}
