import 'dart:io';

import 'package:app_camera/upload_image/upload_image_state.dart';
// import 'package:camerawesome/generated/i18n.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UpLoadInitial());

  // final ImagePicker imagePicker = ImagePicker();
  // List<Asset> imageFileList = [];
  List<PlatformFile> files = [];
  // List<AssetEntity> selectedAssetList = [];
  // List<String> originalImagePaths = [];

  void selectImages() async {
    emit(UploadLoading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          // allowedExtensions: [jp],
          // type: FileType.custom,
          // allowedExtensions: ["jpg", "png"],
          allowMultiple: true);

      if (result != null) {
        files.addAll(result.files);
      } else {
        // User canceled the picker
        print('0');
      }
      emit(UpLoadInitial());
    } catch (e) {
      print('check $e');
      emit(UpLoadFailure('Can not choose image'));
    }
    // print("Image List Length:" + imageFileList.length.toString());
  }

  // List<File> selectedFiles = [];
  // Future convertAssetsToFiles() async {
  //   emit(UploadLoading());
  //   for (var i = 0; i < selectedAssetList.length; i++) {
  //     final File? file = await selectedAssetList[i].originFile;
  //     print('check path ${file?.path}');
  //     // setState(() {
  //     selectedFiles.add(file!);
  //     // });
  //   }
  //   emit(UpLoadInitial());
  // }

  void onDeleteImagePicked(PlatformFile imageDelete) {
    emit(UploadLoading());
    int checkIndex = files.indexWhere((e) => e.path == imageDelete.path);
    if (checkIndex != -1) {
      files.removeAt(checkIndex);
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
      // Thay thế bằng đường dẫn API của bạn

      List<MultipartFile> formDataList = [];

      for (int i = 0; i < files.length; i++) {
        // XFile image = selectedFiles[i];

        print('${files[i].path}');
        print('${files[i].name}');
        formDataList.add(await MultipartFile.fromFile(files[i].path!,
            filename: files[i].name));
      }

      FormData formData = FormData.fromMap({
        'images': formDataList,
        // Thêm các thông tin khác nếu cần thiết
      });
      print('check time');
      Response response = await dio.post('$domain/upload-images',
          queryParameters: {'session_id': sessionId}, data: formData);

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
