import 'dart:convert';
import 'package:flutter/services.dart';

class City {
  final int id;
  final String nameAr;
  final String nameEn;
  final String countryAr;
  final String countryEn;
  final double latitude;
  final double longitude;
  final String timezone;

  City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.countryAr,
    required this.countryEn,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      countryAr: json['country_ar'],
      countryEn: json['country_en'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'country_ar': countryAr,
      'country_en': countryEn,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
    };
  }
}

class CitiesService {
  static const String _assetPath = 'assets/data/cities.json';
  static List<City>? _cachedCities;

  static Future<List<City>> getCities() async {
    if (_cachedCities != null) {
      return _cachedCities!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _cachedCities = jsonList.map((json) => City.fromJson(json)).toList();
      return _cachedCities!;
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  static Future<City?> getCityById(int id) async {
    final cities = await getCities();
    try {
      return cities.firstWhere((city) => city.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<City>> searchCities(String query, {bool isArabic = true}) async {
    final cities = await getCities();
    final lowerQuery = query.toLowerCase();
    
    return cities.where((city) {
      if (isArabic) {
        return city.nameAr.contains(query) || city.countryAr.contains(query);
      } else {
        return city.nameEn.toLowerCase().contains(lowerQuery) || 
               city.countryEn.toLowerCase().contains(lowerQuery);
      }
    }).toList();
  }

  static Future<List<City>> getCitiesByCountry(String country, {bool isArabic = true}) async {
    final cities = await getCities();
    
    return cities.where((city) {
      if (isArabic) {
        return city.countryAr == country;
      } else {
        return city.countryEn.toLowerCase() == country.toLowerCase();
      }
    }).toList();
  }

  static Future<City?> findNearestCity(double latitude, double longitude) async {
    final cities = await getCities();
    
    if (cities.isEmpty) return null;
    
    City? nearestCity;
    double minDistance = double.infinity;
    
    for (final city in cities) {
      final distance = _calculateDistance(
        latitude, longitude, 
        city.latitude, city.longitude
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    }
    
    return nearestCity;
  }

  // Calculate distance between two points using Haversine formula
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.cos() * lat2.cos() * 
        (dLon / 2).sin() * (dLon / 2).sin();
    
    final double c = 2 * a.sqrt().asin();
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}