import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../../features/movie/domain/entities/movie_entity.dart';

class CardMovie extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? removeFavorite;
  final MovieEntity movie;
  final bool? isNewMovie;

  const CardMovie({
    super.key,
    required this.onTap,
    required this.movie,
    this.removeFavorite,
    this.isNewMovie,
  });

  static String resolveImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return 'https://phimimg.com$url';
    return 'https://phimimg.com/$url';
  }

  @override
  State<CardMovie> createState() => _CardMovieState();
}

class _CardMovieState extends State<CardMovie>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final movie = widget.movie;
    final imageUrl = CardMovie.resolveImageUrl(
        movie.posterUrl.isNotEmpty ? movie.posterUrl : movie.thumbUrl);

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(AppDimensions.movieCardRadius),
            color: colors.cardBg,
            border: Border.all(
              color: colors.borderLight,
              width: AppDimensions.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Image
              _buildPosterImage(imageUrl, colors),

              // Top Dark Shadow for Badges
              _buildTopShadow(),

              // Quality & Episode Badges
              _buildBadges(colors),

              // Bottom Gradient with Title
              _buildBottomInfo(colors),

              // NEW badge
              if (widget.isNewMovie == true) _buildNewBadge(colors),

              // Remove Favorite Button
              if (widget.removeFavorite != null)
                _buildRemoveFavoriteButton(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage(String imageUrl, AppColors colors) {
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Container(
          color: colors.cardBg,
          child: Center(
            child: CircularProgressIndicator(
              color: colors.accentPrimary,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: colors.cardBg,
          child: Icon(Icons.movie_filter_rounded,
              color: colors.iconInactive, size: 40),
        ),
      );
    }
    return Container(
      color: colors.cardBg,
      child: Icon(Icons.movie_filter_rounded,
          color: colors.iconInactive, size: 40),
    );
  }

  Widget _buildTopShadow() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 50,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xB3000000),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(AppColors colors) {
    final movie = widget.movie;
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (movie.quality.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.accentPrimary, colors.accentSecondary],
                ),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXs),
                boxShadow: [
                  BoxShadow(
                    color: colors.accentGlow,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                movie.quality,
                style: AppTextStyles.badge.copyWith(
                  color: colors.accentOnAccent,
                ),
              ),
            ),
          if (movie.episodeCurrent.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXs),
                border: Border.all(
                  color: colors.borderLight,
                ),
              ),
              child: Text(
                movie.episodeCurrent,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(AppColors colors) {
    final movie = widget.movie;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Color(0xA6000000),
              Color(0xF2000000),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              movie.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (movie.originName.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                movie.originName,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNewBadge(AppColors colors) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colors.newBadgeColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        child: Text(
          'NEW',
          style: AppTextStyles.badge.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRemoveFavoriteButton(AppColors colors) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: widget.removeFavorite,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.borderLight,
            ),
          ),
          child: Icon(
            Icons.favorite_rounded,
            color: colors.error,
            size: 18,
          ),
        ),
      ),
    );
  }
}
