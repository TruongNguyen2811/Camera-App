import 'package:json_annotation/json_annotation.dart';

part 'confirm_image.g.dart';

@JsonSerializable()
class ConfrimImage {
  List<dynamic>? run_numbers;
  List<dynamic>? texts;
  List<String>? images;

  ConfrimImage({this.run_numbers, this.texts, this.images});

  factory ConfrimImage.fromJson(Map<String, dynamic> json) =>
      _$ConfrimImageFromJson(json);

  Map<String, dynamic> toJson() => _$ConfrimImageToJson(this);
}
