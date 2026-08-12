import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? timer;
  List<String> _recentSearches = [];

  static const String _recentSearchKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  final List<_TrendingTag> _trendingTags = const [
    _TrendingTag('Hành Động', Icons.local_fire_department_rounded),
    _TrendingTag('Tình Cảm', Icons.favorite_rounded),
    _TrendingTag('Kinh Dị', Icons.dark_mode_rounded),
    _TrendingTag('Hài Hước', Icons.emoji_emotions_rounded),
    _TrendingTag('Viễn Tưởng', Icons.rocket_launch_rounded),
    _TrendingTag('Hoạt Hình', Icons.animation_rounded),
    _TrendingTag('Chiến Tranh', Icons.shield_rounded),
    _TrendingTag('Tâm Lý', Icons.psychology_rounded),
  ];

  @override
  void initState() {
    super.initState();
    context.read<MovieSearchBloc>().add(const MovieSearchEvent.executeSearch());
    _loadRecentSearches();
  }

  @override
  void dispose() {
    searchController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList(_recentSearchKey) ?? [];
    });
  }

  Future<void> _saveSearchKeyword(String keyword) async {
    if (keyword.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(keyword);
    _recentSearches.insert(0, keyword);
    if (_recentSearches.length > _maxRecentSearches) {
      _recentSearches = _recentSearches.take(_maxRecentSearches).toList();
    }
    await prefs.setStringList(_recentSearchKey, _recentSearches);
    setState(() {});
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchKey);
    setState(() => _recentSearches = []);
  }

  void _performSearch(String keyword) {
    searchController.text = keyword;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: keyword.length),
    );
    _saveSearchKeyword(keyword);
    context
        .read<MovieSearchBloc>()
        .add(MovieSearchEvent.keywordChanged(keyword.trim()));
    context.read<MovieSearchBloc>().add(const MovieSearchEvent.executeSearch());
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
          style: AppTextStyles.appBarTitle.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md, vertical: 12),
          child: Column(
            children: [
              // Search Input Bar
              _buildSearchBar(colors),

              const SizedBox(height: 14),

              // Filter Action Row
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
                        style: AppTextStyles.bodyLarge.copyWith(
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
                            color:
                                hasFilter ? colors.accentGlow : colors.cardBg,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMd),
                            border: Border.all(
                              color: hasFilter
                                  ? colors.accentPrimary
                                  : colors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: hasFilter
                                    ? colors.accentPrimary
                                    : colors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Bộ lọc',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: hasFilter
                                      ? colors.accentPrimary
                                      : colors.textSecondary,
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

              // Content Area
              Expanded(
                child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (context, state) {
                    // Show recent + trending when search is empty
                    if (searchController.text.isEmpty &&
                        state.searchResults.isEmpty) {
                      return _buildDiscoveryView(colors);
                    }

                    if (state.status == MovieSearchStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: colors.accentPrimary),
                      );
                    }

                    if (state.searchResults.isEmpty &&
                        state.status == MovieSearchStatus.success) {
                      return _buildEmptyState(colors);
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: AppDimensions.movieCardHeight,
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

  // ─── Search Bar ─────────────────────────────────────────
  Widget _buildSearchBar(AppColors colors) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded, color: colors.accentPrimary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Nhập tên phim, diễn viên...',
                hintStyle:
                    AppTextStyles.bodyMedium.copyWith(color: colors.inputHint),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (val) {
                setState(() {}); // Rebuild for clear button
                if (timer?.isActive ?? false) timer?.cancel();
                timer = Timer(const Duration(milliseconds: 400), () {
                  if (val.trim().isNotEmpty) {
                    _saveSearchKeyword(val.trim());
                  }
                  context.read<MovieSearchBloc>().add(
                        MovieSearchEvent.keywordChanged(val.trim()),
                      );
                  context
                      .read<MovieSearchBloc>()
                      .add(const MovieSearchEvent.executeSearch());
                });
              },
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  _saveSearchKeyword(val.trim());
                }
              },
            ),
          ),
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_rounded,
                  color: colors.iconSecondary, size: 20),
              onPressed: () {
                searchController.clear();
                setState(() {});
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
    );
  }

  // ─── Discovery View (Recent + Trending) ─────────────────
  Widget _buildDiscoveryView(AppColors colors) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm kiếm gần đây',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: colors.textPrimary),
                ),
                GestureDetector(
                  onTap: _clearRecentSearches,
                  child: Text(
                    'Xóa tất cả',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: colors.accentPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((keyword) {
                return GestureDetector(
                  onTap: () => _performSearch(keyword),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.pillRadius),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_rounded,
                            size: 14, color: colors.iconSecondary),
                        const SizedBox(width: 6),
                        Text(
                          keyword,
                          style: AppTextStyles.labelSmall
                              .copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Trending Tags
          Text(
            'Thể loại phổ biến 🔥',
            style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _trendingTags.map((tag) {
              return GestureDetector(
                onTap: () => _performSearch(tag.label),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.cardBg,
                        colors.surfaceBg,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tag.icon, size: 16, color: colors.accentPrimary),
                      const SizedBox(width: 8),
                      Text(
                        tag.label,
                        style: AppTextStyles.labelMedium
                            .copyWith(color: colors.textPrimary),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────
  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accentGlow,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 48, color: colors.accentPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy phim phù hợp',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Thử tìm với từ khóa khác',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary),
          ),
        ],
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
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.sheetRadius)),
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
              width: AppDimensions.sheetHandleWidth,
              height: AppDimensions.sheetHandleHeight,
              decoration: BoxDecoration(
                color: colors.iconInactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lọc phim nâng cao',
            style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Year Dropdown
          DropdownButtonFormField<int>(
            initialValue: selectedYear,
            dropdownColor: colors.sheetBg,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Năm phát hành',
              labelStyle: TextStyle(color: colors.accentPrimary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
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
                    side: BorderSide(color: colors.accentPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: Text('Đặt lại',
                      style: TextStyle(color: colors.accentPrimary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final currentFilter =
                        context.read<MovieSearchBloc>().state.filter;
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
                    backgroundColor: colors.accentPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: Text('Áp dụng',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: colors.accentOnAccent,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper model for trending tags
class _TrendingTag {
  final String label;
  final IconData icon;

  const _TrendingTag(this.label, this.icon);
}
