import 'package:flutter/material.dart';
import '../utils/constants.dart';

class Beneficiary {
  final String id;
  final String name;
  final String walletNumber;
  final String? lastAmount;
  final String? lastDate;
  final Color avatarColor;

  const Beneficiary({
    required this.id,
    required this.name,
    required this.walletNumber,
    this.lastAmount,
    this.lastDate,
    required this.avatarColor,
  });
}

final demoBeneficiaries = [
  const Beneficiary(
    id: '1',
    name: 'محمد عبدالله',
    walletNumber: '120000000010',
    lastAmount: '15,000',
    lastDate: 'أمس',
    avatarColor: Color(0xFF1565C0),
  ),
  const Beneficiary(
    id: '2',
    name: 'سارة أحمد',
    walletNumber: '120000000022',
    lastAmount: '8,500',
    lastDate: 'قبل 3 أيام',
    avatarColor: Color(0xFF6A1B9A),
  ),
  const Beneficiary(
    id: '3',
    name: 'خالد العمري',
    walletNumber: '120000000034',
    lastAmount: '50,000',
    lastDate: 'الأسبوع الماضي',
    avatarColor: Color(0xFF2E7D32),
  ),
  const Beneficiary(
    id: '4',
    name: 'فاطمة الزهراء',
    walletNumber: '120000000041',
    lastAmount: '3,200',
    lastDate: '12/03/2026',
    avatarColor: Color(0xFFB71C1C),
  ),
  const Beneficiary(
    id: '5',
    name: 'عمر الحمدي',
    walletNumber: '120000000055',
    lastAmount: '25,000',
    lastDate: '01/03/2026',
    avatarColor: Color(0xFF00695C),
  ),
];

class BeneficiariesScreen extends StatefulWidget {
  /// إذا كان true نُرجع المستفيد المختار بدلاً من التحويل مباشرة
  final bool selectionMode;

  const BeneficiariesScreen({Key? key, this.selectionMode = false})
      : super(key: key);

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  final List<Beneficiary> _list = List.from(demoBeneficiaries);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Beneficiary> get _filtered => _query.isEmpty
      ? _list
      : _list
          .where((b) =>
              b.name.contains(_query) ||
              b.walletNumber.contains(_query))
          .toList();

  void _onTap(Beneficiary b) {
    if (widget.selectionMode) {
      Navigator.pop(context, b);
    } else {
      _showOptions(b);
    }
  }

  void _showOptions(Beneficiary b) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
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
            Row(
              children: [
                _Avatar(b: b, size: 52),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.name,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(b.walletNumber,
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.grey,
                                fontSize: 13))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SheetBtn(
              icon: Icons.send_rounded,
              label: 'تحويل إليه',
              color: AppColors.primaryBlue,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/transfer',
                    arguments: {'walletNumber': b.walletNumber, 'name': b.name});
              },
            ),
            const SizedBox(height: 10),
            _SheetBtn(
              icon: Icons.delete_outline_rounded,
              label: 'حذف من المستفيدين',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _list.removeWhere((x) => x.id == b.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف ${b.name}',
                        style: const TextStyle(fontFamily: 'Cairo')),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _addBeneficiary() {
    final nameCtrl = TextEditingController();
    final walletCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSizes.paddingL,
          right: AppSizes.paddingL,
          top: AppSizes.paddingL,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.paddingL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('إضافة مستفيد جديد',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: const InputDecoration(
                labelText: 'الاسم',
                labelStyle: TextStyle(fontFamily: 'Cairo'),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: walletCtrl,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: const InputDecoration(
                labelText: 'رقم المحفظة',
                labelStyle: TextStyle(fontFamily: 'Cairo'),
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty &&
                      walletCtrl.text.length >= 10) {
                    setState(() {
                      _list.insert(
                        0,
                        Beneficiary(
                          id: DateTime.now().toString(),
                          name: nameCtrl.text,
                          walletNumber: walletCtrl.text,
                          avatarColor: AppColors.primaryBlue,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تمت إضافة ${nameCtrl.text}',
                            style:
                                const TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text('إضافة',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? 'اختر مستفيداً' : 'المستفيدون',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        elevation: 0,
        actions: [
          if (!widget.selectionMode)
            IconButton(
              icon: const Icon(Icons.person_add_rounded),
              onPressed: _addBeneficiary,
              tooltip: 'إضافة مستفيد',
            ),
        ],
      ),
      body: Column(
        children: [
          // بحث
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingM),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(fontFamily: 'Cairo'),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو رقم المحفظة...',
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.grey),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.grey),
                        onPressed: () {
                          _searchCtrl.clear();
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
                        Icon(Icons.people_outline_rounded,
                            size: 60,
                            color: AppColors.grey.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        const Text('لا يوجد مستفيدون',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.grey,
                                fontSize: 16)),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _addBeneficiary,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('أضف مستفيداً',
                              style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.paddingS),
                    itemBuilder: (_, i) {
                      final b = _filtered[i];
                      return _BeneficiaryTile(
                        b: b,
                        onTap: () => _onTap(b),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: !widget.selectionMode
          ? FloatingActionButton.extended(
              onPressed: _addBeneficiary,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('إضافة مستفيد',
                  style: TextStyle(fontFamily: 'Cairo')),
              backgroundColor: AppColors.primaryBlue,
            )
          : null,
    );
  }
}

class _BeneficiaryTile extends StatelessWidget {
  final Beneficiary b;
  final VoidCallback onTap;

  const _BeneficiaryTile({Key? key, required this.b, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _Avatar(b: b, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.name,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.walletNumber,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            if (b.lastAmount != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${b.lastAmount} ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Text(
                    b.lastDate ?? '',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final Beneficiary b;
  final double size;

  const _Avatar({Key? key, required this.b, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: b.avatarColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          b.name[0],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}

class _SheetBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetBtn({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                color: color,
                fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
      ),
    );
  }
}
