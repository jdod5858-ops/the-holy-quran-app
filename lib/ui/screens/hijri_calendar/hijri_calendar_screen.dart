import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../services/hijri_service.dart';
import '../../../providers/app_provider.dart';
import 'package:hijri/hijri.dart';
import 'package:intl/intl.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late HijriCalendar currentHijriDate;
  late DateTime currentGregorianDate;
  List<String> islamicEvents = [];

  @override
  void initState() {
    super.initState();
    currentHijriDate = HijriService.getCurrentHijriDate();
    currentGregorianDate = DateTime.now();
    islamicEvents = HijriService.getIslamicEvents();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calendar),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current date card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    appProvider.isArabic ? 'التاريخ الهجري' : 'Hijri Date',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    HijriService.formatHijriDate(currentHijriDate, isArabic: appProvider.isArabic),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: appProvider.fontSize + 6,
                      fontWeight: FontWeight.bold,
                      fontFamily: appProvider.isArabic ? 'Noor' : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      DateFormat('EEEE, MMMM d, y').format(currentGregorianDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Islamic events
            if (islamicEvents.isNotEmpty) ...[
              Text(
                appProvider.isArabic ? 'المناسبات الإسلامية' : 'Islamic Events',
                style: TextStyle(
                  fontSize: appProvider.fontSize + 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...islamicEvents.map((event) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Colors.green[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        event,
                        style: TextStyle(
                          fontSize: appProvider.fontSize + 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[800],
                          fontFamily: appProvider.isArabic ? 'Noor' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 24),
            ],
            
            // Month info
            Text(
              appProvider.isArabic ? 'معلومات الشهر' : 'Month Information',
              style: TextStyle(
                fontSize: appProvider.fontSize + 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    appProvider.isArabic ? 'الشهر الهجري:' : 'Hijri Month:',
                    HijriService.getHijriMonthName(currentHijriDate.hMonth, isArabic: appProvider.isArabic),
                    appProvider,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    appProvider.isArabic ? 'السنة الهجرية:' : 'Hijri Year:',
                    '${currentHijriDate.hYear} ${appProvider.isArabic ? 'هـ' : 'AH'}',
                    appProvider,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    appProvider.isArabic ? 'اليوم في الشهر:' : 'Day of Month:',
                    '${currentHijriDate.hDay}',
                    appProvider,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Special months info
            if (HijriService.isRamadan()) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.purple[600],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appProvider.isArabic ? 'شهر رمضان المبارك' : 'Blessed Month of Ramadan',
                      style: TextStyle(
                        fontSize: appProvider.fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                        fontFamily: appProvider.isArabic ? 'Noor' : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appProvider.isArabic 
                          ? 'شهر الصيام والقيام والقرآن'
                          : 'Month of fasting, prayer, and Quran',
                      style: TextStyle(
                        fontSize: appProvider.fontSize,
                        color: Colors.purple[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            if (HijriService.isHajjSeason()) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.orange[600],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appProvider.isArabic ? 'موسم الحج' : 'Hajj Season',
                      style: TextStyle(
                        fontSize: appProvider.fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                        fontFamily: appProvider.isArabic ? 'Noor' : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appProvider.isArabic 
                          ? 'أيام الحج المباركة'
                          : 'Blessed days of Hajj',
                      style: TextStyle(
                        fontSize: appProvider.fontSize,
                        color: Colors.orange[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppProvider appProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: appProvider.fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: appProvider.fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: appProvider.isArabic ? 'Noor' : null,
          ),
        ),
      ],
    );
  }
}