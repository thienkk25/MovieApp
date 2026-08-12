import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/data/models/search_filter.dart';
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

  final List<_QuickFilterOption> _quickFilters = const [
    _QuickFilterOption(label: 'Tất cả', category: null, sortLang: null, country: null),
    _QuickFilterOption(label: 'Phim Lẻ', category: 'phim-le'),
    _QuickFilterOption(label: 'Phim Bộ', category: 'phim-bo'),
    _QuickFilterOption(label: 'Hoạt Hình', category: 'hoat-hinh'),
    _QuickFilterOption(label: 'Vietsub', sortLang: 'vietsub'),
    _QuickFilterOption(label: 'Thuyết Minh', sortLang: 'thuyet-minh'),
    _QuickFilterOption(label: 'Hàn Quốc', country: 'han-quoc'),
    _QuickFilterOption(label: 'Trung Quốc', country: 'trung-quoc'),
    _QuickFilterOption(label: 'Âu Mỹ', country: 'au-my'),
    _QuickFilterOption(label: 'Hành Động', category: 'hanh-dong'),
    _QuickFilterOption(label: 'Tình Cảm', category: 'tinh-cam'),
    _QuickFilterOption(label: 'Kinh Dị', category: 'kinh-di'),
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

  int _countActiveFilters(SearchFilter filter) {
    int count = 0;
    if (filter.category != null && filter.category!.isNotEmpty) count++;
    if (filter.country != null && filter.country!.isNotEmpty) count++;
    if (filter.sortLang != null && filter.sortLang!.isNotEmpty) count++;
    if (filter.year != null) count++;
    if (filter.sortField != 'modified.time' || filter.sortType != 'desc') count++;
    return count;
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
          'Tìm kiếm & Lọc phim',
          style: AppTextStyles.appBarTitle.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md, vertical: 8),
          child: Column(
            children: [
              // Search Input Bar
              _buildSearchBar(colors),

              const SizedBox(height: 12),

              // Quick Filter Pills Row (Horizontal Scroll)
              _buildQuickFilterBar(colors),

              const SizedBox(height: 14),

              // Results Header & Advanced Filter Button Row
              BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  final activeCount = _countActiveFilters(state.filter);
                  final hasFilter = activeCount > 0;

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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
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
                              width: hasFilter ? 1.5 : 1.0,
                            ),
                            boxShadow: hasFilter
                                ? [
                                    BoxShadow(
                                      color: colors.accentGlow,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
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
                                hasFilter ? 'Bộ lọc ($activeCount)' : 'Bộ lọc nâng cao',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: hasFilter
                                      ? colors.accentPrimary
                                      : colors.textSecondary,
                                  fontWeight: hasFilter
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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

              // Main Results / Discovery Content Area
              Expanded(
                child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (context, state) {
                    if (searchController.text.isEmpty &&
                        state.searchResults.isEmpty &&
                        !state.filter.isNotEmpty) {
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
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.responsiveColumnCount,
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

  // ─── Search Bar Widget ──────────────────────────────────
  Widget _buildSearchBar(AppColors colors) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
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
                setState(() {});
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

  // ─── Horizontal Quick-Filter Bar ────────────────────────
  Widget _buildQuickFilterBar(AppColors colors) {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        final currentFilter = state.filter;

        return SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _quickFilters.length,
            itemBuilder: (context, index) {
              final opt = _quickFilters[index];

              bool isSelected = false;
              if (opt.category == null &&
                  opt.sortLang == null &&
                  opt.country == null) {
                isSelected = currentFilter.category == null &&
                    currentFilter.sortLang == null &&
                    currentFilter.country == null;
              } else {
                if (opt.category != null &&
                    currentFilter.category == opt.category) {
                  isSelected = true;
                }
                if (opt.sortLang != null &&
                    currentFilter.sortLang == opt.sortLang) {
                  isSelected = true;
                }
                if (opt.country != null &&
                    currentFilter.country == opt.country) {
                  isSelected = true;
                }
              }

              return GestureDetector(
                onTap: () {
                  SearchFilter newFilter;
                  if (opt.category == null &&
                      opt.sortLang == null &&
                      opt.country == null) {
                    newFilter = currentFilter.copyWith(
                      category: null,
                      sortLang: null,
                      country: null,
                    );
                  } else {
                    newFilter = currentFilter.copyWith(
                      category: opt.category,
                      sortLang: opt.sortLang,
                      country: opt.country,
                    );
                  }

                  context
                      .read<MovieSearchBloc>()
                      .add(MovieSearchEvent.filterChanged(newFilter));
                  context
                      .read<MovieSearchBloc>()
                      .add(const MovieSearchEvent.executeSearch());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.accentPrimary
                        : colors.cardBg,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.pillRadius),
                    border: Border.all(
                      color: isSelected ? colors.accentPrimary : colors.border,
                    ),
                  ),
                  child: Text(
                    opt.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected
                          ? colors.accentOnAccent
                          : colors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
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
            'Thử thay đổi từ khóa hoặc cài đặt bộ lọc',
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

// ─── Advanced Filter BottomSheet Modal ─────────────────────
class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late String? selectedCategory;
  late String? selectedCountry;
  late String? selectedSortLang;
  late int? selectedYear;
  late String selectedSortField;
  late String selectedSortType;

  final Map<String, String> _categories = const {
    'phim-le': 'Phim Lẻ',
    'phim-bo': 'Phim Bộ',
    'hoat-hinh': 'Hoạt Hình',
    'hanh-dong': 'Hành Động',
    'tinh-cam': 'Tình Cảm',
    'hai-huoc': 'Hài Hước',
    'kinh-di': 'Kinh Dị',
    'co-trang': 'Cổ Trang',
    'vien-tuong': 'Viễn Tưởng',
    'tam-ly': 'Tâm Lý',
    'vo-thuat': 'Võ Thuật',
    'hinh-su': 'Hình Sự',
    'bi-an': 'Bí Ẩn',
  };

  final Map<String, String> _countries = const {
    'trung-quoc': 'Trung Quốc',
    'han-quoc': 'Hàn Quốc',
    'au-my': 'Âu Mỹ',
    'nhat-ban': 'Nhật Bản',
    'viet-nam': 'Việt Nam',
    'thai-lan': 'Thái Lan',
    'an-do': 'Ấn Độ',
    'hong-kong': 'Hồng Kông',
  };

  final Map<String, String> _languages = const {
    'vietsub': 'Vietsub',
    'thuyet-minh': 'Thuyết Minh',
    'long-tieng': 'Lồng Tiếng',
  };

  final List<Map<String, String>> _sortOptions = const [
    {'field': 'modified.time', 'type': 'desc', 'label': 'Mới cập nhật'},
    {'field': 'year', 'type': 'desc', 'label': 'Năm phát hành mới nhất'},
    {'field': 'view', 'type': 'desc', 'label': 'Nhiều lượt xem nhất'},
  ];

  @override
  void initState() {
    super.initState();
    final filter = context.read<MovieSearchBloc>().state.filter;
    selectedCategory = filter.category;
    selectedCountry = filter.country;
    selectedSortLang = filter.sortLang;
    selectedYear = filter.year;
    selectedSortField = filter.sortField;
    selectedSortType = filter.sortType;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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
          const SizedBox(height: 14),

          // Modal Title & Reset Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bộ lọc phim nâng cao 🎬',
                style: AppTextStyles.h3.copyWith(
                  color: colors.textPrimary,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = null;
                    selectedCountry = null;
                    selectedSortLang = null;
                    selectedYear = null;
                    selectedSortField = 'modified.time';
                    selectedSortType = 'desc';
                  });
                },
                child: Text(
                  'Đặt lại',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.accentPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Scrollable Filter Sections
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Thể loại
                  _buildSectionHeader('Thể loại phim', colors),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Tất cả', selectedCategory == null, () {
                        setState(() => selectedCategory = null);
                      }, colors),
                      ..._categories.entries.map((e) {
                        return _buildChip(e.value, selectedCategory == e.key, () {
                          setState(() => selectedCategory =
                              selectedCategory == e.key ? null : e.key);
                        }, colors);
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2. Quốc gia
                  _buildSectionHeader('Quốc gia phát hành', colors),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Tất cả', selectedCountry == null, () {
                        setState(() => selectedCountry = null);
                      }, colors),
                      ..._countries.entries.map((e) {
                        return _buildChip(e.value, selectedCountry == e.key, () {
                          setState(() => selectedCountry =
                              selectedCountry == e.key ? null : e.key);
                        }, colors);
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. Bản dịch / Ngôn ngữ
                  _buildSectionHeader('Định dạng âm thanh', colors),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Tất cả', selectedSortLang == null, () {
                        setState(() => selectedSortLang = null);
                      }, colors),
                      ..._languages.entries.map((e) {
                        return _buildChip(e.value, selectedSortLang == e.key, () {
                          setState(() => selectedSortLang =
                              selectedSortLang == e.key ? null : e.key);
                        }, colors);
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 4. Năm phát hành & Sắp xếp
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('Năm sản xuất', colors),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<int>(
                              initialValue: selectedYear,
                              dropdownColor: colors.sheetBg,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: colors.textPrimary),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppDimensions.radiusMd),
                                  borderSide: BorderSide(color: colors.border),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('Tất cả năm'),
                                ),
                                ...List.generate(
                                  16,
                                  (i) => DropdownMenuItem<int>(
                                    value: DateTime.now().year - i,
                                    child: Text('${DateTime.now().year - i}'),
                                  ),
                                ),
                              ],
                              onChanged: (val) =>
                                  setState(() => selectedYear = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 5. Sắp xếp theo
                  _buildSectionHeader('Sắp xếp theo', colors),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sortOptions.map((opt) {
                      final isSelected = selectedSortField == opt['field'] &&
                          selectedSortType == opt['type'];
                      return _buildChip(opt['label']!, isSelected, () {
                        setState(() {
                          selectedSortField = opt['field']!;
                          selectedSortType = opt['type']!;
                        });
                      }, colors);
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<MovieSearchBloc>()
                        .add(const MovieSearchEvent.resetFilter());
                    context
                        .read<MovieSearchBloc>()
                        .add(const MovieSearchEvent.executeSearch());
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
                  child: Text('Bỏ lọc',
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
                              category: selectedCategory,
                              country: selectedCountry,
                              sortLang: selectedSortLang,
                              year: selectedYear,
                              sortField: selectedSortField,
                              sortType: selectedSortType,
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
                  child: Text(
                    'Áp dụng bộ lọc',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: colors.accentOnAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColors colors) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChip(
      String label, bool isSelected, VoidCallback onTap, AppColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentPrimary : colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
          border: Border.all(
            color: isSelected ? colors.accentPrimary : colors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? colors.accentOnAccent : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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

/// Helper model for quick filter bar options
class _QuickFilterOption {
  final String label;
  final String? category;
  final String? sortLang;
  final String? country;

  const _QuickFilterOption({
    required this.label,
    this.category,
    this.sortLang,
    this.country,
  });
}
