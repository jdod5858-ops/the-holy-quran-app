import 'package:hijri/hijri.dart';

class HijriService {
  static HijriCalendar getCurrentHijriDate() {
    return HijriCalendar.now();
  }
  
  static HijriCalendar getHijriDate(DateTime gregorianDate) {
    return HijriCalendar.fromDate(gregorianDate);
  }
  
  static DateTime getGregorianDate(int hijriYear, int hijriMonth, int hijriDay) {
    final hijriDate = HijriCalendar();
    hijriDate.hYear = hijriYear;
    hijriDate.hMonth = hijriMonth;
    hijriDate.hDay = hijriDay;
    return hijriDate.hijriToGregorian(hijriYear, hijriMonth, hijriDay);
  }
  
  static String getHijriMonthName(int month, {bool isArabic = true}) {
    final arabicMonths = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    
    final englishMonths = [
      'Muharram', 'Safar', 'Rabi\' al-awwal', 'Rabi\' al-thani',
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', 'Sha\'ban',
      'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah'
    ];
    
    if (month < 1 || month > 12) return '';
    
    return isArabic ? arabicMonths[month - 1] : englishMonths[month - 1];
  }
  
  static String formatHijriDate(HijriCalendar hijriDate, {bool isArabic = true}) {
    final monthName = getHijriMonthName(hijriDate.hMonth, isArabic: isArabic);
    
    if (isArabic) {
      return '${hijriDate.hDay} $monthName ${hijriDate.hYear} هـ';
    } else {
      return '${hijriDate.hDay} $monthName ${hijriDate.hYear} AH';
    }
  }
  
  static List<String> getIslamicEvents() {
    final currentHijri = getCurrentHijriDate();
    final events = <String>[];
    
    // Check for major Islamic events
    if (currentHijri.hMonth == 1 && currentHijri.hDay == 1) {
      events.add('رأس السنة الهجرية');
    }
    
    if (currentHijri.hMonth == 3 && currentHijri.hDay == 12) {
      events.add('المولد النبوي الشريف');
    }
    
    if (currentHijri.hMonth == 7 && currentHijri.hDay == 27) {
      events.add('الإسراء والمعراج');
    }
    
    if (currentHijri.hMonth == 8 && currentHijri.hDay == 15) {
      events.add('ليلة البراءة');
    }
    
    if (currentHijri.hMonth == 9) {
      events.add('شهر رمضان المبارك');
      
      if (currentHijri.hDay >= 21 && currentHijri.hDay <= 29 && currentHijri.hDay % 2 == 1) {
        events.add('ليلة القدر (محتملة)');
      }
    }
    
    if (currentHijri.hMonth == 10 && currentHijri.hDay == 1) {
      events.add('عيد الفطر المبارك');
    }
    
    if (currentHijri.hMonth == 12) {
      if (currentHijri.hDay >= 8 && currentHijri.hDay <= 13) {
        events.add('أيام الحج');
      }
      
      if (currentHijri.hDay == 9) {
        events.add('يوم عرفة');
      }
      
      if (currentHijri.hDay == 10) {
        events.add('عيد الأضحى المبارك');
      }
      
      if (currentHijri.hDay >= 11 && currentHijri.hDay <= 13) {
        events.add('أيام التشريق');
      }
    }
    
    return events;
  }
  
  static bool isRamadan() {
    return getCurrentHijriDate().hMonth == 9;
  }
  
  static bool isHajjSeason() {
    final currentHijri = getCurrentHijriDate();
    return currentHijri.hMonth == 12 && currentHijri.hDay >= 8 && currentHijri.hDay <= 13;
  }
}