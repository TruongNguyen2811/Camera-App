// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiveImage _$ReceiveImageFromJson(Map<String, dynamic> json) => ReceiveImage(
      indexes: json['indexes'] as List<dynamic>?,
      run_numbers: json['run_numbers'] as List<dynamic>?,
      texts: json['texts'] as List<dynamic>?,
      suggested_texts: json['suggested_texts'] as List<dynamic>?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ReceiveImageToJson(ReceiveImage instance) =>
    <String, dynamic>{
      'indexes': instance.indexes,
      'run_numbers': instance.run_numbers,
      'texts': instance.texts,
      'suggested_texts': instance.suggested_texts,
      'images': instance.images,
    };
