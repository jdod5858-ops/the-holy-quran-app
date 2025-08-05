import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../services/qibla_service.dart';
import '../../../providers/app_provider.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? qiblaDirection;
  double compassHeading = 0.0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeQibla();
  }

  Future<void> initializeQibla() async {
    try {
      final direction = await QiblaService.getCurrentQiblaDirection();
      if (direction != null) {
        setState(() {
          qiblaDirection = direction;
          isLoading = false;
        });
        
        // Listen to compass
        QiblaService.getCompassHeading()?.listen((heading) {
          if (mounted) {
            setState(() {
              compassHeading = heading;
            });
          }
        });
      } else {
        setState(() {
          errorMessage = 'Unable to get location';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
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
        title: Text(localizations.qibla),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Column(
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
                          initializeQibla();
                        },
                        child: Text(appProvider.isArabic ? 'إعادة المحاولة' : 'Retry'),
                      ),
                    ],
                  )
                : QiblaCompass(
                    qiblaDirection: qiblaDirection!,
                    compassHeading: compassHeading,
                  ),
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  final double qiblaDirection;
  final double compassHeading;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.compassHeading,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    final qiblaAngle = QiblaService.calculateQiblaAngle(qiblaDirection, compassHeading);
    final isPointingToQibla = QiblaService.isPointingToQibla(qiblaAngle);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status text
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPointingToQibla ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPointingToQibla ? Colors.green : Colors.orange,
              width: 2,
            ),
          ),
          child: Text(
            isPointingToQibla
                ? (appProvider.isArabic ? 'أنت تتجه نحو القبلة' : 'You are facing Qibla')
                : (appProvider.isArabic ? 'اتجه نحو القبلة' : 'Turn towards Qibla'),
            style: TextStyle(
              fontSize: appProvider.fontSize + 2,
              fontWeight: FontWeight.bold,
              color: isPointingToQibla ? Colors.green[800] : Colors.orange[800],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Compass
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Compass background
              Transform.rotate(
                angle: -compassHeading * pi / 180,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[400]!, width: 2),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        Colors.grey[100]!,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // North indicator
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Text(
                          'N',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Cardinal directions
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'W',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'E',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Qibla direction arrow
              Transform.rotate(
                angle: qiblaDirection * pi / 180,
                child: Container(
                  width: 4,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Phone direction indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isPointingToQibla ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              
              // Kaaba icon at Qibla direction
              Transform.rotate(
                angle: qiblaDirection * pi / 180,
                child: Transform.translate(
                  offset: const Offset(0, -100),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Direction info
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appProvider.isArabic ? 'اتجاه القبلة:' : 'Qibla Direction:',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${qiblaDirection.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appProvider.isArabic ? 'اتجاه الهاتف:' : 'Phone Direction:',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${compassHeading.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: appProvider.fontSize,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}