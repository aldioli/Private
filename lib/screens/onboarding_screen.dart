import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class _Slide {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String badge;

  const _Slide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.badge,
  });
}

const _slides = [
  _Slide(
    title: 'محفظتك الرقمية\nفي اليمن',
    subtitle: 'أدِر أموالك بأمان وسهولة\nفي أي وقت ومن أي مكان',
    icon: Icons.account_balance_wallet_rounded,
    gradient: [Color(0xFF0D47A1), Color(0xFF1976D2)],
    badge: '🔐',
  ),
  _Slide(
    title: 'تحويل فوري\nبلا حدود',
    subtitle: 'أرسل واستقبل الأموال\nفي ثوانٍ معدودة',
    icon: Icons.send_rounded,
    gradient: [Color(0xFF1A237E), Color(0xFF283593)],
    badge: '⚡',
  ),
  _Slide(
    title: 'ادفع فواتيرك\nبضغطة واحدة',
    subtitle: 'كهرباء، مياه، إنترنت، شحن رصيد\nكل شيء في مكان واحد',
    icon: Icons.receipt_long_rounded,
    gradient: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
    badge: '💳',
  ),
  _Slide(
    title: 'آمن ومشفّر\n100%',
    subtitle: 'تشفير SSL 256-bit\nودعم بصمة الإصبع وFace ID',
    icon: Icons.security_rounded,
    gradient: [Color(0xFF004D40), Color(0xFF00695C)],
    badge: '🛡️',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _controller = PageController();
  int _page = 0;
  late AnimationController _iconCtrl;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;

  @override
  void initState() {
    super.initState();
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut),
    );
    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeIn),
    );
    _iconCtrl.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _iconCtrl.reset();
    _iconCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_page];
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: slide.gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // زر تخطي
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    isLast ? '' : 'تخطي',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontFamily: 'Cairo',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              // صفحات
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (_, i) => _SlidePage(
                    slide: _slides[i],
                    iconCtrl: _iconCtrl,
                    iconScale: _iconScale,
                    iconFade: _iconFade,
                  ),
                ),
              ),

              // نقاط التنقل
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // زر التالي / ابدأ
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: slide.gradient.first,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        isLast ? 'ابدأ الآن' : 'التالي',
                        key: ValueKey(isLast),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: slide.gradient.first,
                        ),
                      ),
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

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  final AnimationController iconCtrl;
  final Animation<double> iconScale;
  final Animation<double> iconFade;

  const _SlidePage({
    Key? key,
    required this.slide,
    required this.iconCtrl,
    required this.iconScale,
    required this.iconFade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة مع هالة
          AnimatedBuilder(
            animation: iconCtrl,
            builder: (_, __) => FadeTransition(
              opacity: iconFade,
              child: ScaleTransition(
                scale: iconScale,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // هالة خارجية
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    // هالة داخلية
                    Container(
                      width: 155,
                      height: 155,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    // البطاقة
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(slide.icon, color: Colors.white, size: 52),
                          Text(
                            slide.badge,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 52),

          // العنوان
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 18),

          // الوصف
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: Colors.white70,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
