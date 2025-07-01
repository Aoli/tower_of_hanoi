import 'package:flutter/material.dart';
import 'package:tower_of_hanoi/disk_widget.dart';
import 'dart:math';
import 'main.dart';


class TowerWidget extends StatelessWidget {
  final List<int> disks;
  final int numberOfDisks;
  final bool isSelected;
  final List<Color> diskColors;

  const TowerWidget({
    super.key,
    required this.disks,
    required this.numberOfDisks,
    required this.isSelected,
    required this.diskColors,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the height of the rod and disk stack based on max disks
    final double rodHeight = 180.0; // Fixed height for rod
    final double baseHeight = 16.0; // h-4
    final double rodWidth = 8.0; // w-2

    return SizedBox(
      width: 128.0, // w-32
      height: 250.0, // h-[250px]
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
                        ? Colors
                              .blue
                              .shade400 // blue-400 when selected
                        : Colors.blueGrey.shade300, // bg-slate-300
                    borderRadius: BorderRadius.circular(
                      rodWidth / 2,
                    ), // rounded-full
                  ),
                ),
                // Disks (stacked on rod)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: disks.reversed.map((diskSize) {
                    // Calculate disk width as a percentage of the tower container width
                    // The tower container has a fixed width of 128px (w-32)
                    // The original JS was `${30 + diskSize * 15}%`
                    // So, 30% of 128px + (diskSize * 15%) of 128px
                    final double diskWidthPercentage =
                        (30 + diskSize * 15) / 100;
                    final double diskWidth = 128.0 * diskWidthPercentage;

                    return DiskWidget(
                      diskSize: diskSize,
                      diskWidth: diskWidth,
                      diskColor: diskColors[(diskSize - 1) % diskColors.length],
                      isSelected:
                          isSelected &&
                          disks.isNotEmpty &&
                          disks.last == diskSize, // Only top disk is "selected"
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Tower Base (at the bottom)
          Container(
            height: baseHeight,
            width: 128.0, // Full width of tower
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade400, // bg-slate-400
              borderRadius: BorderRadius.circular(6.0), // rounded-md
            ),
          ),
        ],
      ),
    );
  }
}
