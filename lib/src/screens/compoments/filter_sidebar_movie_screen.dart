import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/screens/compoments/view_more_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';

class FilterSidebarMovieScreen extends StatefulWidget {
  final Future<List> futureCategoryMovies;
  final Future<List> futureCountryMovies;
  final int pageMovie;
  final int limitMovie;

  const FilterSidebarMovieScreen({
    super.key,
    required this.futureCategoryMovies,
    required this.pageMovie,
    required this.limitMovie,
    required this.futureCountryMovies,
  });

  @override
  State<FilterSidebarMovieScreen> createState() =>
      _FilterSidebarMovieScreenState();
}

class _FilterSidebarMovieScreenState extends State<FilterSidebarMovieScreen> {
  final MovieController movieController = MovieController();
  final TextEditingController textEditingController = TextEditingController();

  String currentSlugCategory = "";
  int currentIndexCategory = -1;
  int currentIndexCountry = -1;
  String sortType = "desc";
  String country = "";
  int year = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildGridItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;

    int columnCount = sizeWidth < 600
        ? 2
        : sizeWidth <= 900
            ? 3
            : sizeWidth <= 1300
                ? 4
                : 5;

    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: sizeWidth * 0.8,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'filter.title'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('filter.pleaseSelectGenre'.tr()),
                        FutureBuilder<List>(
                          future: widget.futureCategoryMovies,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Icon(Icons.error));
                            }
                            final data = snapshot.data!;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columnCount,
                                mainAxisExtent: 40,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemBuilder: (context, index) => _buildGridItem(
                                label: data[index]['name'],
                                isSelected: currentIndexCategory == index,
                                onTap: () {
                                  setState(() {
                                    currentIndexCategory = index;
                                    currentSlugCategory = data[index]['slug'];
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        const Divider(height: 24),
                        _buildSectionTitle('filter.pleaseSelectCountry'.tr()),
                        FutureBuilder<List>(
                          future: widget.futureCountryMovies,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Icon(Icons.error));
                            }
                            final data = snapshot.data!;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columnCount,
                                mainAxisExtent: 40,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemBuilder: (context, index) => _buildGridItem(
                                label: data[index]['name'],
                                isSelected: currentIndexCountry == index,
                                onTap: () {
                                  setState(() {
                                    if (currentIndexCountry == index) {
                                      currentIndexCountry = -1;
                                      country = "";
                                    } else {
                                      currentIndexCountry = index;
                                      country = data[index]['slug'];
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        const Divider(height: 24),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'filter.year'.tr(),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  year =
                                      value.isNotEmpty ? int.parse(value) : 0;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'filter.sortBy'.tr(),
                                  border: const OutlineInputBorder(),
                                ),
                                initialValue: sortType,
                                items: [
                                  DropdownMenuItem(
                                    value: "desc",
                                    child: Text('filter.latest'.tr()),
                                  ),
                                  DropdownMenuItem(
                                    value: "asc",
                                    child: Text('filter.oldest'.tr()),
                                  ),
                                ],
                                onChanged: (v) => sortType = v!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text('navigation.exit'.tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (currentSlugCategory.isEmpty) {
                            OverlayScreen().showOverlay(
                              context,
                              'filter.genreRequired'.tr(),
                              Colors.red,
                              duration: 2,
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewMoreScreen(
                                currentSlugCategory,
                                widget.pageMovie,
                                widget.limitMovie,
                                sortType,
                                country,
                                year,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'filter.apply'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
