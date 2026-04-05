import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  int _selectedCard = 0;
  bool _showCvv = false;

  final List<_Card> _cards = [
    _Card(
      id: '1',
      label: 'البطاقة الافتراضية',
      number: '4532 1234 5678 9012',
      holder: 'أحمد علي الحمدي',
      expiry: '12/28',
      cvv: '452',
      type: 'visa',
      gradient: const [Color(0xFF1565C0), Color(0xFF0D47A1)],
      balance: 150500,
      isActive: true,
      isDefault: true,
    ),
    _Card(
      id: '2',
      label: 'بطاقة المكافآت',
      number: '5200 8765 4321 0987',
      holder: 'أحمد علي الحمدي',
      expiry: '06/27',
      cvv: '318',
      type: 'mastercard',
      gradient: const [Color(0xFF880E4F), Color(0xFFAD1457)],
      balance: 25000,
      isActive: true,
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final card = _cards[_selectedCard];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('بطاقاتي',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _showAddCardSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.paddingM),

            // Card carousel
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: _cards.length,
                onPageChanged: (i) => setState(() {
                  _selectedCard = i;
                  _showCvv = false;
                }),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _CardWidget(card: _cards[i], showCvv: i == _selectedCard && _showCvv),
                ),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cards.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
                width: _selectedCard == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _selectedCard == i ? AppColors.primaryBlue : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),

            // Card details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Balance
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('الرصيد المتاح',
                                style: TextStyle(fontFamily: 'Cairo',
                                    color: AppColors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '${(card.balance / 1000).toStringAsFixed(1)}K ريال',
                              style: const TextStyle(fontFamily: 'Cairo',
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (card.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('افتراضية',
                                style: TextStyle(fontFamily: 'Cairo',
                                    color: AppColors.success, fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // Card info
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _InfoRow('رقم البطاقة', card.maskedNumber,
                            trailing: IconButton(
                              icon: const Icon(Icons.copy, size: 18, color: AppColors.primaryBlue),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: card.number.replaceAll(' ', '')));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم نسخ رقم البطاقة',
                                      style: TextStyle(fontFamily: 'Cairo')),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                            )),
                        const Divider(height: 1),
                        _InfoRow('تاريخ الانتهاء', card.expiry),
                        const Divider(height: 1),
                        _InfoRow(
                          'رمز CVV',
                          _showCvv ? card.cvv : '•••',
                          trailing: IconButton(
                            icon: Icon(
                              _showCvv ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: () => setState(() => _showCvv = !_showCvv),
                          ),
                        ),
                        const Divider(height: 1),
                        _InfoRow('اسم حامل البطاقة', card.holder),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                    ),
                    child: Column(
                      children: [
                        _ActionTile(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFA000),
                          title: 'تعيين كبطاقة افتراضية',
                          onTap: card.isDefault ? null : () {
                            setState(() {
                              for (var c in _cards) {
                                // ignore: invalid_use_of_protected_member
                              }
                              final idx = _cards.indexWhere((c) => c.id == card.id);
                              _cards[idx] = _cards[idx].copyWith(isDefault: true);
                              for (int i = 0; i < _cards.length; i++) {
                                if (i != idx) {
                                  _cards[i] = _cards[i].copyWith(isDefault: false);
                                }
                              }
                            });
                          },
                          trailing: card.isDefault
                              ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                              : null,
                        ),
                        const Divider(height: 1),
                        _ActionTile(
                          icon: card.isActive ? Icons.lock_outline : Icons.lock_open_outlined,
                          iconColor: card.isActive ? AppColors.warning : AppColors.success,
                          title: card.isActive ? 'تجميد البطاقة مؤقتاً' : 'إلغاء التجميد',
                          onTap: () => setState(() {
                            final idx = _cards.indexWhere((c) => c.id == card.id);
                            _cards[idx] = _cards[idx].copyWith(isActive: !card.isActive);
                          }),
                        ),
                        const Divider(height: 1),
                        _ActionTile(
                          icon: Icons.settings_outlined,
                          iconColor: AppColors.grey,
                          title: 'حدود الإنفاق',
                          onTap: () => _showLimitsSheet(),
                        ),
                        const Divider(height: 1),
                        _ActionTile(
                          icon: Icons.delete_outline_rounded,
                          iconColor: AppColors.error,
                          title: 'إلغاء البطاقة',
                          onTap: () => _showDeleteDialog(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('إضافة بطاقة جديدة',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.credit_card_rounded, color: AppColors.primaryBlue)),
              title: const Text('بطاقة افتراضية جديدة',
                  style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
              subtitle: const Text('تصدر فوراً لاستخدامها أونلاين',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.grey)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: إصدار بطاقة افتراضية جديدة',
                      style: TextStyle(fontFamily: 'Cairo'))),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add_card_rounded, color: AppColors.success)),
              title: const Text('ربط بطاقة مصرفية',
                  style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
              subtitle: const Text('ربط بطاقة بنك يمني',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.grey)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: ربط بطاقة مصرفية',
                      style: TextStyle(fontFamily: 'Cairo'))),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLimitsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('حدود الإنفاق',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _LimitRow('الحد اليومي', '500,000 ريال', AppColors.primaryBlue),
            _LimitRow('الحد الشهري', '5,000,000 ريال', AppColors.success),
            _LimitRow('حد معاملة واحدة', '200,000 ريال', AppColors.warning),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يتطلب تعديل الحدود التحقق من الهوية',
                        style: TextStyle(fontFamily: 'Cairo'))));
                },
                child: const Text('طلب تعديل الحدود',
                    style: TextStyle(fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إلغاء البطاقة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: const Text('هل أنت متأكد من إلغاء هذه البطاقة؟ لا يمكن التراجع.',
            style: TextStyle(fontFamily: 'Cairo')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب إلغاء البطاقة',
                    style: TextStyle(fontFamily: 'Cairo')), backgroundColor: AppColors.success));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('إلغاء البطاقة', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Card {
  final String id, label, number, holder, expiry, cvv, type;
  final List<Color> gradient;
  final double balance;
  final bool isActive, isDefault;

  const _Card({required this.id, required this.label, required this.number,
      required this.holder, required this.expiry, required this.cvv,
      required this.type, required this.gradient, required this.balance,
      required this.isActive, required this.isDefault});

  String get maskedNumber =>
      '**** **** **** ${number.substring(number.length - 4)}';

  _Card copyWith({bool? isActive, bool? isDefault}) => _Card(
      id: id, label: label, number: number, holder: holder, expiry: expiry,
      cvv: cvv, type: type, gradient: gradient, balance: balance,
      isActive: isActive ?? this.isActive, isDefault: isDefault ?? this.isDefault);
}

class _CardWidget extends StatelessWidget {
  final _Card card;
  final bool showCvv;
  const _CardWidget({required this.card, required this.showCvv});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: card.gradient,
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: card.gradient.first.withValues(alpha: 0.4),
            blurRadius: 20, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(card.label,
                  style: const TextStyle(fontFamily: 'Cairo',
                      color: Colors.white70, fontSize: 13)),
              Text(card.type.toUpperCase(),
                  style: const TextStyle(fontFamily: 'Cairo',
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Spacer(),
          Text(card.number,
              style: const TextStyle(color: Colors.white,
                  fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('حامل البطاقة',
                      style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo')),
                  Text(card.holder,
                      style: const TextStyle(color: Colors.white,
                          fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('تنتهي',
                      style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo')),
                  Text(card.expiry,
                      style: const TextStyle(color: Colors.white,
                          fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          if (!card.isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('مجمّدة', style: TextStyle(color: Colors.white,
                  fontFamily: 'Cairo', fontSize: 11)),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Widget? trailing;
  const _InfoRow(this.label, this.value, {this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(children: [
          Text(label, style: const TextStyle(fontFamily: 'Cairo', color: AppColors.grey, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
          if (trailing != null) trailing!,
        ]),
      );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _ActionTile({required this.icon, required this.iconColor,
      required this.title, this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(title, style: TextStyle(fontFamily: 'Cairo',
            color: onTap == null ? AppColors.grey : AppColors.textPrimary)),
        trailing: trailing ?? (onTap != null
            ? const Icon(Icons.chevron_left, color: AppColors.grey, size: 20) : null),
        onTap: onTap,
      );
}

class _LimitRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _LimitRow(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontFamily: 'Cairo',
              fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
      );
}
