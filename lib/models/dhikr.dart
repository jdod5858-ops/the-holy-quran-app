import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr.freezed.dart';
part 'dhikr.g.dart';

@freezed
class Dhikr with _$Dhikr {
  const factory Dhikr({
    required int id,
    required String arabic,
    required String transliteration,
    @JsonKey(name: 'translation_ar') required String translationAr,
    @JsonKey(name: 'translation_en') required String translationEn,
    required int count,
    required String reference,
  }) = _Dhikr;

  factory Dhikr.fromJson(Map<String, dynamic> json) => _$DhikrFromJson(json);
}

@freezed
class AdhkarCategory with _$AdhkarCategory {
  const factory AdhkarCategory({
    required List<Dhikr> morning,
    required List<Dhikr> evening,
    required List<Dhikr> sleep,
  }) = _AdhkarCategory;

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) => _$AdhkarCategoryFromJson(json);
}