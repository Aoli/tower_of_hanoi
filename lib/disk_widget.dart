import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class DiskWidget extends StatelessWidget {
  final int diskSize;
  final double diskWidth;
  final double diskHeight;
  final Color diskColor;
  final bool isSelected;
  final bool isSmallScreen;

  const DiskWidget({
    super.key,
    required this.diskSize,
    required this.diskWidth,
    required this.diskColor,
    required this.isSelected,
    this.diskHeight = 24.0,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    // More aggressive scaling for small screens
    final double margin = isSmallScreen
        ? (isSelected ? 1.5 : 0.5) // Even smaller margins
        : (isSelected ? 4.0 : 1.0);
    final double borderRadius = isSmallScreen ? 6.0 : 12.0; // Smaller rounding
    final double borderWidth = isSmallScreen
        ? (isSelected ? 1.0 : 0.5) // Thinner borders
        : (isSelected ? 2.0 : 1.0);
    final double shadowBlur = isSmallScreen
        ? (isSelected ? 2 : 0) // Minimal shadow on small screens
        : (isSelected ? 6 : 2);

    return Container(
      margin: EdgeInsets.only(bottom: margin),
      height: diskHeight,
      width: diskWidth,
      decoration: BoxDecoration(
        color: diskColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected
              ? Colors.blue.shade600
              : Colors.black.withOpacity(
                  isSmallScreen ? 0.1 : 0.2,
                ), // Lighter border
          width: borderWidth,
        ),
        boxShadow: isSmallScreen && !isSelected
            ? [] // No shadow for unselected disks on small screens
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.3 : 0.15),
                  blurRadius: shadowBlur,
                  offset: Offset(0, isSelected ? 2 : 1),
                ),
              ],
      ),
    );
  }
}
