import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCity = 'صنعاء';
  String _selectedCategory = 'الكل';
  DateTime _checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 3));
  int _guests = 2;

  final List<String> _cities = ['صنعاء', 'عدن', 'تعز', 'الحديدة', 'إب', 'مأرب'];
  final List<String> _categories = ['الكل', '5 نجوم', '4 نجوم', '3 نجوم', 'شقق'];

  final List<Map<String, dynamic>> _hotels = [
    {
      'name': 'فندق موفنبيك صنعاء',
      'city': 'صنعاء',
      'stars': 5,
      'category': '5 نجوم',
      'rating': 4.8,
      'reviews': 342,
      'price': 45000,
      'amenities': ['واي فاي', 'مسبح', 'مطعم', 'صالة رياضة'],
      'gradient': [const Color(0xFF1A237E), const Color(0xFF283593)],
      'icon': Icons.hotel_rounded,
      'available': true,
    },
    {
      'name': 'قصر عدن الكبير',
      'city': 'عدن',
      'stars': 5,
      'category': '5 نجوم',
      'rating': 4.7,
      'reviews': 210,
      'price': 38000,
      'amenities': ['واي فاي', 'شاطئ خاص', 'مطعم', 'سبا'],
      'gradient': [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
      'icon': Icons.villa_rounded,
      'available': true,
    },
    {
      'name': 'فندق الساحل الأزرق',
      'city': 'الحديدة',
      'stars': 4,
      'category': '4 نجوم',
      'rating': 4.5,
      'reviews': 178,
      'price': 22000,
      'amenities': ['واي فاي', 'إفطار', 'موقف سيارات'],
      'gradient': [const Color(0xFF006064), const Color(0xFF00838F)],
      'icon': Icons.beach_access_rounded,
      'available': true,
    },
    {
      'name': 'شقق الرياض السكنية',
      'city': 'صنعاء',
      'stars': 3,
      'category': 'شقق',
      'rating': 4.2,
      'reviews': 95,
      'price': 15000,
      'amenities': ['واي فاي', 'مطبخ كامل', 'غسالة'],
      'gradient': [const Color(0xFF4A148C), const Color(0xFF6A1B9A)],
      'icon': Icons.apartment_rounded,
      'available': false,
    },
    {
      'name': 'فندق تاج تعز',
      'city': 'تعز',
      'stars': 4,
      'category': '4 نجوم',
      'rating': 4.4,
      'reviews': 134,
      'price': 25000,
      'amenities': ['واي فاي', 'إفطار', 'مطعم', 'قاعة اجتماعات'],
      'gradient': [const Color(0xFF880E4F), const Color(0xFFAD1457)],
      'icon': Icons.business_rounded,
      'available': true,
    },
  ];

  final List<Map<String, dynamic>> _myBookings = [
    {
      'hotel': 'فندق موفنبيك صنعاء',
      'checkIn': '20 مارس 2026',
      'checkOut': '23 مارس 2026',
      'nights': 3,
      'guests': 2,
      'total': 135000,
      'status': 'قادم',
      'bookingId': 'HB20260320',
    },
    {
      'hotel': 'قصر عدن الكبير',
      'checkIn': '5 فبراير 2026',
      'checkOut': '7 فبراير 2026',
      'nights': 2,
      'guests': 2,
      'total': 76000,
      'status': 'مكتمل',
      'bookingId': 'HB20260205',
    },
  ];

  List<Map<String, dynamic>> get _filteredHotels {
    return _hotels.where((h) {
      final cityMatch = h['city'] == _selectedCity;
      final catMatch = _selectedCategory == 'الكل' || h['category'] == _selectedCategory;
      return cityMatch && catMatch;
    }).toList();
  }

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

  int get _nights => _checkOut.difference(_checkIn).inDays;

  Future<void> _selectDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut.isBefore(_checkIn.add(const Duration(days: 1)))) {
            _checkOut = _checkIn.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('حجز فنادق', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'بحث'), Tab(text: 'حجوزاتي')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSearchTab(), _buildBookingsTab()],
      ),
    );
  }

  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // فلتر المدينة
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: _cities.length,
              itemBuilder: (_, i) {
                final city = _cities[i];
                final sel = city == _selectedCity;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCity = city),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryBlue : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? AppColors.primaryBlue : AppColors.lightGrey),
                    ),
                    child: Text(city, style: TextStyle(color: sel ? Colors.white : AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // بطاقة البحث
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(true),
                        child: _buildDateBox('تسجيل الدخول', _checkIn, Icons.login_rounded, AppColors.success),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryBlue, size: 18),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(false),
                        child: _buildDateBox('تسجيل الخروج', _checkOut, Icons.logout_rounded, AppColors.error),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people_outline_rounded, color: AppColors.grey, size: 18),
                      const SizedBox(width: 8),
                      const Text('عدد الضيوف:', style: TextStyle(fontFamily: 'Cairo', color: AppColors.grey)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () { if (_guests > 1) setState(() => _guests--); },
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.lightGrey)),
                          child: const Icon(Icons.remove_rounded, size: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('$_guests', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: () { if (_guests < 8) setState(() => _guests++); },
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.nights_stay_rounded, color: AppColors.primaryBlue, size: 16),
                      const SizedBox(width: 6),
                      Text('$_nights ليالٍ', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
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
                      color: sel ? AppColors.accentYellow : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: sel ? AppColors.accentYellow : AppColors.lightGrey),
                    ),
                    child: Text(cat, style: TextStyle(color: sel ? AppColors.primaryBlue : AppColors.grey, fontFamily: 'Cairo', fontSize: 12, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.paddingM),

          if (_filteredHotels.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.hotel_outlined, size: 60, color: AppColors.grey.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    const Text('لا توجد فنادق متاحة في هذه المدينة', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo'), textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          else
            ..._filteredHotels.map((hotel) => _buildHotelCard(hotel)).toList(),
        ],
      ),
    );
  }

  Widget _buildDateBox(String label, DateTime date, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 11, color: color, fontFamily: 'Cairo')),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () => _showHotelDetails(hotel),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (hotel['gradient'] as List).cast<Color>(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.borderRadiusLarge)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(hotel['icon'] as IconData, size: 100, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: Row(
                      children: List.generate(
                        hotel['stars'] as int,
                        (i) => const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 16),
                      ),
                    ),
                  ),
                  if (!(hotel['available'] as bool))
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                        child: const Text('محجوز بالكامل', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Cairo')),
                      ),
                    ),
                  Positioned(
                    bottom: 12, right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hotel['name'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16),
                        ),
                        Text(hotel['city'] as String, style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 16),
                      const SizedBox(width: 4),
                      Text('${hotel['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      Text(' (${hotel['reviews']} تقييم)', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                      const Spacer(),
                      Text(
                        '${hotel['price']} ريال',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontFamily: 'Cairo', fontSize: 16),
                      ),
                      const Text(' / ليلة', style: TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6, runSpacing: 4,
                    children: (hotel['amenities'] as List<String>).map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(a, style: const TextStyle(fontSize: 11, fontFamily: 'Cairo', color: AppColors.textSecondary)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHotelDetails(Map<String, dynamic> hotel) {
    final total = (hotel['price'] as int) * _nights;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)),
              ),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
                  children: [
                    Text(hotel['name'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: AppColors.grey),
                        Text(hotel['city'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo')),
                        const Spacer(),
                        ...List.generate(hotel['stars'] as int, (i) => const Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // تفاصيل الحجز
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          _detailRow('تسجيل الدخول', '${_checkIn.day}/${_checkIn.month}/${_checkIn.year}'),
                          const Divider(height: 16),
                          _detailRow('تسجيل الخروج', '${_checkOut.day}/${_checkOut.month}/${_checkOut.year}'),
                          const Divider(height: 16),
                          _detailRow('عدد الليالي', '$_nights ليالٍ'),
                          const Divider(height: 16),
                          _detailRow('عدد الضيوف', '$_guests أشخاص'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // الخدمات
                    const Text('المرافق والخدمات', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: (hotel['amenities'] as List<String>).map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
                        ),
                        child: Text(a, style: const TextStyle(color: AppColors.primaryBlue, fontFamily: 'Cairo', fontSize: 13)),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    // إجمالي السعر
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('إجمالي التكلفة', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 13)),
                              Text('$total ريال', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 22)),
                            ],
                          ),
                          const Spacer(),
                          Text('$_nights × ${hotel['price']} ريال', style: const TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (hotel['available'] as bool)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmBooking(hotel, total);
                        },
                        child: const Text('تأكيد الحجز', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        ),
                        child: const Text('لا تتوفر غرف في هذه الفترة', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo')),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ],
    );
  }

  void _confirmBooking(Map<String, dynamic> hotel, int total) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('تم الحجز بنجاح!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            Text(hotel['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo'), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('$total ريال', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'رقم الحجز: HB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _myBookings.length,
      itemBuilder: (_, i) {
        final b = _myBookings[i];
        final isUpcoming = b['status'] == 'قادم';
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
                  Text(b['hotel'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming ? const Color(0xFFE3F2FD) : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(b['status'] as String, style: TextStyle(color: isUpcoming ? AppColors.info : AppColors.success, fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _miniInfo(Icons.login_rounded, b['checkIn'] as String),
                  const SizedBox(width: 16),
                  _miniInfo(Icons.logout_rounded, b['checkOut'] as String),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _miniInfo(Icons.nights_stay_rounded, '${b['nights']} ليالٍ'),
                  const SizedBox(width: 16),
                  _miniInfo(Icons.people_outline_rounded, '${b['guests']} ضيوف'),
                  const Spacer(),
                  Text('${b['total']} ريال', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: AppColors.primaryBlue)),
                ],
              ),
              const SizedBox(height: 8),
              Text('رقم الحجز: ${b['bookingId']}', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
            ],
          ),
        );
      },
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.grey, fontFamily: 'Cairo')),
      ],
    );
  }
}
