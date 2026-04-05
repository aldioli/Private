import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class FriendsPaymentsScreen extends StatefulWidget {
  const FriendsPaymentsScreen({super.key});

  @override
  State<FriendsPaymentsScreen> createState() => _FriendsPaymentsScreenState();
}

class _FriendsPaymentsScreenState extends State<FriendsPaymentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _friends = [
    {'name': 'أحمد محمد', 'phone': '777 123 456', 'initials': 'أ', 'color': const Color(0xFF1565C0), 'lastActivity': 'منذ ساعة'},
    {'name': 'فاطمة علي', 'phone': '733 987 654', 'initials': 'ف', 'color': const Color(0xFFE53935), 'lastActivity': 'منذ 3 ساعات'},
    {'name': 'خالد حسين', 'phone': '711 456 789', 'initials': 'خ', 'color': const Color(0xFF388E3C), 'lastActivity': 'أمس'},
    {'name': 'سارة عبدالله', 'phone': '771 321 654', 'initials': 'س', 'color': const Color(0xFF8E24AA), 'lastActivity': 'منذ يومين'},
    {'name': 'محمد الأكحلي', 'phone': '777 654 321', 'initials': 'م', 'color': const Color(0xFF00897B), 'lastActivity': 'منذ أسبوع'},
    {'name': 'نورة القحطاني', 'phone': '733 111 222', 'initials': 'ن', 'color': const Color(0xFFFB8C00), 'lastActivity': 'منذ أسبوع'},
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'type': 'incoming',
      'from': 'أحمد محمد',
      'fromInitials': 'أ',
      'fromColor': const Color(0xFF1565C0),
      'amount': 5000,
      'note': 'نصيب العشاء',
      'date': 'منذ ساعة',
    },
    {
      'type': 'outgoing',
      'to': 'خالد حسين',
      'toInitials': 'خ',
      'toColor': const Color(0xFF388E3C),
      'amount': 8000,
      'note': 'تذاكر السينما',
      'date': 'منذ 3 ساعات',
    },
    {
      'type': 'incoming',
      'from': 'فاطمة علي',
      'fromInitials': 'ف',
      'fromColor': const Color(0xFFE53935),
      'amount': 3500,
      'note': 'قهوة الصباح',
      'date': 'أمس',
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {'name': 'أحمد محمد', 'initials': 'أ', 'color': const Color(0xFF1565C0), 'type': 'sent', 'amount': 10000, 'date': 'اليوم 10:30 ص', 'note': 'دفع الإيجار'},
    {'name': 'سارة عبدالله', 'initials': 'س', 'color': const Color(0xFF8E24AA), 'type': 'received', 'amount': 7500, 'date': 'أمس 4:15 م', 'note': 'نصيب السفر'},
    {'name': 'محمد الأكحلي', 'initials': 'م', 'color': const Color(0xFF00897B), 'type': 'sent', 'amount': 2500, 'date': '18 مارس', 'note': 'فاتورة المطعم'},
    {'name': 'فاطمة علي', 'initials': 'ف', 'color': const Color(0xFFE53935), 'type': 'received', 'amount': 5000, 'date': '15 مارس', 'note': 'نصيب الرحلة'},
  ];

  List<Map<String, dynamic>> get _filteredFriends {
    if (_searchQuery.isEmpty) return _friends;
    return _friends.where((f) =>
      (f['name'] as String).contains(_searchQuery) ||
      (f['phone'] as String).contains(_searchQuery)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchCtrl.addListener(() => setState(() => _searchQuery = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('مدفوعات الأصدقاء', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: [
            const Tab(text: 'الأصدقاء'),
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Tab(text: 'طلبات'),
                if (_pendingRequests.isNotEmpty)
                  Positioned(
                    top: 0, left: 0,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      child: Center(child: Text('${_pendingRequests.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Cairo'))),
                    ),
                  ),
              ],
            ),
            const Tab(text: 'النشاط'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFriendsTab(), _buildRequestsTab(), _buildActivityTab()],
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Column(
      children: [
        // بحث
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'بحث عن صديق...',
              hintStyle: const TextStyle(fontFamily: 'Cairo'),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // إحصائيات سريعة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          child: Row(
            children: [
              Expanded(child: _statBox('مستحق لك', '23,500 ريال', AppColors.success, Icons.arrow_downward_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _statBox('مستحق عليك', '8,000 ريال', AppColors.error, Icons.arrow_upward_rounded)),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            itemCount: _filteredFriends.length,
            itemBuilder: (_, i) {
              final friend = _filteredFriends[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: friend['color'] as Color,
                    child: Text(friend['initials'] as String, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                  title: Text(friend['name'] as String, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
                  subtitle: Text(friend['phone'] as String, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionBtn(Icons.send_rounded, AppColors.primaryBlue, () => _showSendMoneySheet(friend)),
                      const SizedBox(width: 6),
                      _actionBtn(Icons.request_page_rounded, AppColors.success, () => _showRequestMoneySheet(friend)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: color, fontSize: 11, fontFamily: 'Cairo')),
              Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _showSendMoneySheet(Map<String, dynamic> friend) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: friend['color'] as Color,
                    child: Text(friend['initials'] as String, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إرسال إلى ${friend['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                      Text(friend['phone'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 28, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 28),
                  suffixText: 'ريال',
                  suffixStyle: TextStyle(fontFamily: 'Cairo', fontSize: 18, color: AppColors.grey),
                  border: InputBorder.none,
                ),
              ),
              // مبالغ سريعة
              Row(
                children: [2000, 5000, 10000, 20000].map((amt) =>
                  Expanded(
                    child: GestureDetector(
                      onTap: () => amountCtrl.text = '$amt',
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(color: AppColors.lightGrey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                        child: Text('$amt', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12), textAlign: TextAlign.center),
                      ),
                    ),
                  )
                ).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: const InputDecoration(
                  labelText: 'ملاحظة (اختياري)',
                  labelStyle: TextStyle(fontFamily: 'Cairo'),
                  prefixIcon: Icon(Icons.note_rounded),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (amountCtrl.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إرسال ${amountCtrl.text} ريال إلى ${friend['name']}', style: const TextStyle(fontFamily: 'Cairo'))),
                    );
                  }
                },
                child: Text('إرسال ${amountCtrl.text.isNotEmpty ? "${amountCtrl.text} ريال" : ""}', style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRequestMoneySheet(Map<String, dynamic> friend) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('طلب مبلغ من ${friend['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
              const SizedBox(height: 20),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 28, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 28),
                  suffixText: 'ريال',
                  suffixStyle: TextStyle(fontFamily: 'Cairo', fontSize: 18, color: AppColors.grey),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: const InputDecoration(
                  labelText: 'سبب الطلب',
                  labelStyle: TextStyle(fontFamily: 'Cairo'),
                  prefixIcon: Icon(Icons.note_rounded),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (amountCtrl.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إرسال طلب ${amountCtrl.text} ريال إلى ${friend['name']}', style: const TextStyle(fontFamily: 'Cairo'))),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                child: const Text('إرسال الطلب', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 70, color: AppColors.grey.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            const Text('لا توجد طلبات معلقة', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _pendingRequests.length,
      itemBuilder: (_, i) {
        final req = _pendingRequests[i];
        final isIncoming = req['type'] == 'incoming';
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: (isIncoming ? req['fromColor'] : req['toColor']) as Color,
                    child: Text(
                      (isIncoming ? req['fromInitials'] : req['toInitials']) as String,
                      style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncoming ? 'طلب من ${req['from']}' : 'طلبت من ${req['to']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                        ),
                        Text(req['note'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${req['amount']} ريال',
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15, color: isIncoming ? AppColors.primaryBlue : AppColors.error),
                      ),
                      Text(req['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                    ],
                  ),
                ],
              ),
              if (isIncoming) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _pendingRequests.removeAt(i)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('رفض', style: TextStyle(color: AppColors.error, fontFamily: 'Cairo')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _pendingRequests.removeAt(i));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم الدفع بنجاح', style: TextStyle(fontFamily: 'Cairo'))),
                          );
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), minimumSize: Size.zero),
                        child: Text('دفع ${req['amount']} ريال', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _recentActivities.length,
      itemBuilder: (_, i) {
        final act = _recentActivities[i];
        final isSent = act['type'] == 'sent';
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: act['color'] as Color,
                    child: Text(act['initials'] as String, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                  Positioned(
                    bottom: 0, left: 0,
                    child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                        color: isSent ? AppColors.error : AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Icon(isSent ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 9, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(act['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
                    Text(act['note'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                    Text(act['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                  ],
                ),
              ),
              Text(
                '${isSent ? '-' : '+'} ${act['amount']} ريال',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: isSent ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
