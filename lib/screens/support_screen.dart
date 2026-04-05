import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_Message> _messages = [
    _Message(
      text: 'مرحباً بك في دعم Beepay 👋\nأنا مساعدك الافتراضي، كيف يمكنني مساعدتك اليوم؟',
      isAgent: true,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  // ردود تلقائية حسب الكلمات المفتاحية
  static const _autoReplies = {
    'رصيد': 'يمكنك مراجعة رصيدك من الشاشة الرئيسية في التطبيق. إذا واجهت مشكلة في عرض الرصيد، حاول تحديث الصفحة أو تسجيل الخروج وإعادة الدخول.',
    'تحويل': 'لإجراء تحويل، اضغط على زر "تحويل" في الشاشة الرئيسية، وأدخل رقم المحفظة والمبلغ المراد تحويله. تأكد من صحة رقم المستلم قبل التأكيد.',
    'كلمة المرور': 'إذا نسيت كلمة مرورك، استخدم خيار "نسيت كلمة المرور" في شاشة تسجيل الدخول. سيتم إرسال رمز التحقق إلى رقم هاتفك.',
    'رسوم': 'رسوم التحويل الداخلي: 0.5% من المبلغ (الحد الأدنى 50 ريال).\nالتحويل الخارجي: 1%.\nدفع الفواتير: مجاني.',
    'حساب': 'لتفعيل حسابك بالكامل، يجب اجتياز التحقق من الهوية (KYC). اذهب إلى: الملف الشخصي ← توثيق الهوية.',
    'توثيق': 'خطوات التوثيق:\n1. اختر نوع الهوية\n2. ارفع صورة الوجه الأمامي\n3. ارفع صورة الوجه الخلفي\n4. التقط سيلفي\nسيتم مراجعة طلبك خلال 24-48 ساعة.',
    'سحب': 'يمكنك سحب الرصيد عبر:\n• وكيل معتمد في منطقتك\n• تحويل بنكي لحسابك البنكي\nالحد الأدنى للسحب: 1,000 ريال.',
  };

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isAgent: false, time: DateTime.now()));
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // تأخير الرد التلقائي
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final reply = _getReply(text);
      setState(() {
        _isTyping = false;
        _messages.add(_Message(text: reply, isAgent: true, time: DateTime.now()));
      });
      _scrollToBottom();
    });
  }

  String _getReply(String input) {
    final lower = input.toLowerCase();
    for (final entry in _autoReplies.entries) {
      if (lower.contains(entry.key) || input.contains(entry.key)) {
        return entry.value;
      }
    }
    return 'شكراً على تواصلك! تم تسجيل استفسارك وسيتواصل معك أحد ممثلي خدمة العملاء خلال ساعات العمل (8ص - 8م).\n\nيمكنك أيضاً التواصل معنا عبر:\n📞 هاتف: 967-780-XXX-XXX+\n📧 بريد: support@yemenpay.ye';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الدعم الفني',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('متاح الآن',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: AppColors.success)),
                  ],
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // رسائل سريعة
          Container(
            color: isDark ? const Color(0xFF1A1A2E) : AppColors.lightGrey.withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.flash_on_rounded,
                    size: 14, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                const Text('أسئلة شائعة: ',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.grey)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _QuickBtn('كيف أحوّل؟',
                            () => _sendMessage('كيف أحوّل؟')),
                        _QuickBtn('الرسوم؟',
                            () => _sendMessage('ما هي الرسوم؟')),
                        _QuickBtn('نسيت كلمة المرور',
                            () => _sendMessage('نسيت كلمة المرور')),
                        _QuickBtn('توثيق الهوية',
                            () => _sendMessage('كيف أوثق حسابي؟')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // المحادثة
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length && _isTyping) {
                  return const _TypingIndicator();
                }
                return _MessageBubble(
                    message: _messages[i], isDark: isDark);
              },
            ),
          ),

          // حقل الكتابة
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : AppColors.white,
              border: Border(
                top: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.5), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E2E)
                          : AppColors.lightGrey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
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

Widget _QuickBtn(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600)),
    ),
  );
}

class _Message {
  final String text;
  final bool isAgent;
  final DateTime time;

  const _Message({
    required this.text,
    required this.isAgent,
    required this.time,
  });
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  final bool isDark;

  const _MessageBubble({super.key, required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isAgent = message.isAgent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isAgent ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAgent) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isAgent
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isAgent
                        ? (isDark
                            ? const Color(0xFF1E1E2E)
                            : AppColors.white)
                        : AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isAgent ? 4 : 16),
                      bottomRight: Radius.circular(isAgent ? 16 : 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: isAgent ? null : Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.time),
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({super.key});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)
              ],
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Row(
                children: List.generate(3, (i) {
                  final delay = i / 3;
                  final value = ((_anim.value - delay).clamp(0.0, 1.0));
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: 7,
                      height: 7 + (value * 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue
                            .withValues(alpha: 0.4 + value * 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
