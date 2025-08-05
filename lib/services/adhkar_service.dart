import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dhikr.dart';

class AdhkarService {
  static const String _assetPath = 'assets/duas/adhkar_complete.json';
  
  static Future<AdhkarCategory> getAdhkar() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      return AdhkarCategory.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load adhkar: $e');
    }
  }
  
  static Future<List<Dhikr>> getMorningAdhkar() async {
    final adhkar = await getAdhkar();
    return adhkar.morning;
  }
  
  static Future<List<Dhikr>> getEveningAdhkar() async {
    final adhkar = await getAdhkar();
    return adhkar.evening;
  }
  
  static Future<List<Dhikr>> getSleepAdhkar() async {
    final adhkar = await getAdhkar();
    return adhkar.sleep;
  }
  
  static Future<List<Dhikr>> getAdhkarByCategory(String category) async {
    final adhkar = await getAdhkar();
    
    switch (category.toLowerCase()) {
      case 'morning':
        return adhkar.morning;
      case 'evening':
        return adhkar.evening;
      case 'sleep':
        return adhkar.sleep;
      default:
        return [];
    }
  }
}