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

  // مرحلة الرسم: 0.0 → 0.7 (رسم كامل للنحلة)
  late Animation<double> _drawProgress;

  // مرحلة الدوران: 0.7 → 1.0 (دوران النحلة المكتملة)
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // رسم النحلة من البداية حتى الاكتمال
    _drawProgress = TweenSequence([
      // رسم تدريجي 0→1
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
      // توقف قصير عند الاكتمال
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 15,
      ),
      // إخفاء تدريجي
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    // دوران مستمر
    _rotation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
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
        return Transform.rotate(
          angle: _rotation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _BeePainter(
              progress: _drawProgress.value,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

class _BeePainter extends CustomPainter {
  final double progress;
  final Color color;

  _BeePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // تقسيم progress على المكونات الأربعة
    final p1 = (progress * 4).clamp(0.0, 1.0);        // جناح أيسر
    final p2 = ((progress - 0.25) * 4).clamp(0.0, 1.0); // جناح أيمن
    final p3 = ((progress - 0.5) * 4).clamp(0.0, 1.0);  // الجسم
    final p4 = ((progress - 0.75) * 4).clamp(0.0, 1.0); // الهوائيات

    _drawPathWithProgress(canvas, paint, _leftWingPath(cx, cy, size), p1);
    _drawPathWithProgress(canvas, paint, _rightWingPath(cx, cy, size), p2);
    _drawPathWithProgress(canvas, paint, _bodyPath(cx, cy, size), p3);
    _drawPathWithProgress(canvas, paint, _antennaPath(cx, cy, size), p4);
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
    path.moveTo(cx - size.width * 0.04, cy * 0.65);
    path.quadraticBezierTo(
      cx - size.width * 0.15, h * 0.12,
      cx - size.width * 0.12, h * 0.06,
    );
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
      oldDelegate.progress != progress;
}

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
