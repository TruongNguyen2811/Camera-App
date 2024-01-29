import 'package:json_annotation/json_annotation.dart';

part 'confirm_image.g.dart';

@JsonSerializable()
class ConfrimImage {
  String? session_id;
  List<dynamic>? run_numbers;
  List<dynamic>? texts;
  List<String>? images;

  ConfrimImage({this.run_numbers, this.texts, this.images, this.session_id});

  factory ConfrimImage.fromJson(Map<String, dynamic> json) =>
      _$ConfrimImageFromJson(json);

  Map<String, dynamic> toJson() => _$ConfrimImageToJson(this);
}
