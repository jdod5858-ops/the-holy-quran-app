import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_time.freezed.dart';
part 'prayer_time.g.dart';

@freezed
class PrayerTime with _$PrayerTime {
  const factory PrayerTime({
    required DateTime fajr,
    required DateTime sunrise,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
    required DateTime date,
  }) = _PrayerTime;

  factory PrayerTime.fromJson(Map<String, dynamic> json) => _$PrayerTimeFromJson(json);
}

@freezed
class LocationData with _$LocationData {
  const factory LocationData({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
  }) = _LocationData;

  factory LocationData.fromJson(Map<String, dynamic> json) => _$LocationDataFromJson(json);
}