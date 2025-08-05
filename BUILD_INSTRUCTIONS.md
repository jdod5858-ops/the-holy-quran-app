# تعليمات بناء تطبيق حسناتي

## 🚀 البناء التلقائي عبر GitHub Actions

تم إعداد التطبيق للبناء التلقائي عبر GitHub Actions. يمكنك الحصول على APK بعدة طرق:

### 1. البناء التلقائي عند Push
- عند كل push إلى branch `feature/hasanati-islamic-app`
- يتم بناء APK و AAB تلقائياً
- يتم رفع الملفات كـ artifacts

### 2. تشغيل البناء يدوياً

#### الطريقة الأولى: من واجهة GitHub
1. اذهب إلى: https://github.com/jdod5858-ops/the-holy-quran-app
2. اضغط على تبويب "Actions"
3. اختر "Build Android APK" من القائمة اليسرى
4. اضغط "Run workflow" (الزر الأزرق)
5. اختر branch: `feature/hasanati-islamic-app`
6. اضغط "Run workflow"
7. انتظر اكتمال البناء (5-10 دقائق)
8. حمل APK من artifacts

#### الطريقة الثانية: إنشاء Release
1. اذهب إلى تبويب "Actions"
2. اختر "Create Release"
3. اضغط "Run workflow"
4. أدخل رقم الإصدار (مثل: v1.0.0)
5. أدخل ملاحظات الإصدار (اختياري)
6. اضغط "Run workflow"
7. سيتم إنشاء release جديد مع APK

### 3. تحميل APK الجاهز

#### من Artifacts:
1. اذهب إلى تبويب "Actions"
2. اضغط على آخر workflow مكتمل بنجاح ✅
3. انزل إلى قسم "Artifacts"
4. حمل "hasanati-apk"

#### من Releases:
1. اذهب إلى: https://github.com/jdod5858-ops/the-holy-quran-app/releases
2. حمل أحدث APK من الإصدارات

---

## 🛠️ البناء المحلي

إذا كنت تريد بناء التطبيق محلياً:

### المتطلبات:
- Flutter SDK 3.24.5+
- Android SDK
- Java 17+

### الخطوات:
```bash
# استنساخ المشروع
git clone https://github.com/jdod5858-ops/the-holy-quran-app.git
cd the-holy-quran-app

# التبديل إلى branch الصحيح
git checkout feature/hasanati-islamic-app

# تثبيت التبعيات
flutter pub get

# إنشاء الملفات المطلوبة
flutter pub run build_runner build --delete-conflicting-outputs

# بناء APK
flutter build apk --release

# الملف سيكون في:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 تثبيت APK

### على Android:
1. حمل ملف APK
2. اذهب إلى إعدادات الهاتف
3. الأمان → مصادر غير معروفة → فعل
4. اضغط على ملف APK لتثبيته

### معلومات APK:
- **الحجم المتوقع**: ~20-25 MB
- **الحد الأدنى لـ Android**: 5.0 (API 21)
- **الأذونات المطلوبة**:
  - الموقع (لمواقيت الصلاة والقبلة)
  - التنبيهات (لأذان الصلاة)
  - التخزين (لحفظ الإعدادات)

---

## 🔍 حالة البناء الحالية

يمكنك متابعة حالة البناء من:
- **Actions**: https://github.com/jdod5858-ops/the-holy-quran-app/actions
- **Releases**: https://github.com/jdod5858-ops/the-holy-quran-app/releases

### رابط البناء الحالي:
https://github.com/jdod5858-ops/the-holy-quran-app/actions/runs/16762091944

---

## ❓ استكشاف الأخطاء

### إذا فشل البناء:
1. تحقق من logs في Actions
2. تأكد من صحة ملفات pubspec.yaml
3. تأكد من وجود جميع الملفات المطلوبة

### إذا لم يعمل APK:
1. تأكد من إصدار Android (5.0+)
2. فعل "مصادر غير معروفة"
3. تأكد من مساحة التخزين الكافية

### للحصول على المساعدة:
- افتح issue في GitHub
- تحقق من ملف APP_STATUS_REPORT.md
- راجع ملف HASANATI_FEATURES.md

---

## 🎯 ملاحظات مهمة

- ✅ التطبيق يعمل بدون إنترنت
- ✅ جميع الميزات الإسلامية مكتملة
- ✅ دعم كامل للغة العربية
- ✅ بناء تلقائي عبر GitHub Actions
- ✅ APK جاهز للتوزيع

**البناء قيد التشغيل الآن! تحقق من الرابط أعلاه لمتابعة التقدم.**