import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';

enum FavoriteSortType {
  newest,
  nameAZ,
  year,
}

class FavoriteBarScreen extends StatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  State<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends State<FavoriteBarScreen> {
  FavoriteSortType _sortType = FavoriteSortType.newest;

  @override
  void initState() {
    super.initState();
    context
        .read<MovieFavoriteBloc>()
        .add(const MovieFavoriteEvent.fetchFavorites());
  }

  List<MovieEntity> _sortMovies(List<MovieEntity> movies) {
    final sorted = List<MovieEntity>.from(movies);
    switch (_sortType) {
      case FavoriteSortType.newest:
        return sorted; // Already sorted by add time from Firestore
      case FavoriteSortType.nameAZ:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        return sorted;
      case FavoriteSortType.year:
        sorted.sort((a, b) => b.year.compareTo(a.year));
        return sorted;
    }
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
          'Phim yêu thích',
          style: AppTextStyles.appBarTitle.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md, vertical: 12),
          child: BlocBuilder<MovieFavoriteBloc, MovieFavoriteState>(
            builder: (context, state) {
              if (state.status == MovieFavoriteStatus.loading &&
                  state.favoriteMovies.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                      color: colors.accentPrimary),
                );
              }

              if (state.favoriteMovies.isEmpty) {
                return _buildEmptyState(colors);
              }

              final sortedMovies = _sortMovies(state.favoriteMovies);

              return RefreshIndicator(
                color: colors.accentPrimary,
                onRefresh: () async {
                  context
                      .read<MovieFavoriteBloc>()
                      .add(const MovieFavoriteEvent.fetchFavorites());
                },
                child: Column(
                  children: [
                    // Sort Options Bar
                    _buildSortBar(colors, state.favoriteMovies.length),
                    const SizedBox(height: 14),

                    // Movie Grid
                    Expanded(
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: sortedMovies.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.responsiveColumnCount,
                          mainAxisExtent: AppDimensions.movieCardHeight,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final movie = sortedMovies[index];
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
                            removeFavorite: () =>
                                _confirmRemove(context, movie.slug),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ─── Sort Bar ───────────────────────────────────────────
  Widget _buildSortBar(AppColors colors, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count phim đã lưu',
          style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
        ),
        PopupMenuButton<FavoriteSortType>(
          initialValue: _sortType,
          color: colors.sheetBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          onSelected: (type) => setState(() => _sortType = type),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort_rounded,
                    size: 16, color: colors.accentPrimary),
                const SizedBox(width: 6),
                Text(
                  _sortLabel,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: FavoriteSortType.newest,
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 16, color: colors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Mới thêm',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: colors.textPrimary)),
                ],
              ),
            ),
            PopupMenuItem(
              value: FavoriteSortType.nameAZ,
              child: Row(
                children: [
                  Icon(Icons.sort_by_alpha_rounded,
                      size: 16, color: colors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Tên A-Z',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: colors.textPrimary)),
                ],
              ),
            ),
            PopupMenuItem(
              value: FavoriteSortType.year,
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 16, color: colors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Năm sản xuất',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: colors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String get _sortLabel {
    switch (_sortType) {
      case FavoriteSortType.newest:
        return 'Mới thêm';
      case FavoriteSortType.nameAZ:
        return 'Tên A-Z';
      case FavoriteSortType.year:
        return 'Năm';
    }
  }

  // ─── Empty State ────────────────────────────────────────
  Widget _buildEmptyState(AppColors colors) {
    return RefreshIndicator(
      color: colors.accentPrimary,
      onRefresh: () async {
        context
            .read<MovieFavoriteBloc>()
            .add(const MovieFavoriteEvent.fetchFavorites());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colors.accentGlow,
                      colors.accentPrimary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: colors.accentPrimary,
                  size: 54,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Danh sách yêu thích trống',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Nhấn biểu tượng trái tim ở phim để lưu lại xem sau',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: colors.textTertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Remove Confirm Dialog ──────────────────────────────
  void _confirmRemove(BuildContext context, String slug) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (contextDialog) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.dialogBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: colors.error, size: 40),
              const SizedBox(height: 12),
              Text(
                'Bỏ yêu thích phim này?',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(contextDialog),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.error,
                      ),
                      onPressed: () {
                        Navigator.pop(contextDialog);
                        context.read<MovieFavoriteBloc>().add(
                            MovieFavoriteEvent.removeFavorite(slug));
                        OverlayScreen().showOverlay(
                          context,
                          'Đã xóa khỏi danh sách yêu thích',
                          colors.error,
                          duration: 2,
                        );
                      },
                      child: const Text('Xóa',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
