import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class RequestMoneyScreen extends StatefulWidget {
  const RequestMoneyScreen({super.key});

  @override
  State<RequestMoneyScreen> createState() => _RequestMoneyScreenState();
}

class _RequestMoneyScreenState extends State<RequestMoneyScreen>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedContact;
  String? _selectedContactName;
  bool _qrGenerated = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final List<Map<String, String>> _contacts = [
    {'name': 'أحمد محمد', 'wallet': '967711234567', 'avatar': 'أ'},
    {'name': 'فاطمة علي', 'wallet': '967733456789', 'avatar': 'ف'},
    {'name': 'خالد عبدالله', 'wallet': '967755678901', 'avatar': 'خ'},
    {'name': 'مريم حسن', 'wallet': '967777890123', 'avatar': 'م'},
    {'name': 'عمر سالم', 'wallet': '967799012345', 'avatar': 'ع'},
    {'name': 'نور الدين', 'wallet': '967722345678', 'avatar': 'ن'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _buildQrData(String walletNumber) {
    final amount = _amountController.text.trim();
    final note = _noteController.text.trim();
    String data = 'beepay://request?wallet=$walletNumber';
    if (amount.isNotEmpty) data += '&amount=$amount';
    if (note.isNotEmpty) data += '&note=${Uri.encodeComponent(note)}';
    return data;
  }

  void _generateQr() {
    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال المبلغ', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _qrGenerated = true);
    _animController.forward(from: 0);
  }

  void _shareRequest() {
    final walletNumber =
        context.read<AuthProvider>().user?.walletNumber ?? '';
    final amount = _amountController.text.trim();
    final note = _noteController.text.trim();
    final text =
        'طلب دفع عبر Beepay\nرقم المحفظة: $walletNumber\nالمبلغ: $amount ر.ي${note.isNotEmpty ? '\nالملاحظة: $note' : ''}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ تفاصيل الطلب', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _sendToContact() {
    if (_selectedContact == null) {
      _showContactPicker();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال طلب المبلغ إلى $_selectedContactName',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showContactPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'اختر جهة اتصال',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _contacts.length,
                itemBuilder: (_, index) {
                  final contact = _contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        contact['avatar']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      contact['name']!,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    subtitle: Text(
                      contact['wallet']!,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedContact = contact['wallet'];
                        _selectedContactName = contact['name'];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletNumber =
        context.watch<AuthProvider>().user?.walletNumber ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'طلب مبلغ',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount input
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المبلغ المطلوب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          onChanged: (_) {
                            if (_qrGenerated) {
                              setState(() => _qrGenerated = false);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 36,
                              color: AppColors.grey,
                              fontFamily: 'Cairo',
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text(
                        AppConstants.currencySymbol,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.grey,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Quick amounts
                  Wrap(
                    spacing: 8,
                    children: [5000, 10000, 20000, 50000].map((amount) {
                      return ActionChip(
                        label: Text(
                          '${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')} ر.ي',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.08),
                        side: BorderSide(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                        onPressed: () {
                          _amountController.text = amount.toString();
                          if (_qrGenerated) {
                            setState(() => _qrGenerated = false);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // Note input
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _noteController,
                maxLength: 80,
                decoration: const InputDecoration(
                  hintText: 'ملاحظة (اختياري)...',
                  hintStyle: TextStyle(fontFamily: 'Cairo', color: AppColors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.note_outlined, color: AppColors.grey),
                  counterText: '',
                ),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),

            // Contact selector
            GestureDetector(
              onTap: _showContactPicker,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLarge),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedContact != null
                            ? Icons.person
                            : Icons.person_add_outlined,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedContactName ?? 'اختر جهة اتصال (اختياري)',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: _selectedContact != null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedContact != null
                                  ? AppColors.textPrimary
                                  : AppColors.grey,
                            ),
                          ),
                          if (_selectedContact != null)
                            Text(
                              _selectedContact!,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_left,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Generate QR button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateQr,
                icon: const Icon(Icons.qr_code_2),
                label: const Text(
                  'إنشاء رمز QR',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                  ),
                ),
              ),
            ),

            // QR Code display
            if (_qrGenerated) ...[
              const SizedBox(height: AppSizes.paddingL),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 16),
                                const SizedBox(width: 4),
                                const Text(
                                  'رمز QR جاهز للمشاركة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingL),

                      // QR code
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: QrImageView(
                          data: _buildQrData(walletNumber),
                          version: QrVersions.auto,
                          size: 200,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.primaryBlue,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),

                      // Amount display
                      Text(
                        '${_amountController.text} ${AppConstants.currencySymbol}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      if (_noteController.text.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _noteController.text,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'رقم المحفظة: $walletNumber',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingL),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _shareRequest,
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text(
                                'نسخ',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryBlue,
                                side: const BorderSide(
                                    color: AppColors.primaryBlue),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.borderRadius),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _sendToContact,
                              icon: const Icon(Icons.send, size: 18),
                              label: Text(
                                _selectedContact != null
                                    ? 'إرسال'
                                    : 'اختر جهة',
                                style:
                                    const TextStyle(fontFamily: 'Cairo'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.borderRadius),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSizes.paddingXL),

            // Wallet info card
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusLarge),
                border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.primaryBlue, size: 20),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: Text(
                      'سيتم تحويل المبلغ مباشرةً إلى محفظتك رقم $walletNumber عند المسح',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.primaryBlue,
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
    );
  }
}
