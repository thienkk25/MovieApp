import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';

class FilterSidebarMovieScreen extends StatefulWidget {
  final Future<List> futureCategoryMovies;
  final int pageMovie;
  final int limitMovie;

  const FilterSidebarMovieScreen({
    super.key,
    required this.futureCategoryMovies,
    required this.pageMovie,
    required this.limitMovie,
  });

  @override
  State<FilterSidebarMovieScreen> createState() =>
      _FilterSidebarMovieScreenState();
}

class _FilterSidebarMovieScreenState extends State<FilterSidebarMovieScreen> {
  final MovieController movieController = MovieController();
  final TextEditingController textEditingController = TextEditingController();
  late Future<List> futureCountryMovies;
  String currentSlugCategory = "";
  int currentIndexCategory = -1;
  int currentIndexCountry = -1;
  String sortType = "desc";
  String country = "";
  int year = 0;
  @override
  void initState() {
    futureCountryMovies = movieController.countryMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    AppBar(
                      title: const Text('filter.title').tr(),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'filter.pleaseSelectGenre'.tr(),
                        style: const TextStyle(),
                        children: [
                          TextSpan(
                            text: 'filter.required'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: FutureBuilder(
                        future: widget.futureCategoryMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final categoryMovies = snapshot.data!;
                            return CarouselView(
                              onTap: (value) {
                                setState(() {
                                  currentSlugCategory =
                                      categoryMovies[value]['slug'];
                                  currentIndexCategory = value;
                                });
                              },
                              elevation: 2,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemExtent: MediaQuery.of(context).size.width / 3,
                              children: List.generate(
                                categoryMovies.length,
                                (index) => Container(
                                  width: 60,
                                  color: currentIndexCategory == index
                                      ? Colors.orange
                                      : Colors.grey,
                                  child: Center(
                                    child: Text(
                                      categoryMovies[index]['name'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                    ),
                    const Text('filter.pleaseSelectCountry').tr(),
                    SizedBox(
                      height: 50,
                      child: FutureBuilder(
                        future: futureCountryMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final countryMovies = snapshot.data!;
                            return CarouselView(
                              onTap: (value) {
                                if (currentIndexCountry == value) {
                                  currentIndexCountry = -1;
                                  country = "";
                                } else {
                                  currentIndexCountry = value;
                                  country = countryMovies[value]['slug'];
                                }
                                setState(() {});
                              },
                              elevation: 2,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemExtent: MediaQuery.of(context).size.width / 3,
                              children: List.generate(
                                countryMovies.length,
                                (index) => Container(
                                  width: 60,
                                  color: currentIndexCountry == index
                                      ? Colors.orange
                                      : Colors.grey,
                                  child: Center(
                                    child: Text(
                                      countryMovies[index]['name'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70,
                          child: TextFormField(
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            onTapOutside: (event) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              labelText: 'filter.year'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                year = int.parse(value);
                              } else {
                                year = 0;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'filter.sortBy'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            value: sortType,
                            items: [
                              DropdownMenuItem(
                                value: "desc",
                                child: const Text('filter.latest').tr(),
                              ),
                              DropdownMenuItem(
                                value: "asc",
                                child: const Text('filter.oldest').tr(),
                              ),
                            ],
                            onChanged: (value) {
                              sortType = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: 10,
                    width: MediaQuery.sizeOf(context).width * 0.8 - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 80,
                            child: Text(
                              'navigation.exit'.tr(),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (currentSlugCategory.isNotEmpty &&
                                currentIndexCategory != -1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewMoreScreen(
                                      currentSlugCategory,
                                      widget.pageMovie,
                                      widget.limitMovie,
                                      sortType,
                                      country,
                                      year),
                                ),
                              );
                            } else {
                              OverlayScreen().showOverlay(context,
                                  'filter.genreRequired'.tr(), Colors.red,
                                  duration: 2);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 80,
                            child: Text(
                              'filter.apply'.tr(),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
