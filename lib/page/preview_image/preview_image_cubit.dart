import 'dart:io';

import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/model/receive_image.dart';
import 'package:app_camera/page/preview_image/preview_image_state.dart';
import 'package:app_camera/utils/utils.dart';
// import 'package:camerawesome/generated/i18n.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:native_exif/native_exif.dart';
// import 'package:native_exif/native_exif.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;

class PreviewImageCubit extends Cubit<PreviewImageState> {
  PreviewImageCubit() : super(PreviewInitial());

  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  bool isDBR = false;
  late AssetPathEntity _album;
  var box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  ImageData latestImageData = ImageData();
  ReceiveImage receiveImage = ReceiveImage();

  getData() {
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    if (imageDataList.isNotEmpty) {
      // Lấy phần tử mới nhất từ danh sách
      latestImageData = imageDataList.last;
      // Sử dụng latestImageData theo nhu cầu của bạn
    }
  }

  Future<void> uploadImageList(
      String sessionId, String domain, String fileImage) async {
    emit(PreviewLoading());
    var compressedImage = await FlutterImageCompress.compressWithFile(
      fileImage,
      format: CompressFormat.jpeg,
      quality: Platform.isIOS ? 10 : 30,
    );
    final file = File(fileImage);
    await file.writeAsBytes(compressedImage!.toList());
    print('check upload');
    if (Utils.isEmpty(controller.text)) {
      print('check upload fail');
      emit(UploadFailure('You need to enter runner number'));
      return;
    } else if (!Utils.isEmpty(controller.text)) {
      try {
        int value = int.parse(controller.text);
        try {
          Dio dio = Dio();
          print('check upload try');
          // Thay thế bằng đường dẫn API của bạn
          MultipartFile file = await MultipartFile.fromFile(
            fileImage,
            filename: '${controller.text}.jpg',
          );

          // for (int i = 0; i < files.length; i++) {
          //   // XFile image = selectedFiles[i];
          //   String originalString = files[i].name;
          //   String name =
          //       originalString.substring(originalString.lastIndexOf('_') + 1);
          //   print('check split name $name');
          //   // print('${files[i].path}');
          //   // print('${files[i].name}');
          //   formDataList
          //       .add(await MultipartFile.fromFile(files[i].path!, filename: name));
          // }

          FormData formData = FormData.fromMap({
            'images': file,
            // Thêm các thông tin khác nếu cần thiết
          });
          print('check upload check time');
          Response response =
              await dio.post('$domain/ocr-images', data: formData);
          print('check upload response ${response.statusCode}');
          if (response.statusCode == 200) {
            // receiveImage = response.data;
            receiveImage = ReceiveImage.fromJson(response.data);
            print('check upload data ${response.data}');
            print('check upload data ${receiveImage.run_numbers?.first}');
            print('Image list uploaded successfully');
            emit(UploadSuccess('Image list uploaded successfully'));
            print('${response.data}');
          } else {
            print('Error uploading image list');
            emit(UploadFailure('Error uploading image list'));
            print('check ${response}');
          }
        } catch (error) {
          if (error is DioError) {
            try {
              final detail = error.response?.data['detail'];
              print('Error response body: $detail');
              emit(UploadFailure(detail));
            } catch (e) {
              print(error);
              emit(UploadFailure('Error uploading image list'));
            }
            // Xử lý lỗi và truy cập nội dung phản hồi
            // final detail = error.response?.data['detail'];
            // print('Error response body: $detail');
            // emit(UploadFailure('Error uploading image list'));
          } else {
            print(error);
            emit(UploadFailure('Error uploading image list'));
            // Xử lý các lỗi khác
          }
          // print('${response}');
        }
        // If parsing succeeds, return true
        return;
      } catch (e) {
        // If parsing fails, return false
        emit(UploadFailure('You need to enter correct format runner number'));
        return;
      }
    }
  }
}
