import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _selectedType = 'استفسار عام';
  bool _sending = false;
  bool _sent = false;

  final List<String> _types = [
    'استفسار عام',
    'مشكلة تقنية',
    'شكوى',
    'اقتراح',
    'طلب استرداد',
    'أخرى',
  ];

  List<Map<String, dynamic>> get _contactMethods => [
    {
      'icon': Icons.phone_rounded,
      'label': 'اتصل بنا',
      'value': '+967 777 182 233',
      'subtitle': 'متاح 24/7',
      'color': const Color(0xFF1565C0),
      'url': 'tel:+967777182233',
    },
    {
      'icon': Icons.chat_rounded,
      'label': 'واتساب',
      'value': '+967 777 182 233',
      'subtitle': 'رد خلال دقائق',
      'color': const Color(0xFF25D366),
      'url': 'https://wa.me/967777182233',
    },
    {
      'icon': Icons.email_rounded,
      'label': 'البريد الإلكتروني',
      'value': 'h@aldioli.us',
      'subtitle': 'رد خلال 24 ساعة',
      'color': const Color(0xFFE53935),
      'url': 'mailto:h@aldioli.us',
    },
    {
      'icon': Icons.location_on_rounded,
      'label': 'زيارتنا',
      'value': 'صنعاء — شارع التحرير',
      'subtitle': 'الأحد–الخميس 8ص–4م',
      'color': const Color(0xFF388E3C),
      'url': null,
    },
  ];

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تواصل معنا',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: _sent ? _buildSuccessView() : _buildForm(),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 56),
            ),
            const SizedBox(height: AppSizes.paddingL),
            const Text(
              'تم إرسال رسالتك!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            const Text(
              'سيتواصل معك فريق الدعم في أقرب وقت ممكن.\nرقم التذكرة: #YP-2026-4821',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Cairo',
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('العودة',
                    style: TextStyle(fontFamily: 'Cairo')),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            TextButton(
              onPressed: () => setState(() {
                _sent = false;
                _subjectCtrl.clear();
                _messageCtrl.clear();
                _selectedType = 'استفسار عام';
              }),
              child: const Text('إرسال رسالة أخرى',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // وسائل التواصل
          const Text(
            'تواصل مباشرة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.paddingS,
            mainAxisSpacing: AppSizes.paddingS,
            childAspectRatio: 2.4,
            children: _contactMethods.map((m) {
              return GestureDetector(
                onTap: () async {
                  final url = m['url'] as String?;
                  if (url != null) {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                      return;
                    }
                  }
                  Clipboard.setData(ClipboardData(text: m['value'] as String));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم نسخ: ${m['value']}',
                            style: const TextStyle(fontFamily: 'Cairo')),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(
                      color: (m['color'] as Color).withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: (m['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(m['icon'] as IconData,
                            color: m['color'] as Color, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              m['label'] as String,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                m['value'] as String,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  color: m['color'] as Color,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // نموذج التواصل
          const Text(
            'أرسل لنا رسالة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),

          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // نوع الطلب
                  const Text('نوع الطلب',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _types.map((t) {
                      final sel = t == _selectedType;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedType = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primaryBlue
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primaryBlue
                                  : AppColors.lightGrey,
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color:
                                  sel ? Colors.white : AppColors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // الموضوع
                  TextFormField(
                    controller: _subjectCtrl,
                    decoration: const InputDecoration(
                      labelText: 'الموضوع',
                      hintText: 'اكتب موضوع رسالتك',
                      labelStyle: TextStyle(fontFamily: 'Cairo'),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'الرجاء إدخال الموضوع'
                        : null,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // الرسالة
                  TextFormField(
                    controller: _messageCtrl,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'الرسالة',
                      hintText: 'اشرح استفساركم أو مشكلتكم بالتفصيل...',
                      labelStyle: TextStyle(fontFamily: 'Cairo'),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.length < 10)
                        ? 'الرجاء كتابة رسالة لا تقل عن 10 أحرف'
                        : null,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: AppSizes.paddingL),

                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _sending ? null : _submit,
                      child: _sending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('إرسال الرسالة',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // ساعات العمل
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius:
                  BorderRadius.circular(AppSizes.borderRadiusLarge),
              border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        color: AppColors.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ساعات الدعم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingS),
                _WorkHour('الأحد – الخميس', '8:00 صباحاً – 10:00 مساءً'),
                _WorkHour('الجمعة – السبت', '10:00 صباحاً – 6:00 مساءً'),
                _WorkHour('الدعم الرقمي (واتساب)', 'متاح 24/7'),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),
        ],
      ),
    );
  }
}

class _WorkHour extends StatelessWidget {
  final String day;
  final String hours;
  const _WorkHour(this.day, this.hours);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: AppColors.grey)),
          Text(hours,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
