import 'package:flutter/material.dart';

// ui-imports-start
import 'package:hasanati/ui/screens/home/home_screen.dart';
import 'package:hasanati/ui/screens/juz/juz_index_screen.dart';
import 'package:hasanati/ui/screens/onboarding/onboarding.dart';
import 'package:hasanati/ui/screens/share_app/share_app.dart';
import 'package:hasanati/ui/screens/splash/splash.dart';
import 'package:hasanati/ui/screens/surah/surah_index_screen.dart';
import 'package:hasanati/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:hasanati/ui/screens/allah_names/allah_names_screen.dart';
import 'package:hasanati/ui/screens/adhkar/adhkar_screen.dart';
import 'package:hasanati/ui/screens/prayer_times/prayer_times_screen.dart';
import 'package:hasanati/ui/screens/qibla/qibla_screen.dart';
import 'package:hasanati/ui/screens/hijri_calendar/hijri_calendar_screen.dart';
import 'package:hasanati/ui/screens/settings/settings_screen.dart';

import 'routes.dart';

final navigator = GlobalKey<NavigatorState>();

final appRoutes = {
  AppRoutes.juz: (context) => const JuzIndexScreen(),
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.surah: (context) => const SurahIndexScreen(),
  AppRoutes.shareApp: (context) => const ShareAppScreen(),
  AppRoutes.bookmarks: (context) => const BookmarksScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
  AppRoutes.allahNames: (context) => const AllahNamesScreen(),
  AppRoutes.adhkar: (context) => const AdhkarScreen(),
  AppRoutes.prayerTimes: (context) => const PrayerTimesScreen(),
  AppRoutes.qibla: (context) => const QiblaScreen(),
  AppRoutes.hijriCalendar: (context) => const HijriCalendarScreen(),
  AppRoutes.settings: (context) => const SettingsScreen(),
};
