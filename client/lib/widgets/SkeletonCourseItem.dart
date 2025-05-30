import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCourseItem extends StatelessWidget {
  const SkeletonCourseItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: 6, // Number of skeleton loaders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 20),
                Container(height: 12, width: 100, color: Colors.grey.shade400),
                const SizedBox(height: 20),
                Container(height: 12, width: 60, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      },
    );
  }
}
