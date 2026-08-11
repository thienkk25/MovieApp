import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    context.read<MovieSearchBloc>().add(const MovieSearchEvent.executeSearch());
  }

  @override
  void dispose() {
    searchController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tìm kiếm phim',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Search Input Bar
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.inputFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.inputBorder),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search_rounded, color: Colors.amber, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: colors.textPrimary, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Nhập tên phim, diễn viên...',
                          hintStyle: TextStyle(color: colors.inputHint, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          if (timer?.isActive ?? false) timer?.cancel();
                          timer = Timer(const Duration(milliseconds: 400), () {
                            context.read<MovieSearchBloc>().add(
                                  MovieSearchEvent.keywordChanged(val.trim()),
                                );
                            context
                                .read<MovieSearchBloc>()
                                .add(const MovieSearchEvent.executeSearch());
                          });
                        },
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: colors.iconSecondary, size: 20),
                        onPressed: () {
                          searchController.clear();
                          context.read<MovieSearchBloc>().add(
                                const MovieSearchEvent.keywordChanged(''),
                              );
                          context
                              .read<MovieSearchBloc>()
                              .add(const MovieSearchEvent.executeSearch());
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Filter Action Button
              BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  final hasFilter = state.filter.isNotEmpty;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.searchResults.isNotEmpty
                            ? 'Kết quả (${state.searchResults.length})'
                            : 'Gợi ý phim mới',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showFilterModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: hasFilter
                                ? Colors.amber.withValues(alpha: 0.15)
                                : colors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: hasFilter ? Colors.amber : colors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: hasFilter ? Colors.amber : colors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Bộ lọc',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      hasFilter ? Colors.amber : colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 14),

              // Search Results / Suggested Grid
              Expanded(
                child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (context, state) {
                    if (state.status == MovieSearchStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      );
                    }

                    if (state.searchResults.isEmpty &&
                        state.status == MovieSearchStatus.success) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 64, color: colors.iconInactive),
                            const SizedBox(height: 12),
                            Text(
                              'Không tìm thấy phim phù hợp',
                              style: TextStyle(
                                color: colors.textTertiary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final movie = state.searchResults[index];
                        return CardMovie(
                          movie: movie,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    InforMovieScreen(slugMovie: movie.slug),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final bloc = context.read<MovieSearchBloc>();
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: const FilterModalWidget(),
        );
      },
    );
  }
}

class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  String? selectedCategory;
  String? selectedCountry;
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.iconInactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lọc phim nâng cao',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Year Dropdown
          DropdownButtonFormField<int>(
            initialValue: selectedYear,
            dropdownColor: colors.sheetBg,
            style: TextStyle(color: colors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              labelText: 'Năm phát hành',
              labelStyle: const TextStyle(color: Colors.amber),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.border),
              ),
            ),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('Tất cả năm'),
              ),
              ...List.generate(
                15,
                (i) => DropdownMenuItem<int>(
                  value: DateTime.now().year - i,
                  child: Text('${DateTime.now().year - i}'),
                ),
              ),
            ],
            onChanged: (val) => setState(() => selectedYear = val),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<MovieSearchBloc>()
                        .add(const MovieSearchEvent.resetFilter());
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.amber),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Đặt lại',
                      style: TextStyle(color: Colors.amber)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final currentFilter = context.read<MovieSearchBloc>().state.filter;
                    context.read<MovieSearchBloc>().add(
                          MovieSearchEvent.filterChanged(
                            currentFilter.copyWith(
                              year: selectedYear,
                            ),
                          ),
                        );
                    context
                        .read<MovieSearchBloc>()
                        .add(const MovieSearchEvent.executeSearch());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Áp dụng',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
