import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme settings
          _buildSectionHeader(localizations.settings, appProvider),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    appProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    appProvider.isDark ? localizations.darkMode : localizations.lightMode,
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  trailing: Switch(
                    value: appProvider.isDark,
                    onChanged: (value) {
                      appProvider.setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    localizations.language,
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    appProvider.isArabic ? localizations.arabic : localizations.english,
                    style: TextStyle(fontSize: appProvider.fontSize - 2),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showLanguageDialog(context, appProvider, localizations),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.format_size,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    localizations.fontSize,
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    '${appProvider.fontSize.toInt()}',
                    style: TextStyle(fontSize: appProvider.fontSize - 2),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showFontSizeDialog(context, appProvider, localizations),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Prayer settings
          _buildSectionHeader(localizations.prayerTimes, appProvider),
          
          Card(
            child: ListTile(
              leading: Icon(
                Icons.notifications,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                localizations.enableNotifications,
                style: TextStyle(fontSize: appProvider.fontSize),
              ),
              trailing: Switch(
                value: appProvider.prayerNotifications,
                onChanged: (value) {
                  appProvider.setPrayerNotifications(value);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Khatm progress
          _buildSectionHeader(localizations.khatmQuran, appProvider),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    localizations.progress,
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    '${appProvider.getKhatmProgress().length}/114 ${localizations.chapters}',
                    style: TextStyle(fontSize: appProvider.fontSize - 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LinearProgressIndicator(
                    value: appProvider.getKhatmProgress().length / 114,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.refresh,
                    color: Colors.red[600],
                  ),
                  title: Text(
                    appProvider.isArabic ? 'إعادة تعيين التقدم' : 'Reset Progress',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      color: Colors.red[600],
                    ),
                  ),
                  onTap: () => _showResetProgressDialog(context, appProvider, localizations),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About section
          _buildSectionHeader(appProvider.isArabic ? 'حول التطبيق' : 'About', appProvider),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    appProvider.isArabic ? 'اسم التطبيق' : 'App Name',
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    'حسناتي',
                    style: TextStyle(
                      fontSize: appProvider.fontSize - 2,
                      fontFamily: 'Noor',
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.code,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    appProvider.isArabic ? 'المطور' : 'Developer',
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    'Voxin',
                    style: TextStyle(fontSize: appProvider.fontSize - 2),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    appProvider.isArabic ? 'الإصدار' : 'Version',
                    style: TextStyle(fontSize: appProvider.fontSize),
                  ),
                  subtitle: Text(
                    '2.5.6',
                    style: TextStyle(fontSize: appProvider.fontSize - 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppProvider appProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: appProvider.fontSize + 2,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppProvider appProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(localizations.arabic),
              value: 'ar',
              groupValue: appProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setLocale(Locale(value));
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(localizations.english),
              value: 'en',
              groupValue: appProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setLocale(Locale(value));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, AppProvider appProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.fontSize),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                appProvider.isArabic ? 'حجم الخط الحالي' : 'Current font size',
                style: TextStyle(fontSize: appProvider.fontSize),
              ),
              const SizedBox(height: 16),
              Slider(
                value: appProvider.fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: appProvider.fontSize.toInt().toString(),
                onChanged: (value) {
                  appProvider.setFontSize(value);
                  setState(() {});
                },
              ),
              Text(
                appProvider.isArabic ? 'نص تجريبي للخط' : 'Sample text for font',
                style: TextStyle(fontSize: appProvider.fontSize),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appProvider.isArabic ? 'تم' : 'Done'),
          ),
        ],
      ),
    );
  }

  void _showResetProgressDialog(BuildContext context, AppProvider appProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appProvider.isArabic ? 'إعادة تعيين التقدم' : 'Reset Progress'),
        content: Text(
          appProvider.isArabic 
              ? 'هل أنت متأكد من أنك تريد إعادة تعيين تقدم ختمة القرآن؟'
              : 'Are you sure you want to reset your Quran completion progress?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appProvider.isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.resetKhatmProgress();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appProvider.isArabic 
                        ? 'تم إعادة تعيين التقدم بنجاح'
                        : 'Progress reset successfully',
                  ),
                ),
              );
            },
            child: Text(
              appProvider.isArabic ? 'إعادة تعيين' : 'Reset',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }
}