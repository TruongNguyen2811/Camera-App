import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_camera/model/confirm_image.dart';
import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/page/receiveImage/receive_image_state.dart';
import 'package:app_camera/service/api/api_result.dart';
import 'package:app_camera/service/api/network_exceptions.dart';
import 'package:app_camera/service/repository/app_repository_impl.dart';
import 'package:app_camera/utils/logger.dart';
import 'package:app_camera/utils/utils.dart';
// import 'package:camerawesome/generated/i18n.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:native_exif/native_exif.dart';
// import 'package:native_exif/native_exif.dart';
import 'package:path/path.dart' as path;

class ReceiveImageCubit extends Cubit<ReceiveImageState> {
  ReceiveImageCubit() : super(ReceiveInitial());
  ConfrimImage confirmImage = ConfrimImage();
  final AppRepository repository = AppRepository();
  var box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  List<ImageData> imageDataUpdate = [];
  List<Uint8List> imageBytes = [];
  List<dynamic> returnText = [];

  getData() {
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    print('check length image ${imageDataList.length}');
  }

  convertBase64(List<String>? base64) {
    emit(ReceiveLoading());
    for (var i in base64 ?? []) {
      imageBytes.add(base64Decode(i));
    }
    print('check imagebyte length ${imageBytes.length}');
    emit(ConvertSuccess());
  }

  Future<void> confirmListImage(String domain) async {
    emit(ReceiveLoading());
    if (Utils.isEmpty(confirmImage.session_id)) {
      emit(ConfirmFailure('You are not in any session Id'));
      return;
    }
    if (Utils.isEmptyArray(confirmImage.texts)) {
      print('check upload fail');
      emit(ConfirmFailure('You need to enter all text output'));
    } else {
      for (var i in confirmImage.texts ?? []) {
        // print('check upload adsf ${i}');
        if (Utils.isEmpty(i)) {
          print('check upload fail');
          emit(ConfirmFailure('You need to enter all text output'));
          return; // Thoát khỏi hàm nếu điều kiện không đáp ứng
        } else {
          print('check upload confirm ${i}');
        }
      }
    }
    ApiResult<dynamic> apiResult = await repository.confirmImage(confirmImage);
    apiResult.when(success: (dynamic data) {
      // receiveImage = ReceiveImage.fromJson(data);
      emit(ConfirmSuccess('Image list uploaded successfully'));
      updateStatus();
    }, failure: (NetworkExceptions error) {
      logger.d(error);
      emit(ConfirmFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  updateStatus() async {
    for (var i in imageDataList) {
      for (var x in imageDataUpdate) {
        if (i.id == x.id) {
          i.type = 2;
          x.type = 2;
        }
      }
    }
    await box.put('imageListKey', imageDataList);
  }

  // Future<void> confirmListImage(String domain) async {
  //   emit(ReceiveLoading());
  //   print('check upload');
  //   if (Utils.isEmptyArray(confirmImage.texts)) {
  //     print('check upload fail');
  //     emit(ConfirmFailure('You need to enter all serial number'));
  //   } else {
  //     for (var i in confirmImage.texts ?? []) {
  //       print('check upload adsf ${i}');
  //       if (Utils.isEmpty(i)) {
  //         print('check upload fail');
  //         emit(ConfirmFailure('You need to enter all serial number'));
  //         return; // Thoát khỏi hàm nếu điều kiện không đáp ứng
  //       } else {
  //         print('check upload confirm ${i}');
  //       }
  //       break;
  //     }
  //   }
  //   try {
  //     Dio dio = Dio();
  //     print('check upload try');
  //     // Thay thế bằng đường dẫn API của bạn
  //     print('check upload try ${confirmImage.session_id}');
  //     print('check upload try ${confirmImage.run_numbers}');
  //     print('check upload try ${confirmImage.images}');
  //     print('check upload try ${confirmImage.texts}');
  //     Response response =
  //         await dio.post('$domain/ocr-image-confirmation', data: confirmImage);
  //     print('check upload response ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       // receiveImage = response.data;
  //       print('Image list uploaded successfully');
  //       emit(ConfirmSuccess('Images list confirm successfully'));
  //       print('${response.data}');
  //     } else {
  //       print('Error uploading image list');
  //       emit(ConfirmFailure('Error confirm image list'));
  //       print('check ${response}');
  //     }
  //   } catch (error) {
  //     if (error is DioError) {
  //       try {
  //         final detail = error.response?.data['detail'];
  //         print('Error response body: $detail');
  //         emit(ConfirmFailure(detail));
  //       } catch (e) {
  //         print(error);
  //         emit(ConfirmFailure('Error confirm image list'));
  //       }
  //       // Xử lý lỗi và truy cập nội dung phản hồi
  //       // final detail = error.response?.data['detail'];
  //       // print('Error response body: $detail');
  //       // emit(ConfirmFailure(detail));
  //     } else {
  //       print(error);
  //       emit(ConfirmFailure('Error confirm image list'));
  //       // Xử lý các lỗi khác
  //     }
  //     // print('${response}');
  //   }
  // }
}
