import 'package:flutter/material.dart';
import '../utils/constants.dart';

class _Faq {
  final String question;
  final String answer;
  final IconData icon;
  final Color color;

  const _Faq({
    required this.question,
    required this.answer,
    required this.icon,
    required this.color,
  });
}

const _faqs = [
  _Faq(
    question: 'كيف أفتح حساباً في YemenPay؟',
    answer:
        'انقر على "إنشاء حساب" في شاشة تسجيل الدخول، أدخل رقم هاتفك وبياناتك الأساسية، ثم قم بالتحقق برمز OTP المرسل إلى هاتفك.',
    icon: Icons.person_add_outlined,
    color: AppColors.primaryBlue,
  ),
  _Faq(
    question: 'كيف أودع رصيداً في محفظتي؟',
    answer:
        'يمكنك الإيداع بثلاث طرق:\n• بطاقة الصراف الآلي (Visa/Mastercard)\n• تحويل بنكي من أحد البنوك اليمنية\n• عبر وكيل YemenPay أو شبكات الاتصالات (يمن موبايل، MTN، سبأفون)',
    icon: Icons.add_circle_outline,
    color: AppColors.success,
  ),
  _Faq(
    question: 'ما هي رسوم التحويل؟',
    answer:
        'التحويل بين محافظ YemenPay مجاني تماماً. قد تُطبق رسوم رمزية على السحب النقدي حسب الوكيل.',
    icon: Icons.send_outlined,
    color: AppColors.warning,
  ),
  _Faq(
    question: 'ما هو الحد الأقصى للتحويل اليومي؟',
    answer:
        'الحد الأقصى للتحويل اليومي هو 1,000,000 ريال يمني. يمكن رفع الحد بالتواصل مع فريق الدعم وتقديم وثائق إضافية.',
    icon: Icons.account_balance_outlined,
    color: AppColors.info,
  ),
  _Faq(
    question: 'كيف أسحب رصيدي نقداً؟',
    answer:
        'اذهب إلى "سحب" من الخدمات السريعة، أدخل المبلغ واختر طريقة السحب. يمكنك السحب عبر وكيل YemenPay أو التحويل إلى حسابك البنكي.',
    icon: Icons.money_outlined,
    color: AppColors.error,
  ),
  _Faq(
    question: 'هل تطبيق YemenPay آمن؟',
    answer:
        'نعم، نستخدم تشفير SSL 256-bit لحماية جميع بياناتك. كما يمكنك تفعيل البصمة وFace ID لحماية إضافية. نحن نتبع أعلى معايير أمان المدفوعات الرقمية.',
    icon: Icons.security_outlined,
    color: AppColors.success,
  ),
  _Faq(
    question: 'نسيت كلمة المرور، ماذا أفعل؟',
    answer:
        'اضغط على "نسيت كلمة المرور" في شاشة تسجيل الدخول. سيُرسل رمز تحقق إلى رقم هاتفك المسجل لإعادة تعيين كلمة المرور.',
    icon: Icons.lock_reset_outlined,
    color: AppColors.warning,
  ),
  _Faq(
    question: 'كيف أدفع فواتير الكهرباء والمياه؟',
    answer:
        'اضغط على "فواتير" من الخدمات السريعة، اختر نوع الفاتورة (كهرباء، مياه، إنترنت..)، أدخل رقم الحساب والمبلغ، وأكد الدفع.',
    icon: Icons.receipt_long_outlined,
    color: Colors.purple,
  ),
  _Faq(
    question: 'هل يمكنني استخدام التطبيق بدون إنترنت؟',
    answer:
        'تتطلب معظم العمليات اتصالاً بالإنترنت. يمكنك فقط عرض آخر رصيد محفوظ والمعاملات السابقة بدون اتصال.',
    icon: Icons.wifi_off_outlined,
    color: AppColors.grey,
  ),
  _Faq(
    question: 'كيف أتواصل مع الدعم الفني؟',
    answer:
        'يمكنك التواصل معنا عبر:\n• الهاتف: ${AppConstants.supportPhone}\n• البريد: ${AppConstants.supportEmail}\n• ساعات العمل: الأحد – الخميس 8ص – 8م',
    icon: Icons.headset_mic_outlined,
    color: AppColors.primaryBlue,
  ),
];

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Faq> get _filtered {
    if (_query.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f.question.contains(_query) || f.answer.contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة الشائعة',
            style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
      ),
      body: Column(
        children: [
          // رأس ملوّن
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingL),
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontFamily: 'Cairo'),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'ابحث في الأسئلة...',
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.grey),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.lightGrey.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // القائمة
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60,
                            color: AppColors.grey.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        const Text(
                          'لا توجد نتائج',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.grey,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.paddingS),
                    itemBuilder: (context, i) =>
                        _FaqTile(faq: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final _Faq faq;
  const _FaqTile({super.key, required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _rotAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotAnim = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? const Color(0xFF1E1E2E) : AppColors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(
          color: _expanded
              ? widget.faq.color.withValues(alpha: 0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.faq.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.faq.icon,
                        color: widget.faq.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotAnim,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded ? widget.faq.color : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      color: widget.faq.color.withValues(alpha: 0.2), height: 16),
                  Text(
                    widget.faq.answer,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      height: 1.7,
                      color: isDark
                          ? Colors.white70
                          : AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
