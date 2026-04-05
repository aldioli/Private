import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BusinessAccountScreen extends StatefulWidget {
  const BusinessAccountScreen({super.key});

  @override
  State<BusinessAccountScreen> createState() => _BusinessAccountScreenState();
}

class _BusinessAccountScreenState extends State<BusinessAccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.point_of_sale_rounded, 'title': 'نقطة بيع (POS)', 'desc': 'استقبل المدفوعات من عملائك بسهولة', 'color': const Color(0xFF1565C0)},
    {'icon': Icons.qr_code_rounded, 'title': 'رمز QR للدفع', 'desc': 'أنشئ رمز QR خاص بمحلك', 'color': const Color(0xFF6A1B9A)},
    {'icon': Icons.insert_chart_rounded, 'title': 'تقارير المبيعات', 'desc': 'تحليل مفصل لإيراداتك اليومية والشهرية', 'color': const Color(0xFF2E7D32)},
    {'icon': Icons.people_rounded, 'title': 'إدارة الموظفين', 'desc': 'أضف حسابات موظفين بصلاحيات محددة', 'color': const Color(0xFF00838F)},
    {'icon': Icons.receipt_rounded, 'title': 'الفواتير الإلكترونية', 'desc': 'أرسل فواتير احترافية لعملائك', 'color': const Color(0xFFE53935)},
    {'icon': Icons.account_balance_rounded, 'title': 'حساب منفصل', 'desc': 'فصل كامل بين المال الشخصي والتجاري', 'color': const Color(0xFF1B5E20)},
  ];

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'الأساسية',
      'price': 0,
      'cycle': 'مجاناً',
      'features': ['POS أساسي', 'تقرير أسبوعي', 'موظف واحد', 'رمز QR'],
      'color': const Color(0xFF546E7A),
      'recommended': false,
    },
    {
      'name': 'الاحترافية',
      'price': 25000,
      'cycle': 'شهرياً',
      'features': ['POS متقدم', 'تقارير يومية', '5 موظفين', 'فواتير إلكترونية', 'دعم أولوية'],
      'color': AppColors.primaryBlue,
      'recommended': true,
    },
    {
      'name': 'المؤسسية',
      'price': 75000,
      'cycle': 'شهرياً',
      'features': ['كل ميزات الاحترافية', 'موظفون غير محدودين', 'API للتكامل', 'مدير حساب مخصص', 'تقارير مخصصة'],
      'color': const Color(0xFF1B5E20),
      'recommended': false,
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {'customer': 'عبدالله محمد', 'amount': 12500, 'date': 'اليوم 11:30 ص', 'type': 'مبيعات', 'method': 'QR'},
    {'customer': 'رحاب أحمد', 'amount': 7800, 'date': 'اليوم 9:15 ص', 'type': 'مبيعات', 'method': 'POS'},
    {'customer': 'فيصل العمري', 'amount': 35000, 'date': 'أمس 5:00 م', 'type': 'مبيعات', 'method': 'تحويل'},
    {'customer': 'سيارة', 'amount': 5000, 'date': 'أمس 2:00 م', 'type': 'مصروف', 'method': 'سحب'},
    {'customer': 'إيجار مكتب', 'amount': 80000, 'date': '15 مارس', 'type': 'مصروف', 'method': 'تحويل'},
  ];

  final Map<String, dynamic> _stats = {
    'balance': 485000,
    'todayRevenue': 20300,
    'monthRevenue': 342000,
    'transactions': 87,
    'growth': 12.5,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الحساب التجاري', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'لوحة التحكم'), Tab(text: 'الباقات'), Tab(text: 'المميزات')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDashboardTab(), _buildPlansTab(), _buildFeaturesTab()],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الرصيد التجاري
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [BoxShadow(color: const Color(0xFF1B5E20).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store_rounded, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    const Text('رصيد الحساب التجاري', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 13)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('+${_stats['growth']}%', style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_stats['balance']} ريال',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 30),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _miniStatCard('إيرادات اليوم', '${_stats['todayRevenue']} ريال', Icons.today_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _miniStatCard('إيرادات الشهر', '${_stats['monthRevenue']} ريال', Icons.calendar_month_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _miniStatCard('المعاملات', '${_stats['transactions']}', Icons.receipt_rounded)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // أزرار الإجراءات السريعة
          Row(
            children: [
              Expanded(child: _quickActionBtn(Icons.qr_code_rounded, 'طلب دفع', const Color(0xFF6A1B9A), _showQRPayment)),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.point_of_sale_rounded, 'POS', AppColors.primaryBlue, _showPOS)),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.receipt_long_rounded, 'فاتورة', AppColors.success, _showInvoice)),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.bar_chart_rounded, 'تقرير', AppColors.warning, _showReport)),
            ],
          ),
          const SizedBox(height: AppSizes.paddingL),

          // آخر المعاملات
          const Text('آخر المعاملات', style: AppTextStyles.heading3),
          const SizedBox(height: AppSizes.paddingS),
          ..._recentTransactions.map((tx) => _buildTransactionRow(tx)).toList(),
        ],
      ),
    );
  }

  Widget _miniStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 11)),
          Text(label, style: const TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 10)),
        ],
      ),
    );
  }

  Widget _quickActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> tx) {
    final isRevenue = tx['type'] == 'مبيعات';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isRevenue ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isRevenue ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isRevenue ? AppColors.success : AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx['customer'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
                Row(
                  children: [
                    Text(tx['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(tx['method'] as String, style: const TextStyle(color: AppColors.primaryBlue, fontSize: 10, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isRevenue ? '+' : '-'} ${tx['amount']} ريال',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: isRevenue ? AppColors.success : AppColors.error),
          ),
        ],
      ),
    );
  }

  void _showQRPayment() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('رمز QR للدفع', style: TextStyle(fontFamily: 'Cairo'), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180, height: 180,
              decoration: BoxDecoration(border: Border.all(color: AppColors.primaryBlue, width: 2), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.qr_code_2_rounded, size: 150, color: AppColors.primaryBlue)),
            ),
            const SizedBox(height: 12),
            const Text('اعرض هذا الرمز للعميل للدفع', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo'), textAlign: TextAlign.center),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق', style: TextStyle(fontFamily: 'Cairo')))],
      ),
    );
  }

  void _showPOS() {
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('نقطة البيع (POS)', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
              const SizedBox(height: 20),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 32, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '0',
                  suffixText: 'ريال',
                  suffixStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20, color: AppColors.grey),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (amountCtrl.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم استقبال ${amountCtrl.text} ريال بنجاح', style: const TextStyle(fontFamily: 'Cairo'))),
                    );
                  }
                },
                icon: const Icon(Icons.point_of_sale_rounded),
                label: const Text('استقبال الدفع', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إنشاء الفواتير قريباً', style: TextStyle(fontFamily: 'Cairo'))),
    );
  }

  void _showReport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('تقرير المبيعات', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
            const SizedBox(height: 16),
            _reportRow('اليوم', '20,300 ريال', AppColors.primaryBlue),
            _reportRow('هذا الأسبوع', '98,500 ريال', AppColors.success),
            _reportRow('هذا الشهر', '342,000 ريال', const Color(0xFF6A1B9A)),
            _reportRow('العام الحالي', '1,250,000 ريال', AppColors.warning),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _reportRow(String period, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Text(period, style: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          const Spacer(),
          Text(amount, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPlansTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          const Text('اختر الباقة المناسبة لعملك', style: AppTextStyles.heading3, textAlign: TextAlign.center),
          const SizedBox(height: AppSizes.paddingM),
          ..._plans.map((plan) => _buildPlanCard(plan)).toList(),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isRecommended = plan['recommended'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isRecommended ? (plan['color'] as Color).withValues(alpha: 0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(color: isRecommended ? plan['color'] as Color : AppColors.lightGrey, width: isRecommended ? 2 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(plan['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18, color: plan['color'] as Color)),
              const SizedBox(width: 8),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: plan['color'] as Color, borderRadius: BorderRadius.circular(20)),
                  child: const Text('الأكثر شيوعاً', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Cairo')),
                ),
            ],
          ),
          const SizedBox(height: 8),
          plan['price'] == 0
            ? const Text('مجاناً', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 24))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${plan['price']}', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 24, color: plan['color'] as Color)),
                  const SizedBox(width: 4),
                  Text('ريال / ${plan['cycle']}', style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                ],
              ),
          const SizedBox(height: 12),
          ...(plan['features'] as List<String>).map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, size: 16, color: plan['color'] as Color),
                const SizedBox(width: 8),
                Text(f, style: const TextStyle(fontFamily: 'Cairo')),
              ],
            ),
          )).toList(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الاشتراك في باقة ${plan['name']}', style: const TextStyle(fontFamily: 'Cairo'))),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecommended ? plan['color'] as Color : AppColors.white,
                foregroundColor: isRecommended ? Colors.white : plan['color'] as Color,
                side: BorderSide(color: plan['color'] as Color),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: Text(plan['price'] == 0 ? 'ابدأ مجاناً' : 'اشترك الآن', style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _features.length,
      itemBuilder: (_, i) {
        final feat = _features[i];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  color: (feat['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(feat['icon'] as IconData, color: feat['color'] as Color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feat['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(feat['desc'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey.withValues(alpha: 0.5)),
            ],
          ),
        );
      },
    );
  }
}
