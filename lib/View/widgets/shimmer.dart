import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget Shimmerloading(BuildContext context) {
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
    itemBuilder: (context, index) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer(
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
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 20,
                      color: baseColor,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 10,
                          color: baseColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 10,
                          color: baseColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 10,
                          color: baseColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 80,
                          color: baseColor,
                        ),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}
