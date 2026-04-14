import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _Voucher {
  final String id;
  final String code;
  final String title;
  final String merchant;
  final String description;
  final String discount;
  final String expiry;
  final Color color;
  final IconData icon;
  final bool isUsed;
  final String category;

  const _Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.merchant,
    required this.description,
    required this.discount,
    required this.expiry,
    required this.color,
    required this.icon,
    required this.isUsed,
    required this.category,
  });
}

class _VouchersScreenState extends State<VouchersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeCtrl = TextEditingController();
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'تسوق',
    'طعام',
    'سفر',
    'خدمات',
    'مواصلات',
  ];

  final List<_Voucher> _vouchers = [
    const _Voucher(
      id: 'v1',
      code: 'YP-SAVE20',
      title: 'خصم 20% على التسوق',
      merchant: 'سبأ مول',
      description: 'احصل على خصم 20% على جميع مشترياتك في سبأ مول',
      discount: '20%',
      expiry: '30 أبريل 2026',
      color: Color(0xFF1565C0),
      icon: Icons.shopping_bag_rounded,
      isUsed: false,
      category: 'تسوق',
    ),
    const _Voucher(
      id: 'v2',
      code: 'FOOD500',
      title: 'خصم 500 ريال على الطلبات',
      merchant: 'مطاعم الأصالة',
      description: 'خصم 500 ريال على طلبك القادم في مطاعم الأصالة',
      discount: '500 ريال',
      expiry: '15 أبريل 2026',
      color: Color(0xFFE53935),
      icon: Icons.restaurant_rounded,
      isUsed: false,
      category: 'طعام',
    ),
    const _Voucher(
      id: 'v3',
      code: 'FLY-YP15',
      title: 'خصم 15% على تذاكر الطيران',
      merchant: 'اليمنية للطيران',
      description: 'وفّر 15% على حجز تذاكرك عبر تطبيق Beepay',
      discount: '15%',
      expiry: '31 مايو 2026',
      color: Color(0xFF0097A7),
      icon: Icons.flight_rounded,
      isUsed: false,
      category: 'سفر',
    ),
    const _Voucher(
      id: 'v4',
      code: 'RIDE10',
      title: 'أول 3 رحلات مجانية',
      merchant: 'يمن رايد',
      description: 'استمتع بأول 3 رحلات مجانية مع تطبيق يمن رايد',
      discount: 'مجاناً',
      expiry: '30 مارس 2026',
      color: Color(0xFF388E3C),
      icon: Icons.directions_car_rounded,
      isUsed: false,
      category: 'مواصلات',
    ),
    const _Voucher(
      id: 'v5',
      code: 'NET-FREE',
      title: 'باقة إنترنت مجانية 1GB',
      merchant: 'يمن موبايل',
      description: 'احصل على 1GB إنترنت مجانًا عند الشحن بأكثر من 2000 ريال',
      discount: '1 GB',
      expiry: '30 أبريل 2026',
      color: Color(0xFF8E24AA),
      icon: Icons.wifi_rounded,
      isUsed: false,
      category: 'خدمات',
    ),
    const _Voucher(
      id: 'v6',
      code: 'OLD25',
      title: 'خصم 25% — منتهي الصلاحية',
      merchant: 'تجارة الخير',
      description: 'هذه القسيمة منتهية الصلاحية',
      discount: '25%',
      expiry: '1 مارس 2026',
      color: AppColors.grey,
      icon: Icons.local_offer_rounded,
      isUsed: true,
      category: 'تسوق',
    ),
  ];

  List<_Voucher> get _activeVouchers =>
      _vouchers.where((v) => !v.isUsed).toList();

  List<_Voucher> get _filteredActive {
    if (_selectedCategory == 'الكل') return _activeVouchers;
    return _activeVouchers
        .where((v) => v.category == _selectedCategory)
        .toList();
  }

  List<_Voucher> get _usedVouchers =>
      _vouchers.where((v) => v.isUsed).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _addVoucher() {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // محاكاة
    final known = ['BONUS10', 'WELCOME', 'YP2026'];
    if (known.contains(code)) {
      _codeCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إضافة القسيمة بنجاح!',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كود القسيمة غير صحيح أو منتهي الصلاحية',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _useVoucher(_Voucher voucher) {
    Clipboard.setData(ClipboardData(text: voucher.code));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
        title: Text(voucher.title,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: voucher.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: voucher.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    voucher.code,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: voucher.color,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.copy_rounded,
                      color: voucher.color, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('تم نسخ الكود تلقائياً. الصقه عند الدفع.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.grey,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق',
                style:
                    TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم استخدام القسيمة',
                      style: TextStyle(fontFamily: 'Cairo')),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: voucher.color),
            child: const Text('تأكيد الاستخدام',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('قسائم الخصم',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle:
              const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: [
            Tab(text: 'قسائمي (${_activeVouchers.length})'),
            Tab(text: 'المستخدمة (${_usedVouchers.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActiveVouchersTab(
            categories: _categories,
            selected: _selectedCategory,
            filtered: _filteredActive,
            codeCtrl: _codeCtrl,
            onCategoryTap: (c) => setState(() => _selectedCategory = c),
            onAddVoucher: _addVoucher,
            onUseVoucher: _useVoucher,
          ),
          _UsedVouchersTab(vouchers: _usedVouchers),
        ],
      ),
    );
  }
}

// ======= Tab 1: القسائم النشطة =======
class _ActiveVouchersTab extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final List<_Voucher> filtered;
  final TextEditingController codeCtrl;
  final void Function(String) onCategoryTap;
  final VoidCallback onAddVoucher;
  final void Function(_Voucher) onUseVoucher;

  const _ActiveVouchersTab({
    required this.categories,
    required this.selected,
    required this.filtered,
    required this.codeCtrl,
    required this.onCategoryTap,
    required this.onAddVoucher,
    required this.onUseVoucher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // إضافة كود
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'أدخل كود القسيمة',
                    prefixIcon: Icon(Icons.local_offer_rounded),
                    hintStyle: TextStyle(fontFamily: 'Cairo'),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  style: const TextStyle(
                      fontFamily: 'Cairo', letterSpacing: 1.5),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onAddVoucher,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                  child: const Text('إضافة',
                      style: TextStyle(fontFamily: 'Cairo')),
                ),
              ),
            ],
          ),
        ),
        // فلتر
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM),
            child: Row(
              children: categories.map((cat) {
                final isSelected = cat == selected;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(cat,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isSelected
                              ? AppColors.white
                              : AppColors.grey,
                        )),
                    selected: isSelected,
                    onSelected: (_) => onCategoryTap(cat),
                    backgroundColor: AppColors.white,
                    selectedColor: AppColors.primaryBlue,
                    checkmarkColor: AppColors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.lightGrey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // قائمة
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text('لا توجد قسائم في هذا التصنيف',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: AppColors.grey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _VoucherCard(
                    voucher: filtered[i],
                    onUse: () => onUseVoucher(filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final _Voucher voucher;
  final VoidCallback onUse;

  const _VoucherCard({required this.voucher, required this.onUse});

  @override
  Widget build(BuildContext context) {
    final v = voucher;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // الشريط الجانبي
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: v.color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppSizes.borderRadiusLarge),
                  bottomRight:
                      Radius.circular(AppSizes.borderRadiusLarge),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, AppSizes.paddingM, AppSizes.paddingL, AppSizes.paddingM),
            child: Row(
              children: [
                // أيقونة
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: v.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(v.icon, color: v.color, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        v.discount,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: v.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.title,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      const SizedBox(height: 2),
                      Text(v.merchant,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: v.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 12, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text('ينتهي: ${v.expiry}',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppColors.grey,
                              )),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: onUse,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: v.color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                          ),
                          child: const Text('استخدم الآن',
                              style: TextStyle(
                                  fontFamily: 'Cairo', fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======= Tab 2: المستخدمة =======
class _UsedVouchersTab extends StatelessWidget {
  final List<_Voucher> vouchers;
  const _UsedVouchersTab({required this.vouchers});

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return const Center(
        child: Text('لا توجد قسائم مستخدمة',
            style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: vouchers.length,
      itemBuilder: (_, i) {
        final v = vouchers[i];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(v.icon, color: AppColors.grey, size: 22),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.title,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.grey,
                        )),
                    Text(v.merchant,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('منتهية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: AppColors.grey,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
