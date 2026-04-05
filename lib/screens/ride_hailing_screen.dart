import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RideHailingScreen extends StatefulWidget {
  const RideHailingScreen({super.key});

  @override
  State<RideHailingScreen> createState() => _RideHailingScreenState();
}

class _RideHailingScreenState extends State<RideHailingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRideType = 'economy';
  bool _isSearching = false;
  bool _rideFound = false;
  final TextEditingController _fromCtrl = TextEditingController(text: 'موقعي الحالي');
  final TextEditingController _toCtrl = TextEditingController();

  final List<Map<String, dynamic>> _rideTypes = [
    {
      'id': 'economy',
      'name': 'اقتصادي',
      'icon': Icons.directions_car_rounded,
      'desc': '4 مقاعد',
      'price': 1200,
      'time': '3 دقائق',
      'color': const Color(0xFF0097A7),
    },
    {
      'id': 'comfort',
      'name': 'مريح',
      'icon': Icons.airport_shuttle_rounded,
      'desc': '4 مقاعد فاخرة',
      'price': 1800,
      'time': '5 دقائق',
      'color': const Color(0xFF1565C0),
    },
    {
      'id': 'xl',
      'name': 'XL كبير',
      'icon': Icons.directions_bus_rounded,
      'desc': '6 مقاعد',
      'price': 2200,
      'time': '7 دقائق',
      'color': const Color(0xFF388E3C),
    },
    {
      'id': 'bike',
      'name': 'دراجة',
      'icon': Icons.two_wheeler_rounded,
      'desc': 'مقعد واحد',
      'price': 600,
      'time': '2 دقائق',
      'color': const Color(0xFFE53935),
    },
  ];

  final List<Map<String, dynamic>> _myRides = [
    {
      'from': 'شارع الستين',
      'to': 'ميدان التحرير',
      'date': 'اليوم، 10:30 ص',
      'price': 1400,
      'status': 'مكتملة',
      'driver': 'أحمد محمد',
      'rating': 4.8,
      'type': 'اقتصادي',
    },
    {
      'from': 'المطار',
      'to': 'فندق الموج',
      'date': 'أمس، 3:00 م',
      'price': 3500,
      'status': 'مكتملة',
      'driver': 'خالد علي',
      'rating': 5.0,
      'type': 'مريح',
    },
    {
      'from': 'جامعة صنعاء',
      'to': 'السبعين',
      'date': '15 مارس',
      'price': 900,
      'status': 'ملغاة',
      'driver': 'سعيد حسن',
      'rating': 0.0,
      'type': 'اقتصادي',
    },
  ];

  final Map<String, dynamic> _demoDriver = {
    'name': 'محمد عبد الله',
    'rating': 4.9,
    'car': 'تويوتا كامري',
    'plate': 'ص أ 1234',
    'photo': 'م',
    'eta': '3 دقائق',
    'phone': '+967 777 123 456',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _requestRide() {
    if (_toCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل وجهتك', style: TextStyle(fontFamily: 'Cairo')),
        ),
      );
      return;
    }
    setState(() => _isSearching = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() { _isSearching = false; _rideFound = true; });
    });
  }

  void _cancelRide() {
    setState(() { _rideFound = false; _isSearching = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إلغاء الطلب', style: TextStyle(fontFamily: 'Cairo')),
      ),
    );
  }

  void _completeRide() {
    setState(() { _rideFound = false; _toCtrl.clear(); });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9), shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('وصلت بسلام!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            const Text('شكراً لاختيارك YemenPay Ride', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo'), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Text('قيّم رحلتك', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 32)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إرسال التقييم', style: TextStyle(fontFamily: 'Cairo')),
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
        title: const Text('حجز رحلة', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'رحلة جديدة'), Tab(text: 'رحلاتي')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildNewRideTab(), _buildMyRidesTab()],
      ),
    );
  }

  Widget _buildNewRideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // خريطة وهمية
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // شبكة الخريطة
                Positioned.fill(
                  child: CustomPaint(painter: _MapGridPainter()),
                ),
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_rounded, color: Colors.red, size: 40),
                      SizedBox(height: 4),
                      Text('موقعك الحالي', style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      Text('صنعاء - اليمن', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 12)),
                    ],
                  ),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gps_fixed_rounded, size: 14, color: AppColors.primaryBlue),
                        SizedBox(width: 4),
                        Text('تحديد الموقع', style: TextStyle(fontSize: 11, fontFamily: 'Cairo', color: AppColors.primaryBlue)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // حقول المسار
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                        Container(width: 2, height: 30, color: AppColors.grey.withValues(alpha: 0.3)),
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(3))),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _fromCtrl,
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'نقطة الانطلاق',
                              hintStyle: TextStyle(fontFamily: 'Cairo'),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                          Divider(height: 1, color: AppColors.lightGrey.withValues(alpha: 0.5)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _toCtrl,
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'إلى أين؟',
                              hintStyle: TextStyle(fontFamily: 'Cairo'),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.paddingM),

          // أنواع الرحلة
          const Text('نوع الرحلة', style: AppTextStyles.heading3),
          const SizedBox(height: AppSizes.paddingS),
          ...(_rideTypes.map((rt) => _buildRideTypeCard(rt)).toList()),

          const SizedBox(height: AppSizes.paddingM),

          if (_isSearching) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryBlue),
                  const SizedBox(height: 16),
                  const Text('جاري البحث عن سائق...', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _cancelRide,
                    child: const Text('إلغاء', style: TextStyle(color: AppColors.error, fontFamily: 'Cairo')),
                  ),
                ],
              ),
            ),
          ] else if (_rideFound) ...[
            _buildDriverFoundCard(),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: _requestRide,
                icon: const Icon(Icons.local_taxi_rounded),
                label: Text(
                  'طلب ${_rideTypes.firstWhere((r) => r['id'] == _selectedRideType)['name']} - ${_rideTypes.firstWhere((r) => r['id'] == _selectedRideType)['price']} ريال',
                  style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRideTypeCard(Map<String, dynamic> rt) {
    final isSelected = _selectedRideType == rt['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedRideType = rt['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? (rt['color'] as Color).withValues(alpha: 0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: isSelected ? rt['color'] as Color : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: (rt['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(rt['icon'] as IconData, color: rt['color'] as Color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rt['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  Text(rt['desc'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${rt['price']} ريال', style: TextStyle(fontWeight: FontWeight.bold, color: rt['color'] as Color, fontFamily: 'Cairo')),
                Text(rt['time'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: rt['color'] as Color, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDriverFoundCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(_demoDriver['photo'] as String, style: const TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Cairo')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_demoDriver['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                    Text(_demoDriver['car'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 16),
                        const SizedBox(width: 2),
                        Text('${_demoDriver['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'لوحة: ${_demoDriver['plate']}',
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryBlue),
                const SizedBox(width: 6),
                Text('السائق على بعد ${_demoDriver['eta']}', style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cancelRide,
                  icon: const Icon(Icons.close_rounded, color: AppColors.error, size: 18),
                  label: const Text('إلغاء', style: TextStyle(color: AppColors.error, fontFamily: 'Cairo')),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _completeRide,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('اكتملت', style: TextStyle(fontFamily: 'Cairo')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyRidesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _myRides.length,
      itemBuilder: (context, i) {
        final ride = _myRides[i];
        final isDone = ride['status'] == 'مكتملة';
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ride['status'] as String,
                      style: TextStyle(
                        color: isDone ? AppColors.success : AppColors.error,
                        fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(ride['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                ],
              ),
              const SizedBox(height: 12),
              _buildRouteRow(Icons.circle, AppColors.success, ride['from'] as String),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(width: 2, height: 16, color: AppColors.grey.withValues(alpha: 0.2), margin: const EdgeInsets.symmetric(vertical: 2)),
              ),
              _buildRouteRow(Icons.location_on_rounded, AppColors.error, ride['to'] as String),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text(ride['driver'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const SizedBox(width: 8),
                  Text('• ${ride['type']}', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const Spacer(),
                  if (isDone && ride['rating'] > 0) ...[
                    const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 14),
                    const SizedBox(width: 2),
                    Text('${ride['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo')),
                    const SizedBox(width: 8),
                  ],
                  Text('${ride['price']} ريال', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
