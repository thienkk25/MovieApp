import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoriteBarScreen extends StatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  State<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends State<FavoriteBarScreen> {
  ScrollController favoriteScrollController = ScrollController();
  late double favoriteOffset;
  @override
  void initState() {
    favoriteScrollController.addListener(listenScrollControllers);
    super.initState();
  }

  void listenScrollControllers() {
    setState(() {
      favoriteOffset = favoriteScrollController.offset;
    });
  }

  @override
  void dispose() {
    favoriteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  barElevation: const WidgetStatePropertyAll(0),
                  barHintText: "Tìm kiếm ...",
                  suggestionsBuilder: (context, controller) {
                    return [];
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              controller: favoriteScrollController,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                double height = 180;
                double itemY = index * height / 1.4;
                double difirence = favoriteScrollController.offset - itemY;
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
                        child: Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                                colors: [Color(0xff30cfd0), Color(0xff330867)]),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Name",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                    "https://res.cloudinary.com/dksr7si4o/image/upload/v1709205846/images/hhninja-luyen-khi-muoi-van-nam-1_250x350_kprzvw.jpg",
                                progressIndicatorBuilder:
                                    (context, url, progress) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                height: 160,
                                width: MediaQuery.of(context).size.width / 2,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
