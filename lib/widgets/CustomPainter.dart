import 'dart:math';

import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final double dotRadius;
  final Color dotColor;
  final Duration dotAnimationDuration;

  const TypingIndicator({
    Key? key,
    this.dotRadius = 4.0,
    this.dotColor = Colors.grey,
    this.dotAnimationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.dotAnimationDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.dotRadius * 4, widget.dotRadius),
          painter: TypingIndicatorPainter(
            dotRadius: widget.dotRadius,
            dotColor: widget.dotColor,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class TypingIndicatorPainter extends CustomPainter {
  final double dotRadius;
  final Color dotColor;
  final double animationValue;

  TypingIndicatorPainter({
    required this.dotRadius,
    required this.dotColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    final space = dotRadius * 3;

    for (int i = 0; i < 3; i++) {
      final offset = Offset(dotRadius * 2 * i + space * i, size.height / 2);
      final progress = max(0.0, min(1.0, animationValue * 2 - i)); // Reverse the animation for each dot
      final scaledRadius = dotRadius * (1 - progress);
      canvas.drawCircle(offset, scaledRadius, paint);
    }
  }

  @override
  bool shouldRepaint(TypingIndicatorPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
