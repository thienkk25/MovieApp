import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeBarScreen extends StatefulWidget {
  const HomeBarScreen({super.key});

  @override
  State<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends State<HomeBarScreen> {
  ScrollController filterScrollController = ScrollController();
  late double filterOffset;
  @override
  void initState() {
    listenScrollControllers();
    super.initState();
  }

  void listenScrollControllers() {
    filterScrollController.addListener(
      () {
        setState(() {
          filterOffset = filterScrollController.offset;
        });
      },
    );
  }

  @override
  void dispose() {
    filterScrollController.removeListener(listenScrollControllers);
    filterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chủ"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Lọc"),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      width: 1,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: filterScrollController,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          double opacity = 1.0;
                          if (index <
                              filterScrollController.offset / 100 - .4) {
                            opacity = 0.3;
                          }

                          return Opacity(
                            opacity: opacity,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 80,
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
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Phim mới cập nhật",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff30cfd0), Color(0xff330867)]),
                      ),
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
                                  "https://res.cloudinary.com/dksr7si4o/image/upload/v1709205846/images/hhninja-luyen-khi-muoi-van-nam-1_250x350_kprzvw.jpg",
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
                          ),
                          const Text(
                            "Name",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Phim",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4.0),
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
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
                                "https://phimimg.com/upload/vod/20250128-1/ede258f75b02c54deeb80dd9f8d43565.jpg",
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
                        ),
                        const Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ].animate(interval: 500.ms).fadeIn(duration: 500.ms),
          ),
        ),
      ),
    );
  }
}
