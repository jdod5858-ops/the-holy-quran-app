import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final themeMap = {
  'system': ThemeMode.system,
  'dark': ThemeMode.dark,
  'light': ThemeMode.light,
};

final localeMap = {
  'ar': const Locale('ar', ''),
  'en': const Locale('en', ''),
};

enum Cache {
  theme,
  locale,
  firstOpen,
  fontSize,
  lastReadPosition,
  khatmProgress,
  prayerNotifications,
}

class AppProvider extends ChangeNotifier {
  static AppProvider s(BuildContext context, [bool listen = false]) =>
      Provider.of<AppProvider>(context, listen: listen);

  var themeMode = ThemeMode.light;
  var locale = const Locale('ar', '');
  var fontSize = 16.0;
  var key = const Key('app');
  var firstOpen = false;
  var prayerNotifications = true;
  late Box<dynamic> _cache;
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isArabic => locale.languageCode == 'ar';

  AppProvider() {
    _init();
  }

  void _init() async {
    await Hive.openBox('app');
    _cache = Hive.box('app');

    final cachedTheme = _cache.get(Cache.theme.toString());
    themeMode = cachedTheme == null ? themeMode : themeMap[cachedTheme]!;

    final cachedLocale = _cache.get(Cache.locale.toString());
    locale = cachedLocale == null ? locale : localeMap[cachedLocale]!;

    final cachedFontSize = _cache.get(Cache.fontSize.toString());
    fontSize = cachedFontSize ?? fontSize;

    final cachedNotifications = _cache.get(Cache.prayerNotifications.toString());
    prayerNotifications = cachedNotifications ?? prayerNotifications;

    final hasOpened = _cache.get(Cache.firstOpen.toString());
    firstOpen = hasOpened == null;
    notifyListeners();
  }

  void setTheme(ThemeMode newTheme) {
    if (themeMode == newTheme) return;
    themeMode = newTheme;
    notifyListeners();
    _cache.put(
      Cache.theme.toString(),
      newTheme.toString().split('.').last,
    );
  }

  void setLocale(Locale newLocale) {
    if (locale == newLocale) return;
    locale = newLocale;
    notifyListeners();
    _cache.put(
      Cache.locale.toString(),
      newLocale.languageCode,
    );
  }

  void setFontSize(double newSize) {
    if (fontSize == newSize) return;
    fontSize = newSize;
    notifyListeners();
    _cache.put(Cache.fontSize.toString(), newSize);
  }

  void setPrayerNotifications(bool enabled) {
    if (prayerNotifications == enabled) return;
    prayerNotifications = enabled;
    notifyListeners();
    _cache.put(Cache.prayerNotifications.toString(), enabled);
  }

  void setLastReadPosition(int chapterNumber, int verseNumber) {
    final position = {'chapter': chapterNumber, 'verse': verseNumber};
    _cache.put(Cache.lastReadPosition.toString(), position);
  }

  Map<String, int>? getLastReadPosition() {
    final position = _cache.get(Cache.lastReadPosition.toString());
    if (position == null) return null;
    return {
      'chapter': position['chapter'],
      'verse': position['verse'],
    };
  }

  void updateKhatmProgress(int chapterNumber) {
    final progress = _cache.get(Cache.khatmProgress.toString()) ?? <int>[];
    if (!progress.contains(chapterNumber)) {
      progress.add(chapterNumber);
      _cache.put(Cache.khatmProgress.toString(), progress);
      notifyListeners();
    }
  }

  List<int> getKhatmProgress() {
    return _cache.get(Cache.khatmProgress.toString()) ?? <int>[];
  }

  void resetKhatmProgress() {
    _cache.put(Cache.khatmProgress.toString(), <int>[]);
    notifyListeners();
  }

  void setFirstOpen() {
    firstOpen = true;
    notifyListeners();
    _cache.put(Cache.firstOpen.toString(), 'true');
  }

  void reset() async {
    firstOpen = true;
    themeMode = ThemeMode.system;
    locale = const Locale('ar', '');
    fontSize = 16.0;
    prayerNotifications = true;
    await _cache.clear();
    key = Key(DateTime.now().toString());
    notifyListeners();
  }

  void resetKey([bool notify = true]) {
    key = Key(DateTime.now().toString());
    if (notify) notifyListeners();
  }
}
