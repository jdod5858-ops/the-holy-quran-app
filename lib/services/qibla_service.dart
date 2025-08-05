import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaService {
  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;
  
  static double calculateQiblaDirection(double latitude, double longitude) {
    // Convert degrees to radians
    final lat1 = latitude * pi / 180;
    final lon1 = longitude * pi / 180;
    final lat2 = kaabaLatitude * pi / 180;
    final lon2 = kaabaLongitude * pi / 180;
    
    // Calculate the difference in longitude
    final dLon = lon2 - lon1;
    
    // Calculate the bearing
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    double bearing = atan2(y, x);
    
    // Convert radians to degrees
    bearing = bearing * 180 / pi;
    
    // Normalize to 0-360 degrees
    bearing = (bearing + 360) % 360;
    
    return bearing;
  }
  
  static Future<double?> getCurrentQiblaDirection() async {
    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      Position position = await Geolocator.getCurrentPosition();
      
      return calculateQiblaDirection(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }
  
  static Stream<double>? getCompassHeading() {
    return FlutterCompass.events?.map((event) => event.heading ?? 0.0);
  }
  
  static double calculateQiblaAngle(double qiblaDirection, double compassHeading) {
    double angle = qiblaDirection - compassHeading;
    
    // Normalize angle to -180 to 180 degrees
    while (angle > 180) angle -= 360;
    while (angle < -180) angle += 360;
    
    return angle;
  }
  
  static bool isPointingToQibla(double qiblaAngle, {double tolerance = 10.0}) {
    return qiblaAngle.abs() <= tolerance;
  }
}