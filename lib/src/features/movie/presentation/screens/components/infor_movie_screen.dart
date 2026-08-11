import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/di/injection_container.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_detail/movie_detail_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffoldBgSecondary,
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.status == MovieDetailStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (state.status == MovieDetailStatus.failure ||
              state.movieDetail == null) {
            return Scaffold(
              backgroundColor: colors.scaffoldBgSecondary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 54),
                    const SizedBox(height: 14),
                    Text(
                      state.errorMessage ?? 'Không thể tải thông tin phim',
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
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

              // Gradient Overlay Fade to Dark Scaffold
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

              // Scrollable Content
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Sticky Header Bar with Title & Favorite Action
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      leading: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: Icon(
                              state.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: state.isFavorite
                                  ? Colors.redAccent
                                  : Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: () => context
                              .read<MovieDetailBloc>()
                              .add(const MovieDetailEvent.toggleFavorite()),
                        ),
                      ],
                    ),

                    // Media Player Banner or Large Hero Poster
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          if (isWatching && detail.episodes.isNotEmpty) ...[
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.amber.withValues(alpha: 0.15),
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
                            ),
                          ] else ...[
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFFC107),
                                                Color(0xFFFF8F00)
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.amber
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 25,
                                                spreadRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.black,
                                            size: 46,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 22),

                          // Main Info Container Card
                          Container(
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
                                Text(
                                  movie.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: colors.textPrimary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                if (movie.originName.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.originName,
                                    style: TextStyle(
                                      fontSize: 14,
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
                                      _buildBadge(movie.quality, Colors.amber),
                                    if (movie.year > 0)
                                      _buildBadge(
                                          '${movie.year}', Colors.blueAccent),
                                    if (movie.lang.isNotEmpty)
                                      _buildBadge(
                                          movie.lang, Colors.greenAccent),
                                    if (movie.episodeCurrent.isNotEmpty)
                                      _buildBadge(
                                          movie.episodeCurrent, Colors.purpleAccent),
                                  ],
                                ),

                                const SizedBox(height: 18),
                                Divider(
                                    color: colors.border.withValues(alpha: 0.5)),
                                const SizedBox(height: 14),

                                Text(
                                  'Nội dung phim',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  detail.content
                                      .replaceAll(RegExp(r'<[^>]*>'), '')
                                      .trim(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Server & Episode List Section
                          if (detail.episodes.isNotEmpty)
                            Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Danh sách tập',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      if (detail.episodes.length > 1)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${detail.episodes.length} Server',
                                            style: const TextStyle(
                                              color: Colors.amber,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  // Server Selector Tabs (If multiple servers available)
                                  if (detail.episodes.length > 1) ...[
                                    const SizedBox(height: 14),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          detail.episodes.length,
                                          (sIdx) {
                                            final serverName = detail
                                                    .episodes[sIdx]
                                                    .serverName
                                                    .isNotEmpty
                                                ? detail.episodes[sIdx].serverName
                                                : 'Server ${sIdx + 1}';
                                            final isSelected =
                                                state.selectedServerIndex == sIdx;

                                            return GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<MovieDetailBloc>()
                                                    .add(MovieDetailEvent
                                                        .selectEpisode(
                                                      serverIndex: sIdx,
                                                      episodeIndex: 0,
                                                    ));
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 7),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Colors.amber
                                                      : colors.inputFill,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  serverName,
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.black
                                                        : colors.textSecondary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // Episode Grid Buttons
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(
                                      detail.episodes[state.selectedServerIndex]
                                          .serverData.length,
                                      (idx) {
                                        final ep = detail
                                            .episodes[state.selectedServerIndex]
                                            .serverData[idx];
                                        final isSelected =
                                            state.selectedEpisodeIndex == idx;

                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<MovieDetailBloc>()
                                                .add(MovieDetailEvent
                                                    .selectEpisode(
                                                  serverIndex:
                                                      state.selectedServerIndex,
                                                  episodeIndex: idx,
                                                ));
                                            setState(() => isWatching = true);
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              gradient: isSelected
                                                  ? const LinearGradient(
                                                      colors: [
                                                        Color(0xFFFFC107),
                                                        Color(0xFFFF8F00)
                                                      ],
                                                    )
                                                  : null,
                                              color: isSelected
                                                  ? null
                                                  : colors.inputFill,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.amber
                                                    : colors.border,
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.amber
                                                            .withValues(
                                                                alpha: 0.35),
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Text(
                                              ep.name.isNotEmpty
                                                  ? ep.name
                                                  : 'Tập ${idx + 1}',
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.black
                                                    : colors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

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

  Widget _buildBadge(String text, Color color) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
