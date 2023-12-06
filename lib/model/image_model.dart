import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageModel {
  int? id;
  DateTime? createDate;
  String? assetId;
  String? name;
  bool? isDbr;
  AssetEntity assetEntity;
  String? originName;
  PlatformFile? file;
  File? assetFile;

  ImageModel(
      {this.id,
      this.createDate,
      this.assetId,
      this.name,
      this.isDbr,
      this.originName,
      this.assetFile,
      this.file,
      this.assetEntity =
          const AssetEntity(id: '', typeInt: 1, width: 1, height: 1)});

  // Chuyển đổi dữ liệu thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createDate': createDate,
      'assetId': assetId,
      'name': name,
      'isDbr': isDbr,
      'assetEntity': assetEntity,
      'originName': originName,
      'assetFile': assetFile,
      'file': file,
    };
  }

  // Tạo model từ Map
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      createDate: DateTime.parse(map['createDate']),
      assetId: map['assetId'],
      name: map['name'],
      isDbr: map['isDbr'],
      assetEntity: map['assetEntity'],
      originName: map['originName'],
      file: map['file'],
      assetFile: map['assetFile'],
    );
  }
}
