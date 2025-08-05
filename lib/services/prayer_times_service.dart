import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../models/prayer_time.dart';

class PrayerTimesService {
  static Future<LocationData?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition();
      
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: 'Unknown',
        country: 'Unknown',
      );
    } catch (e) {
      return null;
    }
  }
  
  static PrayerTime calculatePrayerTimes(double latitude, double longitude, DateTime date) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    
    final prayerTimes = PrayerTimes.today(coordinates, params);
    
    return PrayerTime(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      date: date,
    );
  }
  
  static Future<PrayerTime?> getTodayPrayerTimes() async {
    final location = await getCurrentLocation();
    if (location == null) return null;
    
    return calculatePrayerTimes(
      location.latitude,
      location.longitude,
      DateTime.now(),
    );
  }
  
  static String getNextPrayerName(PrayerTime prayerTimes) {
    final now = DateTime.now();
    
    if (now.isBefore(prayerTimes.fajr)) return 'fajr';
    if (now.isBefore(prayerTimes.sunrise)) return 'sunrise';
    if (now.isBefore(prayerTimes.dhuhr)) return 'dhuhr';
    if (now.isBefore(prayerTimes.asr)) return 'asr';
    if (now.isBefore(prayerTimes.maghrib)) return 'maghrib';
    if (now.isBefore(prayerTimes.isha)) return 'isha';
    
    // Next day Fajr
    final nextDay = calculatePrayerTimes(
      0, 0, // Will be replaced with actual coordinates
      DateTime.now().add(const Duration(days: 1)),
    );
    return 'fajr';
  }
  
  static DateTime getNextPrayerTime(PrayerTime prayerTimes) {
    final now = DateTime.now();
    
    if (now.isBefore(prayerTimes.fajr)) return prayerTimes.fajr;
    if (now.isBefore(prayerTimes.sunrise)) return prayerTimes.sunrise;
    if (now.isBefore(prayerTimes.dhuhr)) return prayerTimes.dhuhr;
    if (now.isBefore(prayerTimes.asr)) return prayerTimes.asr;
    if (now.isBefore(prayerTimes.maghrib)) return prayerTimes.maghrib;
    if (now.isBefore(prayerTimes.isha)) return prayerTimes.isha;
    
    // Next day Fajr - will need actual coordinates
    return DateTime.now().add(const Duration(days: 1));
  }
}