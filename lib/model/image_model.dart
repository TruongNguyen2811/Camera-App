import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ImageModel {
  int? id;
  DateTime? createDate;
  int? type;
  Uint8List? uint8list;
  bool? isDbr;
  String? name;
  String? byte64;
  bool? isChoose;

  ImageModel({
    this.createDate,
    this.name,
    this.isDbr,
    this.uint8list,
    this.id,
    this.type,
    this.byte64,
    this.isChoose,
  });

  // Chuyển đổi dữ liệu thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createDate': createDate,
      'uint8list': uint8list,
      'name': name,
      'isDbr': isDbr,
      'type': type,
      'byte64': byte64,
      'isChoose': isChoose,
    };
  }

  // Tạo model từ Map
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      createDate: DateTime.parse(map['createDate']),
      uint8list: map['uint8list'],
      name: map['name'],
      isDbr: map['isDbr'],
      type: map['type'],
      byte64: map['byte64'],
      isChoose: map['isChoose'],
    );
  }
}
