import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_home/movie_home_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/view_more_screen.dart';

class HomeBarScreen extends StatefulWidget {
  const HomeBarScreen({super.key});

  @override
  State<HomeBarScreen> createState() => _HomeBarScreenState();
}

class _HomeBarScreenState extends State<HomeBarScreen> {
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MovieHomeBloc>().add(const MovieHomeEvent.fetchHomeData());
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
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }

            if (state.status == MovieHomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Có lỗi xảy ra khi tải dữ liệu',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () {
                        context
                            .read<MovieHomeBloc>()
                            .add(const MovieHomeEvent.fetchHomeData());
                      },
                      child: const Text('Thử lại',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              );
            }

            final featuredMovies = state.newlyUpdatedMovies.take(5).toList();

            return RefreshIndicator(
              color: Colors.amber,
              onRefresh: () async {
                context
                    .read<MovieHomeBloc>()
                    .add(const MovieHomeEvent.fetchHomeData());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with Cinema Logo
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orangeAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.movie_creation_rounded,
                              color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'XEM PHIM',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hero Carousel Section
                  if (featuredMovies.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 380,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: featuredMovies.length,
                          itemBuilder: (context, index) {
                            final movie = featuredMovies[index];
                            return _buildHeroCard(context, movie);
                          },
                        ),
                      ),
                    ),

                  // Category Filter Pills
                  SliverToBoxAdapter(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildCategoryPill('Tất cả', 0, () {
                            setState(() => selectedCategoryIndex = 0);
                          }),
                          _buildCategoryPill('Phim Lẻ', 1, () {
                            setState(() => selectedCategoryIndex = 1);
                          }),
                          _buildCategoryPill('Phim Bộ', 2, () {
                            setState(() => selectedCategoryIndex = 2);
                          }),
                          _buildCategoryPill('Hoạt Hình', 3, () {
                            setState(() => selectedCategoryIndex = 3);
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Movie Section: Newly Updated
                  _buildMovieSection(
                    context,
                    title: 'Phim mới cập nhật 🔥',
                    movies: state.newlyUpdatedMovies,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewMoreScreen(
                              'Phim Lẻ', 1, 12, 'desc', '', 0),
                        ),
                      );
                    },
                  ),

                  // Movie Section: Single Movies
                  _buildMovieSection(
                    context,
                    title: 'Phim Lẻ Chiếu Rạp 🍿',
                    movies: state.singleMovies,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewMoreScreen(
                              'Phim Lẻ', 1, 12, 'desc', '', 0),
                        ),
                      );
                    },
                  ),

                  // Movie Section: Drama Movies
                  _buildMovieSection(
                    context,
                    title: 'Phim Bộ Đặc Sắc 📺',
                    movies: state.dramaMovies,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewMoreScreen(
                              'Phim Bộ', 1, 12, 'desc', '', 0),
                        ),
                      );
                    },
                  ),

                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String label, int index, VoidCallback onTap) {
    final isSelected = selectedCategoryIndex == index;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : colors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.amber : colors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, MovieEntity movie) {
    final colors = context.appColors;
    final imageUrl = CardMovie.resolveImageUrl(
        movie.posterUrl.isNotEmpty ? movie.posterUrl : movie.thumbUrl);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    movie.quality.isNotEmpty ? movie.quality : 'HD',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InforMovieScreen(slugMovie: movie.slug),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: const Text(
                    'Xem Ngay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms);
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                GestureDetector(
                  onTap: onViewMore,
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
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
                          width: 140,
                          decoration: BoxDecoration(
                            color: colors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
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
                          width: 140,
                          child: CardMovie(
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
}
