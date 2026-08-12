import 'package:flutter/material.dart';
import 'package:movie_app/src/core/di/injection_container.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';
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
        hasMore) {
      _loadMoreMovies();
    }
  }

  Future<void> _loadMovies() async {
    final useCase = sl<GetCategoryMoviesUseCase>();
    final result = await useCase(CategoryMoviesParams(
      type: widget.type,
      page: currentPage,
      limit: widget.limit,
    ));

    result.fold(
      (_) => setState(() => isLoading = false),
      (data) {
        setState(() {
          movies = data;
          isLoading = false;
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
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: colors.iconSecondary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.type,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const ShimmerLoading()
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
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
                              builder: (_) =>
                                  InforMovieScreen(slugMovie: movie.slug),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (isLoadingMore)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Đang tải thêm phim...',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
