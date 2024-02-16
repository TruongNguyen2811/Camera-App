import 'dart:async';
import 'package:app_camera/injection_container.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  // Khởi tạo CameraFlutterBinding trước khi chạy ứng dụng
  await configureDependencies();
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
        builder: (context, child) {
          return BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: widget!);
              },
              theme: ThemeData(
                  brightness: Brightness.light,
                  textTheme:
                      GoogleFonts.interTextTheme(Theme.of(context).textTheme),
                  sliderTheme: Theme.of(context).sliderTheme.copyWith(
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 0),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      thumbColor: const Color(0xFF6476D7),
                      tickMarkShape:
                          const RoundSliderTickMarkShape(tickMarkRadius: 4),
                      inactiveTickMarkColor: const Color(0xFFC4C4C4),
                      activeTickMarkColor: const Color(0xFF6476D7))),
              home: BlocConsumer<InternetCubit, InternetState>(
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
