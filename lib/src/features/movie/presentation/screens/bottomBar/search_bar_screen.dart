import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/movie/data/models/movie_model.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/filter_sidebar_movie_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';
import 'package:movie_app/src/core/providers/core_providers.dart';

class SearchBarScreen extends ConsumerStatefulWidget {
  const SearchBarScreen({super.key});

  @override
  ConsumerState<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends ConsumerState<SearchBarScreen> {
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
    futureNewlyUpdatedMovies = ref.read(getNewlyUpdatedMoviesV3UseCaseProvider).call(page: 2);
    futureCategoryMovies = ref.read(categoryMoviesProvider.future);
    futureCountryMovies = ref.read(countryMoviesProvider.future);
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
      backgroundColor: const Color(0xFF090A0F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF090A0F),
                Color(0xFF10121D),
              ],
            ),
          ),
        ),
        title: Text(
          'search.title'.tr(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
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
              colors: [Color(0xFF090A0F), Color(0xFF141622), Color(0xFF090A0F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              spacing: 14,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: .12)),
                      ),
                      child: SearchBar(
                        controller: searchController,
                        hintText: 'search.hint'.tr(),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        leading: const Icon(Icons.search, color: Colors.orangeAccent),
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(color: Colors.white70.withValues(alpha: 0.5)),
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
                              dataSearch = await ref.read(searchMoviesUseCaseProvider).call(
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
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
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
                                horizontal: 12, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                const Icon(Icons.category_outlined,
                                    color: Colors.orangeAccent, size: 20),
                                Text(
                                  'movie.genre'.tr(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final hasFilter = ref.watch(searchFilterProvider).isNotEmpty;
                          return Container(
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: hasFilter
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: hasFilter
                                    ? Colors.orangeAccent.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => showFilterModal(context, ref),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Text(
                                      'filter.title'.tr(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: hasFilter
                                            ? Colors.orangeAccent
                                            : Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      hasFilter
                                          ? Icons.filter_alt_rounded
                                          : Icons.filter_alt_off_rounded,
                                      size: 20,
                                      color: hasFilter
                                          ? Colors.orangeAccent
                                          : Colors.white54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
                          mainAxisExtent: 260,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
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
                              child: Text(
                                'search.noResult'.tr(),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                                    mainAxisExtent: 260,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
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
                                  child: Icon(Icons.error, color: Colors.white24),
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
      backgroundColor: const Color(0xFF141622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final labelStyle = const TextStyle(color: Colors.orangeAccent, fontSize: 14);
        final decoration = (String label) => InputDecoration(
              labelText: label,
              labelStyle: labelStyle,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.orangeAccent, width: 1.5),
              ),
            );

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
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
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'filter.search'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Column(
                    spacing: 16,
                    children: [
                      FutureBuilder(
                        future: futureCategoryMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.white70));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text("Không có dữ liệu", style: TextStyle(color: Colors.white70));
                          }

                          final categories = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            initialValue: currentFilter.category,
                            dropdownColor: const Color(0xFF1D1F30),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: decoration('filter.category'.tr()),
                            isExpanded: true,
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text("Tất cả", style: const TextStyle(color: Colors.white70)),
                              ),
                              ...categories.map(
                                (e) => DropdownMenuItem<String>(
                                  value: e['slug'] as String,
                                  child: Text(e['name'] as String, style: const TextStyle(color: Colors.white)),
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
                            return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.white70));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text("Không có dữ liệu", style: TextStyle(color: Colors.white70));
                          }

                          final countries = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            initialValue: currentFilter.country,
                            dropdownColor: const Color(0xFF1D1F30),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: decoration('filter.country'.tr()),
                            isExpanded: true,
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text("Tất cả", style: const TextStyle(color: Colors.white70)),
                              ),
                              ...countries.map(
                                (e) => DropdownMenuItem<String>(
                                  value: e['slug'] as String,
                                  child: Text(e['name'] as String, style: const TextStyle(color: Colors.white)),
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
                        dropdownColor: const Color(0xFF1D1F30),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: decoration('filter.year'.tr()),
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text("Tất cả", style: const TextStyle(color: Colors.white70)),
                          ),
                          ...List.generate(
                            DateTime.now().year - 1969,
                            (i) => DropdownMenuItem<int>(
                              value: DateTime.now().year - i,
                              child: Text('${DateTime.now().year - i}', style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                        onChanged: (v) =>
                            ref.read(searchFilterProvider.notifier).setYear(v),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: currentFilter.sortLang,
                        dropdownColor: const Color(0xFF1D1F30),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: decoration('app.language'.tr()),
                        items: [
                          {'label': 'Tất cả', 'value': null},
                          {'label': 'Vietsub', 'value': 'vietsub'},
                          {'label': 'Thuyết minh', 'value': 'thuyet-minh'},
                          {'label': 'Lồng tiếng', 'value': 'long-tieng'},
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e['value'],
                                  child: Text(e['label'] ?? 'Tất cả', style: TextStyle(color: e['value'] == null ? Colors.white70 : Colors.white)),
                                ))
                            .toList(),
                        onChanged: (v) => ref
                            .read(searchFilterProvider.notifier)
                            .setSortLang(v),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              dropdownColor: const Color(0xFF1D1F30),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: decoration('filter.sortBy'.tr()),
                              initialValue: currentFilter.sortField,
                              items: const [
                                DropdownMenuItem(
                                    value: 'modified.time',
                                    child: Text("Thời gian cập nhật", style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: '_id', child: Text("ID phim", style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: 'year',
                                    child: Text("Năm phát hành", style: TextStyle(color: Colors.white))),
                              ],
                              onChanged: (v) => ref
                                  .read(searchFilterProvider.notifier)
                                  .setSortField(v ?? 'modified.time'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              dropdownColor: const Color(0xFF1D1F30),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: decoration(''),
                              initialValue: currentFilter.sortType,
                              items: const [
                                DropdownMenuItem(
                                    value: 'desc', child: Text("Giảm dần", style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: 'asc', child: Text("Tăng dần", style: TextStyle(color: Colors.white))),
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
                  const SizedBox(height: 10),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(searchFilterProvider.notifier).clear();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.refresh_rounded, color: Colors.orangeAccent),
                          label: Text('filter.reset'.tr(), style: const TextStyle(color: Colors.orangeAccent)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orangeAccent),
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
                          icon: const Icon(Icons.check_rounded, color: Colors.white),
                          label: Text('filter.apply'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
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
