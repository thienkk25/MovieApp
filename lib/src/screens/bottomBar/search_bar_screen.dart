import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  MovieController movieController = MovieController();
  late Future<Map> futureNewlyUpdatedMovies;
  Timer? timer;
  Map dataSearch = {};
  @override
  void initState() {
    futureNewlyUpdatedMovies = movieController.newlyUpdatedMovies(page: 2);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm kiếm"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                  child: SearchBar(
                    onChanged: (value) {
                      if (timer?.isActive ?? false) {
                        timer?.cancel();
                      }
                      timer = Timer(
                        const Duration(milliseconds: 400),
                        () async {
                          dataSearch =
                              await movieController.searchMovies(value, 30);
                          setState(() {});
                        },
                      );
                    },
                    leading: const Icon(Icons.search),
                    elevation: const WidgetStatePropertyAll(0),
                    hintText: "Tìm kiếm ...",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (dataSearch['data']?['items'] != null &&
                dataSearch['data']['items'].length != 0)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataSearch['data']['items'].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => InforMovieScreen(
                                    slugMovie: dataSearch['data']['items']
                                        [index]['slug'])));
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff30cfd0),
                                  Color(0xff330867)
                                ])),
                        child: Stack(
                          children: [
                            Image.network(
                              "https://phimimg.com/${dataSearch['data']['items'][index]['poster_url']}",
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              cacheHeight: 400,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      color: Colors.white),
                            ),
                            Positioned(
                                child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5))),
                              child: Text(
                                dataSearch['data']['items'][index]['lang'],
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
                                color: Colors.black.withValues(alpha: .3),
                                child: Text(
                                  dataSearch['data']['items'][index]['name'],
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
                ),
              )
            else if (dataSearch['data']?['items'] != null &&
                dataSearch['data']['items'].length == 0)
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(
                  child: Text("Không tìm thấy dữ liệu"),
                ),
              )
            else
              FutureBuilder(
                future: futureNewlyUpdatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    Map newlyUpdatedMovies = snapshot.data!;
                    int responsiveColumnCount =
                        MediaQuery.of(context).size.width > 600 ? 3 : 2;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newlyUpdatedMovies['items']?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: responsiveColumnCount,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => InforMovieScreen(
                                          slugMovie: newlyUpdatedMovies['items']
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
                                    imageUrl: newlyUpdatedMovies['items'][index]
                                        ['poster_url'],
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
                                            bottomRight: Radius.circular(5))),
                                    child: Text(
                                      newlyUpdatedMovies['items'][index]['year']
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                      color: Colors.black.withValues(alpha: .3),
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
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
