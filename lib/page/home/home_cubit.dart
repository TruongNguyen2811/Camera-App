import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/page/home/home_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();
  String? sessionId;

  voidGetSessionId() async {
    emit(HomeLoading());
    sessionId = await sharedPref.sessionId;
    if (sessionId == null) {
      emit(HomeGetSessionIdSucess("You have no session Id"));
    } else {
      emit(HomeGetSessionIdSucess("You are in session Id ${controller.text}"));
    }
  }

  clearSessionId() async {
    emit(HomeLoading());
    await sharedPref.removeSessionId();
    sessionId = null;
    emit(HomeGetSessionIdSucess("Yyou have no session Id"));
  }

  var box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  int countUnRunNumber = 0;
  int countUnConfirm = 0;

  getData() {
    emit(HomeLoading());
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    if (imageDataList.isNotEmpty) {
      print('check length ${imageDataList.length}');
      List<ImageData> filteredList =
          imageDataList.where((obj) => obj.type == 0).toList();
      countUnRunNumber = filteredList.length;
      List<ImageData> filteredList2 =
          imageDataList.where((obj) => obj.type == 1).toList();
      countUnConfirm = filteredList2.length;
      // print('data list length ${imageDataList.length}');
      // // Lấy phần tử mới nhất từ danh sách
      // latestImageData = imageDataList.last;
      // Sử dụng latestImageData theo nhu cầu của bạn
    }
    emit(HomeInitial());
  }
}
