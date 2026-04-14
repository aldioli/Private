import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// شاشة التسوق الإلكتروني — منتجات مباشرة قابلة للشراء عبر Beepay
class ECommerceScreen extends StatefulWidget {
  const ECommerceScreen({super.key});

  @override
  State<ECommerceScreen> createState() => _ECommerceScreenState();
}

class _Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final Color color;
  final IconData icon;
  final double rating;
  final int reviewCount;

  const _Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.color,
    required this.icon,
    required this.rating,
    required this.reviewCount,
  });

  bool get hasDiscount => originalPrice != null;
  int get discountPct => hasDiscount
      ? ((1 - price / originalPrice!) * 100).round()
      : 0;
}

class _CartItem {
  final _Product product;
  int quantity;
  _CartItem({required this.product, this.quantity = 1});
}

class _ECommerceScreenState extends State<ECommerceScreen> {
  String _selectedCategory = 'الكل';
  String _search = '';
  final List<_CartItem> _cart = [];
  final Set<String> _wishlist = {};

  final List<String> _categories = [
    'الكل', 'إلكترونيات', 'ملابس', 'منزل', 'رياضة', 'كتب', 'طعام',
  ];

  final List<_Product> _products = const [
    _Product(
      id: 'p1',
      name: 'سماعات بلوتوث',
      description: 'سماعات لاسلكية عالية الجودة بتقنية ANC',
      price: 45000,
      originalPrice: 65000,
      category: 'إلكترونيات',
      color: Color(0xFF1565C0),
      icon: Icons.headphones_rounded,
      rating: 4.5,
      reviewCount: 128,
    ),
    _Product(
      id: 'p2',
      name: 'ساعة ذكية',
      description: 'ساعة ذكية متعددة الوظائف مع مراقبة صحية',
      price: 85000,
      originalPrice: 120000,
      category: 'إلكترونيات',
      color: Color(0xFF0097A7),
      icon: Icons.watch_rounded,
      rating: 4.3,
      reviewCount: 89,
    ),
    _Product(
      id: 'p3',
      name: 'قميص قطني',
      description: 'قميص قطني فاخر بألوان متعددة',
      price: 12000,
      category: 'ملابس',
      color: Color(0xFF388E3C),
      icon: Icons.checkroom_rounded,
      rating: 4.7,
      reviewCount: 234,
    ),
    _Product(
      id: 'p4',
      name: 'أدوات مطبخ',
      description: 'طقم أدوات مطبخ من الستانلس ستيل 12 قطعة',
      price: 38000,
      originalPrice: 50000,
      category: 'منزل',
      color: Color(0xFFE53935),
      icon: Icons.kitchen_rounded,
      rating: 4.2,
      reviewCount: 67,
    ),
    _Product(
      id: 'p5',
      name: 'حذاء رياضي',
      description: 'حذاء رياضي مريح للجري والتمرين',
      price: 55000,
      category: 'رياضة',
      color: Color(0xFF8E24AA),
      icon: Icons.directions_run_rounded,
      rating: 4.6,
      reviewCount: 156,
    ),
    _Product(
      id: 'p6',
      name: 'كتاب التمويل الشخصي',
      description: 'دليلك لإدارة المال وبناء الثروة',
      price: 8500,
      category: 'كتب',
      color: Color(0xFF5E35B1),
      icon: Icons.menu_book_rounded,
      rating: 4.9,
      reviewCount: 312,
    ),
    _Product(
      id: 'p7',
      name: 'حقيبة ظهر جلدية',
      description: 'حقيبة ظهر أنيقة مناسبة للعمل والسفر',
      price: 42000,
      originalPrice: 60000,
      category: 'ملابس',
      color: Color(0xFFFFA000),
      icon: Icons.backpack_rounded,
      rating: 4.4,
      reviewCount: 95,
    ),
    _Product(
      id: 'p8',
      name: 'مكيف هواء محمول',
      description: 'مكيف هواء محمول ميني للمكتب وغرفة النوم',
      price: 120000,
      originalPrice: 150000,
      category: 'منزل',
      color: Color(0xFF1565C0),
      icon: Icons.ac_unit_rounded,
      rating: 4.1,
      reviewCount: 43,
    ),
  ];

  List<_Product> get _filtered {
    var result = _products;
    if (_selectedCategory != 'الكل') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.contains(_search) ||
              p.description.contains(_search))
          .toList();
    }
    return result;
  }

  int get _cartCount =>
      _cart.fold(0, (sum, item) => sum + item.quantity);
  double get _cartTotal =>
      _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void _addToCart(_Product product) {
    setState(() {
      final existing = _cart.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () {
          final newItem = _CartItem(product: product);
          _cart.add(newItem);
          return newItem;
        },
      );
      if (_cart.any((item) => item.product.id == product.id)) {
        existing.quantity++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${product.name} إلى السلة',
            style: const TextStyle(fontFamily: 'Cairo')),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'السلة',
          onPressed: _showCart,
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CartSheet(
        cart: _cart,
        total: _cartTotal,
        onCheckout: () {
          Navigator.pop(context);
          setState(() => _cart.clear());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تأكيد الطلب! سيصلك خلال 3-5 أيام',
                  style: TextStyle(fontFamily: 'Cairo')),
              backgroundColor: AppColors.success,
            ),
          );
        },
        onRemove: (item) => setState(() => _cart.remove(item)),
        onQuantityChange: (item, delta) {
          setState(() {
            item.quantity += delta;
            if (item.quantity <= 0) _cart.remove(item);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التسوق',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline_rounded),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: _cartCount > 0 ? _showCart : null,
              ),
              if (_cartCount > 0)
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
                      '$_cartCount',
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
          // بحث
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM, 0, AppSizes.paddingM, AppSizes.paddingM),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: const Icon(Icons.search_rounded),
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
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
                            color: isSel ? AppColors.white : AppColors.grey,
                          )),
                      selected: isSel,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.primaryBlue,
                      checkmarkColor: AppColors.white,
                      side: BorderSide(
                        color: isSel
                            ? AppColors.primaryBlue
                            : AppColors.lightGrey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // شبكة المنتجات
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('لا توجد منتجات',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: AppSizes.paddingM,
                      mainAxisSpacing: AppSizes.paddingM,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _ProductCard(
                      product: _filtered[i],
                      isInWishlist: _wishlist.contains(_filtered[i].id),
                      onAddToCart: () => _addToCart(_filtered[i]),
                      onWishlist: () {
                        setState(() {
                          final id = _filtered[i].id;
                          if (_wishlist.contains(id)) {
                            _wishlist.remove(id);
                          } else {
                            _wishlist.add(id);
                          }
                        });
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final bool isInWishlist;
  final VoidCallback onAddToCart;
  final VoidCallback onWishlist;

  const _ProductCard({
    required this.product,
    required this.isInWishlist,
    required this.onAddToCart,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج (أيقونة)
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      p.color.withValues(alpha: 0.15),
                      p.color.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppSizes.borderRadiusLarge),
                    topLeft: Radius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
                child: Icon(p.icon, color: p.color, size: 52),
              ),
              if (p.hasDiscount)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${p.discountPct}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: onWishlist,
                  child: Icon(
                    isInWishlist
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: isInWishlist ? AppColors.error : AppColors.grey,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(p.description,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: AppColors.accentYellow, size: 12),
                      Text(' ${p.rating}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: AppColors.grey,
                          )),
                      Text(' (${p.reviewCount})',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: AppColors.grey,
                          )),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${p.price.toStringAsFixed(0)} ر',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: p.color,
                            ),
                          ),
                          if (p.hasDiscount)
                            Text(
                              '${p.originalPrice!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: AppColors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======= سلة المشتريات =======
class _CartSheet extends StatelessWidget {
  final List<_CartItem> cart;
  final double total;
  final VoidCallback onCheckout;
  final void Function(_CartItem) onRemove;
  final void Function(_CartItem, int) onQuantityChange;

  const _CartSheet({
    required this.cart,
    required this.total,
    required this.onCheckout,
    required this.onRemove,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Row(
              children: [
                const Text('سلة المشتريات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )),
                const Spacer(),
                Text('${cart.length} منتج',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    )),
              ],
            ),
          ),
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Text('السلة فارغة',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.grey)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: item.product.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(item.product.icon,
                                  color: item.product.color, size: 24),
                            ),
                            const SizedBox(width: AppSizes.paddingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      )),
                                  Text(
                                      '${item.product.price.toStringAsFixed(0)} ريال',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: AppColors.grey,
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      onQuantityChange(item, -1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.remove_rounded,
                                        size: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('${item.quantity}',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      onQuantityChange(item, 1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.add_rounded,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // إجمالي + دفع
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: const Border(
                  top: BorderSide(color: AppColors.background, width: 2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Text(
                      '${total.toStringAsFixed(0)} ريال',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: cart.isNotEmpty ? onCheckout : null,
                    child: const Text('إتمام الشراء',
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
