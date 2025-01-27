import 'package:flutter/material.dart';

class AnimatedBeam extends StatefulWidget {
  final Widget? fromChild;
  final Widget? toChild;
  final Offset fromOffset;
  final Offset toOffset;
  final Color pathColor;
  final Color gradientStartColor;
  final Color gradientStopColor;
  final double curvature;
  final Duration duration;
  final bool reverse;

  const AnimatedBeam({
    Key? key,
    this.fromChild,
    this.toChild,
    this.fromOffset = Offset.zero,
    this.toOffset = Offset.zero,
    this.pathColor = Colors.grey,
    this.gradientStartColor = const Color(0xFFffaa40),
    this.gradientStopColor = const Color(0xFF9c40ff),
    this.curvature = 0.0,
    this.duration = const Duration(seconds: 5),
    this.reverse = false,
  }) : super(key: key);

  @override
  _AnimatedBeamState createState() => _AnimatedBeamState();
}

class _AnimatedBeamState extends State<AnimatedBeam>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: false);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path _createBeamPath(Size size) {
    final startX = widget.fromOffset.dx;
    final startY = widget.fromOffset.dy;
    final endX = widget.toOffset.dx;
    final endY = widget.toOffset.dy;

    final controlY = startY - widget.curvature;

    final path = Path()
      ..moveTo(startX, startY)
      ..quadraticBezierTo(
        (startX + endX) / 2,
        controlY,
        endX,
        endY,
      );

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BeamPainter(
        path: _createBeamPath(MediaQuery.of(context).size),
        pathColor: widget.pathColor,
        gradientStartColor: widget.gradientStartColor,
        gradientStopColor: widget.gradientStopColor,
        animation: _gradientAnimation,
        reverse: widget.reverse,
      ),
      child: Stack(
        children: [
          if (widget.fromChild != null)
            Positioned(
              left: widget.fromOffset.dx - 25,
              top: widget.fromOffset.dy - 25,
              child: widget.fromChild!,
            ),
          if (widget.toChild != null)
            Positioned(
              left: widget.toOffset.dx - 25,
              top: widget.toOffset.dy - 25,
              child: widget.toChild!,
            ),
        ],
      ),
    );
  }
}

class _BeamPainter extends CustomPainter {
  final Path path;
  final Color pathColor;
  final Color gradientStartColor;
  final Color gradientStopColor;
  final Animation<double> animation;
  final bool reverse;

  _BeamPainter({
    required this.path,
    required this.pathColor,
    required this.gradientStartColor,
    required this.gradientStopColor,
    required this.animation,
    required this.reverse,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Base path
    final pathPaint = Paint()
      ..color = pathColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, pathPaint);

    // Gradient path
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          gradientStartColor,
          gradientStopColor,
        ],
        stops: [0.0, 1.0],
        begin: reverse ? Alignment.centerRight : Alignment.centerLeft,
        end: reverse ? Alignment.centerLeft : Alignment.centerRight,
      ).createShader(
        Rect.fromPoints(
          Offset(path.getBounds().left, path.getBounds().top),
          Offset(path.getBounds().right, path.getBounds().bottom),
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Animated gradient overlay
    final animatedPath = _createAnimatedPath(path, animation.value);
    canvas.drawPath(animatedPath, gradientPaint);
  }

  Path _createAnimatedPath(Path originalPath, double animationValue) {
    final metrics = originalPath.computeMetrics();
    final path = Path();

    for (var metric in metrics) {
      final length = metric.length;
      final start = length * animationValue;
      final end = start + length * 0.2; // Gradient length

      path.addPath(
        metric.extractPath(start, end),
        Offset.zero,
      );
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _BeamPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.path != path ||
        oldDelegate.pathColor != pathColor ||
        oldDelegate.gradientStartColor != gradientStartColor ||
        oldDelegate.gradientStopColor != gradientStopColor;
  }
}

// Animated Beam between two positioned widgets
class AnimatedBeamDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Example beam between two positioned widgets
            AnimatedBeam(
              fromOffset: Offset(100, 200),
              toOffset: Offset(300, 400),
              fromChild: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              toChild: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              pathColor: Colors.grey,
              gradientStartColor: Colors.orange,
              gradientStopColor: Colors.purple,
              curvature: 100.0,
              duration: Duration(seconds: 3),
              reverse: false,
            ),
          ],
        ),
      ),
    );
  }
}