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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make tower width responsive, but max 128
        final double towerWidth = constraints.maxWidth < 140
            ? constraints.maxWidth
            : 128.0;
        final double towerHeight = constraints.maxHeight < 260
            ? constraints.maxHeight
            : 250.0;
        final double rodHeight = towerHeight - 40.0;
        final double baseHeight = towerHeight * 0.07; // ~16px on 250px
        final double rodWidth = towerWidth * 0.06; // ~8px on 128px

        return SizedBox(
          width: towerWidth,
          height: towerHeight,
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
                        // Disk width as a percentage of tower width
                        final double diskWidthPercentage =
                            (30 + diskSize * 15) / 100;
                        final double diskWidth =
                            towerWidth * diskWidthPercentage;
                        return DiskWidget(
                          diskSize: diskSize,
                          diskWidth: diskWidth,
                          diskColor:
                              diskColors[(diskSize - 1) % diskColors.length],
                          isSelected:
                              isSelected &&
                              disks.isNotEmpty &&
                              disks.last ==
                                  diskSize, // Only top disk is "selected"
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Tower Base (at the bottom)
              Container(
                height: baseHeight,
                width: towerWidth,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade400, // bg-slate-400
                  borderRadius: BorderRadius.circular(6.0), // rounded-md
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
