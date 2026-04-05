import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  String _searchQuery = '';
  String _selectedCity = 'الكل';
  String _selectedType = 'الكل';
  final _searchController = TextEditingController();

  static const _cities = ['الكل', 'صنعاء', 'عدن', 'تعز', 'الحديدة', 'إب'];
  static const _types = ['الكل', 'وكيل', 'فرع رئيسي', 'صراف'];

  static const _agents = [
    _Agent(
      id: '1',
      name: 'وكيل صنعاء المركزي',
      type: 'فرع رئيسي',
      city: 'صنعاء',
      area: 'شارع هائل',
      phone: '+967 1 234567',
      hours: '8:00ص — 8:00م',
      distance: 0.3,
      rating: 4.8,
      services: ['سحب', 'إيداع', 'تحويل', 'صرف عملات'],
      isOpen: true,
      color: AppColors.primaryBlue,
      icon: Icons.account_balance_rounded,
    ),
    _Agent(
      id: '2',
      name: 'وكيل الحصبة',
      type: 'وكيل',
      city: 'صنعاء',
      area: 'شارع الحصبة',
      phone: '+967 777 123456',
      hours: '9:00ص — 6:00م',
      distance: 0.8,
      rating: 4.5,
      services: ['سحب', 'إيداع'],
      isOpen: true,
      color: AppColors.success,
      icon: Icons.store_rounded,
    ),
    _Agent(
      id: '3',
      name: 'صراف التحرير',
      type: 'صراف',
      city: 'صنعاء',
      area: 'ميدان التحرير',
      phone: '+967 711 654321',
      hours: '8:00ص — 9:00م',
      distance: 1.2,
      rating: 4.2,
      services: ['سحب', 'صرف عملات'],
      isOpen: true,
      color: AppColors.warning,
      icon: Icons.currency_exchange_rounded,
    ),
    _Agent(
      id: '4',
      name: 'فرع كريتر الرئيسي',
      type: 'فرع رئيسي',
      city: 'عدن',
      area: 'حي كريتر',
      phone: '+967 2 456789',
      hours: '8:00ص — 8:00م',
      distance: 1.5,
      rating: 4.7,
      services: ['سحب', 'إيداع', 'تحويل', 'صرف عملات'],
      isOpen: true,
      color: AppColors.primaryBlue,
      icon: Icons.account_balance_rounded,
    ),
    _Agent(
      id: '5',
      name: 'وكيل المعلا',
      type: 'وكيل',
      city: 'عدن',
      area: 'حي المعلا',
      phone: '+967 770 789012',
      hours: '9:00ص — 5:00م',
      distance: 2.1,
      rating: 4.0,
      services: ['سحب', 'إيداع'],
      isOpen: false,
      color: AppColors.success,
      icon: Icons.store_rounded,
    ),
    _Agent(
      id: '6',
      name: 'وكيل تعز المركزي',
      type: 'فرع رئيسي',
      city: 'تعز',
      area: 'وسط المدينة',
      phone: '+967 4 567890',
      hours: '8:00ص — 7:00م',
      distance: 3.0,
      rating: 4.6,
      services: ['سحب', 'إيداع', 'تحويل'],
      isOpen: true,
      color: AppColors.primaryBlue,
      icon: Icons.account_balance_rounded,
    ),
    _Agent(
      id: '7',
      name: 'صراف الحديدة',
      type: 'صراف',
      city: 'الحديدة',
      area: 'شارع البحر',
      phone: '+967 733 112233',
      hours: '8:30ص — 6:30م',
      distance: 3.4,
      rating: 3.9,
      services: ['سحب', 'صرف عملات'],
      isOpen: true,
      color: AppColors.warning,
      icon: Icons.currency_exchange_rounded,
    ),
    _Agent(
      id: '8',
      name: 'وكيل إب الجديد',
      type: 'وكيل',
      city: 'إب',
      area: 'السوق القديم',
      phone: '+967 778 445566',
      hours: '9:00ص — 6:00م',
      distance: 4.1,
      rating: 4.3,
      services: ['سحب', 'إيداع'],
      isOpen: false,
      color: AppColors.success,
      icon: Icons.store_rounded,
    ),
  ];

  List<_Agent> get _filtered {
    return _agents.where((a) {
      final matchCity =
          _selectedCity == 'الكل' || a.city == _selectedCity;
      final matchType =
          _selectedType == 'الكل' || a.type == _selectedType;
      final matchSearch = _searchQuery.isEmpty ||
          a.name.contains(_searchQuery) ||
          a.area.contains(_searchQuery) ||
          a.city.contains(_searchQuery);
      return matchCity && matchType && matchSearch;
    }).toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = _filtered;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('الوكلاء والفروع', style: TextStyle(fontFamily: 'Cairo')),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'الخريطة',
            onPressed: () => _showMapPlaceholder(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث والفلاتر
          Container(
            color: isDark
                ? const Color(0xFF1A1A2E)
                : Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                // بحث
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن وكيل أو منطقة...',
                    hintStyle: const TextStyle(fontFamily: 'Cairo'),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : AppColors.lightGrey.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                // فلتر المدينة
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) {
                      final c = _cities[i];
                      final sel = c == _selectedCity;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCity = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primaryBlue
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : AppColors.lightGrey.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(c,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: sel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color:
                                    sel ? Colors.white : AppColors.grey,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                // فلتر النوع
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _types.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) {
                      final t = _types[i];
                      final sel = t == _selectedType;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.accentYellow
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : AppColors.lightGrey.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(t,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: sel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: sel
                                    ? AppColors.primaryBlue
                                    : AppColors.grey,
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // عدد النتائج
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text('${list.length} وكيل',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 13)),
                const Spacer(),
                const Icon(Icons.near_me_rounded,
                    size: 14, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                const Text('مرتبة بالأقرب',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primaryBlue,
                        fontSize: 12)),
              ],
            ),
          ),

          // قائمة الوكلاء
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_off_rounded,
                            size: 60, color: AppColors.lightGrey),
                        SizedBox(height: 12),
                        Text('لا يوجد وكلاء في هذه المنطقة',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.grey,
                                fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _AgentCard(agent: list[i], isDark: isDark),
                  ),
          ),
        ],
      ),
    );
  }

  void _showMapPlaceholder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.borderRadiusLarge)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('الخريطة التفاعلية',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  child: Stack(
                    children: [
                      // شبكة خريطة بسيطة
                      CustomPaint(
                        size: Size.infinite,
                        painter: _MapGridPainter(),
                      ),
                      // دبابيس الوكلاء
                      ..._filtered.take(5).toList().asMap().entries.map((e) {
                        final positions = [
                          const Offset(0.3, 0.4),
                          const Offset(0.5, 0.3),
                          const Offset(0.65, 0.55),
                          const Offset(0.25, 0.6),
                          const Offset(0.7, 0.3),
                        ];
                        return LayoutBuilder(
                          builder: (ctx, constraints) {
                            final pos = positions[e.key];
                            return Positioned(
                              left: constraints.maxWidth * pos.dx - 16,
                              top: constraints.maxHeight * pos.dy - 16,
                              child: _MapPin(
                                  agent: e.value,
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showAgentDetail(context, e.value);
                                  }),
                            );
                          },
                        );
                      }),
                      // موقعي
                      LayoutBuilder(
                        builder: (_, constraints) => Positioned(
                          left: constraints.maxWidth * 0.48 - 12,
                          top: constraints.maxHeight * 0.48 - 12,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.primaryBlue
                                        .withValues(alpha: 0.4),
                                    blurRadius: 8)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  '${_filtered.length} وكيل في المنطقة المحددة',
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAgentDetail(BuildContext context, _Agent agent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AgentDetailSheet(agent: agent),
    );
  }
}

// ========== بطاقة الوكيل ==========
class _AgentCard extends StatelessWidget {
  final _Agent agent;
  final bool isDark;

  const _AgentCard({super.key, required this.agent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _AgentDetailSheet(agent: agent),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: agent.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(agent.icon, color: agent.color, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(agent.name,
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: agent.isOpen
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          agent.isOpen ? 'مفتوح' : 'مغلق',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: agent.isOpen
                                  ? AppColors.success
                                  : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text('${agent.city} — ${agent.area}',
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.near_me_rounded,
                          size: 12, color: AppColors.primaryBlue),
                      const SizedBox(width: 3),
                      Text('${agent.distance} كم',
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.primaryBlue)),
                      const SizedBox(width: 12),
                      const Icon(Icons.star_rounded,
                          size: 12, color: Color(0xFFFFB300)),
                      const SizedBox(width: 2),
                      Text('${agent.rating}',
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.grey)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          children: agent.services.take(2).map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(s,
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 9,
                                      color: AppColors.primaryBlue)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

// ========== تفاصيل الوكيل ==========
class _AgentDetailSheet extends StatelessWidget {
  final _Agent agent;
  const _AgentDetailSheet({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.borderRadiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: agent.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(agent.icon, color: agent.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(agent.name,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    Text(agent.type,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: AppColors.grey)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: agent.isOpen
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  agent.isOpen ? '● مفتوح' : '● مغلق',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: agent.isOpen
                          ? AppColors.success
                          : AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
              icon: Icons.location_on_rounded,
              text: '${agent.city} — ${agent.area}',
              color: AppColors.error),
          const SizedBox(height: 8),
          _InfoRow(
              icon: Icons.access_time_rounded,
              text: 'أوقات العمل: ${agent.hours}',
              color: AppColors.warning),
          const SizedBox(height: 8),
          _InfoRow(
              icon: Icons.phone_rounded,
              text: agent.phone,
              color: AppColors.success),
          const SizedBox(height: 8),
          _InfoRow(
              icon: Icons.near_me_rounded,
              text: '${agent.distance} كم منك — تقييم: ${agent.rating}/5',
              color: AppColors.primaryBlue),
          const SizedBox(height: 16),
          // الخدمات المتاحة
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: agent.services.map((s) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: agent.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: agent.color.withValues(alpha: 0.3)),
                ),
                child: Text(s,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: agent.color,
                        fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('الاتجاهات',
                      style: TextStyle(fontFamily: 'Cairo')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.call_rounded, size: 18, color: Colors.white),
                  label: const Text('اتصال',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow(
      {super.key,
      required this.icon,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontFamily: 'Cairo', fontSize: 13, color: AppColors.grey)),
        ),
      ],
    );
  }
}

// ========== دبوس الخريطة ==========
class _MapPin extends StatelessWidget {
  final _Agent agent;
  final VoidCallback onTap;
  const _MapPin({super.key, required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: agent.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                    color: agent.color.withValues(alpha: 0.4), blurRadius: 8)
              ],
            ),
            child: Icon(agent.icon, size: 16, color: Colors.white),
          ),
          Container(
            width: 2,
            height: 8,
            color: agent.color,
          ),
        ],
      ),
    );
  }
}

// ========== نموذج الوكيل ==========
class _Agent {
  final String id, name, type, city, area, phone, hours;
  final double distance, rating;
  final List<String> services;
  final bool isOpen;
  final Color color;
  final IconData icon;

  const _Agent({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.area,
    required this.phone,
    required this.hours,
    required this.distance,
    required this.rating,
    required this.services,
    required this.isOpen,
    required this.color,
    required this.icon,
  });
}

// ========== رسام شبكة الخريطة ==========
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // خطوط أفقية
    for (int i = 1; i < 8; i++) {
      final y = size.height / 8 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // خطوط رأسية
    for (int i = 1; i < 8; i++) {
      final x = size.width / 8 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // شوارع رئيسية
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 4;
    canvas.drawLine(Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.3),
        Offset(size.width * 0.7, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
