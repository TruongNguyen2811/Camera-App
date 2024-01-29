import 'dart:async';
import 'package:app_camera/page/check_internet/check_internet_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity = Connectivity();
  late StreamSubscription connectivitySubscription;
  bool isConnect = true;

  InternetCubit() : super(InternetInitial()) {
    // Khởi tạo lắng nghe sự thay đổi của trạng thái kết nối
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnect = false;
        emit(InternetFailure('Lost Connect Internet'));
      } else {
        isConnect = true;
        emit(InternetSucess('You are online'));
      }
    });
  }

  @override
  Future<void> close() {
    // Hủy lắng nghe khi Cubit bị đóng
    connectivitySubscription.cancel();
    return super.close();
  }

  // MainCubit() : super(MainInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();
}
