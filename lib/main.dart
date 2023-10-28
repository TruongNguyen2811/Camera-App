import 'dart:async';
import 'package:app_camera/take_picture/take_picture_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Khởi tạo CameraFlutterBinding trước khi chạy ứng dụng
  WidgetsFlutterBinding.ensureInitialized();

  // Lấy danh sách các camera có sẵn trên thiết bị

  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPage(),
      // CameraScreen(camera: camera),
    );
  }
}
