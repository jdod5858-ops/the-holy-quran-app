import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../models/prayer_time.dart';
import 'cities_service.dart';

class PrayerTimesService {
  static Future<LocationData?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Return default location (Makkah) if location service is disabled
        return LocationData(
          latitude: 21.3891,
          longitude: 39.8579,
          city: 'مكة المكرمة',
          country: 'السعودية',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Return default location if permission denied
          return LocationData(
            latitude: 21.3891,
            longitude: 39.8579,
            city: 'مكة المكرمة',
            country: 'السعودية',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Return default location if permission denied forever
        return LocationData(
          latitude: 21.3891,
          longitude: 39.8579,
          city: 'مكة المكرمة',
          country: 'السعودية',
        );
      }

      Position position = await Geolocator.getCurrentPosition();
      
      // Try to find nearest city from our offline database
      final nearestCity = await CitiesService.findNearestCity(
        position.latitude, 
        position.longitude
      );
      
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: nearestCity?.nameAr ?? 'الموقع الحالي',
        country: nearestCity?.countryAr ?? '',
      );
    } catch (e) {
      // Return default location on any error
      return LocationData(
        latitude: 21.3891,
        longitude: 39.8579,
        city: 'مكة المكرمة',
        country: 'السعودية',
      );
    }
  }

  static Future<LocationData?> getLocationByCity(String cityName) async {
    try {
      final cities = await CitiesService.searchCities(cityName, isArabic: true);
      if (cities.isNotEmpty) {
        final city = cities.first;
        return LocationData(
          latitude: city.latitude,
          longitude: city.longitude,
          city: city.nameAr,
          country: city.countryAr,
        );
      }
      
      // Try English search
      final citiesEn = await CitiesService.searchCities(cityName, isArabic: false);
      if (citiesEn.isNotEmpty) {
        final city = citiesEn.first;
        return LocationData(
          latitude: city.latitude,
          longitude: city.longitude,
          city: city.nameAr,
          country: city.countryAr,
        );
      }
      
      return null;
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