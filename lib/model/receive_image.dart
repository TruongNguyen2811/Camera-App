import 'package:json_annotation/json_annotation.dart';

part 'receive_image.g.dart';

@JsonSerializable()
class ReceiveImage {
  List<dynamic>? indexes;
  List<dynamic>? run_numbers;
  List<dynamic>? texts;
  List<dynamic>? suggested_texts;
  List<String>? images;

  ReceiveImage(
      {this.indexes,
      this.run_numbers,
      this.texts,
      this.suggested_texts,
      this.images});

  factory ReceiveImage.fromJson(Map<String, dynamic> json) =>
      _$ReceiveImageFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiveImageToJson(this);
}
