import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/allah_name.dart';

class AllahNamesService {
  static const String _assetPath = 'assets/names/allah_names_complete.json';
  
  static Future<List<AllahName>> getAllahNames() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) => AllahName.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load Allah names: $e');
    }
  }
  
  static Future<AllahName?> getAllahNameById(int id) async {
    final names = await getAllahNames();
    try {
      return names.firstWhere((name) => name.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static Future<List<AllahName>> searchAllahNames(String query) async {
    final names = await getAllahNames();
    final lowerQuery = query.toLowerCase();
    
    return names.where((name) => 
      name.name.toLowerCase().contains(lowerQuery) ||
      name.transliteration.toLowerCase().contains(lowerQuery) ||
      name.meaningAr.toLowerCase().contains(lowerQuery) ||
      name.meaningEn.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}