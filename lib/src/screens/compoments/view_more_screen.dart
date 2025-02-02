import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class ViewMoreScreen extends ConsumerStatefulWidget {
  final String name;
  final int page;
  final int limit;
  final TaskCallback taskCallback;
  const ViewMoreScreen(this.name, this.page, this.limit, this.taskCallback,
      {super.key});

  @override
  ConsumerState<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends ConsumerState<ViewMoreScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() async {
    Map data = await widget.taskCallback();
    ref
        .read(viewMoreMoviesNotifierProvider.notifier)
        .initState(data['data']?['items'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    List dataMovies = ref.watch(viewMoreMoviesNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff30cfd0), Color(0xff330867)])),
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
                        progressIndicatorBuilder: (context, url, progress) =>
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
    );
  }
}
