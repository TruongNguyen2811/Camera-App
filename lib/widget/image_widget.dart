import 'dart:convert';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Base64ImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final BoxFit fit;
  final String base64String;

  Base64ImageWidget({
    required this.height,
    required this.width,
    required this.fit,
    required this.base64String,
  });

  @override
  Widget build(BuildContext context) {
    // Decode chuỗi base64 thành một mảng byte
    List<int> imageBytes;
    // print('check e ${base64String}eeee');
    if (Utils.isEmpty(base64String)) {
      // print('check error ${base64String}');
      return _buildErrorWidget();
    } else {
      try {
        // print('check up error ${base64String}');
        imageBytes = base64Decode(base64String);
      } catch (e) {
        // Handle the case where decoding fails, for example, display an error icon
        print('check up error $e');
        return _buildErrorWidget();
      }

      // Tạo một Image từ mảng byte
      Image image = Image.memory(
        Uint8List.fromList(imageBytes),
        height: height,
        width: width,
        fit: fit,
      );

      // Wrapping trong một container để có thể xác định kích thước của ảnh
      return Container(
        height: height,
        width: width,
        child: image,
      );
    }
  }

  Widget _buildErrorWidget() {
    // You can customize this widget to display an error icon or message
    return Icon(
      Icons.error,
      color: Colors.red,
      size: height > width ? height / 2 : width / 2,
    );
  }
}
