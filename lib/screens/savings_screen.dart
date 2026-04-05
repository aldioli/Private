import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final List<_SavingGoal> _goals = [
    _SavingGoal(
      id: '1',
      name: 'شراء سيارة',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFF1565C0),
      target: 5000000,
      saved: 1250000,
      deadline: DateTime(2026, 12, 31),
    ),
    _SavingGoal(
      id: '2',
      name: 'رحلة العائلة',
      icon: Icons.flight_takeoff_rounded,
      color: const Color(0xFF00897B),
      target: 800000,
      saved: 320000,
      deadline: DateTime(2026, 8, 1),
    ),
    _SavingGoal(
      id: '3',
      name: 'طارئ وضمان',
      icon: Icons.health_and_safety_rounded,
      color: const Color(0xFFE53935),
      target: 1000000,
      saved: 1000000,
      deadline: DateTime(2025, 6, 1),
    ),
  ];

  double get _totalSaved => _goals.fold(0, (s, g) => s + g.saved);
  double get _totalTarget => _goals.fold(0, (s, g) => s + g.target);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('خطط الادخار',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddGoalSheet(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall progress card
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إجمالي المدخرات',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white70,
                          fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '${(_totalSaved / 1000).toStringAsFixed(0)}K ريال',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _totalTarget > 0 ? _totalSaved / _totalTarget : 0,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(_totalTarget > 0 ? (_totalSaved / _totalTarget * 100) : 0).toStringAsFixed(0)}% من الهدف',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white70,
                            fontSize: 13),
                      ),
                      Text(
                        'الهدف: ${(_totalTarget / 1000).toStringAsFixed(0)}K ر',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white70,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'الأهداف النشطة',
                    value: _goals.where((g) => g.saved < g.target).length.toString(),
                    icon: Icons.flag_rounded,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    label: 'مكتملة',
                    value: _goals.where((g) => g.saved >= g.target).length.toString(),
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    label: 'المدخرات',
                    value: '${(_totalSaved / 1000).toStringAsFixed(0)}K',
                    icon: Icons.savings_rounded,
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),

            const Text('أهدافي',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.paddingM),

            // Goals list
            ..._goals.map((goal) => _GoalCard(
                  goal: goal,
                  onAdd: () => _showDepositSheet(goal),
                )),

            const SizedBox(height: AppSizes.paddingL),

            // Tip card
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                border: Border.all(
                    color: AppColors.accentYellow.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Color(0xFFFFA000), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'نصيحة: حاول ادخار 20% من دخلك الشهري لتحقيق أهدافك بشكل أسرع.',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: Color(0xFF5D4037)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalSheet,
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('هدف جديد',
            style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showAddGoalSheet() {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هدف ادخار جديد',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'اسم الهدف',
                labelStyle: const TextStyle(fontFamily: 'Cairo'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'المبلغ المستهدف (ريال)',
                labelStyle: const TextStyle(fontFamily: 'Cairo'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && targetCtrl.text.isNotEmpty) {
                    final target = double.tryParse(targetCtrl.text) ?? 0;
                    if (target > 0) {
                      setState(() {
                        _goals.add(_SavingGoal(
                          id: DateTime.now().toString(),
                          name: nameCtrl.text,
                          icon: Icons.savings_rounded,
                          color: AppColors.primaryBlue,
                          target: target,
                          saved: 0,
                          deadline: DateTime.now().add(const Duration(days: 365)),
                        ));
                      });
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إنشاء الهدف',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDepositSheet(_SavingGoal goal) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('إضافة للهدف: ${goal.name}',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'المبلغ المراد إضافته',
                labelStyle: const TextStyle(fontFamily: 'Cairo'),
                suffixText: 'ريال',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(ctrl.text) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      final i = _goals.indexWhere((g) => g.id == goal.id);
                      final newSaved = (_goals[i].saved + amount)
                          .clamp(0.0, _goals[i].target);
                      _goals[i] = _goals[i].copyWith(saved: newSaved);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم إضافة ${amount.toStringAsFixed(0)} ريال للهدف',
                            style: const TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إضافة',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SavingGoal {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double target;
  final double saved;
  final DateTime deadline;

  const _SavingGoal({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.target,
    required this.saved,
    required this.deadline,
  });

  _SavingGoal copyWith({double? saved}) => _SavingGoal(
        id: id,
        name: name,
        icon: icon,
        color: color,
        target: target,
        saved: saved ?? this.saved,
        deadline: deadline,
      );

  double get progress => target > 0 ? (saved / target).clamp(0.0, 1.0) : 0;
  bool get isCompleted => saved >= target;
}

class _GoalCard extends StatelessWidget {
  final _SavingGoal goal;
  final VoidCallback onAdd;

  const _GoalCard({required this.goal, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
        border: goal.isCompleted
            ? Border.all(color: AppColors.success.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(goal.icon, color: goal.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(goal.name,
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        if (goal.isCompleted) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle,
                              color: AppColors.success, size: 16),
                        ],
                      ],
                    ),
                    Text(
                      goal.isCompleted
                          ? 'مكتمل! 🎉'
                          : 'يتبقى ${daysLeft > 0 ? '$daysLeft يوم' : 'انتهى الموعد'}',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: daysLeft < 30 && !goal.isCompleted
                              ? AppColors.error
                              : AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (!goal.isCompleted)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppColors.primaryBlue),
                  onPressed: onAdd,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(goal.saved / 1000).toStringAsFixed(0)}K ريال',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: goal.color),
              ),
              Text(
                'من ${(goal.target / 1000).toStringAsFixed(0)}K ريال',
                style: const TextStyle(
                    fontFamily: 'Cairo', fontSize: 13, color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: goal.color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isCompleted ? AppColors.success : goal.color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(goal.progress * 100).toStringAsFixed(0)}% مكتمل',
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 12, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo', fontSize: 11, color: AppColors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
