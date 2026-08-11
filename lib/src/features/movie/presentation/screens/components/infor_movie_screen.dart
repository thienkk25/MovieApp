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
                child: Text(
                  state.errorMessage ?? 'Không thể tải thông tin phim',
                  style: const TextStyle(color: Colors.white70),
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
                height: MediaQuery.of(context).size.height * 0.5,
                child: Opacity(
                  opacity: 0.25,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colors.scaffoldBgSecondary,
                      ],
                      stops: const [0.0, 0.45],
                    ),
                  ),
                ),
              ),

              // Foreground Scrollable View
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
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
                          icon: Icon(
                            state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                state.isFavorite ? Colors.redAccent : Colors.white,
                          ),
                          onPressed: () => context
                              .read<MovieDetailBloc>()
                              .add(const MovieDetailEvent.toggleFavorite()),
                        ),
                      ],
                    ),

                    // Player or Poster Banner with Big Play Button
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (isWatching && detail.episodes.isNotEmpty) ...[
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: WatchMovieWidget(
                                detail: detail,
                                serverIndex: state.selectedServerIndex,
                                episodeIndex: state.selectedEpisodeIndex,
                              ),
                            ),
                          ] else ...[
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                                      color: Colors.black.withValues(alpha: 0.35),
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => isWatching = true);
                                        },
                                        child: Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.amber,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.amber
                                                    .withValues(alpha: 0.4),
                                                blurRadius: 20,
                                                spreadRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Main Info Card
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: colors.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: colors.textPrimary,
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

                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    _buildBadge(movie.quality, Colors.amber),
                                    const SizedBox(width: 8),
                                    _buildBadge(
                                        '${movie.year}', Colors.blueAccent),
                                    const SizedBox(width: 8),
                                    _buildBadge(movie.lang, Colors.greenAccent),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  'Nội dung phim',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  detail.content.replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Episode Selector Section
                          if (detail.episodes.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: colors.cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: colors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Danh sách tập',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
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
                                                .add(MovieDetailEvent.selectEpisode(
                                                  serverIndex:
                                                      state.selectedServerIndex,
                                                  episodeIndex: idx,
                                                ));
                                            setState(() => isWatching = true);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.amber
                                                  : colors.inputFill,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.amber
                                                    : colors.border,
                                              ),
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
        border: Border.all(color: color.withValues(alpha: 0.4)),
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
