import 'dart:io';

import 'package:app_camera/upload_image/upload_image_state.dart';
import 'package:camerawesome/generated/i18n.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UpLoadInitial());

  // final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImages() async {
    emit(UploadLoading());
    final List<XFile>? selectedImages =
        await ImagePicker().pickMultiImage(imageQuality: 60);
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    // print("Image List Length:" + imageFileList.length.toString());
    emit(UpLoadInitial());
  }

  void onDeleteImagePicked(XFile imageDelete) {
    emit(UploadLoading());
    int checkIndex =
        imageFileList.indexWhere((e) => e.path == imageDelete.path);
    if (checkIndex != -1) {
      imageFileList.removeAt(checkIndex);
    }
    print('123');
    emit(UpLoadInitial());
  }

  // Future<void> uploadImageList() async {
  //   try {
  //     FirebaseStorage storage = FirebaseStorage.instance;

  //     if (imageFileList.isNotEmpty) {
  //       for (int i = 0; i < imageFileList.length; i++) {
  //         XFile image = imageFileList[i];
  //         File file = File(image.path);

  //         String fileName = 'image_$i.jpg';
  //         Reference ref = storage.ref().child('imageList/$fileName');

  //         UploadTask uploadTask = ref.putFile(file);
  //         TaskSnapshot taskSnapshot = await uploadTask
  //             .whenComplete(() => print('Image $i uploaded successfully'));

  //         String imageUrl = await taskSnapshot.ref.getDownloadURL();
  //         print('Image $i URL: $imageUrl');
  //       }
  //     }
  //   } catch (error) {
  //     print('Error uploading image list: $error');
  //   }
  // }
  Future<void> uploadImageList(String sessionId, String domain) async {
    emit(UploadLoading());
    try {
      Dio dio = Dio();
      String url =
          'https://your-api-endpoint.com/upload'; // Thay thế bằng đường dẫn API của bạn

      List<MultipartFile> formDataList = [];

      for (int i = 0; i < imageFileList.length; i++) {
        XFile image = imageFileList[i];
        File file = File(image.path);
        formDataList.add(await MultipartFile.fromFile(file.path));
      }

      FormData formData = FormData.fromMap({
        'images': formDataList,
        // Thêm các thông tin khác nếu cần thiết
      });
      print('check time');
      Response response = await dio.post('$domain/upload-images',
          queryParameters: {'session_id': sessionId}, data: formData);
      print('check time2');
      if (response.statusCode == 200) {
        print('Image list uploaded successfully');
        emit(UpLoadSuccess('Image list uploaded successfully'));
        print('${response.data}');
      } else {
        print('Error uploading image list');
        emit(UpLoadFailure('Error uploading image list'));
        print('check ${response}');
      }
    } catch (error) {
      if (error is DioError) {
        // Xử lý lỗi và truy cập nội dung phản hồi
        final detail = error.response?.data['detail'];
        print('Error response body: $detail');
        emit(UpLoadFailure(detail));
      } else {
        print(error);
        emit(UpLoadFailure('Error uploading image list'));
        // Xử lý các lỗi khác
      }
      // print('${response}');
    }
  }
}
