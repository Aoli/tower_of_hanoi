import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class DiskWidget extends StatelessWidget {
  final int diskSize;
  final double diskWidth;
  final Color diskColor;
  final bool isSelected;

  const DiskWidget({
    super.key,
    required this.diskSize,
    required this.diskWidth,
    required this.diskColor,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isSelected ? 4.0 : 1.0,
      ), // Small gap between disks
      height: 24.0, // Slightly smaller height
      width: diskWidth,
      decoration: BoxDecoration(
        color: diskColor,
        borderRadius: BorderRadius.circular(12.0), // border-radius: 12px
        border: Border.all(
          color: isSelected
              ? Colors.blue.shade600
              : Colors.black.withOpacity(0.2),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.3 : 0.15),
            blurRadius: isSelected ? 6 : 2,
            offset: Offset(0, isSelected ? 3 : 1),
          ),
        ],
      ),
    );
  }
}
