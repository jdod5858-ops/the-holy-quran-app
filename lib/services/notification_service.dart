import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'prayer_times_service.dart';
import '../models/prayer_time.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(initSettings);
    
    // Initialize workmanager for background tasks
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }
  
  static Future<bool> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }
    
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    
    return false;
  }
  
  static Future<void> schedulePrayerNotifications() async {
    // Cancel existing notifications
    await _notifications.cancelAll();
    
    try {
      final prayerTimes = await PrayerTimesService.getTodayPrayerTimes();
      if (prayerTimes == null) return;
      
      final prayers = [
        {'name': 'الفجر', 'time': prayerTimes.fajr, 'id': 1},
        {'name': 'الظهر', 'time': prayerTimes.dhuhr, 'id': 2},
        {'name': 'العصر', 'time': prayerTimes.asr, 'id': 3},
        {'name': 'المغرب', 'time': prayerTimes.maghrib, 'id': 4},
        {'name': 'العشاء', 'time': prayerTimes.isha, 'id': 5},
      ];
      
      for (final prayer in prayers) {
        final prayerTime = prayer['time'] as DateTime;
        final prayerName = prayer['name'] as String;
        final id = prayer['id'] as int;
        
        // Schedule notification 5 minutes before prayer time
        final notificationTime = prayerTime.subtract(const Duration(minutes: 5));
        
        if (notificationTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: id,
            title: 'حان وقت صلاة $prayerName',
            body: 'حان الآن وقت صلاة $prayerName',
            scheduledTime: notificationTime,
          );
        }
        
        // Schedule notification at exact prayer time
        if (prayerTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: id + 10,
            title: 'أذان $prayerName',
            body: 'حان الآن وقت صلاة $prayerName',
            scheduledTime: prayerTime,
          );
        }
      }
      
      // Schedule daily refresh
      await Workmanager().registerPeriodicTask(
        'prayer_notifications',
        'refreshPrayerNotifications',
        frequency: const Duration(hours: 24),
      );
      
    } catch (e) {
      print('Error scheduling prayer notifications: $e');
    }
  }
  
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adhan'),
    );
    
    const iosDetails = DarwinNotificationDetails(
      sound: 'adhan.mp3',
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Instant notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
  
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    await Workmanager().cancelAll();
  }
}

// Background task callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'refreshPrayerNotifications':
        await NotificationService.schedulePrayerNotifications();
        break;
    }
    return Future.value(true);
  });
}