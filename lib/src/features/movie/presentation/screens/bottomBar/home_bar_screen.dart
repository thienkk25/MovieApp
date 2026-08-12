import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/domain/entities/watch_history_entity.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_state.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/watch_history/watch_history_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/watch_history/watch_history_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/view_more_screen.dart';

class HomeBarScreen extends StatefulWidget {
  const HomeBarScreen({super.key});

  @override
  State<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends State<HomeBarScreen> {
  int selectedCategoryIndex = 0;
  final PageController _heroController = PageController(viewportFraction: 0.92);
  Timer? _autoScrollTimer;
  int _currentHeroPage = 0;

  final List<_CategoryItem> _categories = const [
    _CategoryItem('Tất cả', Icons.movie_outlined, 'all'),
    _CategoryItem('Phim Lẻ', Icons.theaters_outlined, 'Phim Lẻ'),
    _CategoryItem('Phim Bộ', Icons.tv_outlined, 'Phim Bộ'),
    _CategoryItem('Hoạt Hình', Icons.animation_outlined, 'Hoạt Hình'),
    _CategoryItem('TV Shows', Icons.live_tv_outlined, 'TV Shows'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<MovieHomeBloc>().add(const MovieHomeEvent.fetchHomeData());
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _heroController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_heroController.hasClients) return;
      _currentHeroPage++;
      _heroController.animateToPage(
        _currentHeroPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
    // Resume after 8 seconds of inactivity
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        top: false,
        child: BlocBuilder<MovieHomeBloc, MovieHomeState>(
          builder: (context, state) {
            if (state.status == MovieHomeStatus.loading ||
                state.status == MovieHomeStatus.initial) {
              return Center(
                child: CircularProgressIndicator(color: colors.accentPrimary),
              );
            }

            if (state.status == MovieHomeStatus.failure) {
              return _buildErrorState(colors, state);
            }

            final featuredMovies = state.heroCarousel;

            return RefreshIndicator(
              color: colors.accentPrimary,
              onRefresh: () async {
                context
                    .read<MovieHomeBloc>()
                    .add(const MovieHomeEvent.fetchHomeData());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with Cinema Logo
                  _buildAppBar(colors),

                  // Hero Carousel Section with Page Indicators
                  if (featuredMovies.isNotEmpty)
                    _buildHeroCarousel(context, featuredMovies, colors),

                  // Continue Watching Section
                  _buildContinueWatchingSection(context, colors),

                  // Category Filter Pills
                  SliverToBoxAdapter(
                    child: Container(
                      height: AppDimensions.pillHeight,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryPill(
                            _categories[index],
                            index,
                            () {
                              setState(() => selectedCategoryIndex = index);
                              if (index > 0) {
                                context.read<MovieHomeBloc>().add(
                                    MovieHomeEvent.selectCategory(
                                        _categories[index].slug));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Category Results (when not "Tất cả")
                  if (selectedCategoryIndex > 0)
                    _buildCategoryResults(context, state, colors),

                  // Default sections when "Tất cả" is selected
                  if (selectedCategoryIndex == 0) ...[
                    // Movie Section: Newly Updated
                    _buildMovieSection(
                      context,
                      title: 'Phim mới cập nhật 🔥',
                      movies: state.newlyUpdatedMovies,
                      onViewMore: () => _navigateViewMore(
                          context, 'Phim mới cập nhật'),
                    ),

                    // Movie Section: Single Movies
                    _buildMovieSection(
                      context,
                      title: 'Phim Lẻ Chiếu Rạp 🍿',
                      movies: state.singleMovies,
                      onViewMore: () => _navigateViewMore(
                          context, 'Phim Lẻ'),
                    ),

                    // Movie Section: Drama Movies
                    _buildMovieSection(
                      context,
                      title: 'Phim Bộ Đặc Sắc 📺',
                      movies: state.dramaMovies,
                      onViewMore: () => _navigateViewMore(
                          context, 'Phim Bộ'),
                    ),

                    // Movie Section: Cartoons
                    _buildMovieSection(
                      context,
                      title: 'Hoạt Hình Nổi Bật 🎨',
                      movies: state.cartoonMovies,
                      onViewMore: () => _navigateViewMore(
                          context, 'Hoạt Hình'),
                    ),

                    // Movie Section: TV Shows
                    _buildMovieSection(
                      context,
                      title: 'TV Shows Hot 🎭',
                      movies: state.tvShowsMovies,
                      onViewMore: () => _navigateViewMore(
                          context, 'TV Shows'),
                    ),
                  ],

                  const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Error State ────────────────────────────────────────
  Widget _buildErrorState(AppColors colors, MovieHomeState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: colors.error, size: 48),
          const SizedBox(height: 12),
          Text(
            state.errorMessage ?? 'Có lỗi xảy ra khi tải dữ liệu',
            style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentPrimary),
            onPressed: () {
              context
                  .read<MovieHomeBloc>()
                  .add(const MovieHomeEvent.fetchHomeData());
            },
            child: Text('Thử lại',
                style: AppTextStyles.buttonSmall
                    .copyWith(color: colors.accentOnAccent)),
          ),
        ],
      ),
    );
  }

  // ─── App Bar ────────────────────────────────────────────
  Widget _buildAppBar(AppColors colors) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colors.accentPrimary, colors.accentSecondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.accentGlow,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.movie_creation_rounded,
                color: colors.accentOnAccent, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'XEM PHIM',
            style: AppTextStyles.appBarTitle.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  // ─── Hero Carousel with Page Indicators ─────────────────
  Widget _buildHeroCarousel(
      BuildContext context, List<MovieEntity> movies, AppColors colors) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: AppDimensions.heroHeight,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  _pauseAutoScroll();
                }
                return false;
              },
              child: PageView.builder(
                controller: _heroController,
                physics: const BouncingScrollPhysics(),
                itemCount: null, // infinite scroll
                onPageChanged: (index) {
                  setState(() => _currentHeroPage = index);
                },
                itemBuilder: (context, index) {
                  final movie = movies[index % movies.length];
                  return _buildHeroCard(context, movie);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(movies.length, (index) {
              final isActive = (_currentHeroPage % movies.length) == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? colors.accentPrimary : colors.iconInactive,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ─── Continue Watching Section ──────────────────────────
  Widget _buildContinueWatchingSection(
      BuildContext context, AppColors colors) {
    return BlocBuilder<WatchHistoryBloc, WatchHistoryState>(
      builder: (context, state) {
        if (state.history.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

        final recentHistory = state.history.take(10).toList();

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                colors,
                title: 'Tiếp tục xem ▶',
                onViewMore: null,
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: recentHistory.length,
                  itemBuilder: (context, index) {
                    final item = recentHistory[index];
                    return _buildContinueWatchingCard(
                        context, item, colors);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContinueWatchingCard(
      BuildContext context, WatchHistoryEntity item, AppColors colors) {
    final imageUrl = CardMovie.resolveImageUrl(
        item.posterUrl.isNotEmpty ? item.posterUrl : item.thumbUrl);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InforMovieScreen(slugMovie: item.slug),
          ),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          color: colors.cardBg,
          border: Border.all(color: colors.border),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.play_circle_fill_rounded,
                          color: colors.accentPrimary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item.lastEpisodeName.isNotEmpty
                            ? item.lastEpisodeName
                            : 'Tập ${item.lastEpisodeIndex + 1}',
                        style: TextStyle(
                          color: colors.accentPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Category Pills ─────────────────────────────────────
  Widget _buildCategoryPill(
      _CategoryItem category, int index, VoidCallback onTap) {
    final isSelected = selectedCategoryIndex == index;
    final colors = context.appColors;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentPrimary : colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
          border: Border.all(
            color: isSelected ? colors.accentPrimary : colors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.accentGlow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 16,
              color:
                  isSelected ? colors.accentOnAccent : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: AppTextStyles.labelMedium.copyWith(
                color:
                    isSelected ? colors.accentOnAccent : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Category Results ───────────────────────────────────
  Widget _buildCategoryResults(
      BuildContext context, MovieHomeState state, AppColors colors) {
    if (state.isCategoryLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: colors.accentPrimary),
          ),
        ),
      );
    }

    if (state.categoryMovies.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.movie_filter_outlined,
                    size: 48, color: colors.iconInactive),
                const SizedBox(height: 8),
                Text(
                  'Không có phim nào trong danh mục này',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = state.categoryMovies[index];
            return CardMovie(
              movie: movie,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InforMovieScreen(slugMovie: movie.slug),
                  ),
                );
              },
            );
          },
          childCount: state.categoryMovies.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsiveColumnCount,
          mainAxisExtent: AppDimensions.movieCardHeight,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
      ),
    );
  }

  // ─── Hero Card ──────────────────────────────────────────
  Widget _buildHeroCard(BuildContext context, MovieEntity movie) {
    final colors = context.appColors;
    final imageUrl = CardMovie.resolveImageUrl(
        movie.posterUrl.isNotEmpty ? movie.posterUrl : movie.thumbUrl);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.heroRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  colors.scaffoldBg.withValues(alpha: 0.5),
                  colors.scaffoldBg,
                ],
                stops: const [0.3, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.accentPrimary,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Text(
                    movie.quality.isNotEmpty ? movie.quality : 'HD',
                    style: AppTextStyles.badge
                        .copyWith(color: colors.accentOnAccent),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentPrimary,
                    foregroundColor: colors.accentOnAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InforMovieScreen(slugMovie: movie.slug),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: Text(
                    'Xem Ngay',
                    style: AppTextStyles.buttonSmall
                        .copyWith(color: colors.accentOnAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms);
  }

  // ─── Section Header ─────────────────────────────────────
  Widget _buildSectionHeader(
    AppColors colors, {
    required String title,
    required VoidCallback? onViewMore,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle
                .copyWith(color: colors.textPrimary),
          ),
          if (onViewMore != null)
            GestureDetector(
              onTap: onViewMore,
              child: Text(
                'Xem tất cả',
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.accentPrimary),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Movie Section ──────────────────────────────────────
  Widget _buildMovieSection(
    BuildContext context, {
    required String title,
    required List<MovieEntity> movies,
    required VoidCallback onViewMore,
  }) {
    final colors = context.appColors;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(colors, title: title, onViewMore: onViewMore),
          SizedBox(
            height: AppDimensions.movieCardHeight,
            child: movies.isEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: AppDimensions.movieCardWidth,
                          decoration: BoxDecoration(
                            color: colors.cardBg,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.movieCardRadius),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colors.accentPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: AppDimensions.movieCardWidth,
                          child: CardMovie(
                            movie: movie,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InforMovieScreen(
                                      slugMovie: movie.slug),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _navigateViewMore(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewMoreScreen(type, 1, 12, 'desc', '', 0),
      ),
    );
  }
}

/// Helper model for category pills
class _CategoryItem {
  final String label;
  final IconData icon;
  final String slug;

  const _CategoryItem(this.label, this.icon, this.slug);
}
