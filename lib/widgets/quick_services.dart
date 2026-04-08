import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'beepay_loading.dart';
import '../screens/bills_screen.dart';
import '../screens/offers_screen.dart';
import '../screens/exchange_screen.dart';
import '../screens/agents_screen.dart';
import '../screens/mobile_recharge_screen.dart';
import '../screens/currency_converter_screen.dart';
import '../screens/international_transfer_screen.dart';
import '../screens/donations_screen.dart';
import '../screens/e_commerce_screen.dart';
import '../screens/government_services_screen.dart';
import '../screens/food_delivery_screen.dart';
import '../screens/ride_hailing_screen.dart';
import '../screens/hotel_booking_screen.dart';
import '../screens/flight_booking_screen.dart';
import '../screens/friends_payments_screen.dart';
import '../screens/subscriptions_screen.dart';
import '../screens/market_rates_screen.dart';

class QuickServices extends StatelessWidget {
  const QuickServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الخدمات السريعة',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'إيداع',
                      color: AppColors.success,
                      onTap: () => Navigator.pushNamed(context, '/deposit'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.remove_circle_outline_rounded,
                      label: 'سحب',
                      color: AppColors.warning,
                      onTap: () => Navigator.pushNamed(context, '/withdraw'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.send_rounded,
                      label: 'تحويل',
                      color: AppColors.primaryBlue,
                      onTap: () => Navigator.pushNamed(context, '/transfer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.receipt_long_rounded,
                      label: 'فواتير',
                      color: const Color(0xFFE53935),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BillsScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.currency_exchange_rounded,
                      label: 'صرافة',
                      color: const Color(0xFF388E3C),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExchangeScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.store_rounded,
                      label: 'الوكلاء',
                      color: const Color(0xFF8E24AA),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AgentsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.local_offer_rounded,
                      label: 'عروض',
                      color: const Color(0xFFFA709A),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OffersScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.phone_android_rounded,
                      label: 'شحن جوال',
                      color: const Color(0xFF00897B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MobileRechargeScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.swap_horiz_rounded,
                      label: 'محول عملات',
                      color: const Color(0xFF0097A7),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CurrencyConverterScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.call_split_rounded,
                      label: 'تقسيم',
                      color: const Color(0xFF43A047),
                      onTap: () => Navigator.pushNamed(context, '/split_bill'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.savings_rounded,
                      label: 'ادخار',
                      color: const Color(0xFF00ACC1),
                      onTap: () => Navigator.pushNamed(context, '/savings'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.flight_takeoff_rounded,
                      label: 'تحويل دولي',
                      color: const Color(0xFF0D47A1),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InternationalTransferScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.favorite_rounded,
                      label: 'تبرع',
                      color: const Color(0xFFE53935),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DonationsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.trending_up_rounded,
                      label: 'استثمار',
                      color: const Color(0xFF1B5E20),
                      onTap: () => Navigator.pushNamed(context, '/investment'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.health_and_safety_rounded,
                      label: 'تأمين',
                      color: const Color(0xFF1565C0),
                      onTap: () => Navigator.pushNamed(context, '/insurance'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.delivery_dining_rounded,
                      label: 'طعام',
                      color: const Color(0xFFE53935),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FoodDeliveryScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.local_taxi_rounded,
                      label: 'تاكسي',
                      color: const Color(0xFF0097A7),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RideHailingScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.hotel_rounded,
                      label: 'فنادق',
                      color: const Color(0xFF1A237E),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HotelBookingScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.airplanemode_active_rounded,
                      label: 'طيران',
                      color: const Color(0xFF1565C0),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FlightBookingScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.people_alt_rounded,
                      label: 'أصدقاء',
                      color: const Color(0xFF00897B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FriendsPaymentsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.subscriptions_rounded,
                      label: 'اشتراكات',
                      color: const Color(0xFF7B1FA2),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.show_chart_rounded,
                      label: 'السوق',
                      color: const Color(0xFF1B5E20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MarketRatesScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Row(
                children: [
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.shopping_bag_rounded,
                      label: 'تسوق',
                      color: const Color(0xFF43A047),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ECommerceScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.account_balance_rounded,
                      label: 'حكومية',
                      color: const Color(0xFF5E35B1),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GovernmentServicesScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'ميزانية',
                      color: const Color(0xFFE53935),
                      onTap: () => Navigator.pushNamed(context, '/budget_planner'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: _ServiceButton(
                      icon: Icons.local_shipping_rounded,
                      label: 'شحنات',
                      color: const Color(0xFF0097A7),
                      onTap: () => Navigator.pushNamed(context, '/parcel_tracking'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => BeepayTransitionOverlay.navigate(
        context: context,
        onNavigate: onTap,
      ),
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
