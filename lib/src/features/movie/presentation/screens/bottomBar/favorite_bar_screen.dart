import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/features/movie/data/models/movie_model.dart';
import 'package:movie_app/src/features/movie/presentation/screens/components/infor_movie_screen.dart';
import 'package:movie_app/src/core/configs/overlay_screen.dart';
import 'package:movie_app/src/core/widgets/card_movie.dart';
import 'package:movie_app/src/features/movie/presentation/providers/movie_providers.dart';

class FavoriteBarScreen extends ConsumerStatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  ConsumerState<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends ConsumerState<FavoriteBarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future<void> loadData() async {
    final data = await ref.read(getFavoriteMoviesUseCaseProvider).call();
    if (!mounted) return;
    ref.read(getFavoriteMoviesNotifierProvider.notifier).initState(data);
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(getFavoriteMoviesNotifierProvider);
    final dataFavorites = data.values.toList();
    final sizeWidth = MediaQuery.of(context).size.width;

    int columnCount = sizeWidth < 600
        ? 2
        : sizeWidth <= 900
            ? 3
            : sizeWidth <= 1300
                ? 4
                : 5;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF090A0F),
                Color(0xFF10121D),
              ],
            ),
          ),
        ),
        title: Text(
          'favoritesScreen.title'.tr(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090A0F), Color(0xFF141622), Color(0xFF090A0F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glassmorphic Search Anchor Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SearchAnchor.bar(
                  isFullScreen: false,
                  barHintText: 'search.hint'.tr(),
                  barElevation: const WidgetStatePropertyAll(0),
                  barBackgroundColor: WidgetStatePropertyAll(
                      Colors.white.withValues(alpha: 0.06)),
                  barOverlayColor: WidgetStatePropertyAll(
                      Colors.white.withValues(alpha: 0.05)),
                  barTextStyle: const WidgetStatePropertyAll(
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  barHintStyle: WidgetStatePropertyAll(
                    TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  barShape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  barLeading:
                      const Icon(Icons.search, color: Colors.orangeAccent),
                  suggestionsBuilder: (context, controller) {
                    final search = controller.text.toLowerCase();
                    final results = dataFavorites
                        .where((e) => e['name'].toLowerCase().contains(search))
                        .toList();
                    if (results.isEmpty) {
                      return [
                        ListTile(
                          title: Text(
                            'search.noResult'.tr(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      ];
                    }
                    return results.map((movie) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie['poster_url'],
                              width: 45,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            movie['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InforMovieScreen(
                                slugMovie: movie['slug'],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: dataFavorites.isNotEmpty
                    ? GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dataFavorites.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 260,
                        ),
                        itemBuilder: (context, index) {
                          final movie = dataFavorites[index];
                          return CardMovie(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InforMovieScreen(
                                  slugMovie: movie['slug'],
                                ),
                              ),
                            ),
                            removeFavorite: () => _confirmRemove(movie['slug']),
                            movie: MovieData.fromJson(movie),
                            isLink: true,
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Colors.orangeAccent.withValues(alpha: 0.1),
                              ),
                              child: const Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.orangeAccent,
                                size: 54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'favoritesScreen.emptyMessage'.tr(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'search.hint'.tr(),
                              style: const TextStyle(
                                color: Colors.white30,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRemove(String slug) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C29),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'settingsScreen.notifications.title'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'dialog.confirmFavorite'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('navigation.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        removeFavoriteMovie(slug);
                      },
                      child: Text('navigation.confirm'.tr()),
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

  Future<void> removeFavoriteMovie(String slug) async {
    final result =
        await ref.read(removeFavoriteMovieUseCaseProvider).call(slug);
    if (!mounted) return;
    if (result) {
      ref.read(getFavoriteMoviesNotifierProvider.notifier).removeState(slug);
      OverlayScreen().showOverlay(
          context, 'success.removeFavorite'.tr(), Colors.green,
          duration: 3);
    } else {
      OverlayScreen().showOverlay(
          context, 'errors.removeFavorite'.tr(), Colors.red,
          duration: 3);
    }
  }
}
