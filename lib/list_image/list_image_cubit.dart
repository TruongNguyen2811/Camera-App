import 'dart:io';
import 'dart:typed_data';
import 'package:app_camera/list_image/list_image_state.dart';
import 'package:app_camera/model/image_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';
import 'package:photo_manager/photo_manager.dart';

class ListImageCubit extends Cubit<ListImageState> {
  ListImageCubit() : super(ListImageInitial());

  List<PlatformFile> files = [];
  List<PlatformFile> listDBR = [];
  List<PlatformFile> listNoneDBR = [];
  List<AssetEntity> image = [];
  List<AssetEntity> imageDBR = [];
  List<AssetEntity> imageNoDBR = [];
  List<String> imageName = [];
  List<ImageModel> imageModel = [];
  // List<AssetEntity> selectedAssetList = [];
  // List<String> originalImagePaths = [];

  Future<void> getImagesFromApp() async {
    emit(ListImageLoading());
    print('aaaa');
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
      print('check title ${assetList.first.title}');
      String originalSubTitle = await assetList.first.titleAsyncWithSubtype;
      String originalFile = await assetList.first.titleAsync;
      print('Check originsub $originalSubTitle');
      print('Check origin $originalFile');
      print('check ${assetList.length}');
      for (var i in assetList) {
        String originname = await i.titleAsync;
        DateTime today = DateTime.now();
        if (originname.contains('CameraApp') &&
            today.year == i.createDateTime.year &&
            today.month == i.createDateTime.month &&
            today.day == i.createDateTime.day) {
          image.add(i);
        }
      }
      if (image.isNotEmpty) {
        for (var i in image) {
          String nameOrigin = await i.titleAsync;
          File file = await i.file ?? File('a');
          imageName.add(nameOrigin);
          String name = nameOrigin.substring(nameOrigin.lastIndexOf('_') + 1);
          bool containsDBR = nameOrigin.contains("DBR");
          imageModel.add(ImageModel(
              name: name,
              assetId: i.id,
              createDate: i.createDateTime,
              isDbr: containsDBR,
              originName: nameOrigin,
              assetFile: file,
              assetEntity: i));
          // print('check ${i.title}');
          if (nameOrigin.contains('DBR')) {
            imageDBR.add(i);
          } else {
            imageNoDBR.add(i);
          }
        }
      }
      emit(ListImageInitial());
    } catch (e) {
      print('Check error $e');
      emit(ListImageFailure('Can not load image'));
    }
  }

  Future<void> renameImage(String assetId, String newName) async {
    AssetEntity? asset = await AssetEntity.fromId(assetId);

    if (asset != null) {
      // Lấy đường dẫn của asset

      // Tạo một bản sao của asset với tên mới
      Uint8List? newAsset = await asset.originBytes;
      // await asset.titleAsync = 'aaa';
      // if (newAsset != null) {
      //   PhotoManager.editor.saveImage(
      //     newAsset,
      //     // quality: 40,
      //     title: newName,
      //     // relativePath: '${picturesDir.path}/$title',
      //     // isReturnImagePathOfIOS: true,
      //   );
      // }
      // Xóa asset cũ

      getImagesFromApp();
    } else {}
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
          imageName.add(nameOrigin);
          String name = nameOrigin.substring(nameOrigin.lastIndexOf('_') + 1);
          bool containsDBR = nameOrigin.contains("DBR");
          imageModel.add(ImageModel(
            file: file,
            originName: nameOrigin,
            name: name,
            isDbr: containsDBR,
          ));
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
