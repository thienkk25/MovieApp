import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;

    int responsiveColumnCount;

    if (sizeWidth < 600) {
      responsiveColumnCount = 2;
    } else if (sizeWidth <= 800) {
      responsiveColumnCount = 3;
    } else if (sizeWidth <= 1200) {
      responsiveColumnCount = 4;
    } else {
      responsiveColumnCount = 5;
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveColumnCount,
        mainAxisExtent: 250,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
