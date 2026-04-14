import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'beepay_loading.dart';

/// قائمة أفقية للوصول السريع — تُخزَّن الاختصارات المثبَّتة في SharedPreferences
class PinnedShortcutsWidget extends StatefulWidget {
  const PinnedShortcutsWidget({super.key});

  @override
  State<PinnedShortcutsWidget> createState() => _PinnedShortcutsWidgetState();
}

class _PinnedShortcutsWidgetState extends State<PinnedShortcutsWidget> {
  static const _allShortcuts = <_Shortcut>[
    _Shortcut(id: 'transfer', label: 'تحويل', icon: Icons.send_rounded, color: Color(0xFF0D47A1), route: '/transfer'),
    _Shortcut(id: 'deposit', label: 'إيداع', icon: Icons.add_circle_outline_rounded, color: Color(0xFF2E7D32), route: '/deposit'),
    _Shortcut(id: 'bills', label: 'فواتير', icon: Icons.receipt_long_rounded, color: Color(0xFFE53935), route: '/bills'),
    _Shortcut(id: 'recharge', label: 'شحن', icon: Icons.phone_android_rounded, color: Color(0xFF00897B), route: '/mobile_recharge'),
    _Shortcut(id: 'exchange', label: 'صرافة', icon: Icons.currency_exchange_rounded, color: Color(0xFF388E3C), route: '/exchange'),
    _Shortcut(id: 'savings', label: 'ادخار', icon: Icons.savings_rounded, color: Color(0xFF00ACC1), route: '/savings'),
    _Shortcut(id: 'cards', label: 'بطاقاتي', icon: Icons.credit_card_rounded, color: Color(0xFF1A237E), route: '/cards'),
    _Shortcut(id: 'investment', label: 'استثمار', icon: Icons.trending_up_rounded, color: Color(0xFF1B5E20), route: '/investment'),
    _Shortcut(id: 'donations', label: 'تبرع', icon: Icons.favorite_rounded, color: Color(0xFFE53935), route: '/donations'),
    _Shortcut(id: 'split', label: 'تقسيم', icon: Icons.call_split_rounded, color: Color(0xFF43A047), route: '/split_bill'),
  ];

  // الاختصارات الافتراضية
  static const _defaultPinned = ['transfer', 'deposit', 'bills', 'recharge', 'savings'];

  List<String> _pinned = List.from(_defaultPinned);

  @override
  void initState() {
    super.initState();
    _loadPinned();
  }

  Future<void> _loadPinned() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('pinned_shortcuts');
    if (saved != null && saved.isNotEmpty) {
      setState(() => _pinned = saved);
    }
  }

  Future<void> _savePinned() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pinned_shortcuts', _pinned);
  }

  void _showEditDialog() {
    final selected = Set<String>.from(_pinned);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateModal) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.8,
              builder: (_, scrollCtrl) {
                return Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      const Text('تخصيص الاختصارات', style: AppTextStyles.heading3),
                      const SizedBox(height: 4),
                      const Text(
                        'اختر حتى 6 اختصارات تظهر في الصفحة الرئيسية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollCtrl,
                          itemCount: _allShortcuts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final s = _allShortcuts[i];
                            final isPinned = selected.contains(s.id);
                            return CheckboxListTile(
                              secondary: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: s.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(s.icon, color: s.color, size: 20),
                              ),
                              title: Text(s.label,
                                  style: const TextStyle(fontFamily: 'Cairo')),
                              value: isPinned,
                              activeColor: AppColors.primaryBlue,
                              onChanged: (val) {
                                setStateModal(() {
                                  if (val == true && selected.length < 6) {
                                    selected.add(s.id);
                                  } else if (val == false && selected.length > 1) {
                                    selected.remove(s.id);
                                  } else if (val == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('الحد الأقصى 6 اختصارات',
                                            style: TextStyle(fontFamily: 'Cairo')),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            // حافظ على ترتيب الاختصارات الأصلي
                            setState(() {
                              _pinned = _allShortcuts
                                  .where((s) => selected.contains(s.id))
                                  .map((s) => s.id)
                                  .toList();
                            });
                            _savePinned();
                            Navigator.pop(ctx);
                          },
                          child: const Text('حفظ',
                              style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortcuts = _allShortcuts.where((s) => _pinned.contains(s.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('وصول سريع', style: AppTextStyles.heading3),
            GestureDetector(
              onTap: _showEditDialog,
              child: const Row(
                children: [
                  Icon(Icons.tune_rounded,
                      size: 16, color: AppColors.primaryBlue),
                  SizedBox(width: 4),
                  Text(
                    'تخصيص',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingS),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shortcuts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final s = shortcuts[i];
              return _ShortcutChip(shortcut: s);
            },
          ),
        ),
      ],
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  final _Shortcut shortcut;
  const _ShortcutChip({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BeepayTransitionOverlay.navigate(
        context: context,
        onNavigate: () => Navigator.pushNamed(context, shortcut.route),
      ),
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: shortcut.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(shortcut.icon, color: shortcut.color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              shortcut.label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Shortcut {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _Shortcut({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}
