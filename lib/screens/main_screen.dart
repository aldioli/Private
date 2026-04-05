import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'transfer_screen.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TransferScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconScales;

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    _iconScales = _iconControllers
        .map((c) => Tween<double>(begin: 1.0, end: 1.25).animate(
              CurvedAnimation(parent: c, curve: Curves.elasticOut),
            ))
        .toList();

    // تشغيل أنيمشن التبويب الأول عند البداية
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();

    // إيقاف التبويب القديم
    _iconControllers[_currentIndex].reverse();

    setState(() => _currentIndex = index);

    // تشغيل التبويب الجديد
    _iconControllers[index].forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  index: 0,
                  currentIndex: _currentIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'الرئيسية',
                  scaleAnim: _iconScales[0],
                  onTap: () => _onTabTap(0),
                ),
                _NavItem(
                  index: 1,
                  currentIndex: _currentIndex,
                  icon: Icons.send_outlined,
                  activeIcon: Icons.send_rounded,
                  label: 'تحويل',
                  scaleAnim: _iconScales[1],
                  onTap: () => _onTabTap(1),
                ),
                _NavItem(
                  index: 2,
                  currentIndex: _currentIndex,
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: 'المعاملات',
                  scaleAnim: _iconScales[2],
                  onTap: () => _onTabTap(2),
                ),
                _NavItem(
                  index: 3,
                  currentIndex: _currentIndex,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'حسابي',
                  scaleAnim: _iconScales[3],
                  onTap: () => _onTabTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Animation<double> scaleAnim;
  final VoidCallback onTap;

  const _NavItem({
    Key? key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.scaleAnim,
    required this.onTap,
  }) : super(key: key);

  bool get _isSelected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: scaleAnim,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _isSelected ? scaleAnim.value : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    width: _isSelected ? 50 : 40,
                    height: _isSelected ? 32 : 40,
                    decoration: _isSelected
                        ? BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          )
                        : null,
                    child: Icon(
                      _isSelected ? activeIcon : icon,
                      color: _isSelected
                          ? AppColors.primaryBlue
                          : AppColors.grey,
                      size: _isSelected ? 22 : 24,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: _isSelected ? 11 : 11,
                    fontWeight: _isSelected
                        ? FontWeight.w700
                        : FontWeight.normal,
                    color: _isSelected
                        ? AppColors.primaryBlue
                        : AppColors.grey,
                  ),
                  child: Text(label),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
