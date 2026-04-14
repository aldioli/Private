import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _search = '';
  String? _selectedCategory;

  static const _categories = [
    _Cat('الحساب', Icons.person_outline, Color(0xFF1565C0)),
    _Cat('التحويل', Icons.send_rounded, Color(0xFF388E3C)),
    _Cat('الأمان', Icons.shield_outlined, Color(0xFFE53935)),
    _Cat('الفواتير', Icons.receipt_long_outlined, Color(0xFF8E24AA)),
    _Cat('المحفظة', Icons.account_balance_wallet_outlined, Color(0xFFFA709A)),
    _Cat('التحقق', Icons.verified_user_outlined, Color(0xFFFFA000)),
  ];

  static const _articles = [
    _Article(
      'كيف أسجل حساباً جديداً؟',
      'الحساب',
      Icons.person_add_outlined,
      '''لتسجيل حساب جديد في Beepay:
1. افتح التطبيق واضغط "إنشاء حساب"
2. أدخل رقم هاتفك اليمني
3. سيصلك رمز OTP لتأكيد رقمك
4. أدخل بياناتك الشخصية (الاسم، البريد)
5. اختر كلمة مرور قوية
6. اضغط "إنشاء الحساب"

✅ ملاحظة: تأكد من صحة رقم هاتفك لأنه سيُستخدم لإرسال رمز التحقق.''',
    ),
    _Article(
      'كيف أحول مبلغاً؟',
      'التحويل',
      Icons.send_rounded,
      '''لتحويل مبلغ عبر Beepay:
1. اضغط على "تحويل" في الشاشة الرئيسية
2. أدخل رقم المحفظة للمستلم أو اختره من المستفيدين
3. أدخل المبلغ المراد تحويله
4. راجع تفاصيل التحويل والرسوم
5. اضغط "تأكيد التحويل"
6. أدخل رمز PIN للموافقة

💡 يمكنك أيضاً مسح رمز QR للمستلم لتعبئة بياناته تلقائياً.''',
    ),
    _Article(
      'ما هي رسوم التحويل؟',
      'التحويل',
      Icons.attach_money_rounded,
      '''رسوم التحويل في Beepay:
• التحويل داخل Beepay: مجاني
• التحويل للبنوك: 0.5% من المبلغ (حد أدنى 500 ريال)
• الحد اليومي للتحويل: 500,000 ريال
• الحد الشهري: 5,000,000 ريال

🎁 للمستخدمين الذهبيين: تحويل بدون رسوم حتى 100,000 ريال يومياً.''',
    ),
    _Article(
      'كيف أغير كلمة مروري؟',
      'الأمان',
      Icons.lock_reset,
      '''لتغيير كلمة المرور:
1. اذهب إلى "حسابي" → "تغيير كلمة المرور"
2. أدخل كلمة المرور الحالية
3. أدخل كلمة المرور الجديدة (8 أحرف على الأقل)
4. أعد إدخال كلمة المرور للتأكيد
5. اضغط "حفظ"

🔒 نصيحة: اختر كلمة مرور قوية تحتوي على أحرف كبيرة وصغيرة وأرقام.''',
    ),
    _Article(
      'كيف أفعّل البصمة؟',
      'الأمان',
      Icons.fingerprint,
      '''لتفعيل تسجيل الدخول بالبصمة:
1. اذهب إلى "حسابي" → "أمان التطبيق"
2. فعّل خيار "البصمة / Face ID"
3. سيطلب منك التطبيق إدخال PIN أولاً للتحقق
4. اتبع تعليمات الجهاز لتسجيل البصمة

⚠️ يجب تفعيل رمز PIN أولاً قبل البصمة.''',
    ),
    _Article(
      'كيف أدفع فاتورة الكهرباء؟',
      'الفواتير',
      Icons.bolt_rounded,
      '''لدفع فاتورة الكهرباء:
1. اضغط "فواتير" في الشاشة الرئيسية
2. اختر "كهرباء"
3. أدخل رقم الحساب الموجود على الفاتورة
4. سيظهر مبلغ الفاتورة تلقائياً
5. اضغط "دفع الآن"
6. أكد الدفع برمز PIN

✅ يمكنك حفظ رقم حسابك لتسهيل الدفع في المرات القادمة.''',
    ),
    _Article(
      'كيف أزيد حد التحويل؟',
      'التحقق',
      Icons.upgrade_rounded,
      '''لزيادة حد التحويل:
1. وثّق هويتك عبر "توثيق الهوية (KYC)"
2. ارفع صورة الهوية الوطنية (أمامية وخلفية)
3. التقط صورة سيلفي للتحقق
4. انتظر مراجعة الطلب (24-48 ساعة)

بعد التوثيق:
• الحساب الفضي: 500,000 ريال/يوم
• الحساب الذهبي: 2,000,000 ريال/يوم''',
    ),
    _Article(
      'ماذا أفعل إذا نسيت PIN؟',
      'الأمان',
      Icons.lock_open_rounded,
      '''إذا نسيت رمز PIN:
1. في شاشة إدخال PIN، اضغط "نسيت PIN"
2. سيتم إرسال رمز OTP على هاتفك
3. أدخل الرمز للتحقق من هويتك
4. اختر رمز PIN جديداً

بديلاً: يمكنك الدخول بكلمة المرور العادية ثم تغيير PIN من الإعدادات.''',
    ),
  ];

  List<_Article> get _filtered {
    return _articles.where((a) {
      final matchCat =
          _selectedCategory == null || a.category == _selectedCategory;
      final matchSearch = _search.isEmpty ||
          a.title.contains(_search) ||
          a.category.contains(_search);
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('مركز المساعدة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'ابحث في مركز المساعدة...',
                hintStyle:
                    const TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                filled: true,
                fillColor: AppColors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat.name;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedCategory = selected ? null : cat.name;
                  }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? cat.color
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? cat.color
                            : AppColors.lightGrey,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat.icon,
                            color: selected ? Colors.white : cat.color,
                            size: 22),
                        const SizedBox(height: 4),
                        Text(cat.name,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textPrimary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Articles
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64,
                            color: AppColors.grey.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        const Text('لا توجد نتائج',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.grey,
                                fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final art = _filtered[i];
                      return InkWell(
                        onTap: () => _showArticle(context, art),
                        borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusLarge),
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.paddingM),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                                AppSizes.borderRadiusLarge),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(art.icon,
                                    color: AppColors.primaryBlue, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(art.title,
                                        style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(art.category,
                                        style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 12,
                                            color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_left,
                                  color: AppColors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showArticle(BuildContext context, _Article art) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, sc) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Icon(art.icon, color: AppColors.primaryBlue, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(art.title,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: sc,
                padding: const EdgeInsets.all(20),
                child: Text(
                  art.content,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    height: 2.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cat {
  final String name;
  final IconData icon;
  final Color color;
  const _Cat(this.name, this.icon, this.color);
}

class _Article {
  final String title;
  final String category;
  final IconData icon;
  final String content;
  const _Article(this.title, this.category, this.icon, this.content);
}
