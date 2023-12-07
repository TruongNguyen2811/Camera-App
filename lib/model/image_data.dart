import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'image_data.g.dart';

@HiveType(typeId: 0)
class ImageData {
  @HiveField(0)
  DateTime? createDate;

  @HiveField(1)
  String? assetId;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? isDbr;

  ImageData({
    this.createDate,
    this.assetId,
    this.name,
    this.isDbr,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'createDate': createDate,
      'assetId': assetId,
      'name': name,
      'isDbr': isDbr,
      // 'assetEntity': assetEntity,
      // 'originName': originName,
      // 'assetFile': assetFile,
      // 'file': file,
    };
  }

  static ImageData fromMap(Map<String, dynamic> map) {
    return ImageData(
      createDate: DateTime.parse(map['createDate']),
      assetId: map['assetId'],
      name: map['name'],
      isDbr: map['isDbr'],
    );
  }

  // factory ImageData.fromMap(Map<String, dynamic> map) {
  //   return ImageData(
  //     // id: map['id'],
  //     createDate: DateTime.parse(map['createDate']),
  //     assetId: map['assetId'],
  //     name: map['name'],
  //     isDbr: map['isDbr'],
  //     // assetEntity: map['assetEntity'],
  //     // originName: map['originName'],
  //     // file: map['file'],
  //     // assetFile: map['assetFile'],
  //   );
  // }
}
