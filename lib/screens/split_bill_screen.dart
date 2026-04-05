import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _totalCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final Set<int> _selected = {};
  bool _includeMyself = true;

  final List<Map<String, String>> _contacts = [
    {'name': 'أحمد محمد', 'wallet': '967711234567', 'avatar': 'أ'},
    {'name': 'فاطمة علي', 'wallet': '967733456789', 'avatar': 'ف'},
    {'name': 'خالد عبدالله', 'wallet': '967755678901', 'avatar': 'خ'},
    {'name': 'مريم حسن', 'wallet': '967777890123', 'avatar': 'م'},
    {'name': 'عمر سالم', 'wallet': '967799012345', 'avatar': 'ع'},
    {'name': 'نور الدين', 'wallet': '967722345678', 'avatar': 'ن'},
  ];

  int get _participants =>
      _selected.length + (_includeMyself ? 1 : 0);

  double get _total => double.tryParse(_totalCtrl.text) ?? 0;
  double get _share =>
      _participants > 0 ? _total / _participants : 0;

  @override
  void dispose() {
    _totalCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _sendRequests() {
    if (_total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل المبلغ الإجمالي أولاً',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر شخصاً واحداً على الأقل',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: AppColors.success, size: 34),
            ),
            const SizedBox(height: 12),
            const Text('تأكيد تقسيم الفاتورة',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _ConfirmRow(
                label: 'الإجمالي',
                value: '${_total.toStringAsFixed(0)} ريال'),
            _ConfirmRow(label: 'عدد المشاركين', value: '$_participants أشخاص'),
            _ConfirmRow(
                label: 'نصيب كل شخص',
                value: '${_share.toStringAsFixed(0)} ريال'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إرسال طلبات التقسيم إلى ${_selected.length} أشخاص',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  setState(() {
                    _selected.clear();
                    _totalCtrl.clear();
                    _noteCtrl.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إرسال الطلبات',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تقسيم الفاتورة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount input
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المبلغ الإجمالي',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _totalCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo'),
                          decoration: const InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                                fontSize: 32,
                                color: AppColors.lightGrey,
                                fontFamily: 'Cairo'),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text('ريال',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              color: AppColors.grey)),
                    ],
                  ),
                  const Divider(),
                  TextField(
                    controller: _noteCtrl,
                    decoration: const InputDecoration(
                      hintText: 'وصف الفاتورة (مطعم، رحلة...)',
                      hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.grey,
                          fontSize: 13),
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.note_outlined, color: AppColors.grey),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // Include myself toggle
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_rounded,
                      color: AppColors.primaryBlue, size: 22),
                  const SizedBox(width: AppSizes.paddingM),
                  const Expanded(
                    child: Text('تضمين نصيبي أنا',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                  Switch(
                    value: _includeMyself,
                    onChanged: (v) => setState(() => _includeMyself = v),
                    activeColor: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // Contact selection
            const Text('اختر المشاركين',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.paddingS),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _contacts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 60),
                itemBuilder: (_, i) {
                  final c = _contacts[i];
                  final selected = _selected.contains(i);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: selected
                          ? AppColors.primaryBlue
                          : AppColors.primaryBlue.withValues(alpha: 0.1),
                      child: Text(c['avatar']!,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: selected
                                  ? Colors.white
                                  : AppColors.primaryBlue,
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(c['name']!,
                        style: const TextStyle(fontFamily: 'Cairo')),
                    subtitle: Text(c['wallet']!,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.grey)),
                    trailing: selected
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primaryBlue)
                        : const Icon(Icons.radio_button_unchecked,
                            color: AppColors.lightGrey),
                    onTap: () => setState(() {
                      if (selected) {
                        _selected.remove(i);
                      } else {
                        _selected.add(i);
                      }
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Share preview
            if (_participants > 0 && _total > 0) ...[
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.06),
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLarge),
                  border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareStat(
                        label: 'الإجمالي',
                        value: '${_total.toStringAsFixed(0)} ر'),
                    Container(
                        width: 1, height: 40, color: AppColors.lightGrey),
                    _ShareStat(
                        label: 'المشاركون',
                        value: '$_participants أشخاص'),
                    Container(
                        width: 1, height: 40, color: AppColors.lightGrey),
                    _ShareStat(
                        label: 'نصيب الفرد',
                        value: '${_share.toStringAsFixed(0)} ر',
                        highlight: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendRequests,
                icon: const Icon(Icons.send_rounded),
                label: Text(
                  _selected.isEmpty
                      ? 'اختر مشاركين للإرسال'
                      : 'إرسال طلبات التقسيم (${_selected.length})',
                  style: const TextStyle(
                      fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _ShareStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ShareStat(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 12, color: AppColors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: highlight ? AppColors.primaryBlue : AppColors.textPrimary)),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.grey)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
