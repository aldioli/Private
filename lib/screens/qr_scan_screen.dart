import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'transfer_screen.dart';

/// شاشة مسح QR — محاكاة بدون كاميرا حقيقية
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanAnim;
  bool _scanning = true;
  bool _detected = false;
  String? _detectedWallet;

  // بيانات تجريبية لمحاكاة المسح
  static const _demoResults = [
    {'wallet': '777987654', 'name': 'أحمد محمد العمري'},
    {'wallet': '771234567', 'name': 'سارة خالد الشميري'},
    {'wallet': '733445566', 'name': 'عبدالله علي الصنعاني'},
  ];

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // محاكاة اكتشاف QR بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final result = _demoResults[0];
      setState(() {
        _scanning = false;
        _detected = true;
        _detectedWallet = result['wallet'];
      });
      _showResultSheet(result['wallet']!, result['name']!);
    });
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    super.dispose();
  }

  void _showResultSheet(String wallet, String name) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResultSheet(
        wallet: wallet,
        name: name,
        onTransfer: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TransferScreen(prefillWallet: wallet, prefillName: name),
            ),
          );
        },
        onRescan: () {
          Navigator.pop(context);
          setState(() {
            _scanning = true;
            _detected = false;
            _detectedWallet = null;
          });
          _scanAnim.repeat();
          // محاكاة نتيجة مختلفة
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            final result = _demoResults[1];
            setState(() {
              _scanning = false;
              _detected = true;
              _detectedWallet = result['wallet'];
            });
            _showResultSheet(result['wallet']!, result['name']!);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('مسح رمز QR',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
            onPressed: () {},
            tooltip: 'الفلاش',
          ),
        ],
      ),
      body: Stack(
        children: [
          // خلفية محاكاة الكاميرا
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A1A2E), Color(0xFF0A0A15)],
              ),
            ),
          ),

          // إطار المسح
          Center(
            child: _ScanFrame(animation: _scanAnim, detected: _detected),
          ),

          // تعليمات
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _detected
                        ? 'تم اكتشاف رمز QR ✓'
                        : 'وجّه الكاميرا نحو رمز QR',
                    key: ValueKey(_detected),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: _detected ? AppColors.success : Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'سيتم مسح الرمز تلقائياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // زر الإدخال اليدوي
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: OutlinedButton.icon(
              onPressed: () => _showManualEntry(),
              icon: const Icon(Icons.keyboard_rounded, color: Colors.white60),
              label: const Text('إدخال يدوي',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: Colors.white60, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntry() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E2E)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.borderRadiusLarge)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إدخال رقم المحفظة يدوياً',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '7XXXXXXXX',
                  hintStyle: const TextStyle(fontFamily: 'Cairo'),
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (ctrl.text.length >= 7) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TransferScreen(prefillWallet: ctrl.text),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                  child: const Text('متابعة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== إطار المسح ==========
class _ScanFrame extends StatelessWidget {
  final AnimationController animation;
  final bool detected;

  const _ScanFrame({super.key, required this.animation, required this.detected});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          width: 260,
          height: 260,
          child: Stack(
            children: [
              // الإطار
              CustomPaint(
                size: const Size(260, 260),
                painter: _FramePainter(detected: detected),
              ),

              // خط المسح المتحرك
              if (!detected)
                Positioned(
                  top: 20 + (animation.value * 200),
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryBlue.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),

              // أيقونة النجاح
              if (detected)
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 40),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FramePainter extends CustomPainter {
  final bool detected;

  _FramePainter({required this.detected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = detected ? AppColors.success : AppColors.primaryBlue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 30.0;
    const radius = 12.0;

    // زوايا الإطار
    // أعلى يسار
    canvas.drawLine(
        const Offset(radius, 0), const Offset(cornerLen, 0), paint);
    canvas.drawLine(
        const Offset(0, radius), const Offset(0, cornerLen), paint);

    // أعلى يمين
    canvas.drawLine(Offset(size.width - cornerLen, 0),
        Offset(size.width - radius, 0), paint);
    canvas.drawLine(Offset(size.width, radius),
        Offset(size.width, cornerLen), paint);

    // أسفل يسار
    canvas.drawLine(
        const Offset(0, 0), const Offset(0, 0), paint); // placeholder
    canvas.drawLine(
        Offset(0, size.height - cornerLen),
        Offset(0, size.height - radius),
        paint);
    canvas.drawLine(
        Offset(radius, size.height),
        Offset(cornerLen, size.height),
        paint);

    // أسفل يمين
    canvas.drawLine(
        Offset(size.width, size.height - cornerLen),
        Offset(size.width, size.height - radius),
        paint);
    canvas.drawLine(
        Offset(size.width - cornerLen, size.height),
        Offset(size.width - radius, size.height),
        paint);

    // خلفية شبه شفافة
    final bgPaint = Paint()
      ..color = (detected ? AppColors.success : AppColors.primaryBlue)
          .withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.detected != detected;
}

// ========== نتيجة المسح ==========
class _ResultSheet extends StatelessWidget {
  final String wallet;
  final String name;
  final VoidCallback onTransfer;
  final VoidCallback onRescan;

  const _ResultSheet({
    Key? key,
    required this.wallet,
    required this.name,
    required this.onTransfer,
    required this.onRescan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.borderRadiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(wallet,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.grey)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRescan,
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                  label: const Text('مسح آخر',
                      style: TextStyle(fontFamily: 'Cairo')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onTransfer,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('تحويل إليه',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
