import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/card_movie.dart';
import '../../../movie/domain/entities/watch_history_entity.dart';
import '../../../movie/presentation/bloc/watch_history/watch_history_bloc.dart';
import '../../../movie/presentation/bloc/watch_history/watch_history_event.dart';
import '../../../movie/presentation/bloc/watch_history/watch_history_state.dart';
import '../../../movie/presentation/screens/components/infor_movie_screen.dart';

class WatchHistoryScreen extends StatelessWidget {
  const WatchHistoryScreen({super.key});

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
          'Lịch sử xem',
          style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<WatchHistoryBloc, WatchHistoryState>(
            builder: (context, state) {
              if (state.history.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.delete_sweep_outlined,
                    color: colors.error, size: 22),
                onPressed: () =>
                    _confirmClearAll(context, colors),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WatchHistoryBloc, WatchHistoryState>(
        builder: (context, state) {
          if (state.status == WatchHistoryStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                  color: colors.accentPrimary),
            );
          }

          if (state.history.isEmpty) {
            return _buildEmptyState(colors);
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md, vertical: 8),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              return _buildHistoryTile(context, item, colors);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryTile(BuildContext context,
      WatchHistoryEntity item, AppColors colors) {
    final imageUrl = CardMovie.resolveImageUrl(
        item.posterUrl.isNotEmpty ? item.posterUrl : item.thumbUrl);

    return Dismissible(
      key: Key(item.slug),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.15),
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: Icon(Icons.delete_rounded, color: colors.error),
      ),
      onDismissed: (_) {
        context.read<WatchHistoryBloc>().add(
            WatchHistoryEvent.removeFromHistory(item.slug));
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  InforMovieScreen(slugMovie: item.slug),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              // Poster Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMd),
                child: SizedBox(
                  width: 80,
                  height: 100,
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: colors.inputFill,
                          child: Icon(Icons.movie_filter_rounded,
                              color: colors.iconInactive),
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Movie Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.labelLarge
                          .copyWith(color: colors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.originName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.originName,
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textTertiary,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.play_circle_fill_rounded,
                            color: colors.accentPrimary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          item.lastEpisodeName.isNotEmpty
                              ? item.lastEpisodeName
                              : 'Tập ${item.lastEpisodeIndex + 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.accentPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.watchedAt),
                      style: AppTextStyles.caption
                          .copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.chevron_right_rounded,
                  color: colors.iconInactive, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accentGlow,
            ),
            child: Icon(Icons.history_rounded,
                color: colors.accentPrimary, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có lịch sử xem',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Các phim bạn xem sẽ được lưu lại ở đây',
            style: AppTextStyles.bodySmall
                .copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: colors.dialogBg,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_sweep_rounded,
                  color: colors.error, size: 40),
              const SizedBox(height: 12),
              Text(
                'Xóa toàn bộ lịch sử?',
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
                      onPressed: () => Navigator.pop(ctx),
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
                        Navigator.pop(ctx);
                        context.read<WatchHistoryBloc>().add(
                            const WatchHistoryEvent
                                .clearHistory());
                      },
                      child: const Text('Xóa tất cả',
                          style:
                              TextStyle(color: Colors.white)),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';

    return '${date.day}/${date.month}/${date.year}';
  }
}
