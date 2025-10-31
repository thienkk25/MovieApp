import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/screens/compoments/infor_movie_screen.dart';
import 'package:movie_app/src/screens/configs/overlay_screen.dart';
import 'package:movie_app/src/screens/widgets/card_movie.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class FavoriteBarScreen extends ConsumerStatefulWidget {
  const FavoriteBarScreen({super.key});

  @override
  ConsumerState<FavoriteBarScreen> createState() => _FavoriteBarScreenState();
}

class _FavoriteBarScreenState extends ConsumerState<FavoriteBarScreen> {
  final MovieController movieController = MovieController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future<void> loadData() async {
    await movieController.getFavoriteMovies(ref);
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
            ),
          ),
        ),
        title: Text(
          'favoritesScreen.title'.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 10,
            children: [
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withValues(alpha: .3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SearchAnchor.bar(
                    isFullScreen: false,
                    barHintText: 'search.hint'.tr(),
                    barBackgroundColor: WidgetStatePropertyAll(
                        Colors.white.withValues(alpha: .3)),
                    suggestionsBuilder: (context, controller) {
                      final search = controller.text.toLowerCase();
                      final results = dataFavorites
                          .where(
                              (e) => e['name'].toLowerCase().contains(search))
                          .toList();
                      if (results.isEmpty) {
                        return [
                          ListTile(title: const Text('search.noResult').tr())
                        ];
                      }
                      return results.map((movie) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: movie['poster_url'],
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(movie['name']),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => InforMovieScreen(
                                      slugMovie: movie['slug']))),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: dataFavorites.isNotEmpty
                    ? GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dataFavorites.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
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
                                          ))),
                              removeFavorite: () =>
                                  _confirmRemove(movie['slug']),
                              movie: MovieData.fromJson(movie),
                              isLink: true);
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.movie_creation_outlined,
                                color: Colors.white54, size: 60),
                            const SizedBox(height: 10),
                            Text('favoritesScreen.emptyMessage'.tr(),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16)),
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'settingsScreen.notifications.title'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'dialog.confirmFavorite'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('navigation.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
    final result = await movieController.removeFavoriteMovie(slug);
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
