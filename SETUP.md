# دليل الإعداد السريع - YemenPay ⚡

## 🎯 البدء في 5 دقائق

هذا الدليل سيساعدك على تشغيل التطبيق بسرعة!

---

## الخطوة 1: تثبيت Flutter

### Windows:

1. حمل Flutter SDK من: https://flutter.dev/docs/get-started/install/windows
2. استخرج الملف في مجلد (مثل: `C:\flutter`)
3. أضف Flutter إلى PATH:
   - ابحث عن "Environment Variables" في Windows
   - أضف: `C:\flutter\bin` إلى PATH
4. تحقق من التثبيت:
   ```cmd
   flutter doctor
   ```

### macOS:

```bash
# باستخدام Homebrew
brew install flutter

# أو حمل يدوياً من
https://flutter.dev/docs/get-started/install/macos

# تحقق من التثبيت
flutter doctor
```

### Linux:

```bash
# حمل Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz

# استخرج
tar xf flutter_linux_3.x.x-stable.tar.xz

# أضف إلى PATH
export PATH="$PATH:`pwd`/flutter/bin"

# تحقق
flutter doctor
```

---

## الخطوة 2: تثبيت Android Studio

1. حمل من: https://developer.android.com/studio
2. ثبت البرنامج
3. افتح Android Studio
4. اذهب إلى: SDK Manager → SDK Tools
5. ثبت:
   - Android SDK Command-line Tools
   - Android SDK Platform-Tools
   - Android SDK Build-Tools

---

## الخطوة 3: تشغيل المشروع

### A) إذا لديك الملفات:

```bash
# 1. افتح Terminal/CMD في مجلد المشروع
cd yemenpay

# 2. ثبت المكتبات
flutter pub get

# 3. شغل التطبيق
flutter run
```

### B) إذا تبدأ من الصفر:

```bash
# 1. أنشئ مشروع جديد
flutter create yemenpay
cd yemenpay

# 2. انسخ ملفات lib من المشروع المرفق
# ضع جميع الملفات في مجلد lib/

# 3. انسخ محتوى pubspec.yaml

# 4. ثبت المكتبات
flutter pub get

# 5. شغل
flutter run
```

---

## الخطوة 4: اختبار على الهاتف

### Android:

1. فعّل "Developer Options" في الهاتف:
   - Settings → About Phone
   - اضغط على "Build Number" 7 مرات

2. فعّل "USB Debugging":
   - Settings → Developer Options → USB Debugging

3. وصّل الهاتف بالكمبيوتر

4. تحقق من الاتصال:
   ```bash
   flutter devices
   ```

5. شغل التطبيق:
   ```bash
   flutter run
   ```

### iOS (Mac فقط):

1. وصّل iPhone بالماك
2. ثق بالكمبيوتر على الآيفون
3. في Terminal:
   ```bash
   flutter run
   ```

---

## الخطوة 5: بناء APK للتوزيع

```bash
# بناء APK
flutter build apk --release

# الملف سيكون في:
# build/app/outputs/flutter-apk/app-release.apk

# انسخه إلى هاتفك وثبته!
```

---

## 🔧 حل المشاكل الشائعة

### مشكلة: "Flutter command not found"

**الحل:**
```bash
# أضف Flutter إلى PATH
# في Windows: Environment Variables
# في Mac/Linux: ~/.bashrc أو ~/.zshrc

export PATH="$PATH:/path/to/flutter/bin"
```

### مشكلة: "Android licenses not accepted"

**الحل:**
```bash
flutter doctor --android-licenses
# اضغط y لقبول جميع التراخيص
```

### مشكلة: "Gradle build failed"

**الحل:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### مشكلة: "Unable to locate Android SDK"

**الحل:**
1. افتح Android Studio
2. File → Settings → Android SDK
3. انسخ مسار SDK
4. في Terminal:
   ```bash
   # Windows
   set ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk
   
   # Mac/Linux
   export ANDROID_HOME=/Users/YourName/Library/Android/sdk
   ```

---

## 📱 اختبار بدون كتابة كود

### استخدام المحاكي:

#### Android Emulator:

1. افتح Android Studio
2. AVD Manager
3. Create Virtual Device
4. اختر جهاز (مثل: Pixel 5)
5. اختر نظام (مثل: Android 13)
6. Finish
7. شغل المحاكي
8. في Terminal:
   ```bash
   flutter run
   ```

#### iOS Simulator (Mac):

```bash
# فتح Simulator
open -a Simulator

# اختيار جهاز
xcrun simctl list devices

# تشغيل التطبيق
flutter run
```

---

## 🎨 تخصيص سريع

### تغيير الاسم:

في `lib/utils/constants.dart`:
```dart
static const String appName = 'اسمك هنا';
```

### تغيير الألوان:

في `lib/utils/constants.dart`:
```dart
static const Color primaryBlue = Color(0xFFاللون);
static const Color accentYellow = Color(0xFFاللون);
```

### تغيير الشعار:

ضع صورتك في:
```
assets/images/logo.png
```

---

## 📊 نصائح للأداء

1. **استخدم Release Mode للاختبار الحقيقي:**
   ```bash
   flutter run --release
   ```

2. **راقب الأداء:**
   ```bash
   flutter run --profile
   ```

3. **حلل حجم التطبيق:**
   ```bash
   flutter build apk --analyze-size
   ```

---

## ✅ قائمة التحقق النهائية

- [ ] Flutter مثبت ويعمل
- [ ] Android Studio مثبت
- [ ] `flutter doctor` بدون أخطاء
- [ ] المشروع يفتح بنجاح
- [ ] `flutter pub get` ينجح
- [ ] التطبيق يعمل على المحاكي
- [ ] التطبيق يعمل على الهاتف
- [ ] APK يبنى بنجاح

---

## 🚀 الخطوات التالية

بعد ما يشتغل التطبيق:

1. **تعلم الكود:**
   - اقرأ ملفات `lib/screens/`
   - افهم كيف تعمل الشاشات

2. **أضف ميزات:**
   - شاشة جديدة
   - تعديل التصميم
   - إضافة وظائف

3. **اتصل بالسيرفر:**
   - غير API URL في `constants.dart`
   - اختبر الاتصال

---

## 📞 محتاج مساعدة؟

- **مشاكل Flutter:**
  - https://flutter.dev/docs
  - https://stackoverflow.com/questions/tagged/flutter

- **مشاكل Dart:**
  - https://dart.dev/guides

- **دروس فيديو:**
  - https://youtube.com/flutter

---

<div align="center">
  <h3>🎉 مبروك! تطبيقك جاهز للعمل!</h3>
  <p>الآن ابدأ بالتطوير والإبداع 💪</p>
</div>
