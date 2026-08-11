import 'package:flutter/material.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/view_more_screen.dart';

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
  String currentSlugCategory = "";
  int currentIndexCategory = -1;
  int currentIndexCountry = -1;
  String sortType = "desc";
  String country = "";
  int year = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: colors.surfaceBg,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bộ lọc thể loại',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: colors.iconSecondary),
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
                        Text(
                          'Chọn thể loại',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<List>(
                          future: widget.futureCategoryMovies,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.amber));
                            }
                            final data = snapshot.data!;
                            return Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: List.generate(data.length, (index) {
                                final isSelected =
                                    currentIndexCategory == index;
                                return ChoiceChip(
                                  label: Text(data[index]['name']),
                                  selected: isSelected,
                                  selectedColor: Colors.amber,
                                  backgroundColor: colors.cardBg,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : colors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      currentIndexCategory = index;
                                      currentSlugCategory =
                                          data[index]['slug'];
                                    });
                                  },
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Thoát'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          if (currentSlugCategory.isEmpty) return;
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
                        child: const Text('Áp dụng',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
