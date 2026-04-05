# YemenPay - تطبيق المحفظة الرقمية اليمنية 💳

<div align="center">
  <img src="assets/images/logo.png" alt="YemenPay Logo" width="200"/>
  
  **محفظتك الرقمية في اليمن**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

---

## 📱 نظرة عامة

**YemenPay** هو تطبيق محفظة رقمية متكامل مصمم خصيصاً للسوق اليمني. يتيح للمستخدمين إجراء المعاملات المالية بسهولة وأمان.

### ✨ المميزات الرئيسية

- 🔐 **تسجيل دخول آمن** - حماية متقدمة بالرقم السري
- 💰 **عرض الرصيد** - متابعة رصيدك في الوقت الفعلي
- 💸 **التحويل الفوري** - تحويل الأموال بين المحافظ
- 📊 **سجل المعاملات** - متابعة جميع عملياتك
- 🎨 **واجهة عصرية** - تصميم جميل باللونين الأزرق والأصفر
- 🌙 **دعم العربية** - واجهة كاملة باللغة العربية (RTL)
- 📱 **متوافق** - يعمل على Android و iOS

---

## 🚀 البدء السريع

### المتطلبات الأساسية

قبل البدء، تأكد من تثبيت:

1. **Flutter SDK** (3.0 أو أحدث)
   ```bash
   # تحميل من الموقع الرسمي
   https://flutter.dev/docs/get-started/install
   ```

2. **Android Studio** أو **VS Code**
   - Android Studio للتطوير على Android
   - Xcode للتطوير على iOS (Mac فقط)

3. **Git** لإدارة الكود

### 📥 التثبيت

#### الخطوة 1: استنساخ المشروع

```bash
# استنساخ المشروع
git clone https://github.com/yourusername/yemenpay.git

# الانتقال إلى مجلد المشروع
cd yemenpay
```

#### الخطوة 2: تثبيت المكتبات

```bash
# تثبيت جميع المكتبات المطلوبة
flutter pub get
```

#### الخطوة 3: التحقق من الإعداد

```bash
# فحص أن كل شيء جاهز
flutter doctor
```

إذا ظهرت علامات ✓ خضراء، فأنت جاهز!

---

## 🎮 تشغيل التطبيق

### على Android

```bash
# توصيل هاتف Android أو تشغيل محاكي
# ثم تشغيل:
flutter run
```

### على iOS (Mac فقط)

```bash
# فتح محاكي iOS
open -a Simulator

# تشغيل التطبيق
flutter run
```

### بناء ملف APK

```bash
# بناء APK للإصدار
flutter build apk --release

# الملف سيكون في:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📂 هيكل المشروع

```
yemenpay/
├── lib/
│   ├── main.dart              # نقطة البداية
│   ├── models/                # نماذج البيانات
│   │   ├── user.dart
│   │   ├── wallet.dart
│   │   └── transaction.dart
│   ├── screens/               # الشاشات
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   └── transfer_screen.dart
│   ├── widgets/               # المكونات المشتركة
│   │   ├── logo_widget.dart
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── balance_card.dart
│   │   ├── quick_services.dart
│   │   └── recent_transactions.dart
│   ├── providers/             # إدارة الحالة
│   │   ├── auth_provider.dart
│   │   └── wallet_provider.dart
│   ├── services/              # خدمات API
│   │   └── api_service.dart
│   └── utils/                 # الأدوات المساعدة
│       └── constants.dart
├── assets/
│   ├── images/                # الصور والشعارات
│   └── fonts/                 # الخطوط العربية
├── pubspec.yaml               # المكتبات والإعدادات
└── README.md                  # هذا الملف
```

---

## 🎨 الألوان المستخدمة

```dart
الأزرق الأساسي:  #0D47A1
الأزرق الفاتح:    #42A5F5
الأصفر الزاهي:    #FFD600
الأصفر الفاتح:    #FFF59D
```

---

## 🔧 الإعدادات والتخصيص

### تغيير عنوان API

في ملف `lib/utils/constants.dart`:

```dart
static const String baseUrl = 'https://api.yemenpay.ye';
```

غير العنوان إلى عنوان السيرفر الخاص بك.

### تخصيص الألوان

في ملف `lib/utils/constants.dart`:

```dart
class AppColors {
  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color accentYellow = Color(0xFFFFD600);
  // ...
}
```

---

## 📚 المكتبات المستخدمة

| المكتبة | الوصف |
|---------|-------|
| `provider` | إدارة الحالة |
| `http` | الاتصال بالسيرفر |
| `shared_preferences` | التخزين المحلي |
| `qr_code_scanner` | مسح رموز QR |
| `qr_flutter` | إنشاء رموز QR |
| `intl` | تنسيق التواريخ والأرقام |

---

## 🔐 الأمان

التطبيق يستخدم:

- ✅ تشفير HTTPS لجميع الاتصالات
- ✅ تخزين آمن للتوكنات
- ✅ تحقق من صحة المدخلات
- ✅ حماية من الهجمات الشائعة

⚠️ **مهم:** في الإنتاج، استخدم:
- SSL Pinning
- تشفير قاعدة البيانات المحلية
- Biometric Authentication

---

## 📝 استخدام التطبيق

### 1. التسجيل

1. افتح التطبيق
2. اضغط على "سجل الآن"
3. أدخل البيانات المطلوبة
4. ستحصل على رقم محفظة فوراً

### 2. تسجيل الدخول

1. أدخل رقم الهاتف (+967)
2. أدخل الرقم السري (6 أرقام)
3. اضغط "تسجيل الدخول"

### 3. التحويل

1. من الشاشة الرئيسية، اضغط "تحويل"
2. أدخل رقم محفظة المستلم
3. أدخل المبلغ
4. أكد بالرقم السري

---

## 🛠️ حل المشاكل

### مشكلة: التطبيق لا يعمل

```bash
# نظف وأعد البناء
flutter clean
flutter pub get
flutter run
```

### مشكلة: خطأ في المكتبات

```bash
# حدث المكتبات
flutter pub upgrade
```

### مشكلة: الخطوط العربية لا تظهر

تأكد من وجود خطوط Cairo في:
```
assets/fonts/Cairo-Regular.ttf
assets/fonts/Cairo-Bold.ttf
```

---

## 🚧 ميزات قادمة

- [ ] دعم البصمة وFace ID
- [ ] مسح رموز QR
- [ ] الإشعارات الفورية
- [ ] دفع الفواتير
- [ ] شحن الرصيد
- [ ] خريطة الوكلاء
- [ ] تقارير مفصلة

---

## 🤝 المساهمة

نرحب بمساهماتك! إذا كنت تريد المساهمة:

1. Fork المشروع
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للفرع (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

---

## 📄 الترخيص

هذا المشروع مرخص تحت MIT License - انظر ملف [LICENSE](LICENSE) للتفاصيل.

---

## 📞 الدعم

- 📧 Email: support@yemenpay.ye
- 📱 Phone: +967 777 123 456
- 🌐 Website: https://yemenpay.ye

---

## 👨‍💻 المطورون

تم تطويره بواسطة فريق YemenPay مع ❤️ لليمن

---

<div align="center">
  <sub>بني بـ Flutter - يعمل في كل مكان 🚀</sub>
</div>
