import 'dart:convert';

import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/model/image_model.dart';
import 'package:app_camera/model/receive_image.dart';
import 'package:app_camera/page/all_Image/all_image_state.dart';
import 'package:app_camera/service/api/api_result.dart';
import 'package:app_camera/service/api/network_exceptions.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/service/repository/app_repository_impl.dart';
import 'package:app_camera/utils/logger.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllImageCubit extends Cubit<AllImageState> {
  AllImageCubit() : super(AllImageInitial());
  // TextEditingController controller = TextEditingController();

  final AppRepository repository = AppRepository();

  final sharedPref = AppPreferences();
  String? sessionId;
  ReceiveImage receiveImage = ReceiveImage();
  var box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  List<ImageData> imageDataListChoose = [];
  List<bool> isChoose = [];
  // List<ImageModel> imageModel = [];
  int countUnRunNumber = 0;
  int countUnConfirm = 0;
  bool selectAll = false;

  cleanAllData() async {
    emit(AllImageLoading());
    imageDataList = [];
    imageDataListChoose = [];
    imageDataShow = [];
    getData();
    await box.put('imageListKey', []);
    // imageModel = [];
    emit(DeleteImage('You have deleted all photos'));
    getData();
  }

  selectAllData() {
    emit(AllImageLoading());
    imageDataListChoose = [];
    for (var i = 0; i < isChoose.length; i++) {
      isChoose[i] = false;
    }
    if (selectAll == true) {
      selectAll = false;
      imageDataListChoose = [];
      for (var i = 0; i < isChoose.length; i++) {
        isChoose[i] = false;
      }
    } else {
      selectAll = true;
      if (imageDataList.length <= 10) {
        imageDataListChoose.addAll(imageDataList);
        for (var i = 0; i < isChoose.length; i++) {
          isChoose[i] = true;
        }
      } else {
        for (var i = 0; i < 10; i++) {
          isChoose[i] = true;
          imageDataListChoose.add(imageDataList[i]);
        }
      }
    }
    print('is choose $isChoose');
    emit(selectAllSuccess());
  }

  cleanChoosedData() async {
    emit(AllImageLoading());
    if (Utils.isEmpty(imageDataListChoose)) {
      emit(AllImageFailure('You must select at least 1 photo'));
      return;
    }
    imageDataList.removeWhere((element) => imageDataListChoose
        .any((chosenObject) => chosenObject.id == element.id));
    await box.put('imageListKey', imageDataList);
    imageDataShow = [];
    getData();
    // imageModel.removeWhere((element) => imageDataListChoose
    //     .any((chosenObject) => chosenObject.id == element.id));
    emit(DeleteImage('You have deleted ${imageDataListChoose.length} photos'));
    imageDataListChoose = [];
  }

  getData({int? type}) async {
    emit(AllImageLoading());
    print('start');
    String? base64String;
    isChoose = [];
    // imageDataList = List<ImageData>.from(
    //     box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? []);
    if (type != null) {
      imageDataList = List<ImageData>.from(box
              .get('imageListKey', defaultValue: [])
              ?.cast<ImageData>()
              .where((imageData) => imageData.type == type)
              .toList() ??
          []);
    } else {
      imageDataList = List<ImageData>.from(
          box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? []);
    }
    if (imageDataList.isNotEmpty) {
      pagingImage(0);
      createPage();
      for (var i = 0; i < imageDataList.length; i++) {
        isChoose.add(false);
        // if (type != null && imageDataList[i].type == type) {
        //   // print('check id ${imageDataList[i].id}');
        //   // base64String =
        //   //     await base64Encode(imageDataList[i].uint8list?.toList() ?? []);
        //   ImageModel oneImageModel = ImageModel(
        //     createDate: imageDataList[i].createDate,
        //     name: imageDataList[i].name,
        //     id: imageDataList[i].id,
        //     isDbr: imageDataList[i].isDbr,
        //     type: imageDataList[i].type,
        //     uint8list: imageDataList[i].uint8list,
        //     // byte64: base64String,
        //     isChoose: false,
        //   );
        //   imageModel.add(oneImageModel);
        //   // print(imageModel.length);
        // }
        // if (type == null) {
        //   // base64String =
        //   //     base64Encode(imageDataList[i].uint8list?.toList() ?? []);
        //   ImageModel oneImageModel = ImageModel(
        //     createDate: imageDataList[i].createDate,
        //     name: imageDataList[i].name,
        //     id: imageDataList[i].id,
        //     isDbr: imageDataList[i].isDbr,
        //     type: imageDataList[i].type,
        //     uint8list: imageDataList[i].uint8list,
        //     // byte64: base64String,
        //     isChoose: false,
        //   );
        //   imageModel.add(oneImageModel);
        //   // print(imageModel.length);
        // }
      }
      emit(AllImageSuccess());
    } else {
      emit(ListImageEmpty());
    }
  }

  int page = 0;

  createPage() {
    int modulo = imageDataList.length % 10;
    if (modulo == 0) {
      page = imageDataList.length ~/ 10;
    } else {
      page = imageDataList.length ~/ 10 + 1;
    }
  }

  List<ImageData> imageDataShow = [];
  int pageChoose = 0;

  pagingImage(int page) {
    emit(AllImageLoading());
    pageChoose = page;
    imageDataShow.clear();
    if (page * 10 + 10 < imageDataList.length) {
      for (var i = page * 10; i < (page + 1) * 10; i++) {
        imageDataShow.add(imageDataList[i]);
      }
    } else {
      for (var i = page * 10; i < imageDataList.length; i++) {
        imageDataShow.add(imageDataList[i]);
      }
    }
    emit(AllImagePaging());
  }

  void choose(bool newDBR, int id, int index) {
    emit(AllImageLoading());

    for (var i in imageDataList) {
      // print('check id ${i.id}');
      if (i.id == id) {
        // Nếu assetId trùng khớp với mục tiêu, cập nhật trường isDBR
        // i.isDbr = newDBR;
        if (newDBR == true) {
          imageDataListChoose.add(i);
        }
        if (newDBR == false) {
          imageDataListChoose.remove(i);
        }
        // Sử dụng box.put để lưu lại thay đổi
      }
      if (imageDataList != 10) {
        selectAll = false;
      }
      isChoose[index] = newDBR;
      // for (var x in imageModel) {
      //   if (x.id == id) {
      //     x.isChoose = newDBR;
      //   }
      // }
    }
    emit(const AllImageSuccess());
  }

  uploadImageList() async {
    emit(AllImageLoading());
    if (Utils.isEmptyArray(imageDataListChoose)) {
      emit(AllImageFailure(
          'You must select at least 1 photo and at most 10 photos'));
      return;
    } else if (imageDataListChoose.length > 10) {
      emit(AllImageFailure(
          'You must select at least 1 photo and at most 10 photos'));
      return;
    }
    ApiResult<dynamic> apiResult =
        await repository.uploadImage(imageDataListChoose);
    apiResult.when(success: (dynamic data) {
      receiveImage = ReceiveImage.fromJson(data);
      emit(UploadImageSuccess('Image list uploaded successfully'));
    }, failure: (NetworkExceptions error) {
      logger.d(error);
      emit(AllImageFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }
}
