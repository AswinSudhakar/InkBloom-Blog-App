import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerList(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final shimmerGradient = LinearGradient(
    colors: isDarkMode
        ? [
            Colors.grey.shade800,
            Colors.grey.shade700,
            Colors.grey.shade800,
          ]
        : [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
    stops: const [0.1, 0.5, 0.9],
  );

  final baseColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300;

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Shimmer(
          direction: ShimmerDirection.ltr,
          gradient: shimmerGradient,
          child: SizedBox(
            height: 190,
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: double.infinity,
                  color: baseColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 20,
                            width: double.infinity,
                            color: baseColor),
                        Container(
                            height: 16,
                            width: double.infinity,
                            color: baseColor),
                        Container(height: 16, width: 100, color: baseColor),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
