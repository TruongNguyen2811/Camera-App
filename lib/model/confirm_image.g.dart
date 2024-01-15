// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfrimImage _$ConfrimImageFromJson(Map<String, dynamic> json) => ConfrimImage(
      run_numbers: json['run_numbers'] as List<dynamic>?,
      texts: json['texts'] as List<dynamic>?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConfrimImageToJson(ConfrimImage instance) =>
    <String, dynamic>{
      'run_numbers': instance.run_numbers,
      'texts': instance.texts,
      'images': instance.images,
    };
