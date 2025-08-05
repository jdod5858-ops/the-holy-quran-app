import 'package:hasanati/router/routes.dart';
import 'package:iconsax/iconsax.dart';

class DrawerUtils {
  static const List items = [
    {
      'title': 'Surah Index',
      'icon': Iconsax.sort,
      'route': AppRoutes.surah,
    },
    {
      'title': 'Juz Index',
      'icon': Iconsax.note_1,
      'route': AppRoutes.juz,
    },
    {
      'title': 'Bookmarks',
      'icon': Iconsax.book_1,
      'route': AppRoutes.bookmarks,
    },
    {
      'title': 'Allah Names',
      'icon': Iconsax.star,
      'route': AppRoutes.allahNames,
    },
    {
      'title': 'Adhkar & Duas',
      'icon': Iconsax.heart,
      'route': AppRoutes.adhkar,
    },
    {
      'title': 'Prayer Times',
      'icon': Iconsax.clock,
      'route': AppRoutes.prayerTimes,
    },
    {
      'title': 'Qibla Direction',
      'icon': Iconsax.location,
      'route': AppRoutes.qibla,
    },
    {
      'title': 'Hijri Calendar',
      'icon': Iconsax.calendar,
      'route': AppRoutes.hijriCalendar,
    },
    {
      'title': 'Settings',
      'icon': Iconsax.setting,
      'route': AppRoutes.settings,
    },
    {
      'title': 'Introduction',
      'icon': Iconsax.info_circle,
      'route': AppRoutes.onboarding,
    },
    {
      'title': 'Share App',
      'icon': Iconsax.share,
      'route': AppRoutes.shareApp,
    },
  ];
}
