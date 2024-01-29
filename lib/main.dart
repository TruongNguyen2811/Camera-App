import 'dart:async';
import 'package:app_camera/page/check_internet/check_internet_cubit.dart';
import 'package:app_camera/page/check_internet/check_internet_state.dart';
import 'package:app_camera/page/home/home_page.dart';
import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/page/main/main_cubit.dart';
import 'package:app_camera/page/main/main_page.dart';
import 'package:app_camera/page/main/main_state.dart';
import 'package:app_camera/page/take_picture/take_picture_screen.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  // Khởi tạo CameraFlutterBinding trước khi chạy ứng dụng
  await Hive.initFlutter();
  Hive.registerAdapter(ImageDataAdapter()); // Đảm bảo đăng ký adapter
  await Hive.openBox<List>('imageBox');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Chỉ cho phép màn hình xoay theo chiều dọc
  ]).then((value) => runApp(CameraApp()));
  // Lấy danh sách các camera có sẵn trên thiết bị
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, child) {
          return BlocProvider<InternetCubit>(
            create: (_) => InternetCubit(),
            child: MaterialApp(
              home: BlocProvider<InternetCubit>(
                create: (_) => InternetCubit(),
                child: BlocConsumer<InternetCubit, InternetState>(
                  listener: (context, state) {
                    if (state is InternetSucess) {
                      Utils.showToast(context, state.success,
                          type: ToastType.SUCCESS);
                    }
                    if (state is InternetFailure) {
                      Utils.showToast(context, state.error,
                          type: ToastType.ERROR);
                    }
                  },
                  builder: (context, state) {
                    return MainPage();
                  },
                  // child: MainPage()
                ),
              ),
              // CameraScreen(camera: camera),
            ),
          );
        });
  }

  @override
  void dispose() {
    // Đóng box khi không cần truy cập nữa, ví dụ khi widget bị hủy
    Hive.box<List<ImageData>>('imageBox').close();
    // super.dispose();
  }
}
