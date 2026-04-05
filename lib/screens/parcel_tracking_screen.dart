import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class ParcelTrackingScreen extends StatefulWidget {
  const ParcelTrackingScreen({super.key});

  @override
  State<ParcelTrackingScreen> createState() => _ParcelTrackingScreenState();
}

class _TrackingEvent {
  final String status;
  final String description;
  final String time;
  final String date;
  final bool isCompleted;
  final IconData icon;

  const _TrackingEvent({
    required this.status,
    required this.description,
    required this.time,
    required this.date,
    required this.isCompleted,
    required this.icon,
  });
}

class _Parcel {
  final String trackingNo;
  final String sender;
  final String recipient;
  final String origin;
  final String destination;
  final String estimatedDelivery;
  final String currentStatus;
  final Color statusColor;
  final List<_TrackingEvent> events;
  final String carrier;
  final double weight;

  const _Parcel({
    required this.trackingNo,
    required this.sender,
    required this.recipient,
    required this.origin,
    required this.destination,
    required this.estimatedDelivery,
    required this.currentStatus,
    required this.statusColor,
    required this.events,
    required this.carrier,
    required this.weight,
  });
}

final _mockParcels = <String, _Parcel>{
  'YP2026001': const _Parcel(
    trackingNo: 'YP2026001',
    sender: 'متجر الخليج للإلكترونيات',
    recipient: 'أحمد علي',
    origin: 'دبي، الإمارات',
    destination: 'صنعاء، اليمن',
    estimatedDelivery: '22 مارس 2026',
    currentStatus: 'في الطريق إليك',
    statusColor: Color(0xFF0097A7),
    carrier: 'يمن اكسبريس',
    weight: 1.5,
    events: [
      _TrackingEvent(
        status: 'تم الشحن من المرسل',
        description: 'استلمت شركة يمن اكسبريس الطرد من المرسل',
        time: '10:30 ص',
        date: '16 مارس 2026',
        isCompleted: true,
        icon: Icons.inventory_rounded,
      ),
      _TrackingEvent(
        status: 'وصول مستودع دبي',
        description: 'الطرد في مستودع الفرز بمطار دبي',
        time: '2:45 م',
        date: '17 مارس 2026',
        isCompleted: true,
        icon: Icons.warehouse_rounded,
      ),
      _TrackingEvent(
        status: 'رحلة جوية',
        description: 'الطرد على متن الطائرة FZ602 دبي - صنعاء',
        time: '11:00 م',
        date: '18 مارس 2026',
        isCompleted: true,
        icon: Icons.flight_rounded,
      ),
      _TrackingEvent(
        status: 'وصول مطار صنعاء',
        description: 'الطرد في مطار صنعاء الدولي — قيد التخليص الجمركي',
        time: '6:20 ص',
        date: '19 مارس 2026',
        isCompleted: true,
        icon: Icons.local_airport_rounded,
      ),
      _TrackingEvent(
        status: 'في الطريق إليك',
        description: 'السائق في طريقه لتوصيل الطرد',
        time: '9:00 ص',
        date: '19 مارس 2026',
        isCompleted: false,
        icon: Icons.local_shipping_rounded,
      ),
      _TrackingEvent(
        status: 'تم التسليم',
        description: 'تم تسليم الطرد بنجاح',
        time: '—',
        date: 'متوقع 22 مارس 2026',
        isCompleted: false,
        icon: Icons.check_circle_rounded,
      ),
    ],
  ),
  'YP2026002': const _Parcel(
    trackingNo: 'YP2026002',
    sender: 'أمازون السعودية',
    recipient: 'أحمد علي',
    origin: 'الرياض، السعودية',
    destination: 'عدن، اليمن',
    estimatedDelivery: '25 مارس 2026',
    currentStatus: 'قيد التخليص الجمركي',
    statusColor: Color(0xFFFFA000),
    carrier: 'ارامكس اليمن',
    weight: 3.2,
    events: [
      _TrackingEvent(
        status: 'تم الشحن',
        description: 'الطرد في طريقه',
        time: '8:00 ص',
        date: '17 مارس 2026',
        isCompleted: true,
        icon: Icons.inventory_rounded,
      ),
      _TrackingEvent(
        status: 'قيد التخليص الجمركي',
        description: 'يجري مراجعة الطرد من قبل الجمارك',
        time: '11:30 ص',
        date: '19 مارس 2026',
        isCompleted: false,
        icon: Icons.rule_rounded,
      ),
      _TrackingEvent(
        status: 'توصيل',
        description: 'سيتم التوصيل بعد التخليص',
        time: '—',
        date: 'متوقع 25 مارس 2026',
        isCompleted: false,
        icon: Icons.home_rounded,
      ),
    ],
  ),
};

class _ParcelTrackingScreenState extends State<ParcelTrackingScreen> {
  final _ctrl = TextEditingController();
  _Parcel? _foundParcel;
  bool _searched = false;
  bool _notFound = false;

  // شحنات محفوظة
  final List<String> _savedTracking = ['YP2026001', 'YP2026002'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _track() {
    final no = _ctrl.text.trim().toUpperCase();
    if (no.isEmpty) return;
    setState(() {
      _foundParcel = _mockParcels[no];
      _searched = true;
      _notFound = _foundParcel == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تتبع الشحنات',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل البحث
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أدخل رقم التتبع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                  const SizedBox(height: AppSizes.paddingS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'مثال: YP2026001',
                            prefixIcon:
                                Icon(Icons.qr_code_scanner_rounded),
                            hintStyle: TextStyle(fontFamily: 'Cairo'),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Cairo', letterSpacing: 1.5),
                          onSubmitted: (_) => _track(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _track,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.borderRadius),
                            ),
                          ),
                          child: const Text('تتبع',
                              style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // نتيجة البحث
            if (_searched) ...[
              const SizedBox(height: AppSizes.paddingM),
              if (_notFound)
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_off_rounded,
                          color: AppColors.error, size: 32),
                      SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Text(
                          'لم يتم العثور على الشحنة.\nتحقق من رقم التتبع وحاول مجدداً.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_foundParcel != null)
                _ParcelDetails(parcel: _foundParcel!),
            ],

            // شحناتي المحفوظة
            if (!_searched || _notFound) ...[
              const SizedBox(height: AppSizes.paddingL),
              const Text('شحناتي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const SizedBox(height: AppSizes.paddingS),
              ..._savedTracking.map((no) {
                final p = _mockParcels[no];
                if (p == null) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    _ctrl.text = no;
                    setState(() {
                      _foundParcel = p;
                      _searched = true;
                      _notFound = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: p.statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.local_shipping_rounded,
                              color: p.statusColor, size: 24),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(no,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  )),
                              Text(p.sender,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: p.statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(p.currentStatus,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: p.statusColor,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _ParcelDetails extends StatelessWidget {
  final _Parcel parcel;
  const _ParcelDetails({required this.parcel});

  @override
  Widget build(BuildContext context) {
    final p = parcel;
    final completedCount = p.events.where((e) => e.isCompleted).length;
    final progress = completedCount / p.events.length;

    return Column(
      children: [
        // بطاقة ملخص
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [p.statusColor, p.statusColor.withValues(alpha: 0.7)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.currentStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'Cairo',
                            )),
                        Text(p.trackingNo,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                              letterSpacing: 1.5,
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: p.trackingNo));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم نسخ رقم التتبع',
                              style: TextStyle(fontFamily: 'Cairo')),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(Icons.copy_rounded,
                        color: Colors.white70, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(progress * 100).toStringAsFixed(0)}% مكتمل',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      )),
                  Text('التوصيل المتوقع: ${p.estimatedDelivery}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.paddingM),

        // تفاصيل الشحنة
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Column(
            children: [
              _InfoRow(Icons.person_rounded, 'المرسل', p.sender),
              const Divider(height: 16),
              _InfoRow(Icons.person_outline_rounded, 'المستلم', p.recipient),
              const Divider(height: 16),
              _InfoRow(Icons.location_on_rounded, 'من', p.origin),
              const Divider(height: 16),
              _InfoRow(Icons.location_on_outlined, 'إلى', p.destination),
              const Divider(height: 16),
              _InfoRow(Icons.local_shipping_rounded, 'شركة الشحن', p.carrier),
              const Divider(height: 16),
              _InfoRow(Icons.scale_rounded, 'الوزن', '${p.weight} كيلوغرام'),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.paddingM),

        // تسلسل التتبع
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مراحل الشحنة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
              const SizedBox(height: AppSizes.paddingM),
              ...p.events.asMap().entries.map((entry) {
                final i = entry.key;
                final event = entry.value;
                final isLast = i == p.events.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العمود الزمني
                    Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: event.isCompleted
                                ? p.statusColor
                                : AppColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(event.icon,
                              color: event.isCompleted
                                  ? Colors.white
                                  : AppColors.grey,
                              size: 18),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 50,
                            color: event.isCompleted
                                ? p.statusColor.withValues(alpha: 0.3)
                                : AppColors.lightGrey,
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: isLast ? 0 : AppSizes.paddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.status,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: event.isCompleted
                                      ? AppColors.textPrimary
                                      : AppColors.grey,
                                )),
                            const SizedBox(height: 2),
                            Text(event.description,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: AppColors.grey,
                                  height: 1.3,
                                )),
                            const SizedBox(height: 2),
                            Text(
                              event.isCompleted
                                  ? '${event.date} — ${event.time}'
                                  : event.date,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: event.isCompleted
                                    ? p.statusColor
                                    : AppColors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.grey),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(
                fontFamily: 'Cairo', color: AppColors.grey, fontSize: 13)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
