import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/screens/compoments/filter_sidebar_movie_screen.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/widgets/card_movie.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class SearchBarScreen extends ConsumerStatefulWidget {
  const SearchBarScreen({super.key});

  @override
  ConsumerState<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends ConsumerState<SearchBarScreen> {
  final MovieController movieController = MovieController();
  final TextEditingController searchController = TextEditingController();
  late Future<Map> futureNewlyUpdatedMovies;
  late Future<List> futureCategoryMovies;
  late Future<List> futureCountryMovies;
  final int pageMovie = 1;
  final int limitMovie = 12;
  final String sortType = "desc";
  final String country = "";
  final int year = 0;
  Timer? timer;
  Map dataSearch = {};
  @override
  void initState() {
    futureNewlyUpdatedMovies = movieController.newlyUpdatedMoviesV3(page: 2);
    futureCategoryMovies = movieController.categoryMovies();
    futureCountryMovies = movieController.countryMovies();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
            ),
          ),
        ),
        title: Text(
          'search.title'.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: .4)),
                      ),
                      child: SearchBar(
                        controller: searchController,
                        hintText: 'search.hint'.tr(),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        leading: const Icon(Icons.search, color: Colors.white),
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        trailing: [
                          if (searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Colors.white70),
                              onPressed: () {
                                searchController.clear();
                              },
                            ),
                        ],
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        onChanged: (value) {
                          if (timer?.isActive ?? false) timer?.cancel();
                          timer = Timer(
                            const Duration(milliseconds: 300),
                            () async {
                              final filters = ref.read(searchFilterProvider);
                              dataSearch = await movieController.searchMovies(
                                keyword: value,
                                limit: 18,
                                filters: filters,
                              );
                              if (mounted) setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'filter.title'.tr(),
                          pageBuilder: (context, anim1, anim2) {
                            return FilterSidebarMovieScreen(
                              futureCategoryMovies: futureCategoryMovies,
                              futureCountryMovies: futureCountryMovies,
                              pageMovie: pageMovie,
                              limitMovie: limitMovie,
                            );
                          },
                          transitionBuilder: (context, anim1, anim2, child) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: anim1,
                              curve: Curves.easeOut,
                            ));
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          child: Row(
                            spacing: 8,
                            children: [
                              const Icon(Icons.category_outlined,
                                  color: Colors.blueAccent),
                              Text(
                                'movie.genre'.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => showFilterModal(context, ref),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: Row(
                              spacing: 8,
                              children: [
                                Text(
                                  'filter.title'.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ref
                                            .watch(searchFilterProvider)
                                            .isNotEmpty
                                        ? Colors.orange
                                        : null,
                                  ),
                                ),
                                Icon(
                                  ref.watch(searchFilterProvider).isNotEmpty
                                      ? Icons.filter_alt
                                      : Icons.filter_alt_off,
                                  color:
                                      ref.watch(searchFilterProvider).isNotEmpty
                                          ? Colors.orange
                                          : Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                dataSearch['data']?['items'] != null &&
                        dataSearch['data']['items'].isNotEmpty
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataSearch['data']['items'].length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: responsiveColumnCount,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return CardMovie(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InforMovieScreen(
                                      slugMovie: dataSearch['data']['items']
                                          [index]['slug'],
                                    ),
                                  ),
                                );
                              },
                              movie: MovieData.fromJson(
                                  dataSearch['data']['items'][index]),
                              isLink: false);
                        },
                      )
                    : dataSearch['data'] != null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: const Text('search.noResult').tr(),
                            ),
                          )
                        : FutureBuilder(
                            future: futureNewlyUpdatedMovies,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
                                Map newlyUpdatedMovies = snapshot.data!;
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      newlyUpdatedMovies['items']?.length ?? 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: responsiveColumnCount,
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return CardMovie(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => InforMovieScreen(
                                                      slugMovie:
                                                          newlyUpdatedMovies[
                                                                      'items']
                                                                  [index]
                                                              ['slug'])));
                                        },
                                        movie: MovieData.fromJson(
                                            newlyUpdatedMovies['items'][index]),
                                        isLink: true);
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Icon(Icons.error),
                                );
                              }
                            },
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showFilterModal(BuildContext context, WidgetRef ref) async {
    final currentFilter = ref.read(searchFilterProvider);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'filter.search'.tr(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    spacing: 14,
                    children: [
                      FutureBuilder(
                        future: futureCategoryMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text("Không có dữ liệu");
                          }

                          final categories = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            initialValue: currentFilter.category,
                            decoration: InputDecoration(
                              labelText: 'filter.category'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: [
                              ...categories.map(
                                (e) => DropdownMenuItem(
                                  value: e['slug'],
                                  child: Text(e['name']!),
                                ),
                              )
                            ],
                            onChanged: (v) => ref
                                .read(searchFilterProvider.notifier)
                                .setCategory(v),
                          );
                        },
                      ),
                      FutureBuilder(
                        future: futureCountryMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text("Không có dữ liệu");
                          }

                          final countries = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            initialValue: currentFilter.country,
                            decoration: InputDecoration(
                              labelText: 'filter.country'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: [
                              ...countries.map(
                                (e) => DropdownMenuItem(
                                  value: e['slug'],
                                  child: Text(e['name']!),
                                ),
                              )
                            ],
                            onChanged: (v) => ref
                                .read(searchFilterProvider.notifier)
                                .setCountry(v),
                          );
                        },
                      ),
                      DropdownButtonFormField<int>(
                        initialValue: currentFilter.year,
                        decoration: InputDecoration(
                          labelText: 'filter.year'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        items: List.generate(
                          DateTime.now().year - 1969,
                          (i) => DropdownMenuItem(
                            value: DateTime.now().year - i,
                            child: Text('${DateTime.now().year - i}'),
                          ),
                        ),
                        onChanged: (v) =>
                            ref.read(searchFilterProvider.notifier).setYear(v),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: currentFilter.sortLang,
                        decoration: InputDecoration(
                          labelText: 'app.language'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          {'label': 'Tất cả', 'value': null},
                          {'label': 'Vietsub', 'value': 'vietsub'},
                          {'label': 'Thuyết minh', 'value': 'thuyet-minh'},
                          {'label': 'Lồng tiếng', 'value': 'long-tieng'},
                        ]
                            .map((e) => DropdownMenuItem(
                                  value: e['value'],
                                  child: Text(e['label'] ?? 'Tất cả'),
                                ))
                            .toList(),
                        onChanged: (v) => ref
                            .read(searchFilterProvider.notifier)
                            .setSortLang(v),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'filter.sortBy'.tr(),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                              ),
                              initialValue: currentFilter.sortField,
                              items: const [
                                DropdownMenuItem(
                                    value: 'modified.time',
                                    child: Text("Thời gian cập nhật")),
                                DropdownMenuItem(
                                    value: '_id', child: Text("ID phim")),
                                DropdownMenuItem(
                                    value: 'year',
                                    child: Text("Năm phát hành")),
                              ],
                              onChanged: (v) => ref
                                  .read(searchFilterProvider.notifier)
                                  .setSortField(v ?? 'modified.time'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'filter.sortBy'.tr(),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                              ),
                              initialValue: currentFilter.sortType,
                              items: const [
                                DropdownMenuItem(
                                    value: 'desc', child: Text("Giảm dần")),
                                DropdownMenuItem(
                                    value: 'asc', child: Text("Tăng dần")),
                              ],
                              onChanged: (v) => ref
                                  .read(searchFilterProvider.notifier)
                                  .setSortType(v ?? 'desc'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(searchFilterProvider.notifier).clear();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('filter.reset').tr(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('filter.apply').tr(),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
