import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/loading_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/bills_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/receive_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/referral_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/beneficiaries_screen.dart';
import 'screens/my_card_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/account_level_screen.dart';
import 'screens/statement_screen.dart';
import 'screens/kyc_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/qr_scan_screen.dart';
import 'screens/support_screen.dart';
import 'screens/exchange_screen.dart';
import 'screens/agents_screen.dart';
import 'screens/scheduled_payments_screen.dart';
import 'screens/request_money_screen.dart';
import 'screens/app_security_screen.dart';
import 'screens/about_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/savings_screen.dart';
import 'screens/split_bill_screen.dart';
import 'screens/loyalty_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/notifications_settings_screen.dart';
import 'screens/mobile_recharge_screen.dart';
import 'screens/currency_converter_screen.dart';
import 'screens/payment_receipt_screen.dart';
import 'screens/international_transfer_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/donations_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/investment_screen.dart';
import 'screens/insurance_screen.dart';
import 'screens/microfinance_screen.dart';
import 'screens/vouchers_screen.dart';
import 'screens/government_services_screen.dart';
import 'screens/parcel_tracking_screen.dart';
import 'screens/market_rates_screen.dart';
import 'screens/profile_completion_screen.dart';
import 'screens/budget_planner_screen.dart';
import 'screens/e_commerce_screen.dart';
import 'screens/food_delivery_screen.dart';
import 'screens/ride_hailing_screen.dart';
import 'screens/hotel_booking_screen.dart';
import 'screens/flight_booking_screen.dart';
import 'screens/business_account_screen.dart';
import 'screens/friends_payments_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'models/transaction.dart';
import 'utils/constants.dart';
import 'widgets/beepay_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wiqldyzkqsehfcwhakws.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpcWxkeXprcXNlaGZjd2hha3dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMTAxNDAsImV4cCI6MjA5MDg4NjE0MH0.NsI-qEpi1PHmXuF397x_mDghasRHFtTYEV5xp95UkpE',
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BeepayApp());
}

class BeepayNavigatorObserver extends NavigatorObserver {
  final LoadingProvider loadingProvider;
  BeepayNavigatorObserver(this.loadingProvider);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      loadingProvider.show('جاري التحميل...');
      Future.delayed(const Duration(milliseconds: 400), loadingProvider.hide);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    loadingProvider.show('جاري التحميل...');
    Future.delayed(const Duration(milliseconds: 300), loadingProvider.hide);
  }
}

class BeepayApp extends StatelessWidget {
  const BeepayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(
            create: (_) => SettingsProvider()..loadSettings()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: settings.themeMode,

        // دعم RTL للعربية
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer3<AuthProvider, WalletProvider, LoadingProvider>(
              builder: (context, auth, wallet, loading, _) {
                final isLoading = auth.isLoading || wallet.isLoading || loading.isLoading;
                final message = loading.isLoading ? loading.message : 'جاري المعالجة...';
                return Stack(
                  children: [
                    child!,
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.45),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BeepayLoading(size: 160, color: Color(0xFFFFD600)),
                                const SizedBox(height: 20),
                                Text(
                                  message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },

        theme: ThemeData(
          primaryColor: AppColors.primaryBlue,
          scaffoldBackgroundColor: AppColors.white,
          fontFamily: 'Cairo',
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            secondary: AppColors.accentYellow,
            error: AppColors.error,
            surface: AppColors.white,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.black,
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: AppColors.black),
            titleTextStyle: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),

          cardTheme: CardTheme(
            elevation: 2,
            color: AppColors.white,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingM,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            labelStyle: const TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
            ),
            hintStyle: const TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.grey,
            ),
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.grey,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),

          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            contentTextStyle: const TextStyle(fontFamily: 'Cairo'),
          ),

          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
          ),
        ),

        // الثيم الداكن
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primaryBlue,
          scaffoldBackgroundColor: const Color(0xFF0F0F1A),
          fontFamily: 'Cairo',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            brightness: Brightness.dark,
            secondary: AppColors.accentYellow,
            error: AppColors.error,
            surface: const Color(0xFF1A1A2E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1E1E30),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1E1E30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: Color(0xFF3A3A5C)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide: const BorderSide(color: Color(0xFF3A3A5C)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              borderSide:
                  const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            labelStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.white54),
            hintStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.white38),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A2E),
            selectedItemColor: AppColors.accentYellow,
            unselectedItemColor: Colors.white38,
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF2A2A40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            contentTextStyle:
                const TextStyle(fontFamily: 'Cairo', color: Colors.white),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: const Color(0xFF1E1E30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
            ),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected)
                    ? AppColors.accentYellow
                    : Colors.white38),
            trackColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected)
                    ? AppColors.primaryBlue
                    : const Color(0xFF3A3A5C)),
          ),
          dividerColor: const Color(0xFF2A2A40),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.white70,
          ),
        ),

        navigatorObservers: [
          BeepayNavigatorObserver(
            Provider.of<LoadingProvider>(context, listen: false),
          ),
        ],
        home: const SplashScreen(),

        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainScreen(),
          '/transfer': (context) => const TransferScreen(),
          '/deposit': (context) => const DepositScreen(),
          '/withdraw': (context) => const WithdrawScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/bills': (context) => const BillsScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/change_password': (context) => const ChangePasswordScreen(),
          '/receive': (context) => const ReceiveScreen(),
          '/edit_profile': (context) => const EditProfileScreen(),
          '/faq': (context) => const FaqScreen(),
          '/referral': (context) => const ReferralScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/beneficiaries': (context) => const BeneficiariesScreen(),
          '/my_card': (context) => const MyCardScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/account_level': (context) => const AccountLevelScreen(),
          '/statement': (context) => const StatementScreen(),
          '/kyc': (context) => const KycScreen(),
          '/offers': (context) => const OffersScreen(),
          '/qr_scan': (context) => const QrScanScreen(),
          '/support': (context) => const SupportScreen(),
          '/exchange': (context) => const ExchangeScreen(),
          '/agents': (context) => const AgentsScreen(),
          '/scheduled_payments': (context) => const ScheduledPaymentsScreen(),
          '/request_money': (context) => const RequestMoneyScreen(),
          '/security': (context) => const AppSecurityScreen(),
          '/about': (context) => const AboutScreen(),
          '/transactions': (context) => const TransactionsScreen(),
          '/savings': (context) => const SavingsScreen(),
          '/split_bill': (context) => const SplitBillScreen(),
          '/loyalty': (context) => const LoyaltyScreen(),
          '/help_center': (context) => const HelpCenterScreen(),
          '/notifications_settings': (context) => const NotificationsSettingsScreen(),
          '/mobile_recharge': (context) => const MobileRechargeScreen(),
          '/currency_converter': (context) => const CurrencyConverterScreen(),
          '/receipt': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>? ?? {};
            return PaymentReceiptScreen(
              type: args['type'] ?? 'transfer',
              amount: (args['amount'] ?? 0).toDouble(),
              recipient: args['recipient'] ?? '',
              reference: args['reference'] ?? 'YP${DateTime.now().millisecondsSinceEpoch}',
              date: args['date'] ?? DateTime.now(),
              details: Map<String, String>.from(args['details'] ?? {}),
            );
          },
          '/international_transfer': (context) => const InternationalTransferScreen(),
          '/cards': (context) => const CardsScreen(),
          '/donations': (context) => const DonationsScreen(),
          '/contact_us': (context) => const ContactUsScreen(),
          '/investment': (context) => const InvestmentScreen(),
          '/insurance': (context) => const InsuranceScreen(),
          '/microfinance': (context) => const MicrofinanceScreen(),
          '/vouchers': (context) => const VouchersScreen(),
          '/government_services': (context) => const GovernmentServicesScreen(),
          '/business_account': (context) => const BusinessAccountScreen(),
          '/friends_payments': (context) => const FriendsPaymentsScreen(),
          '/subscriptions': (context) => const SubscriptionsScreen(),
          '/transaction_detail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Transaction;
            return TransactionDetailScreen(transaction: args);
          },
          '/parcel_tracking': (context) => const ParcelTrackingScreen(),
          '/market_rates': (context) => const MarketRatesScreen(),
          '/profile_completion': (context) => const ProfileCompletionScreen(),
          '/budget_planner': (context) => const BudgetPlannerScreen(),
          '/e_commerce': (context) => const ECommerceScreen(),
          '/food_delivery': (context) => const FoodDeliveryScreen(),
          '/ride_hailing': (context) => const RideHailingScreen(),
          '/hotel_booking': (context) => const HotelBookingScreen(),
          '/flight_booking': (context) => const FlightBookingScreen(),
          '/otp': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            return OtpScreen(
              phoneNumber: args?['phone'] ?? '',
              nextRoute: args?['nextRoute'] ?? '/home',
            );
          },
        },
        ),
      ),
    );
  }
}

// شاشة البداية
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // مرحلة الظهور
  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<double> _entryScaleAnim;
  late Animation<double> _slideAnim;

  // مرحلة النبض (قريب وبعيد)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  bool _showPulse = false;

  @override
  void initState() {
    super.initState();

    // --- الحركة الأولية (ظهور) ---
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );

    _entryScaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController, curve: Curves.elasticOut),
    );

    _slideAnim = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );

    // --- حركة النبض (تكرار قريب/بعيد) ---
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pulseController.forward();
      }
    });

    // تشغيل الظهور ثم النبض
    _entryController.forward().then((_) {
      if (mounted) {
        setState(() => _showPulse = true);
        _pulseController.forward();
      }
    });

    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;

    // تحقق من الـ Onboarding أولاً
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;
    if (!onboardingDone) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserData();
    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      // ignore: use_build_context_synchronously
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      final notifProvider =
          Provider.of<NotificationsProvider>(context, listen: false);
      await Future.wait([
        walletProvider.loadWallet(),
        notifProvider.loadNotifications(),
      ]);
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, Color(0xFF1565C0), AppColors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_entryController, _pulseController]),
              builder: (context, child) {
                final logoScale = _showPulse
                    ? _pulseAnim.value
                    : _entryScaleAnim.value;

                return FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الشعار مع النبض
                      Transform.scale(
                        scale: logoScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // هالة خارجية
                            if (_showPulse)
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                                      .withValues(alpha: 0.08 * _pulseAnim.value),
                                ),
                              ),
                            // هالة داخلية
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            // اللوجو الرئيسي
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: AppColors.accentYellow,
                                borderRadius: BorderRadius.circular(38),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 35,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: AppColors.accentYellow.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(38),
                                child: Image.asset(
                                  'assets/images/app_icon.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // النص
                      Transform.translate(
                        offset: Offset(0, _showPulse ? 0 : _slideAnim.value),
                        child: Column(
                          children: [
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                                fontFamily: 'Cairo',
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'محفظتك الرقمية في اليمن',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 70),

                      // أنيميشن النحلة
                      Column(
                        children: [
                          const BeepayLoading(size: 60, color: Colors.white),
                          const SizedBox(height: 14),
                          Text(
                            'جاري التحميل...',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: 'Cairo',
                              fontSize: 13,
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
        ),
      ),
    );
  }
}
