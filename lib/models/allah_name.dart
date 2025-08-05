import 'package:freezed_annotation/freezed_annotation.dart';

part 'allah_name.freezed.dart';
part 'allah_name.g.dart';

@freezed
class AllahName with _$AllahName {
  const factory AllahName({
    required int id,
    required String name,
    required String transliteration,
    @JsonKey(name: 'meaning_ar') required String meaningAr,
    @JsonKey(name: 'meaning_en') required String meaningEn,
  }) = _AllahName;

  factory AllahName.fromJson(Map<String, dynamic> json) => _$AllahNameFromJson(json);
}