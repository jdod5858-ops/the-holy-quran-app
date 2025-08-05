import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../models/prayer_time.dart';
import '../../../services/prayer_times_service.dart';
import '../../../providers/app_provider.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  PrayerTime? prayerTimes;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPrayerTimes();
  }

  Future<void> loadPrayerTimes() async {
    try {
      final times = await PrayerTimesService.getTodayPrayerTimes();
      if (times != null) {
        setState(() {
          prayerTimes = times;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Unable to get location for prayer times';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading prayer times: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.prayerTimes),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              loadPrayerTimes();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: appProvider.fontSize,
                          color: Colors.red[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          loadPrayerTimes();
                        },
                        child: Text(appProvider.isArabic ? 'إعادة المحاولة' : 'Retry'),
                      ),
                    ],
                  ),
                )
              : PrayerTimesView(prayerTimes: prayerTimes!),
    );
  }
}

class PrayerTimesView extends StatelessWidget {
  final PrayerTime prayerTimes;

  const PrayerTimesView({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    final now = DateTime.now();
    final nextPrayerName = PrayerTimesService.getNextPrayerName(prayerTimes);
    final nextPrayerTime = PrayerTimesService.getNextPrayerTime(prayerTimes);
    
    final prayers = [
      {'name': localizations.fajr, 'time': prayerTimes.fajr, 'icon': Icons.wb_twilight},
      {'name': localizations.sunrise, 'time': prayerTimes.sunrise, 'icon': Icons.wb_sunny},
      {'name': localizations.dhuhr, 'time': prayerTimes.dhuhr, 'icon': Icons.wb_sunny_outlined},
      {'name': localizations.asr, 'time': prayerTimes.asr, 'icon': Icons.wb_cloudy},
      {'name': localizations.maghrib, 'time': prayerTimes.maghrib, 'icon': Icons.wb_twilight},
      {'name': localizations.isha, 'time': prayerTimes.isha, 'icon': Icons.nights_stay},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, y').format(now),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.today,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Next prayer countdown
          if (nextPrayerTime.isAfter(now))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    appProvider.isArabic ? 'الصلاة القادمة' : 'Next Prayer',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getPrayerNameInArabic(nextPrayerName, appProvider.isArabic),
                    style: TextStyle(
                      fontSize: appProvider.fontSize + 4,
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('h:mm a').format(nextPrayerTime),
                    style: TextStyle(
                      fontSize: appProvider.fontSize + 2,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          
          // Prayer times list
          Text(
            appProvider.isArabic ? 'مواقيت الصلاة' : 'Prayer Times',
            style: TextStyle(
              fontSize: appProvider.fontSize + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...prayers.map((prayer) {
            final prayerTime = prayer['time'] as DateTime;
            final isNext = _isNextPrayer(prayer['name'] as String, nextPrayerName, appProvider.isArabic);
            final isPassed = now.isAfter(prayerTime);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isNext 
                    ? Colors.green[50] 
                    : isPassed 
                        ? Colors.grey[50] 
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isNext 
                      ? Colors.green[200]! 
                      : Colors.grey[200]!,
                ),
              ),
              child: ListTile(
                leading: Icon(
                  prayer['icon'] as IconData,
                  color: isNext 
                      ? Colors.green[600] 
                      : isPassed 
                          ? Colors.grey[400] 
                          : Theme.of(context).primaryColor,
                  size: 28,
                ),
                title: Text(
                  prayer['name'] as String,
                  style: TextStyle(
                    fontSize: appProvider.fontSize + 2,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    color: isPassed ? Colors.grey[600] : null,
                  ),
                ),
                trailing: Text(
                  DateFormat('h:mm a').format(prayerTime),
                  style: TextStyle(
                    fontSize: appProvider.fontSize + 1,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                    color: isNext 
                        ? Colors.green[700] 
                        : isPassed 
                            ? Colors.grey[500] 
                            : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getPrayerNameInArabic(String englishName, bool isArabic) {
    if (!isArabic) return englishName;
    
    switch (englishName.toLowerCase()) {
      case 'fajr':
        return 'الفجر';
      case 'sunrise':
        return 'الشروق';
      case 'dhuhr':
        return 'الظهر';
      case 'asr':
        return 'العصر';
      case 'maghrib':
        return 'المغرب';
      case 'isha':
        return 'العشاء';
      default:
        return englishName;
    }
  }

  bool _isNextPrayer(String prayerName, String nextPrayerName, bool isArabic) {
    if (isArabic) {
      return _getPrayerNameInArabic(nextPrayerName, true) == prayerName;
    }
    return nextPrayerName.toLowerCase() == prayerName.toLowerCase();
  }
}