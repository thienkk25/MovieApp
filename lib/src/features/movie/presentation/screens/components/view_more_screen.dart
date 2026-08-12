import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_app/src/core/di/injection_container.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/core/widgets/shimmer_loading.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/domain/usecases/movie_usecases.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';

class ViewMoreScreen extends StatefulWidget {
  final String type;
  final int page;
  final int limit;
  final String sortType;
  final String country;
  final int year;

  const ViewMoreScreen(
    this.type,
    this.page,
    this.limit,
    this.sortType,
    this.country,
    this.year, {
    super.key,
  });

  @override
  State<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  final ScrollController scrollController = ScrollController();
  List<MovieEntity> movies = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasError = false;
  int currentPage = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    currentPage = widget.page;
    _loadMovies();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300 &&
        !isLoadingMore &&
        hasMore &&
        !hasError) {
      _loadMoreMovies();
    }
  }

  Future<void> _loadMovies({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        currentPage = widget.page;
        hasMore = true;
        hasError = false;
      });
    }

    final useCase = sl<GetCategoryMoviesUseCase>();
    final result = await useCase(CategoryMoviesParams(
      type: widget.type,
      page: currentPage,
      limit: widget.limit,
    ));

    result.fold(
      (_) => setState(() {
        isLoading = false;
        hasError = true;
      }),
      (data) {
        setState(() {
          movies = data;
          isLoading = false;
          hasError = false;
          if (data.length < widget.limit) {
            hasMore = false;
          }
        });
      },
    );
  }

  Future<void> _loadMoreMovies() async {
    setState(() => isLoadingMore = true);
    final nextPage = currentPage + 1;
    final useCase = sl<GetCategoryMoviesUseCase>();
    final result = await useCase(CategoryMoviesParams(
      type: widget.type,
      page: nextPage,
      limit: widget.limit,
    ));

    result.fold(
      (_) => setState(() => isLoadingMore = false),
      (data) {
        setState(() {
          currentPage = nextPage;
          movies.addAll(data);
          isLoadingMore = false;
          if (data.isEmpty || data.length < widget.limit) {
            hasMore = false;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
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
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: colors.textPrimary, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.type,
              style: AppTextStyles.appBarTitle.copyWith(
                color: colors.textPrimary,
                fontSize: 18,
              ),
            ),
            if (movies.isNotEmpty)
              Text(
                '${movies.length} phim đã tải',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.textTertiary,
                  fontSize: 11,
                ),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const ShimmerLoading()
          : hasError && movies.isEmpty
              ? _buildErrorView(colors)
              : movies.isEmpty
                  ? _buildEmptyView(colors)
                  : RefreshIndicator(
                      color: colors.accentPrimary,
                      onRefresh: () => _loadMovies(isRefresh: true),
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: movies.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: context.responsiveColumnCount,
                                mainAxisExtent: AppDimensions.movieCardHeight,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return CardMovie(
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
                                )
                                    .animate()
                                    .fade(
                                      duration: const Duration(milliseconds: 300),
                                    )
                                    .scale(
                                      begin: const Offset(0.95, 0.95),
                                      end: const Offset(1, 1),
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            ),
                          ),
                          if (isLoadingMore)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: colors.cardBg,
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.pillRadius),
                                border: Border.all(color: colors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.accentGlow,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: colors.accentPrimary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Đang tải thêm phim...',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: colors.accentPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildErrorView(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 56, color: colors.error),
          const SizedBox(height: 16),
          Text(
            'Không thể kết nối đến máy chủ',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vui lòng kiểm tra lại kết nối mạng của bạn',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accentPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
            onPressed: () {
              setState(() => isLoading = true);
              _loadMovies();
            },
            child: Text(
              'Thử lại',
              style: AppTextStyles.buttonSmall.copyWith(
                color: colors.accentOnAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter_outlined,
              size: 56, color: colors.iconInactive),
          const SizedBox(height: 16),
          Text(
            'Chưa có phim nào trong danh mục này',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
