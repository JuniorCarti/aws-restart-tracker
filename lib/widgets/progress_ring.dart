import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.secondary;
    final bgColor = backgroundColor ?? Colors.grey.shade200;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(bgColor),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeCap: StrokeCap.round,
          ),
          // Center text
          Center(
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}