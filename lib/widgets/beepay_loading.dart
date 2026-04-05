import 'package:flutter/material.dart';
import 'dart:math' as math;

class BeepayLoading extends StatefulWidget {
  final double size;
  final Color color;

  const BeepayLoading({
    super.key,
    this.size = 80,
    this.color = const Color(0xFFB8860B),
  });

  @override
  State<BeepayLoading> createState() => _BeepayLoadingState();
}

class _BeepayLoadingState extends State<BeepayLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wingAnimation;
  late Animation<double> _bodyAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _wingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _bodyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
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
          size: Size(widget.size, widget.size),
          painter: _BeePainter(
            wingProgress: _wingAnimation.value,
            bodyProgress: _bodyAnimation.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _BeePainter extends CustomPainter {
  final double wingProgress;
  final double bodyProgress;
  final Color color;

  _BeePainter({
    required this.wingProgress,
    required this.bodyProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // رسم الجناح الأيسر
    _drawPathWithProgress(canvas, paint, _leftWingPath(cx, cy, size), wingProgress);

    // رسم الجناح الأيمن
    _drawPathWithProgress(canvas, paint, _rightWingPath(cx, cy, size), wingProgress);

    // رسم جسم النحلة (قطرة)
    _drawPathWithProgress(canvas, paint, _bodyPath(cx, cy, size), bodyProgress);

    // رسم الهوائيات
    _drawPathWithProgress(canvas, paint, _antennaPath(cx, cy, size), wingProgress);
  }

  Path _leftWingPath(double cx, double cy, Size size) {
    final path = Path();
    final w = size.width;
    path.moveTo(cx, cy * 0.7);
    path.cubicTo(
      cx - w * 0.05, cy * 0.3,
      cx - w * 0.45, cy * 0.25,
      cx - w * 0.35, cy * 0.65,
    );
    path.cubicTo(
      cx - w * 0.3, cy * 0.85,
      cx - w * 0.05, cy * 0.8,
      cx, cy * 0.7,
    );
    return path;
  }

  Path _rightWingPath(double cx, double cy, Size size) {
    final path = Path();
    final w = size.width;
    path.moveTo(cx, cy * 0.7);
    path.cubicTo(
      cx + w * 0.05, cy * 0.3,
      cx + w * 0.45, cy * 0.25,
      cx + w * 0.35, cy * 0.65,
    );
    path.cubicTo(
      cx + w * 0.3, cy * 0.85,
      cx + w * 0.05, cy * 0.8,
      cx, cy * 0.7,
    );
    return path;
  }

  Path _bodyPath(double cx, double cy, Size size) {
    final path = Path();
    final h = size.height;
    // الجسم على شكل قطرة / مثلث مدور
    path.moveTo(cx, cy * 0.7);
    path.cubicTo(
      cx - size.width * 0.18, cy * 0.9,
      cx - size.width * 0.18, h * 0.85,
      cx, h * 0.92,
    );
    path.cubicTo(
      cx + size.width * 0.18, h * 0.85,
      cx + size.width * 0.18, cy * 0.9,
      cx, cy * 0.7,
    );
    return path;
  }

  Path _antennaPath(double cx, double cy, Size size) {
    final path = Path();
    final h = size.height;
    // هوائي أيسر
    path.moveTo(cx - size.width * 0.04, cy * 0.65);
    path.quadraticBezierTo(
      cx - size.width * 0.15, h * 0.12,
      cx - size.width * 0.12, h * 0.06,
    );
    // هوائي أيمن
    path.moveTo(cx + size.width * 0.04, cy * 0.65);
    path.quadraticBezierTo(
      cx + size.width * 0.15, h * 0.12,
      cx + size.width * 0.12, h * 0.06,
    );
    return path;
  }

  void _drawPathWithProgress(Canvas canvas, Paint paint, Path path, double progress) {
    if (progress <= 0) return;
    if (progress >= 1) {
      canvas.drawPath(path, paint);
      return;
    }

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final extractPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(_BeePainter oldDelegate) =>
      oldDelegate.wingProgress != wingProgress ||
      oldDelegate.bodyProgress != bodyProgress;
}

// Widget جاهز للاستخدام في شاشة التحميل
class BeepayLoadingScreen extends StatelessWidget {
  final String message;

  const BeepayLoadingScreen({
    super.key,
    this.message = 'جاري المعالجة...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFD600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BeepayLoading(size: 120, color: Color(0xFFB8860B)),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB8860B),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
