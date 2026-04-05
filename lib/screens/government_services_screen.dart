import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GovernmentServicesScreen extends StatefulWidget {
  const GovernmentServicesScreen({super.key});

  @override
  State<GovernmentServicesScreen> createState() =>
      _GovernmentServicesScreenState();
}

class _Service {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String category;
  final List<String> fields;
  final double fee;

  const _Service({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.category,
    required this.fields,
    this.fee = 0,
  });
}

class _GovernmentServicesScreenState
    extends State<GovernmentServicesScreen> {
  String _search = '';
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'وثائق',
    'ضرائب',
    'جمارك',
    'بلدية',
    'تعليم',
    'صحة',
  ];

  final List<_Service> _services = const [
    _Service(
      id: 's1',
      name: 'استخراج بطاقة هوية',
      description: 'استخراج أو تجديد بطاقة الهوية الوطنية',
      color: Color(0xFF1565C0),
      icon: Icons.badge_rounded,
      category: 'وثائق',
      fields: ['الاسم الكامل', 'رقم الهوية', 'تاريخ الميلاد'],
      fee: 1500,
    ),
    _Service(
      id: 's2',
      name: 'سداد فاتورة الكهرباء',
      description: 'دفع فاتورة الكهرباء والغاز',
      color: Color(0xFFFFA000),
      icon: Icons.bolt_rounded,
      category: 'بلدية',
      fields: ['رقم العداد', 'المنطقة'],
      fee: 0,
    ),
    _Service(
      id: 's3',
      name: 'سداد فاتورة المياه',
      description: 'دفع فاتورة خدمة المياه والصرف الصحي',
      color: Color(0xFF0097A7),
      icon: Icons.water_drop_rounded,
      category: 'بلدية',
      fields: ['رقم الاشتراك', 'المنطقة'],
      fee: 0,
    ),
    _Service(
      id: 's4',
      name: 'رسوم جواز السفر',
      description: 'سداد رسوم استخراج جواز السفر',
      color: Color(0xFF1B5E20),
      icon: Icons.airplanemode_active_rounded,
      category: 'وثائق',
      fields: ['رقم الملف', 'الاسم'],
      fee: 5000,
    ),
    _Service(
      id: 's5',
      name: 'دفع الضرائب التجارية',
      description: 'سداد الضرائب والرسوم على الأنشطة التجارية',
      color: Color(0xFF8E24AA),
      icon: Icons.account_balance_rounded,
      category: 'ضرائب',
      fields: ['رقم السجل التجاري', 'نوع الضريبة', 'الفترة'],
      fee: 0,
    ),
    _Service(
      id: 's6',
      name: 'رسوم الجمارك',
      description: 'سداد رسوم البيان الجمركي واستيفاء الرسوم',
      color: Color(0xFFE53935),
      icon: Icons.local_shipping_rounded,
      category: 'جمارك',
      fields: ['رقم البيان الجمركي', 'نوع البضاعة'],
      fee: 0,
    ),
    _Service(
      id: 's7',
      name: 'رسوم القبول الجامعي',
      description: 'سداد رسوم التقديم والقبول في الجامعات الحكومية',
      color: Color(0xFF0097A7),
      icon: Icons.school_rounded,
      category: 'تعليم',
      fields: ['رقم المتقدم', 'اسم الجامعة', 'التخصص'],
      fee: 2000,
    ),
    _Service(
      id: 's8',
      name: 'سداد رسوم المستشفيات',
      description: 'دفع رسوم الخدمات الصحية في المستشفيات الحكومية',
      color: Color(0xFF388E3C),
      icon: Icons.local_hospital_rounded,
      category: 'صحة',
      fields: ['رقم الملف الطبي', 'نوع الخدمة'],
      fee: 0,
    ),
    _Service(
      id: 's9',
      name: 'تجديد رخصة القيادة',
      description: 'سداد رسوم تجديد رخصة القيادة الشخصية',
      color: Color(0xFF5E35B1),
      icon: Icons.directions_car_rounded,
      category: 'وثائق',
      fields: ['رقم الرخصة', 'رقم الهوية'],
      fee: 3000,
    ),
    _Service(
      id: 's10',
      name: 'رسوم البلدية والبناء',
      description: 'سداد رسوم تراخيص البناء والبلدية',
      color: Color(0xFFFF6F00),
      icon: Icons.apartment_rounded,
      category: 'بلدية',
      fields: ['رقم الطلب', 'نوع الترخيص', 'المنطقة'],
      fee: 0,
    ),
  ];

  List<_Service> get _filtered {
    var result = _services;
    if (_selectedCategory != 'الكل') {
      result = result.where((s) => s.category == _selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      result = result
          .where((s) =>
              s.name.contains(_search) ||
              s.description.contains(_search))
          .toList();
    }
    return result;
  }

  void _openService(_Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ServiceSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الخدمات الحكومية',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // البحث
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingM),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة...',
                prefixIcon: const Icon(Icons.search_rounded),
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM, vertical: 12),
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          // فلتر التصنيف
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(cat,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: isSelected
                                ? AppColors.white
                                : AppColors.grey,
                          )),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.primaryBlue,
                      checkmarkColor: AppColors.white,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.lightGrey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // قائمة الخدمات
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 64, color: AppColors.lightGrey),
                        SizedBox(height: 16),
                        Text('لا توجد نتائج',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.grey,
                            )),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _ServiceCard(
                      service: _filtered[i],
                      onTap: () => _openService(_filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = service;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [s.color, s.color.withValues(alpha: 0.7)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(s.icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                  const SizedBox(height: 2),
                  Text(s.description,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(s.category,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: s.color,
                            )),
                      ),
                      if (s.fee > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          'رسوم: ${s.fee.toStringAsFixed(0)} ريال',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

// ======= نافذة الخدمة =======
class _ServiceSheet extends StatefulWidget {
  final _Service service;
  const _ServiceSheet({required this.service});

  @override
  State<_ServiceSheet> createState() => _ServiceSheetState();
}

class _ServiceSheetState extends State<_ServiceSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    for (final field in widget.service.fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _success ? _buildSuccess(s) : _buildForm(s),
    );
  }

  Widget _buildSuccess(_Service s) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 48),
          ),
          const SizedBox(height: AppSizes.paddingL),
          const Text('تم تقديم الطلب بنجاح!',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          const Text(
            'سيتم معالجة طلبك خلال 1-3 أيام عمل.\nرقم الطلب: GOV-2026-88241',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(_Service s) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header
        Container(
          margin: const EdgeInsets.all(AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [s.color, s.color.withValues(alpha: 0.7)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          ),
          child: Row(
            children: [
              Icon(s.icon, color: Colors.white, size: 28),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Cairo',
                        )),
                    if (s.fee > 0)
                      Text('رسوم الخدمة: ${s.fee.toStringAsFixed(0)} ريال',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.description,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 13,
                        height: 1.5,
                      )),
                  const SizedBox(height: AppSizes.paddingM),
                  ...s.fields.map((field) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                        child: TextFormField(
                          controller: _controllers[field],
                          decoration: InputDecoration(
                            labelText: field,
                            labelStyle: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'الرجاء إدخال $field'
                              : null,
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                      )),
                  const SizedBox(height: AppSizes.paddingL),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingL),
          child: SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: s.color),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      s.fee > 0
                          ? 'دفع ${s.fee.toStringAsFixed(0)} ريال'
                          : 'تقديم الطلب',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
            ),
          ),
        ),
      ],
    );
  }
}
