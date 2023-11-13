import 'dart:async';
import 'package:app_camera/home/home_page.dart';
import 'package:app_camera/take_picture/take_picture_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  // Khởi tạo CameraFlutterBinding trước khi chạy ứng dụng
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Lấy danh sách các camera có sẵn trên thiết bị

  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, child) {
          return MaterialApp(
            home: HomePage(),
            // CameraScreen(camera: camera),
          );
        });
  }
}
