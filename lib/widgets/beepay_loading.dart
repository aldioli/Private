import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BeepayLoading — أنيميشن لوب للأزرار
// ─────────────────────────────────────────────
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
  late Animation<double> _drawProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _drawProgress = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);
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
          painter: BeePainter(
            progress: _drawProgress.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// BeepayTransitionOverlay — شاشة انتقال كاملة
// ترسم النحلة مرة واحدة ثم تنتقل للصفحة
// ─────────────────────────────────────────────
class BeepayTransitionOverlay extends StatefulWidget {
  final Future<void> Function() operation;
  final VoidCallback onDone;
  final Color backgroundColor;
  final bool transparent;

  const BeepayTransitionOverlay({
    super.key,
    required this.operation,
    required this.onDone,
    this.backgroundColor = const Color(0xFF0D47A1),
    this.transparent = false,
  });

  /// للـ splash وتسجيل الدخول — خلفية زرقاء كاملة
  static Future<void> show({
    required BuildContext context,
    required Future<void> Function() operation,
    required VoidCallback onDone,
    Color backgroundColor = const Color(0xFF0D47A1),
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) => BeepayTransitionOverlay(
          operation: operation,
          onDone: onDone,
          backgroundColor: backgroundColor,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// للتنقل بين الشاشات — يرسم النحلة كاملاً ثم ينتقل
  static void navigate({
    required BuildContext context,
    required VoidCallback onNavigate,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (ctx, _, __) => _BeepayNavOverlay(
          onComplete: () {
            Navigator.of(ctx).pop();
            onNavigate();
          },
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  /// للتنقلات (تحويل، فواتير...) — نحلة ذهبية متوهجة بدون خلفية
  static Future<void> showNav({
    required BuildContext context,
    required Future<void> Function() operation,
    required VoidCallback onDone,
  }) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => BeepayTransitionOverlay(
          operation: operation,
          transparent: true,
          onDone: () => Navigator.of(context).pop(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    onDone();
  }

  @override
  State<BeepayTransitionOverlay> createState() =>
      _BeepayTransitionOverlayState();
}

class _BeepayTransitionOverlayState extends State<BeepayTransitionOverlay>
    with TickerProviderStateMixin {
  // 1. رسم النحلة — 2000ms خطي
  late AnimationController _drawCtrl;

  // 2. توهج + نبضة عند الاكتمال — 600ms
  late AnimationController _glowCtrl;
  late Animation<double> _glowScale;
  late Animation<double> _glowOpacity;

  // 3. ظهور النص — 400ms
  late AnimationController _textCtrl;
  late Animation<double> _textOpacity;

  // 4. تلاشي الخروج — 400ms
  late AnimationController _exitCtrl;
  late Animation<double> _exitOpacity;

  // 5. مرحلة الانتظار (بطء/انقطاع النت) — 1600ms حلقة
  late AnimationController _waitCtrl;
  late Animation<double> _waitScale;
  late Animation<double> _waitRingR;
  late Animation<double> _waitRingA;

  bool _operationDone = false;
  bool _drawDone = false;
  bool _completing = false;
  bool _waitingForNetwork = false;

  @override
  void initState() {
    super.initState();

    _drawCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _glowScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_glowCtrl);
    _glowOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_glowCtrl);

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textOpacity = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    // نبضة + حلقة صدى أثناء الانتظار
    _waitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _waitScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.06)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_waitCtrl);
    _waitRingR = Tween<double>(begin: 90, end: 145)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_waitCtrl);
    _waitRingA = Tween<double>(begin: 0.6, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_waitCtrl);

    // ابدأ رسم النحلة
    _drawCtrl.forward().then((_) {
      if (!mounted) return;
      _drawDone = true;
      if (!_operationDone) {
        // العملية لا تزال تنتظر (بطء/انقطاع النت) → ابدأ النبضة
        setState(() => _waitingForNetwork = true);
        _waitCtrl.repeat();
      } else {
        _startCompletion();
      }
    });

    // شغّل العملية بالتوازي
    widget.operation().then((_) {
      if (!mounted) return;
      _operationDone = true;
      _maybeComplete();
    }).catchError((_) {
      if (!mounted) return;
      _operationDone = true;
      _maybeComplete();
    });
  }

  void _maybeComplete() {
    if (_drawDone && _operationDone && !_completing) {
      _startCompletion();
    }
  }

  void _startCompletion() {
    if (_completing) return;
    _completing = true;
    _waitCtrl.stop();
    // تأخير بسيط لإخفاء الحلقة قبل التوهج
    final delay = _waitingForNetwork
        ? const Duration(milliseconds: 150)
        : Duration.zero;
    Future.delayed(delay, () {
      if (!mounted) return;
      setState(() => _waitingForNetwork = false);
      _glowCtrl.forward();
      _textCtrl.forward();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _exitCtrl.forward().then((_) {
          if (mounted) widget.onDone();
        });
      });
    });
  }

  @override
  void dispose() {
    _drawCtrl.dispose();
    _glowCtrl.dispose();
    _textCtrl.dispose();
    _exitCtrl.dispose();
    _waitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTransparent = widget.transparent;

    return AnimatedBuilder(
      animation: _exitCtrl,
      builder: (context, child) => Opacity(
        opacity: _exitOpacity.value,
        child: child,
      ),
      child: Material(
        color: isTransparent
            ? const Color(0xD9000000) // أسود 85% — يجعل النحلة تتوهج
            : widget.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // النحلة + التأثيرات
              AnimatedBuilder(
                animation:
                    Listenable.merge([_drawCtrl, _glowCtrl, _waitCtrl]),
                builder: (context, _) {
                  final progress = _drawCtrl.value;
                  final isComplete = progress >= 1.0;
                  final waiting = _waitingForNetwork;

                  final beeScale = waiting
                      ? _waitScale.value
                      : (isComplete ? _glowScale.value : 1.0);

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // حلقة صدى متمددة أثناء الانتظار
                      if (waiting)
                        Opacity(
                          opacity: _waitRingA.value,
                          child: Container(
                            width: _waitRingR.value * 2,
                            height: _waitRingR.value * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFD600),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),

                      // دائرة توهج عند الاكتمال
                      if (isComplete && !waiting)
                        Transform.scale(
                          scale: _glowScale.value,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFD600).withValues(
                                  alpha: _glowOpacity.value * 0.15),
                            ),
                          ),
                        ),

                      // النحلة
                      Transform.scale(
                        scale: beeScale,
                        child: CustomPaint(
                          size: const Size(160, 160),
                          painter: BeePainter(
                            progress: progress,
                            color: const Color(0xFFFFD600),
                            strokeWidth: 7.0,
                            filled: isComplete,
                            glowing: isTransparent,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 36),

              // نص الحالة
              SizedBox(
                height: 40,
                child: _waitingForNetwork
                    ? AnimatedBuilder(
                        animation: _waitCtrl,
                        builder: (context, _) {
                          final dots =
                              '.' * ((_waitCtrl.value * 4).floor() % 4);
                          return Text(
                            'جاري الاتصال$dots',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFD600),
                              fontFamily: 'Cairo',
                            ),
                          );
                        },
                      )
                    : FadeTransition(
                        opacity: _textOpacity,
                        child: Text(
                          isTransparent ? '' : 'Beepay',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD600),
                            fontFamily: 'Cairo',
                            letterSpacing: 3,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BeePainter — رسام النحلة المشترك
// ─────────────────────────────────────────────
class BeePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool filled;
  final bool glowing;

  BeePainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 0,
    this.filled = false,
    this.glowing = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final sw = strokeWidth > 0 ? strokeWidth : size.width * 0.06;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final p1 = (progress * 4).clamp(0.0, 1.0);
    final p2 = ((progress - 0.25) * 4).clamp(0.0, 1.0);
    final p3 = ((progress - 0.5) * 4).clamp(0.0, 1.0);
    final p4 = ((progress - 0.75) * 4).clamp(0.0, 1.0);

    // رسم مملوء عند الاكتمال
    if (filled && progress >= 1.0) {
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;

      canvas.drawPath(_leftWingPath(cx, cy, size), fillPaint);
      canvas.drawPath(_rightWingPath(cx, cy, size), fillPaint);
      canvas.drawPath(_bodyPath(cx, cy, size), fillPaint);
    }

    // طبقة التوهج (للتنقلات)
    if (glowing) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw * 2.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      _drawPathWithProgress(canvas, glowPaint, _leftWingPath(cx, cy, size), p1);
      _drawPathWithProgress(canvas, glowPaint, _rightWingPath(cx, cy, size), p2);
      _drawPathWithProgress(canvas, glowPaint, _bodyPath(cx, cy, size), p3);
      _drawPathWithProgress(canvas, glowPaint, _antennaPath(cx, cy, size), p4);
    }

    _drawPathWithProgress(canvas, strokePaint, _leftWingPath(cx, cy, size), p1);
    _drawPathWithProgress(canvas, strokePaint, _rightWingPath(cx, cy, size), p2);
    _drawPathWithProgress(canvas, strokePaint, _bodyPath(cx, cy, size), p3);
    _drawPathWithProgress(canvas, strokePaint, _antennaPath(cx, cy, size), p4);
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

  void _drawPathWithProgress(
      Canvas canvas, Paint paint, Path path, double progress) {
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
  bool shouldRepaint(BeePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.filled != filled ||
      oldDelegate.glowing != glowing;
}

// ─────────────────────────────────────────────
// _BeepayNavOverlay — رسم النحلة للتنقل بين الشاشات
// ─────────────────────────────────────────────
class _BeepayNavOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  const _BeepayNavOverlay({required this.onComplete});

  @override
  State<_BeepayNavOverlay> createState() => _BeepayNavOverlayState();
}

class _BeepayNavOverlayState extends State<_BeepayNavOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward().whenComplete(() {
        if (mounted) widget.onComplete();
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0D47A1),
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            size: const Size(160, 160),
            painter: BeePainter(
              progress: _ctrl.value,
              color: const Color(0xFFFFD600),
              strokeWidth: 7.0,
              filled: _ctrl.value >= 1.0,
              glowing: false,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BeepayLoadingScreen — شاشة تحميل بسيطة (للاستخدام العام)
// ─────────────────────────────────────────────
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
