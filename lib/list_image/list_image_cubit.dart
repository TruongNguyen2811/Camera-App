import 'dart:io';
import 'dart:typed_data';
import 'package:app_camera/list_image/list_image_state.dart';
import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/model/image_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';

class ListImageCubit extends Cubit<ListImageState> {
  ListImageCubit() : super(ListImageInitial());

  List<PlatformFile> files = [];
  List<AssetEntity> image = [];
  // List<String> imageName = [];
  List<ImageModel> imageModel = [];
  List<ImageModel> imageDateNow = [];
  // var box = Hive.box<ImageData>('imageBox');
  Box<List> box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];
  int countFalse = 0;
  int countTrue = 0;
  // List<AssetEntity> selectedAssetList = [];
  // List<String> originalImagePaths = [];

  Future<void> checkDate() async {
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    // imageDataList = box.get('imageListKey', defaultValue: <ImageData>[]) ??
    //     [] as List<ImageData>;
    DateTime today = DateTime.now();
    // Chuyển định dạng để so sánh chỉ theo ngày, không tính giờ phút giây
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    var imagesToKeep = imageDataList.where((imageData) {
      DateTime? imageDataDate = imageData.createDate;
      return imageDataDate != null &&
          imageDataDate.year == todayWithoutTime.year &&
          imageDataDate.month == todayWithoutTime.month &&
          imageDataDate.day == todayWithoutTime.day;
    }).toList();
    box.put('imageListKey', imagesToKeep);
  }

  Future<void> getImagesFromApp() async {
    emit(ListImageLoading());
    imageDataList =
        box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
    try {
      final optionGroup = FilterOptionGroup(
        imageOption: const FilterOption(
          durationConstraint: DurationConstraint(max: Duration.zero),
          // sizeConstraint: SizeConstraint( 0),
          needTitle: true,
        ),
      );

      final pathList = await PhotoManager.getAssetPathList(
          onlyAll: false, filterOption: optionGroup);
      print('check list Album ${pathList.length}');
      if (pathList.isEmpty) {
        print('Empty Album?');
      }

      final galleryPath = pathList[0];

      final assetList = await galleryPath.getAssetListPaged(page: 0, size: 400);
      if (assetList.isEmpty) {
        emit(ListImageFailure("Your gallery have no photo"));
        return;
      } else {
        print('Check abc ${assetList.length}');
        for (var i in assetList) {
          String originname = await i.titleAsync;
          DateTime today = DateTime.now();
          if (today.year == i.createDateTime.year &&
              today.month == i.createDateTime.month &&
              today.day == i.createDateTime.day) {
            image.add(i);
          }
        }
        if (image.isNotEmpty) {
          for (var i in image) {
            String nameOrigin = await i.titleAsync;
            File file = await i.file ?? File('a');
            // imageName.add(nameOrigin);
            // String name = nameOrigin.substring(nameOrigin.lastIndexOf('_') + 1);
            imageDateNow.add(ImageModel(
                name: nameOrigin,
                assetId: i.id,
                createDate: i.createDateTime,
                originName: nameOrigin,
                assetFile: file,
                assetEntity: i));
          }
        }

        List<String?> imageDataIds =
            imageDataList.map((imageData) => imageData.assetId).toList();
// Tìm các assetId không tìm thấy trong assetList
        List<String?> notFoundAssetIds = imageDataIds
            .where((assetId) =>
                assetList.every((imageObject) => imageObject.id != assetId))
            .toList();

// Xóa các imageData có assetId không tìm thấy
        imageDataList.removeWhere(
            (imageData) => notFoundAssetIds.contains(imageData.assetId));

        imageModel = imageDataList
            .where((imageData) => imageDataIds.contains(imageData.assetId))
            .map((imageData) {
          var matchingImageObject = imageDateNow.firstWhere(
              (imageObject) => imageObject.assetId == imageData.assetId,
              orElse: () => ImageModel());

          return ImageModel(
            name: imageData.name,
            assetId: imageData.assetId ?? '', // Handle null case
            createDate: imageData.createDate,
            isDbr: imageData.isDbr,
            originName: matchingImageObject.originName,
            assetFile: matchingImageObject.assetFile,
            assetEntity: matchingImageObject.assetEntity,
          );
        }).toList();
        print('check length ${imageModel.length}');
        countTrue =
            imageDataList.where((imageData) => imageData.isDbr == true).length;
        countFalse =
            imageDataList.where((imageData) => imageData.isDbr == false).length;
      }
      // print('check title ${assetList.first.title}');
      // String originalSubTitle = await assetList.first.titleAsyncWithSubtype;
      // String originalFile = await assetList.first.titleAsync;
      // print('Check originsub $originalSubTitle');
      // print('Check origin $originalFile');
      // print('check ${assetList.length}');
      emit(ListImageInitial());
    } catch (e) {
      print('Check error $e');
      emit(ListImageFailure('Can not load image'));
    }
  }

  void changeDBR(bool newDBR, String assetId) {
    emit(ListImageInitial());
    for (var i in imageDataList) {
      if (i.assetId == assetId) {
        // Nếu assetId trùng khớp với mục tiêu, cập nhật trường isDBR
        i.isDbr = newDBR;
        // Sử dụng box.put để lưu lại thay đổi
      }
      for (var x in imageModel) {
        if (x.assetId == assetId) {
          x.isDbr = newDBR;
        }
      }
      countTrue =
          imageDataList.where((imageData) => imageData.isDbr == true).length;
      countFalse =
          imageDataList.where((imageData) => imageData.isDbr == false).length;
    }
    emit(ListImageSuccess(''));
  }

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
          String nameOrigin = file.name;
          // imageName.add(nameOrigin);
          String name = nameOrigin.substring(nameOrigin.lastIndexOf('_') + 1);
          bool containsDBR = nameOrigin.contains("DBR");
          imageModel.add(ImageModel(
            file: file,
            originName: nameOrigin,
            name: name,
            isDbr: containsDBR,
          ));
          if (file.name.contains('DBR')) {
            // listDBR.add(file);
          } else {
            // listNoneDBR.add(file);
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
      final directory = await getApplicationDocumentsDirectory();
      String trimmedPath =
          directory.path.substring(0, directory.path.lastIndexOf("/0"));
      // Lọc danh sách các tệp thoả mãn điều kiện
      print('check trimmed ${trimmedPath}');
      // final imagesDirectoryPath = '${trimmedPath}/0/Pictures';
      // Directory imagesDirectory = Directory(imagesDirectoryPath);
      // Directory appDir = await getApplicationDocumentsDirectory();
      // String galleryPathIos = directory.parent.parent.path;
      print('check IOS${directory.path}');

      if (directory != null) {
        String galleryPath = directory.path;

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
      // print('Check ${imagesDirectory}');
      print('Check length ${images.length}');
      // In ra đường dẫn của các ảnh đã lọc được
    } catch (e) {
      print('Error: $e');
    }
    emit(ListImageSuccess('Error to load image'));
  }
}
