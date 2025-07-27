import 'package:flutter/material.dart';
import 'package:tower_of_hanoi/disk_widget.dart';
import 'dart:math';
import 'main.dart';

class TowerWidget extends StatelessWidget {
  final List<int> disks;
  final int numberOfDisks;
  final bool isSelected;
  final List<Color> diskColors;
  final VoidCallback onTowerSelected;

  const TowerWidget({
    super.key,
    required this.disks,
    required this.numberOfDisks,
    required this.isSelected,
    required this.diskColors,
    required this.onTowerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive scaling based on screen size
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 375; // iPhone SE width is 320px

        // Adaptive tower sizing based on screen size
        final double minTowerWidth = isSmallScreen ? 40.0 : 60.0;
        final double maxTowerWidth = 128.0;
        final double towerWidth = constraints.maxWidth.clamp(
          minTowerWidth,
          maxTowerWidth,
        );

        // Adaptive height
        final double minTowerHeight = isSmallScreen ? 100.0 : 120.0;
        final double maxTowerHeight = 250.0;
        final double towerHeight = constraints.maxHeight.clamp(
          minTowerHeight,
          maxTowerHeight,
        );

        // Rod and base scale with tower size - REDUCED BY 30%
        final double rodHeight = towerHeight * 0.7 * 0.7; // 30% smaller
        final double rodWidth =
            towerWidth *
            (isSmallScreen ? 0.035 : 0.05); // 30% thinner rod on small screens
        final double baseHeight =
            towerHeight *
            (isSmallScreen
                ? 0.042
                : 0.056); // 30% shorter base on small screens
        final double baseWidth = towerWidth * 0.7; // 30% narrower base
        final double baseRadius =
            towerWidth * 0.035 +
            (isSmallScreen ? 0.7 : 1.4); // 30% smaller corners

        // Calculate disk height based on available height and number of disks
        final double diskHeight = min(
          24.0, // max height on large screens
          (towerHeight * 0.6) /
              (numberOfDisks +
                  1), // scale down for more disks or smaller screens
        );

        return Column(
          children: [
            // Button at the top
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: onTowerSelected,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.blue.shade600
                      : Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmallScreen ? 4 : 8,
                  ),
                  textStyle: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Select'),
              ),
            ),
            // Tower visual wrapped in Expanded to fill remaining space
            Expanded(
              child: SizedBox(
                width: towerWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Disk Stack (above the rod)
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Tower Rod (background)
                          Container(
                            width: rodWidth,
                            height: rodHeight,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.blueGrey.shade300,
                              borderRadius: BorderRadius.circular(rodWidth / 2),
                            ),
                          ),
                          // Disks (stacked on rod)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: disks.reversed.map((diskSize) {
                              // Create more dramatic size differences between disks with 30% smaller sizes
                              final double basePercentage = isSmallScreen
                                  ? 14
                                  : 21; // 30% smaller base size
                              final double sizeMultiplier = isSmallScreen
                                  ? 7
                                  : 8.4; // 30% smaller increments

                              // Calculate disk width as percentage of tower width
                              final double diskWidthPercentage =
                                  basePercentage + (diskSize * sizeMultiplier);
                              final double diskWidth =
                                  towerWidth * (diskWidthPercentage / 100);

                              // Scale disk height based on screen size
                              final double actualDiskHeight = isSmallScreen
                                  ? min(18.0, diskHeight)
                                  : diskHeight;

                              return DiskWidget(
                                diskSize: diskSize,
                                diskWidth: diskWidth,
                                diskHeight: actualDiskHeight,
                                diskColor:
                                    diskColors[(diskSize - 1) %
                                        diskColors.length],
                                isSelected:
                                    isSelected &&
                                    disks.isNotEmpty &&
                                    disks.last == diskSize,
                                isSmallScreen: isSmallScreen,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    // Tower Base (at the bottom)
                    Container(
                      height: baseHeight,
                      width: baseWidth, // Use the narrower width
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade400,
                        borderRadius: BorderRadius.circular(baseRadius),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
