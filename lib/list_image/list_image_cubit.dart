import 'dart:io';
import 'package:app_camera/list_image/list_image_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';

class ListImageCubit extends Cubit<ListImageState> {
  ListImageCubit() : super(ListImageInitial());

  List<PlatformFile> files = [];
  List<PlatformFile> listDBR = [];
  List<PlatformFile> listNoneDBR = [];

  // List<AssetEntity> selectedAssetList = [];
  // List<String> originalImagePaths = [];

  void selectImages() async {
    emit(ListImageLoading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          // allowedExtensions: [jp],
          // type: FileType.custom,
          // allowedExtensions: ["jpg", "png"],
          allowMultiple: true);
      if (result != null) {
        files.addAll(result.files);
        for (var file in result.files) {
          // Lấy thông tin Exif từ ảnh
          if (file.name.contains('DBR')) {
            listDBR.add(file);
          } else {
            listNoneDBR.add(file);
          }
        }
      } else {
        // User canceled the picker
        print('0');
      }
      // for (var i in files) {
      //   final exif = await Exif.fromPath(i.path ?? '');
      //   final attribute = await exif.getAttributes();
      //   print('check feature ${attribute}');
      // }
      emit(ListImageInitial());
    } catch (e) {
      print('check $e');
      emit(ListImageFailure('Can not choose image'));
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
    emit(ListImageLoading());
    int checkIndex = files.indexWhere((e) => e.path == imageDelete.path);
    if (checkIndex != -1) {
      files.removeAt(checkIndex);
    }
    print('123');
    emit(ListImageInitial());
  }

  List<File> images = [];
  List<File> imagesDBR = [];
  List<File> imagesNoDBR = [];
  void getImage() async {
    emit(ListImageLoading());
    print(1234);
    try {
      // Lấy đường dẫn đến thư mục lưu trữ ảnh
      final directory = await getExternalStorageDirectory();
      String trimmedPath =
          directory?.path.substring(0, directory.path.lastIndexOf("/0")) ?? '';
      // Lọc danh sách các tệp thoả mãn điều kiện
      print('check trimmed ${trimmedPath}');
      final imagesDirectoryPath = '${trimmedPath}/0/Pictures';
      Directory imagesDirectory = Directory(imagesDirectoryPath);
      // Directory appDir = await getApplicationDocumentsDirectory();
      String galleryPathIos = directory!.parent.parent.parent.parent.path;
      print('check IOS${galleryPathIos}');

      if (imagesDirectory != null) {
        String galleryPath = imagesDirectory.path;

        // Kiểm tra tất cả các tệp tin trong thư mục gallery
        Directory(galleryPath).listSync().forEach((entity) {
          if (entity is File) {
            String fileName = entity.path.split('/').last;
            if (fileName.startsWith('CameraApp') && fileName.endsWith('.jpg')) {
              images.add(entity);
            }
          }
        });
      }
      images = images.reversed.toList();
      for (var image in images) {
        print('Check image ${image.path}');
        // Lấy thông tin Exif từ ảnh
        if (image.path.contains('DBR')) {
          imagesDBR.add(image);
        } else {
          imagesNoDBR.add(image);
        }
      }
      print('Check ${imagesDirectory}');
      print('Check length ${images.length}');
      // In ra đường dẫn của các ảnh đã lọc được
    } catch (e) {
      print('Error: $e');
    }
    emit(ListImageSuccess('Error to load image'));
  }
}
