import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/core/theme/app_dimensions.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final int columnCount = context.responsiveColumnCount;
    final int itemCount = columnCount * 3;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisExtent: AppDimensions.movieCardHeight,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colors.shimmerBase,
          highlightColor: colors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: colors.shimmerBase,
              borderRadius:
                  BorderRadius.circular(AppDimensions.movieCardRadius),
              border: Border.all(color: colors.border.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Poster Skeleton
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.movieCardRadius),
                      ),
                    ),
                  ),
                ),
                // Title & Subtitle Skeleton Lines
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colors.cardBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors.cardBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
