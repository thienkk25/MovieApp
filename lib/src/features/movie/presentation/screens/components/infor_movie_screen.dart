import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/di/injection_container.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
import 'package:movie_app/src/core/theme/app_text_styles.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/domain/entities/watch_history_entity.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/watch_history/watch_history_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/watch_history/watch_history_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/watch_history/watch_history_state.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_event.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/watch_movie_screen.dart';

class InforMovieScreen extends StatelessWidget {
  final String slugMovie;

  const InforMovieScreen({super.key, required this.slugMovie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MovieDetailBloc>()
        ..add(MovieDetailEvent.fetchMovieDetail(slugMovie)),
      child: const _InforMovieScreenContent(),
    );
  }
}

class _InforMovieScreenContent extends StatefulWidget {
  const _InforMovieScreenContent();

  @override
  State<_InforMovieScreenContent> createState() =>
      __InforMovieScreenContentState();
}

class __InforMovieScreenContentState extends State<_InforMovieScreenContent> {
  bool isWatching = false;
  bool _isSynopsisExpanded = false;
  final ScrollController _episodeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      context
          .read<WatchHistoryBloc>()
          .add(const WatchHistoryEvent.loadHistory());
    } catch (_) {}
  }

  @override
  void dispose() {
    _episodeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffoldBgSecondary,
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.status == MovieDetailStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colors.accentPrimary),
            );
          }

          if (state.status == MovieDetailStatus.failure ||
              state.movieDetail == null) {
            return _buildErrorView(colors, state);
          }

          final detail = state.movieDetail!;
          final movie = detail.movie;
          final imageUrl = CardMovie.resolveImageUrl(
              movie.posterUrl.isNotEmpty ? movie.posterUrl : movie.thumbUrl);

          return Stack(
            children: [
              // Immersive Blurred Poster Backdrop
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Opacity(
                  opacity: 0.35,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Gradient Overlay Fade
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        colors.scaffoldBgSecondary.withValues(alpha: 0.85),
                        colors.scaffoldBgSecondary,
                      ],
                      stops: const [0.0, 0.35, 0.65],
                    ),
                  ),
                ),
              ),

              // Scrollable View
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Sticky Header Bar
                    _buildSliverAppBar(context, movie, state, colors),

                    // Content
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Media Player or Hero Poster
                          _buildMediaSection(
                              context, state, detail, imageUrl, colors),

                          const SizedBox(height: 22),

                          // Main Info Card
                          _buildInfoCard(context, detail, colors),

                          const SizedBox(height: 20),

                          // Episode List
                          if (detail.episodes.isNotEmpty)
                            _buildEpisodeSection(
                                context, state, detail, colors),

                          // Related Movies
                          if (state.relatedMovies.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildRelatedMovies(
                                context, state.relatedMovies, colors),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ).animate().fade(duration: 400.ms),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Error View ─────────────────────────────────────────
  Widget _buildErrorView(AppColors colors, MovieDetailState state) {
    return Scaffold(
      backgroundColor: colors.scaffoldBgSecondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: colors.error, size: 54),
            const SizedBox(height: 14),
            Text(
              state.errorMessage ?? 'Không thể tải thông tin phim',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sliver App Bar ─────────────────────────────────────
  Widget _buildSliverAppBar(BuildContext context, MovieEntity movie,
      MovieDetailState state, AppColors colors) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 16),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        movie.name,
        style: AppTextStyles.bodyLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Favorite Button
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Icon(
              state.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: state.isFavorite ? colors.error : Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            final isFav = state.isFavorite;
            context
                .read<MovieDetailBloc>()
                .add(const MovieDetailEvent.toggleFavorite());
            try {
              if (isFav) {
                context
                    .read<MovieFavoriteBloc>()
                    .add(MovieFavoriteEvent.removeFavorite(movie.slug));
                OverlayScreen().showOverlay(
                  context,
                  'Đã xóa khỏi danh sách yêu thích',
                  colors.error,
                  duration: 2,
                );
              } else {
                context
                    .read<MovieFavoriteBloc>()
                    .add(MovieFavoriteEvent.addFavorite(movie));
                OverlayScreen().showOverlay(
                  context,
                  'Đã thêm vào danh sách yêu thích!',
                  colors.success,
                  duration: 2,
                );
              }
            } catch (_) {}
          },
        ),
      ],
    );
  }

  // ─── Media Section ──────────────────────────────────────
  Widget _buildMediaSection(BuildContext context, MovieDetailState state,
      MovieDetailEntity detail, String imageUrl, AppColors colors) {
    if (isWatching && detail.episodes.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.accentGlow,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: WatchMovieWidget(
            detail: detail,
            serverIndex: state.selectedServerIndex,
            episodeIndex: state.selectedEpisodeIndex,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() => isWatching = true);
                  _saveToWatchHistory(context);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colors.accentPrimary,
                        colors.accentSecondary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.accentGlow,
                        blurRadius: 25,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: colors.accentOnAccent,
                    size: 46,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Info Card ──────────────────────────────────────────
  Widget _buildInfoCard(
      BuildContext context, MovieDetailEntity detail, AppColors colors) {
    final movie = detail.movie;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Name
          Text(
            movie.name,
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
          if (movie.originName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              movie.originName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (movie.quality.isNotEmpty)
                _buildBadge(movie.quality, colors.accentPrimary, colors),
              if (movie.year > 0)
                _buildBadge('${movie.year}', colors.info, colors),
              if (movie.lang.isNotEmpty)
                _buildBadge(movie.lang, colors.success, colors),
              if (movie.episodeCurrent.isNotEmpty)
                _buildBadge(movie.episodeCurrent, Colors.purpleAccent, colors),
            ],
          ),

          // Category Tags
          if (movie.categories.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: movie.categories.map((cat) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.inputFill,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    cat,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: colors.textSecondary),
                  ),
                );
              }).toList(),
            ),
          ],

          // Cast & Director
          if (detail.actors.isNotEmpty || detail.directors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: colors.border.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            if (detail.directors.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    'Đạo diễn: ',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: colors.accentPrimary),
                  ),
                  Expanded(
                    child: Text(
                      detail.directors.join(', '),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: colors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            if (detail.actors.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diễn viên: ',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: colors.accentPrimary),
                  ),
                  Expanded(
                    child: Text(
                      detail.actors.join(', '),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: colors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],

          const SizedBox(height: 18),
          Divider(color: colors.border.withValues(alpha: 0.5)),
          const SizedBox(height: 14),

          // Expandable Synopsis
          Text(
            'Nội dung phim',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildExpandableSynopsis(detail.content, colors),
        ],
      ),
    );
  }

  // ─── Expandable Synopsis ────────────────────────────────
  Widget _buildExpandableSynopsis(String content, AppColors colors) {
    final cleanContent = content.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cleanContent,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.6,
            color: colors.textSecondary,
          ),
          maxLines: _isSynopsisExpanded ? null : 3,
          overflow: _isSynopsisExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () =>
              setState(() => _isSynopsisExpanded = !_isSynopsisExpanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isSynopsisExpanded ? 'Thu gọn' : 'Xem thêm',
                style: AppTextStyles.labelMedium
                    .copyWith(color: colors.accentPrimary),
              ),
              const SizedBox(width: 4),
              Icon(
                _isSynopsisExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: colors.accentPrimary,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Episode Section ────────────────────────────────────
  Widget _buildEpisodeSection(BuildContext context, MovieDetailState state,
      MovieDetailEntity detail, AppColors colors) {
    return BlocBuilder<WatchHistoryBloc, WatchHistoryState>(
      builder: (context, historyState) {
        final matches =
            historyState.history.where((h) => h.slug == detail.movie.slug);
        final historyEntry = matches.isEmpty ? null : matches.first;

        final currentServer = detail.episodes[state.selectedServerIndex];
        final episodeCount = currentServer.serverData.length;

        final hasWatchedHistory = historyEntry != null &&
            historyEntry.lastServerIndex < detail.episodes.length &&
            historyEntry.lastEpisodeIndex <
                detail.episodes[historyEntry.lastServerIndex].serverData.length;

        final lastWatchedEpName = hasWatchedHistory
            ? (historyEntry.lastEpisodeName.isNotEmpty
                ? historyEntry.lastEpisodeName
                : 'Tập ${historyEntry.lastEpisodeIndex + 1}')
            : '';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách tập',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (hasWatchedHistory)
                    GestureDetector(
                      onTap: () {
                        context.read<MovieDetailBloc>().add(
                              MovieDetailEvent.selectEpisode(
                                serverIndex: historyEntry.lastServerIndex,
                                episodeIndex: historyEntry.lastEpisodeIndex,
                              ),
                            );
                        setState(() => isWatching = true);
                        _saveToWatchHistory(
                          context,
                          episodeIndex: historyEntry.lastEpisodeIndex,
                        );

                        if (_episodeScrollController.hasClients) {
                          final targetOffset =
                              historyEntry.lastEpisodeIndex * 65.0;
                          _episodeScrollController.animateTo(
                            targetOffset.clamp(
                              0.0,
                              _episodeScrollController.position.maxScrollExtent,
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        }

                        OverlayScreen().showOverlay(
                          context,
                          'Đang phát tiếp $lastWatchedEpName',
                          colors.accentPrimary,
                          duration: 2,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.accentPrimary,
                              colors.accentSecondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colors.accentGlow,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Xem tiếp $lastWatchedEpName',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (detail.episodes.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.accentGlow,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        '${detail.episodes.length} Nguồn chiếu',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.accentPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // Server Selector Tabs
              if (detail.episodes.length > 1) ...[
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(detail.episodes.length, (sIdx) {
                      final serverName =
                          detail.episodes[sIdx].serverName.isNotEmpty
                              ? detail.episodes[sIdx].serverName
                              : 'Nguồn ${sIdx + 1}';
                      final isSelected = state.selectedServerIndex == sIdx;

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<MovieDetailBloc>()
                              .add(MovieDetailEvent.selectEpisode(
                                serverIndex: sIdx,
                                episodeIndex: 0,
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.accentPrimary
                                : colors.inputFill,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: Text(
                            serverName,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? colors.accentOnAccent
                                  : colors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Episode Grid/Horizontal scroll
              if (episodeCount > 20)
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    controller: _episodeScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: episodeCount,
                    itemBuilder: (context, idx) {
                      final isLastWatched = hasWatchedHistory &&
                          state.selectedServerIndex ==
                              historyEntry.lastServerIndex &&
                          idx == historyEntry.lastEpisodeIndex;
                      return _buildEpisodeChip(
                        context,
                        state,
                        detail,
                        idx,
                        colors,
                        isLastWatched: isLastWatched,
                      );
                    },
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(episodeCount, (idx) {
                    final isLastWatched = hasWatchedHistory &&
                        state.selectedServerIndex ==
                            historyEntry.lastServerIndex &&
                        idx == historyEntry.lastEpisodeIndex;
                    return _buildEpisodeChip(
                      context,
                      state,
                      detail,
                      idx,
                      colors,
                      isLastWatched: isLastWatched,
                    );
                  }),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEpisodeChip(
    BuildContext context,
    MovieDetailState state,
    MovieDetailEntity detail,
    int idx,
    AppColors colors, {
    bool isLastWatched = false,
  }) {
    final ep = detail.episodes[state.selectedServerIndex].serverData[idx];
    final isSelected = state.selectedEpisodeIndex == idx;

    return GestureDetector(
      onTap: () {
        context.read<MovieDetailBloc>().add(MovieDetailEvent.selectEpisode(
              serverIndex: state.selectedServerIndex,
              episodeIndex: idx,
            ));
        setState(() => isWatching = true);
        _saveToWatchHistory(context, episodeIndex: idx);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    colors.accentPrimary,
                    colors.accentSecondary,
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isLastWatched ? colors.accentGlow : colors.inputFill),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected
                ? colors.accentPrimary
                : (isLastWatched
                    ? colors.accentPrimary.withValues(alpha: 0.6)
                    : colors.border),
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
            if (isLastWatched && !isSelected) ...[
              Icon(
                Icons.history_rounded,
                size: 14,
                color: colors.accentPrimary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              ep.name.isNotEmpty ? ep.name : 'Tập ${idx + 1}',
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? colors.accentOnAccent
                    : (isLastWatched
                        ? colors.accentPrimary
                        : colors.textPrimary),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Related Movies ─────────────────────────────────────
  Widget _buildRelatedMovies(
      BuildContext context, List<MovieEntity> movies, AppColors colors) {
    if (movies.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.accentPrimary,
                        colors.accentSecondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colors.accentGlow,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colors.accentOnAccent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phim tương tự đề xuất',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dành riêng cho bạn dựa trên thể loại này',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.accentGlow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.accentPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${movies.length} phim',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colors.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal Movie Cards List
          SizedBox(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final relMovie = movies[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 140,
                    child: CardMovie(
                      movie: relMovie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InforMovieScreen(
                              slugMovie: relMovie.slug,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                    .animate()
                    .fade(
                      delay: Duration(milliseconds: 50 * index),
                      duration: const Duration(milliseconds: 350),
                    )
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Badge ──────────────────────────────────────────────
  Widget _buildBadge(String text, Color color, AppColors colors) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ─── Save to Watch History ──────────────────────────────
  void _saveToWatchHistory(BuildContext context, {int? episodeIndex}) {
    try {
      final state = context.read<MovieDetailBloc>().state;
      if (state.movieDetail == null) return;

      final detail = state.movieDetail!;
      final movie = detail.movie;
      final epIdx = episodeIndex ?? state.selectedEpisodeIndex;
      final ep = detail.episodes.isNotEmpty
          ? detail.episodes[state.selectedServerIndex].serverData[epIdx]
          : null;

      final entry = WatchHistoryEntity(
        slug: movie.slug,
        name: movie.name,
        originName: movie.originName,
        posterUrl: movie.posterUrl,
        thumbUrl: movie.thumbUrl,
        quality: movie.quality,
        episodeCurrent: movie.episodeCurrent,
        lastServerIndex: state.selectedServerIndex,
        lastEpisodeIndex: epIdx,
        lastEpisodeName: ep?.name ?? '',
        watchedAt: DateTime.now(),
      );

      context
          .read<WatchHistoryBloc>()
          .add(WatchHistoryEvent.addToHistory(entry));
    } catch (_) {
      // Silently fail if WatchHistoryBloc is not available
    }
  }
}
