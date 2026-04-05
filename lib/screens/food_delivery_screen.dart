import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FoodDeliveryScreen extends StatefulWidget {
  const FoodDeliveryScreen({super.key});

  @override
  State<FoodDeliveryScreen> createState() => _FoodDeliveryScreenState();
}

class _Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int deliveryTime; // minutes
  final double minOrder;
  final Color color;
  final IconData icon;
  final bool isFeatured;
  final List<_MenuItem> menu;

  const _Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.minOrder,
    required this.color,
    required this.icon,
    required this.isFeatured,
    required this.menu,
  });
}

class _MenuItem {
  final String name;
  final String description;
  final double price;
  final IconData icon;

  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

class _OrderItem {
  final _MenuItem item;
  final _Restaurant restaurant;
  int quantity;

  _OrderItem({
    required this.item,
    required this.restaurant,
    this.quantity = 1,
  });
}

class _FoodDeliveryScreenState extends State<FoodDeliveryScreen> {
  String _selectedCategory = 'الكل';
  final List<_OrderItem> _order = [];

  final List<String> _categories = [
    'الكل', 'يمني', 'برغر', 'شاورما', 'مشويات', 'مأكولات بحرية', 'حلويات',
  ];

  final List<_Restaurant> _restaurants = [
    const _Restaurant(
      id: 'r1',
      name: 'مطعم الأصالة',
      cuisine: 'يمني',
      rating: 4.8,
      deliveryTime: 35,
      minOrder: 5000,
      color: Color(0xFF8D6E63),
      icon: Icons.restaurant_menu_rounded,
      isFeatured: true,
      menu: [
        _MenuItem(
          name: 'مندي دجاج',
          description: 'مندي دجاج طازج بالأرز والتوابل اليمنية',
          price: 12000,
          icon: Icons.rice_bowl_rounded,
        ),
        _MenuItem(
          name: 'سلطة يمنية',
          description: 'سلطة طازجة بالخضروات والزيت الزيتون',
          price: 3000,
          icon: Icons.eco_rounded,
        ),
        _MenuItem(
          name: 'عصيد',
          description: 'عصيد يمني أصيل',
          price: 8000,
          icon: Icons.soup_kitchen_rounded,
        ),
      ],
    ),
    const _Restaurant(
      id: 'r2',
      name: 'برغر بلس',
      cuisine: 'برغر',
      rating: 4.5,
      deliveryTime: 25,
      minOrder: 4000,
      color: Color(0xFFE53935),
      icon: Icons.lunch_dining_rounded,
      isFeatured: false,
      menu: [
        _MenuItem(
          name: 'دبل برغر',
          description: 'برغر مزدوج مع الجبنة والخضروات الطازجة',
          price: 9000,
          icon: Icons.lunch_dining_rounded,
        ),
        _MenuItem(
          name: 'شيكن برغر',
          description: 'برغر دجاج مقرمش مع صلصة الباربيكيو',
          price: 7500,
          icon: Icons.fastfood_rounded,
        ),
        _MenuItem(
          name: 'بطاطس مقلية كبيرة',
          description: 'بطاطس مقلية مقرمشة بالملح والبهارات',
          price: 2500,
          icon: Icons.food_bank_rounded,
        ),
      ],
    ),
    const _Restaurant(
      id: 'r3',
      name: 'شاورما الريان',
      cuisine: 'شاورما',
      rating: 4.6,
      deliveryTime: 20,
      minOrder: 3000,
      color: Color(0xFFFFA000),
      icon: Icons.kebab_dining_rounded,
      isFeatured: true,
      menu: [
        _MenuItem(
          name: 'شاورما دجاج عادية',
          description: 'شاورما دجاج مشوية بالأعشاب الطازجة',
          price: 4000,
          icon: Icons.kebab_dining_rounded,
        ),
        _MenuItem(
          name: 'شاورما لحم',
          description: 'شاورما لحم مشوية بالتوابل الأصلية',
          price: 6000,
          icon: Icons.kebab_dining_rounded,
        ),
        _MenuItem(
          name: 'فول مدمس',
          description: 'فول مدمس بالزيت والليمون والكمون',
          price: 2500,
          icon: Icons.soup_kitchen_rounded,
        ),
      ],
    ),
    const _Restaurant(
      id: 'r4',
      name: 'مشويات البحر',
      cuisine: 'مأكولات بحرية',
      rating: 4.7,
      deliveryTime: 45,
      minOrder: 10000,
      color: Color(0xFF0097A7),
      icon: Icons.set_meal_rounded,
      isFeatured: false,
      menu: [
        _MenuItem(
          name: 'سمك مشوي كامل',
          description: 'سمك طازج مشوي مع الأعشاب والليمون',
          price: 18000,
          icon: Icons.set_meal_rounded,
        ),
        _MenuItem(
          name: 'ربيان مقلي',
          description: 'ربيان طازج مقلي بالثوم والزبدة',
          price: 22000,
          icon: Icons.set_meal_rounded,
        ),
      ],
    ),
    const _Restaurant(
      id: 'r5',
      name: 'حلويات الجود',
      cuisine: 'حلويات',
      rating: 4.4,
      deliveryTime: 30,
      minOrder: 2000,
      color: Color(0xFF8E24AA),
      icon: Icons.cake_rounded,
      isFeatured: false,
      menu: [
        _MenuItem(
          name: 'كنافة بالجبن',
          description: 'كنافة بالجبن البلدي والقطر',
          price: 5000,
          icon: Icons.cake_rounded,
        ),
        _MenuItem(
          name: 'بقلاوة مشكلة',
          description: 'بقلاوة بالفستق والعسل الطبيعي',
          price: 7000,
          icon: Icons.cookie_rounded,
        ),
        _MenuItem(
          name: 'أيس كريم مانجو',
          description: 'أيس كريم طازج بالمانجو الطبيعية',
          price: 3000,
          icon: Icons.icecream_rounded,
        ),
      ],
    ),
  ];

  List<_Restaurant> get _filtered {
    if (_selectedCategory == 'الكل') return _restaurants;
    return _restaurants
        .where((r) => r.cuisine == _selectedCategory)
        .toList();
  }

  int get _orderCount => _order.fold(0, (s, i) => s + i.quantity);
  double get _orderTotal =>
      _order.fold(0, (s, i) => s + i.item.price * i.quantity);

  void _addItem(_MenuItem item, _Restaurant restaurant) {
    setState(() {
      final existing = _order.firstWhere(
        (o) => o.item.name == item.name,
        orElse: () {
          final newItem =
              _OrderItem(item: item, restaurant: restaurant);
          _order.add(newItem);
          return newItem;
        },
      );
      if (_order.any((o) => o.item.name == item.name)) {
        existing.quantity++;
      }
    });
  }

  void _showRestaurantMenu(_Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RestaurantMenuSheet(
        restaurant: restaurant,
        onAddItem: (item) => _addItem(item, restaurant),
        orderCounts: {
          for (final o in _order) o.item.name: o.quantity,
        },
      ),
    );
  }

  void _showOrderSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OrderSummarySheet(
        order: _order,
        total: _orderTotal,
        onConfirm: () {
          Navigator.pop(context);
          setState(() => _order.clear());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تأكيد طلبك! وقت التوصيل 30-45 دقيقة',
                  style: TextStyle(fontFamily: 'Cairo')),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 3),
            ),
          );
        },
        onRemove: (item) => setState(() => _order.remove(item)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('توصيل الطعام',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_rounded),
                onPressed: _orderCount > 0 ? _showOrderSummary : null,
              ),
              if (_orderCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_orderCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // فلتر التصنيف
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
                vertical: AppSizes.paddingS),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM),
              child: Row(
                children: _categories.map((cat) {
                  final isSel = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(cat,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: isSel
                                ? AppColors.white
                                : AppColors.grey,
                          )),
                      selected: isSel,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      backgroundColor: AppColors.white,
                      selectedColor: const Color(0xFFE53935),
                      checkmarkColor: AppColors.white,
                      side: BorderSide(
                        color: isSel
                            ? const Color(0xFFE53935)
                            : AppColors.lightGrey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // قائمة المطاعم
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _RestaurantCard(
                restaurant: _filtered[i],
                onTap: () => _showRestaurantMenu(_filtered[i]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _orderCount > 0
          ? FloatingActionButton.extended(
              onPressed: _showOrderSummary,
              backgroundColor: const Color(0xFFE53935),
              icon: const Icon(Icons.shopping_bag_rounded,
                  color: Colors.white),
              label: Text(
                'الطلب • ${_orderTotal.toStringAsFixed(0)} ريال',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final _Restaurant restaurant;
  final VoidCallback onTap;

  const _RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
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
        child: Column(
          children: [
            // رأس
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [r.color, r.color.withValues(alpha: 0.6)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppSizes.borderRadiusLarge),
                  topLeft: Radius.circular(AppSizes.borderRadiusLarge),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(r.icon,
                        color: Colors.white.withValues(alpha: 0.3), size: 70),
                  ),
                  if (r.isFeatured)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('مميز',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            )),
                      ),
                    ),
                ],
              ),
            ),
            // تفاصيل
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(r.name,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      const Spacer(),
                      Icon(Icons.star_rounded,
                          color: AppColors.accentYellow, size: 16),
                      const SizedBox(width: 2),
                      Text('${r.rating}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _InfoChip(Icons.access_time_rounded,
                          '${r.deliveryTime} دقيقة'),
                      const SizedBox(width: 12),
                      _InfoChip(Icons.money_rounded,
                          'حد أدنى ${r.minOrder.toStringAsFixed(0)} ريال'),
                      const SizedBox(width: 12),
                      _InfoChip(Icons.restaurant_rounded, r.cuisine),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.grey),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.grey,
            )),
      ],
    );
  }
}

// ======= قائمة المطعم =======
class _RestaurantMenuSheet extends StatelessWidget {
  final _Restaurant restaurant;
  final void Function(_MenuItem) onAddItem;
  final Map<String, int> orderCounts;

  const _RestaurantMenuSheet({
    required this.restaurant,
    required this.onAddItem,
    required this.orderCounts,
  });

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // رأس
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [r.color, r.color.withValues(alpha: 0.7)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(r.icon, color: Colors.white, size: 30),
                    const SizedBox(width: AppSizes.paddingM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Cairo',
                            )),
                        Text(
                            '${r.deliveryTime} دقيقة تسليم • تقييم ${r.rating}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              itemCount: r.menu.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final item = r.menu[i];
                final count = orderCounts[item.name] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: r.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: r.color, size: 26),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                            Text(item.description,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                              '${item.price.toStringAsFixed(0)} ريال',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                color: r.color,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onAddItem(item),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: count > 0 ? r.color : AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: count > 0
                              ? Center(
                                  child: Text('$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                      )))
                              : const Icon(Icons.add_rounded,
                                  color: Colors.white, size: 20),
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
    );
  }
}

// ======= ملخص الطلب =======
class _OrderSummarySheet extends StatelessWidget {
  final List<_OrderItem> order;
  final double total;
  final VoidCallback onConfirm;
  final void Function(_OrderItem) onRemove;

  const _OrderSummarySheet({
    required this.order,
    required this.total,
    required this.onConfirm,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const deliveryFee = 2000.0;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
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
          const Padding(
            padding: EdgeInsets.all(AppSizes.paddingM),
            child: Text('ملخص الطلب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                )),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM),
              itemCount: order.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final o = order[i];
                return ListTile(
                  leading: Icon(o.item.icon, color: o.restaurant.color),
                  title: Text(o.item.name,
                      style: const TextStyle(
                          fontFamily: 'Cairo', fontSize: 14)),
                  subtitle: Text(
                    '${o.quantity} × ${o.item.price.toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                        fontFamily: 'Cairo', fontSize: 12),
                  ),
                  trailing: Text(
                    '${(o.item.price * o.quantity).toStringAsFixed(0)} ريال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('رسوم التوصيل',
                        style: TextStyle(
                            fontFamily: 'Cairo', color: AppColors.grey)),
                    Text('${deliveryFee.toStringAsFixed(0)} ريال',
                        style: const TextStyle(fontFamily: 'Cairo')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    Text('${(total + deliveryFee).toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryBlue,
                        )),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935)),
                    child: const Text('تأكيد الطلب',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
