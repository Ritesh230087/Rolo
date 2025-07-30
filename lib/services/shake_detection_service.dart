import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectionService {
  static final ShakeDetectionService _instance = ShakeDetectionService._internal();
  factory ShakeDetectionService() => _instance;
  ShakeDetectionService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Function? _onShakeDetected;
  
  static const double _shakeThreshold = 2.7; 
  static const int _shakeDuration = 1200; 
  static const int _shakeCountResetTime = 5000; 
  
  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  Timer? _shakeResetTimer;

  void initialize({required Function onShakeDetected}) {
    _onShakeDetected = onShakeDetected;
    _startListening();
  }

  void _startListening() {
    _accelerometerSubscription?.cancel();
    
    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        _detectShake(event.x, event.y, event.z);
      },
      onError: (error) {
        print('Accelerometer error: $error');
      },
    );
  }

  void _detectShake(double x, double y, double z) {
    double acceleration = sqrt(x * x + y * y + z * z);
    double deltaAcceleration = acceleration - 9.8;
    if (deltaAcceleration.abs() > _shakeThreshold) {
      DateTime now = DateTime.now();
      if (_lastShakeTime != null && 
          now.difference(_lastShakeTime!).inMilliseconds < _shakeDuration) {
        return; 
      }
      if (_lastShakeTime != null && 
          now.difference(_lastShakeTime!).inMilliseconds > _shakeCountResetTime) {
        _shakeCount = 0;
      }
      _shakeCount++;
      _lastShakeTime = now;
      _shakeResetTimer?.cancel();
      _shakeResetTimer = Timer(Duration(milliseconds: _shakeCountResetTime), () {
        _shakeCount = 0;
      });
      if (_shakeCount >= 3) {
        _triggerLogout();
        _shakeCount = 0; 
      }
    }
  }
  void _triggerLogout() {
    if (_onShakeDetected != null) {
      HapticFeedback.heavyImpact();
      _onShakeDetected!();
    }
  }
  void dispose() {
    _accelerometerSubscription?.cancel();
    _shakeResetTimer?.cancel();
    _onShakeDetected = null;
  }
  void pause() {
    _accelerometerSubscription?.pause();
  }
  void resume() {
    _accelerometerSubscription?.resume();
  }
}