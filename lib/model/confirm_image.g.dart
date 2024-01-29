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
      session_id: json['session_id'] as String?,
    );

Map<String, dynamic> _$ConfrimImageToJson(ConfrimImage instance) =>
    <String, dynamic>{
      'session_id': instance.session_id,
      'run_numbers': instance.run_numbers,
      'texts': instance.texts,
      'images': instance.images,
    };
