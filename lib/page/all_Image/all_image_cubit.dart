import 'dart:convert';

import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/model/image_model.dart';
import 'package:app_camera/page/all_Image/all_image_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllImageCubit extends Cubit<AllImageState> {
  AllImageCubit() : super(AllImageInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();
  String? sessionId;

  var box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  List<ImageModel> imageModel = [];
  int countUnRunNumber = 0;
  int countUnConfirm = 0;

  cleanAllData() async {
    emit(AllImageLoading());
    await box.put('imageListKey', []);
    imageModel = [];
    emit(AllImageSuccess());
    getData();
  }

  getData() {
    emit(AllImageLoading());
    String? base64String;
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    if (imageDataList.isNotEmpty) {
      for (var i = 0; i < imageDataList.length; i++) {
        print('check id ${imageDataList[i].id}');
        base64String = base64Encode(imageDataList[i].uint8list?.toList() ?? []);
        ImageModel oneImageModel = ImageModel(
          createDate: imageDataList[i].createDate,
          name: imageDataList[i].name,
          id: imageDataList[i].id,
          isDbr: imageDataList[i].isDbr,
          type: imageDataList[i].type,
          uint8list: imageDataList[i].uint8list,
          byte64: base64String,
        );
        imageModel.add(oneImageModel);
        print(imageModel.length);
      }
      emit(AllImageSuccess());
    } else {
      emit(ListImageEmpty());
    }
  }

  void choose(bool newDBR, int id) {
    emit(AllImageLoading());
    for (var i in imageDataList) {
      print('check id ${i.id}');
      if (i.id == id) {
        // Nếu assetId trùng khớp với mục tiêu, cập nhật trường isDBR
        i.isDbr = newDBR;
        // Sử dụng box.put để lưu lại thay đổi
      }
      for (var x in imageModel) {
        if (x.id == id) {
          x.isDbr = newDBR;
        }
      }
    }
    emit(const AllImageSuccess());
  }
}
