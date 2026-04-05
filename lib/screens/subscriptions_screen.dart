import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'الكل';

  final List<String> _categories = ['الكل', 'ترفيه', 'تعليم', 'صحة', 'أعمال', 'أخرى'];

  final List<Map<String, dynamic>> _activeSubscriptions = [
    {
      'name': 'نتفليكس',
      'category': 'ترفيه',
      'price': 8500,
      'cycle': 'شهري',
      'nextDate': '1 أبريل 2026',
      'daysLeft': 12,
      'icon': Icons.play_circle_rounded,
      'color': const Color(0xFFE53935),
      'active': true,
    },
    {
      'name': 'سبوتيفاي',
      'category': 'ترفيه',
      'price': 4000,
      'cycle': 'شهري',
      'nextDate': '5 أبريل 2026',
      'daysLeft': 16,
      'icon': Icons.music_note_rounded,
      'color': const Color(0xFF1DB954),
      'active': true,
    },
    {
      'name': 'كورسيرا',
      'category': 'تعليم',
      'price': 12000,
      'cycle': 'شهري',
      'nextDate': '15 أبريل 2026',
      'daysLeft': 26,
      'icon': Icons.school_rounded,
      'color': const Color(0xFF0056D2),
      'active': true,
    },
    {
      'name': 'أدوبي كريتيف',
      'category': 'أعمال',
      'price': 35000,
      'cycle': 'شهري',
      'nextDate': '20 أبريل 2026',
      'daysLeft': 31,
      'icon': Icons.design_services_rounded,
      'color': const Color(0xFFFF0000),
      'active': true,
    },
    {
      'name': 'جيم صنعاء',
      'category': 'صحة',
      'price': 15000,
      'cycle': 'شهري',
      'nextDate': '25 أبريل 2026',
      'daysLeft': 36,
      'icon': Icons.fitness_center_rounded,
      'color': const Color(0xFF43A047),
      'active': false,
    },
  ];

  final List<Map<String, dynamic>> _availableServices = [
    {
      'name': 'يوتيوب بريميوم',
      'category': 'ترفيه',
      'price': 6000,
      'cycle': 'شهري',
      'desc': 'مقاطع فيديو بدون إعلانات',
      'icon': Icons.youtube_searched_for_rounded,
      'color': const Color(0xFFFF0000),
    },
    {
      'name': 'لينكدإن بريميوم',
      'category': 'أعمال',
      'price': 25000,
      'cycle': 'شهري',
      'desc': 'فرص وظيفية وتواصل مهني',
      'icon': Icons.work_rounded,
      'color': const Color(0xFF0A66C2),
    },
    {
      'name': 'دوولينجو بلس',
      'category': 'تعليم',
      'price': 5000,
      'cycle': 'شهري',
      'desc': 'تعلم اللغات بدون إعلانات',
      'icon': Icons.translate_rounded,
      'color': const Color(0xFF58CC02),
    },
    {
      'name': 'كلاود ستوريج',
      'category': 'أخرى',
      'price': 3000,
      'cycle': 'شهري',
      'desc': '1 تيرابايت تخزين سحابي',
      'icon': Icons.cloud_rounded,
      'color': const Color(0xFF0097A7),
    },
  ];

  List<Map<String, dynamic>> get _filteredActive {
    if (_selectedCategory == 'الكل') return _activeSubscriptions;
    return _activeSubscriptions.where((s) => s['category'] == _selectedCategory).toList();
  }

  int get _totalMonthly => _activeSubscriptions
      .where((s) => s['active'] as bool)
      .fold(0, (sum, s) => sum + (s['price'] as int));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('إدارة الاشتراكات', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'اشتراكاتي'), Tab(text: 'خدمات متاحة')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMySubscriptionsTab(), _buildAvailableTab()],
      ),
    );
  }

  Widget _buildMySubscriptionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الإجمالي
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('إجمالي الاشتراكات الشهرية', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 13)),
                    const SizedBox(height: 6),
                    Text('$_totalMonthly ريال', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 26)),
                    const SizedBox(height: 4),
                    Text(
                      '${_activeSubscriptions.where((s) => s['active'] as bool).length} اشتراكات نشطة',
                      style: const TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.subscriptions_rounded, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // فلتر التصنيف
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final sel = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryBlue : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: sel ? AppColors.primaryBlue : AppColors.lightGrey),
                    ),
                    child: Text(cat, style: TextStyle(color: sel ? Colors.white : AppColors.grey, fontFamily: 'Cairo', fontSize: 12, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          ..._filteredActive.map((sub) => _buildSubscriptionCard(sub)).toList(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> sub) {
    final isActive = sub['active'] as bool;
    final daysLeft = sub['daysLeft'] as int;
    final isUrgent = daysLeft <= 7;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: isUrgent && isActive ? Border.all(color: AppColors.warning.withValues(alpha: 0.4), width: 1.5) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: (sub['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(sub['icon'] as IconData, color: sub['color'] as Color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sub['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    Text(sub['category'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                activeColor: AppColors.primaryBlue,
                onChanged: (v) {
                  setState(() => sub['active'] = v);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('${sub['price']} ريال / ${sub['cycle']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: AppColors.primaryBlue)),
              const Spacer(),
              if (isActive) ...[
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: isUrgent ? AppColors.warning : AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  'التجديد: ${sub['nextDate']}',
                  style: TextStyle(
                    color: isUrgent ? AppColors.warning : AppColors.grey,
                    fontSize: 11, fontFamily: 'Cairo',
                    fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ] else
                const Text('متوقف', style: TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
            ],
          ),
          if (isActive && isUrgent) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'سيتجدد خلال $daysLeft أيام',
                style: const TextStyle(color: AppColors.warning, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailableTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _availableServices.length,
      itemBuilder: (_, i) {
        final svc = _availableServices[i];
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
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: (svc['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(svc['icon'] as IconData, color: svc['color'] as Color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(svc['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    Text(svc['desc'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                    const SizedBox(height: 4),
                    Text('${svc['price']} ريال / ${svc['cycle']}', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _subscribeDialog(svc),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('اشترك', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _subscribeDialog(Map<String, dynamic> svc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('الاشتراك في ${svc['name']}', style: const TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سيتم خصم ${svc['price']} ريال شهرياً من محفظتك', style: const TextStyle(fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            Text(svc['desc'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الاشتراك في ${svc['name']} بنجاح', style: const TextStyle(fontFamily: 'Cairo'))),
              );
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}
