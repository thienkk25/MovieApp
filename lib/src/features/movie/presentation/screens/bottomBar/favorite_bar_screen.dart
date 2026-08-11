import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_bloc.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_event.dart';
import 'package:movie_app/src/features/movie/presentation/bloc/movie_favorite/movie_favorite_state.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';

class FavoriteBarScreen extends StatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  State<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends State<FavoriteBarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieFavoriteBloc>().add(const MovieFavoriteEvent.fetchFavorites());
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
          child: BlocBuilder<MovieFavoriteBloc, MovieFavoriteState>(
            builder: (context, state) {
              if (state.status == MovieFavoriteStatus.loading &&
                  state.favoriteMovies.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              }

              if (state.favoriteMovies.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.amber,
                          size: 54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Danh sách yêu thích trống',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Nhấn biểu tượng trái tim ở phim để lưu lại xem sau',
                        style: TextStyle(
                          color: colors.textTertiary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.favoriteMovies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final movie = state.favoriteMovies[index];
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
                    removeFavorite: () => _confirmRemove(context, movie.slug),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline_rounded,
                  color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                'Bỏ yêu thích phim này?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(contextDialog),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.pop(contextDialog);
                        context
                            .read<MovieFavoriteBloc>()
                            .add(MovieFavoriteEvent.removeFavorite(slug));
                        OverlayScreen().showOverlay(
                            context, 'Đã xóa khỏi danh sách yêu thích', Colors.green);
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
