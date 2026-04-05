import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FlightBookingScreen extends StatefulWidget {
  const FlightBookingScreen({super.key});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRoundTrip = false;
  String _selectedClass = 'اقتصادي';
  int _adults = 1;
  int _children = 0;
  DateTime _departDate = DateTime.now().add(const Duration(days: 5));
  DateTime _returnDate = DateTime.now().add(const Duration(days: 12));
  String _fromCity = 'صنعاء (SAH)';
  String _toCity = 'القاهرة (CAI)';
  bool _searched = false;

  final List<String> _cities = [
    'صنعاء (SAH)', 'عدن (ADE)', 'سيئون (GXF)',
    'الريان (RXA)', 'أبوظبي (AUH)', 'دبي (DXB)',
    'القاهرة (CAI)', 'الرياض (RUH)', 'عمّان (AMM)',
    'إسطنبول (IST)', 'لندن (LHR)', 'فرانكفورت (FRA)',
  ];

  final List<String> _classes = ['اقتصادي', 'رجال أعمال', 'درجة أولى'];

  final List<Map<String, dynamic>> _flights = [
    {
      'airline': 'اليمنية',
      'airlineCode': 'IY',
      'from': 'SAH',
      'to': 'CAI',
      'departure': '06:30',
      'arrival': '09:45',
      'duration': '3س 15د',
      'stops': 'مباشر',
      'price': 85000,
      'seats': 12,
      'class': 'اقتصادي',
      'gradient': [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
    },
    {
      'airline': 'فلاي دبي',
      'airlineCode': 'FZ',
      'from': 'SAH',
      'to': 'DXB',
      'departure': '10:15',
      'arrival': '13:30',
      'duration': '2س 15د',
      'stops': 'مباشر',
      'price': 62000,
      'seats': 4,
      'class': 'اقتصادي',
      'gradient': [const Color(0xFFE53935), const Color(0xFFC62828)],
    },
    {
      'airline': 'الخطوط السعودية',
      'airlineCode': 'SV',
      'from': 'SAH',
      'to': 'RUH',
      'departure': '14:00',
      'arrival': '16:10',
      'duration': '2س 10د',
      'stops': 'مباشر',
      'price': 55000,
      'seats': 8,
      'class': 'اقتصادي',
      'gradient': [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
    },
    {
      'airline': 'الإمارات',
      'airlineCode': 'EK',
      'from': 'SAH',
      'to': 'DXB',
      'departure': '18:45',
      'arrival': '22:00',
      'duration': '2س 15د',
      'stops': 'مباشر',
      'price': 110000,
      'seats': 2,
      'class': 'رجال أعمال',
      'gradient': [const Color(0xFF4A148C), const Color(0xFF6A1B9A)],
    },
    {
      'airline': 'طيران عُمان',
      'airlineCode': 'WY',
      'from': 'SAH',
      'to': 'AMM',
      'departure': '08:00',
      'arrival': '12:30',
      'duration': '4س 30د',
      'stops': '1 وقفة',
      'price': 95000,
      'seats': 20,
      'class': 'اقتصادي',
      'gradient': [const Color(0xFF37474F), const Color(0xFF546E7A)],
    },
  ];

  final List<Map<String, dynamic>> _myBookings = [
    {
      'airline': 'اليمنية',
      'from': 'صنعاء',
      'to': 'القاهرة',
      'date': '20 مارس 2026',
      'departure': '06:30',
      'arrival': '09:45',
      'seat': '14A',
      'class': 'اقتصادي',
      'price': 85000,
      'status': 'مؤكد',
      'bookingRef': 'IY20260320',
    },
    {
      'airline': 'فلاي دبي',
      'from': 'دبي',
      'to': 'صنعاء',
      'date': '5 مارس 2026',
      'departure': '22:00',
      'arrival': '01:15',
      'seat': '22C',
      'class': 'اقتصادي',
      'price': 58000,
      'status': 'منتهي',
      'bookingRef': 'FZ20260305',
    },
  ];

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

  Future<void> _selectDate(bool isDeparture) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? _departDate : _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) _departDate = picked;
        else _returnDate = picked;
      });
    }
  }

  void _swapCities() {
    setState(() {
      final tmp = _fromCity;
      _fromCity = _toCity;
      _toCity = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('حجز طيران', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [Tab(text: 'بحث عن رحلة'), Tab(text: 'حجوزاتي')],
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
          // بطاقة البحث
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                // ذهاب فقط / ذهاب وعودة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tripTypeBtn('ذهاب فقط', !_isRoundTrip),
                    const SizedBox(width: 8),
                    _tripTypeBtn('ذهاب وعودة', _isRoundTrip),
                  ],
                ),
                const SizedBox(height: 16),

                // من / إلى
                Row(
                  children: [
                    Expanded(child: _citySelector(_fromCity, 'من', Icons.flight_takeoff_rounded, true)),
                    GestureDetector(
                      onTap: _swapCities,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(child: _citySelector(_toCity, 'إلى', Icons.flight_land_rounded, false)),
                  ],
                ),
                const SizedBox(height: 12),

                // تواريخ
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(true),
                        child: _dateBox('المغادرة', _departDate),
                      ),
                    ),
                    if (_isRoundTrip) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(false),
                          child: _dateBox('العودة', _returnDate),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // مقاعد وصف
                Row(
                  children: [
                    Expanded(child: _passengerSelector()),
                    const SizedBox(width: 8),
                    Expanded(child: _classSelector()),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () => setState(() => _searched = true),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('بحث عن رحلات', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.primaryBlue,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
              ],
            ),
          ),

          if (_searched) ...[
            const SizedBox(height: AppSizes.paddingL),
            Row(
              children: [
                const Text('الرحلات المتاحة', style: AppTextStyles.heading3),
                const Spacer(),
                Text('${_flights.length} رحلة', style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo')),
              ],
            ),
            const SizedBox(height: AppSizes.paddingM),
            ..._flights.map((f) => _buildFlightCard(f)).toList(),
          ] else ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(Icons.flight_rounded, size: 80, color: AppColors.primaryBlue.withValues(alpha: 0.2)),
                  const SizedBox(height: 12),
                  const Text('ابحث عن رحلتك', style: TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 16)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tripTypeBtn(String label, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => _isRoundTrip = label == 'ذهاب وعودة'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.white : Colors.white38),
        ),
        child: Text(label, style: TextStyle(color: selected ? AppColors.primaryBlue : Colors.white70, fontFamily: 'Cairo', fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _citySelector(String city, String label, IconData icon, bool isFrom) {
    final code = city.contains('(') ? city.substring(city.indexOf('(') + 1, city.indexOf(')')) : city;
    return GestureDetector(
      onTap: () => _showCityPicker(isFrom),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo')),
            ]),
            const SizedBox(height: 4),
            Text(code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 20)),
            Text(city.split(' ').first, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(String label, DateTime date) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo')),
          const SizedBox(height: 4),
          Text('${date.day}/${date.month}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
          Text(date.year.toString(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _passengerSelector() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المسافرون', style: TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo')),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${_adults + _children}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
              const SizedBox(width: 4),
              const Icon(Icons.person_rounded, color: Colors.white70, size: 16),
              const Spacer(),
              GestureDetector(
                onTap: () { if (_adults + _children < 9) setState(() => _adults++); },
                child: const Icon(Icons.add_circle_rounded, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () { if (_adults > 1) setState(() => _adults--); },
                child: const Icon(Icons.remove_circle_rounded, color: Colors.white70, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _classSelector() {
    return GestureDetector(
      onTap: () => _showClassPicker(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الدرجة', style: TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo')),
            const SizedBox(height: 4),
            Text(_selectedClass, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 14)),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCityPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2))),
          Text(isFrom ? 'اختر مدينة المغادرة' : 'اختر مدينة الوصول', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _cities.length,
              itemBuilder: (_, i) {
                final city = _cities[i];
                final code = city.substring(city.indexOf('(') + 1, city.indexOf(')'));
                return ListTile(
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontFamily: 'Cairo', fontSize: 12))),
                  ),
                  title: Text(city, style: const TextStyle(fontFamily: 'Cairo')),
                  onTap: () {
                    setState(() {
                      if (isFrom) _fromCity = city; else _toCity = city;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClassPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2))),
          const Text('اختر الدرجة', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
          const SizedBox(height: 8),
          ..._classes.map((c) => ListTile(
            title: Text(c, style: const TextStyle(fontFamily: 'Cairo')),
            trailing: _selectedClass == c ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue) : null,
            onTap: () {
              setState(() => _selectedClass = c);
              Navigator.pop(context);
            },
          )).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    final isLowSeats = (flight['seats'] as int) <= 5;
    return GestureDetector(
      onTap: () => _showFlightDetails(flight),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: (flight['gradient'] as List).cast<Color>()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(flight['airlineCode'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 12))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight['airline'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      Text(flight['class'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${flight['price']} ريال', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontFamily: 'Cairo', fontSize: 15)),
                    const Text('للشخص', style: TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(flight['departure'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 22)),
                    Text(flight['from'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(flight['duration'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.grey.withValues(alpha: 0.3), thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.flight_rounded, size: 14, color: AppColors.primaryBlue.withValues(alpha: 0.6)),
                          ),
                          Expanded(child: Divider(color: AppColors.grey.withValues(alpha: 0.3), thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight['stops'] as String,
                        style: TextStyle(
                          color: flight['stops'] == 'مباشر' ? AppColors.success : AppColors.warning,
                          fontFamily: 'Cairo', fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(flight['arrival'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 22)),
                    Text(flight['to'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
              ],
            ),
            if (isLowSeats) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'تبقى ${flight['seats']} مقاعد فقط!',
                  style: const TextStyle(color: AppColors.warning, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFlightDetails(Map<String, dynamic> flight) {
    final totalPrice = (flight['price'] as int) * (_adults + _children);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
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
                    // رأس الرحلة
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: (flight['gradient'] as List).cast<Color>()),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(flight['departure'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 28)),
                              Text(flight['from'] as String, style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(Icons.flight_rounded, color: Colors.white60),
                                Text(flight['duration'] as String, style: const TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 11)),
                                Text(flight['stops'] as String, style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 11)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(flight['arrival'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 28)),
                              Text(flight['to'] as String, style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // تفاصيل
                    const Text('تفاصيل الرحلة', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          _flightDetailRow('الشركة', flight['airline'] as String),
                          const Divider(height: 16),
                          _flightDetailRow('الدرجة', flight['class'] as String),
                          const Divider(height: 16),
                          _flightDetailRow('عدد المسافرين', '$_adults بالغ${_children > 0 ? ' + $_children طفل' : ''}'),
                          const Divider(height: 16),
                          _flightDetailRow('تاريخ الرحلة', '${_departDate.day}/${_departDate.month}/${_departDate.year}'),
                          if (_isRoundTrip) ...[
                            const Divider(height: 16),
                            _flightDetailRow('تاريخ العودة', '${_returnDate.day}/${_returnDate.month}/${_returnDate.year}'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // السعر
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
                              const Text('إجمالي السعر', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 13)),
                              Text('$totalPrice ريال', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 22)),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${flight['price']} × ${_adults + _children}', style: const TextStyle(color: Colors.white60, fontFamily: 'Cairo', fontSize: 12)),
                              Text('متبقي: ${flight['seats']} مقاعد', style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmFlight(flight, totalPrice);
                      },
                      child: const Text('تأكيد الحجز', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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

  Widget _flightDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo')),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ],
    );
  }

  void _confirmFlight(Map<String, dynamic> flight, int total) {
    setState(() => _searched = false);
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
            Text('${flight['airline']} - ${flight['from']} ← ${flight['to']}', style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo'), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('$total ريال', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'رقم الرحلة: ${flight['airlineCode']}${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
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
        final isUpcoming = b['status'] == 'مؤكد';
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
                  Text('${b['from']} ← ${b['to']}', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(b['status'] as String, style: TextStyle(color: isUpcoming ? AppColors.info : AppColors.grey, fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(b['airline'] as String, style: const TextStyle(color: AppColors.grey, fontFamily: 'Cairo', fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text(b['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time_rounded, size: 13, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text('${b['departure']} - ${b['arrival']}', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const Spacer(),
                  Text('${b['price']} ريال', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: AppColors.primaryBlue)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.airline_seat_recline_normal_rounded, size: 13, color: AppColors.grey),
                  const SizedBox(width: 4),
                  Text('مقعد: ${b['seat']}', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const SizedBox(width: 10),
                  Text('• ${b['class']}', style: const TextStyle(color: AppColors.grey, fontSize: 12, fontFamily: 'Cairo')),
                  const Spacer(),
                  Text('رقم: ${b['bookingRef']}', style: const TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'Cairo')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
