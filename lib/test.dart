import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerList() {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: 5,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Shimmer(
          direction: ShimmerDirection.ltr,
          gradient: LinearGradient(
            colors: [
              // Theme.of(context).colorScheme.primary,
              // Theme.of(context).colorScheme.primary,
              // Theme.of(context).colorScheme.primary
              // Colors.grey.shade300,
              // Colors.grey.shade100,
              // Colors.grey.shade300,

              Colors.grey.shade500.withOpacity(.4),
              Colors.grey.shade400.withOpacity(.4),
              Colors.grey.shade500.withOpacity(.4),
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
          child: SizedBox(
            height: 190,
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: double.infinity,
                  color: Colors.white,
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
                            color: Colors.white),
                        Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.white),
                        Container(height: 16, width: 100, color: Colors.white),
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
