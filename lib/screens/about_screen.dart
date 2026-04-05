import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _version = '2.4.1';
  static const _buildNumber = '241';
  static const _releaseDate = '15 مارس 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'حول التطبيق',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App logo header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'YP',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'يمن باي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'محفظتك الرقمية الأولى في اليمن',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'الإصدار $_version (Build $_buildNumber)',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Version info
                  _SectionCard(children: [
                    _InfoRow(
                      label: 'الإصدار',
                      value: _version,
                      icon: Icons.info_outline,
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      label: 'رقم البناء',
                      value: _buildNumber,
                      icon: Icons.build_outlined,
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      label: 'تاريخ الإصدار',
                      value: _releaseDate,
                      icon: Icons.calendar_today_outlined,
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      label: 'المنصة',
                      value: 'Android / iOS',
                      icon: Icons.devices_outlined,
                    ),
                  ]),
                  const SizedBox(height: AppSizes.paddingM),

                  // Features
                  _SectionTitle(title: 'مميزات التطبيق'),
                  _SectionCard(children: [
                    _FeatureItem(
                      icon: Icons.send_rounded,
                      color: AppColors.primaryBlue,
                      title: 'تحويل فوري',
                      subtitle: 'تحويل الأموال بين المحافظ فورياً وبدون رسوم',
                    ),
                    const Divider(height: 1),
                    _FeatureItem(
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFFE53935),
                      title: 'دفع الفواتير',
                      subtitle: 'كهرباء، ماء، إنترنت والمزيد في مكان واحد',
                    ),
                    const Divider(height: 1),
                    _FeatureItem(
                      icon: Icons.currency_exchange_rounded,
                      color: const Color(0xFF388E3C),
                      title: 'تبادل العملات',
                      subtitle: 'أسعار صرف تنافسية وتحديث لحظي',
                    ),
                    const Divider(height: 1),
                    _FeatureItem(
                      icon: Icons.qr_code_scanner,
                      color: const Color(0xFF8E24AA),
                      title: 'الدفع بـ QR',
                      subtitle: 'ادفع واستقبل المال بمسح رمز QR',
                    ),
                    const Divider(height: 1),
                    _FeatureItem(
                      icon: Icons.shield_rounded,
                      color: const Color(0xFF0097A7),
                      title: 'أمان متقدم',
                      subtitle: 'حماية بـ PIN والبصمة وتشفير متقدم',
                    ),
                  ]),
                  const SizedBox(height: AppSizes.paddingM),

                  // Legal
                  _SectionTitle(title: 'القانوني والتراخيص'),
                  _SectionCard(children: [
                    _ActionRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'سياسة الخصوصية',
                      onTap: () => _showPrivacyPolicy(context),
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.gavel_outlined,
                      title: 'شروط الاستخدام',
                      onTap: () => _showTermsOfService(context),
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.article_outlined,
                      title: 'تراخيص المكتبات',
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: 'يمن باي',
                        applicationVersion: _version,
                      ),
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.security_outlined,
                      title: 'الإفصاح الأمني',
                      onTap: () => _showSecurityDisclosure(context),
                    ),
                  ]),
                  const SizedBox(height: AppSizes.paddingM),

                  // Contact & Social
                  _SectionTitle(title: 'تواصل معنا'),
                  _SectionCard(children: [
                    _ActionRow(
                      icon: Icons.language,
                      title: 'الموقع الرسمي',
                      value: 'www.yemenpay.ye',
                      iconColor: AppColors.primaryBlue,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.email_outlined,
                      title: 'البريد الإلكتروني',
                      value: 'support@yemenpay.ye',
                      iconColor: AppColors.primaryBlue,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.phone_outlined,
                      title: 'الدعم الهاتفي',
                      value: '920 000 00',
                      iconColor: AppColors.primaryBlue,
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: AppSizes.paddingM),

                  // Rate & Share
                  _SectionCard(children: [
                    _ActionRow(
                      icon: Icons.star_outline_rounded,
                      title: 'قيّم التطبيق',
                      iconColor: const Color(0xFFFFA000),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'شكراً لدعمك! جارٍ الانتقال إلى متجر التطبيقات...',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _ActionRow(
                      icon: Icons.share_outlined,
                      title: 'شارك التطبيق',
                      iconColor: AppColors.primaryBlue,
                      onTap: () {
                        Clipboard.setData(const ClipboardData(
                            text: 'حمّل يمن باي: https://yemenpay.ye/app'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم نسخ رابط التطبيق',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSizes.paddingXL),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '© 2026 يمن باي للخدمات المالية الرقمية',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'مرخص من البنك المركزي اليمني',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                                const ClipboardData(text: 'Beepay v$_version build $_buildNumber'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ معلومات الإصدار',
                                    style: TextStyle(fontFamily: 'Cairo')),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text(
                            'Made with ❤️ in Yemen',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
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

  void _showPrivacyPolicy(BuildContext context) {
    _showLegalSheet(
      context,
      title: 'سياسة الخصوصية',
      icon: Icons.privacy_tip_outlined,
      sections: [
        _LegalSection(
          title: '1. البيانات التي نجمعها',
          body:
              'نجمع المعلومات الشخصية التي تقدمها عند التسجيل مثل: الاسم الكامل، رقم الهاتف، والبريد الإلكتروني. نجمع أيضاً بيانات المعاملات لمعالجة الدفعات وضمان الأمان.',
        ),
        _LegalSection(
          title: '2. كيف نستخدم بياناتك',
          body:
              'نستخدم بياناتك لتوفير الخدمات المالية، ومنع الاحتيال، وتحسين تجربة المستخدم، والامتثال للمتطلبات التنظيمية للبنك المركزي اليمني.',
        ),
        _LegalSection(
          title: '3. مشاركة البيانات',
          body:
              'لا نبيع بياناتك الشخصية لأطراف ثالثة. قد نشارك البيانات مع الجهات التنظيمية وفق القانون، أو مع شركاء الخدمة المُرخصين.',
        ),
        _LegalSection(
          title: '4. أمان البيانات',
          body:
              'نحمي بياناتك بتشفير SSL/TLS من الدرجة البنكية. جميع كلمات المرور مُشفّرة ولا يمكن لأي موظف الاطلاع عليها.',
        ),
        _LegalSection(
          title: '5. حقوقك',
          body:
              'لك الحق في الاطلاع على بياناتك، وطلب تصحيحها أو حذفها. تواصل معنا على privacy@yemenpay.ye لأي استفسار.',
        ),
      ],
    );
  }

  void _showTermsOfService(BuildContext context) {
    _showLegalSheet(
      context,
      title: 'شروط الاستخدام',
      icon: Icons.gavel_outlined,
      sections: [
        _LegalSection(
          title: '1. قبول الشروط',
          body:
              'باستخدام تطبيق يمن باي، فإنك توافق على هذه الشروط والأحكام. إذا كنت لا توافق، يُرجى التوقف عن استخدام التطبيق.',
        ),
        _LegalSection(
          title: '2. الأهلية',
          body:
              'يجب أن يكون عمرك 18 عاماً أو أكثر لاستخدام يمن باي. بتسجيل حساب، تؤكد أنك مقيم في الجمهورية اليمنية.',
        ),
        _LegalSection(
          title: '3. الحدود والرسوم',
          body:
              'الحد اليومي للتحويل هو 500,000 ر.ي. الرسوم محددة في جدول الرسوم المتاح داخل التطبيق وقد تتغير مع الإخطار المسبق.',
        ),
        _LegalSection(
          title: '4. الاستخدام المقبول',
          body:
              'يُحظر استخدام التطبيق لأي نشاط غير قانوني، أو غسيل الأموال، أو تمويل الإرهاب. المخالفون سيتم إبلاغ الجهات المختصة عنهم.',
        ),
        _LegalSection(
          title: '5. المسؤولية',
          body:
              'يمن باي غير مسؤولة عن أي خسائر ناتجة عن الاستخدام غير المصرح به لحسابك. أبلغنا فوراً عن أي نشاط مشبوه.',
        ),
        _LegalSection(
          title: '6. إنهاء الخدمة',
          body:
              'يحق لنا تعليق أو إنهاء حسابك في حالة انتهاك هذه الشروط أو بموجب أمر قانوني.',
        ),
      ],
    );
  }

  void _showSecurityDisclosure(BuildContext context) {
    _showLegalSheet(
      context,
      title: 'الإفصاح الأمني',
      icon: Icons.security_outlined,
      sections: [
        _LegalSection(
          title: 'معايير التشفير',
          body:
              'نستخدم TLS 1.3 لتشفير الاتصالات، وAES-256 لتشفير البيانات المحلية. مفاتيح التشفير مخزنة في Android Keystore / iOS Secure Enclave.',
        ),
        _LegalSection(
          title: 'مصادقة متعددة العوامل',
          body:
              'ندعم رمز PIN، والبصمة، وFace ID كطبقات حماية إضافية. رمز OTP يُرسل عبر SMS لكل عملية حساسة.',
        ),
        _LegalSection(
          title: 'الامتثال',
          body:
              'يمن باي متوافق مع متطلبات البنك المركزي اليمني لأنظمة الدفع الإلكتروني (قرار 2022/15).',
        ),
        _LegalSection(
          title: 'الإبلاغ عن الثغرات',
          body:
              'إذا اكتشفت ثغرة أمنية، يُرجى الإبلاغ عنها مباشرةً إلى: security@yemenpay.ye. نلتزم بالرد خلال 48 ساعة.',
        ),
      ],
    );
  }

  void _showLegalSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_LegalSection> sections,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: sections.length,
                itemBuilder: (_, i) {
                  final section = sections[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          section.body,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            height: 1.8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalSection {
  final String title;
  final String body;
  const _LegalSection({required this.title, required this.body});
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM, vertical: AppSizes.paddingM),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey, size: 20),
          const SizedBox(width: AppSizes.paddingM),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.grey, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    this.value,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM, vertical: AppSizes.paddingM),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.grey, size: 22),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  if (value != null)
                    Text(value!,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM, vertical: AppSizes.paddingS),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
