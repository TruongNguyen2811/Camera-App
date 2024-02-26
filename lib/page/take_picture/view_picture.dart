// import 'dart:io';
// import 'dart:typed_data';
// import 'package:app_camera/model/image_data.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/adapters.dart';
// // import 'package:native_exif/native_exif.dart';
// // import 'package:native_exif/native_exif.dart';
// import 'package:path/path.dart' as path;
// import 'package:image/image.dart' as img;
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:path_provider/path_provider.dart';

// class ViewPicture extends StatefulWidget {
//   // final File image;
//   String imagePath;
//   ViewPicture({super.key, required this.imagePath});

//   @override
//   State<ViewPicture> createState() => _ViewPictureState();
// }

// class _ViewPictureState extends State<ViewPicture> {
//   final FocusNode focusNode = FocusNode();
//   final TextEditingController controller = TextEditingController();
//   bool isLoading = false;
//   bool isDBR = false;
//   late AssetPathEntity _album;
//   var box = Hive.box<List>('imageBox');
//   List<ImageData> imageDataList = [];
//   ImageData latestImageData = ImageData();

//   // Future<void> compressAndSaveImage(File imageFile) async {
//   //   var compressedImage = await FlutterImageCompress.compressWithFile(
//   //     imageFile.absolute.path,
//   //     quality: 65,
//   //   );
//   //   final file = File(imageFile.path);
//   //   await file.writeAsBytes(compressedImage!.toList());
//   //   final result = await ImageGallerySaver.saveFile(
//   //     file.path,
//   //     name: controller.text,
//   //   );
//   //   if (result['isSuccess']) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Đã lưu ảnh vào thư viện ảnh')),
//   //     );
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Lỗi: Không thể lưu ảnh vào thư viện ảnh')),
//   //     );
//   //   }
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     imageDataList =
//         box.get('imageListKey', defaultValue: [])?.cast<ImageData>() ?? [];
//     if (imageDataList.isNotEmpty) {
//       // Lấy phần tử mới nhất từ danh sách
//       latestImageData = imageDataList.last;
//       // Sử dụng latestImageData theo nhu cầu của bạn
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // File picture = File(widget.image.path);
//     return GestureDetector(
//       onTap: () {
//         focusNode.unfocus();
//       },
//       child: Stack(
//         children: [
//           Scaffold(
//             appBar: AppBar(
//               title: Text('Photo Information'),
//               centerTitle: true,
//               elevation: 0,
//               backgroundColor: Color.fromARGB(255, 40, 40, 40),
//             ),
//             resizeToAvoidBottomInset: false,
//             body: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       24.verticalSpace,
//                       Center(
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: textField(),
//                         ),
//                       ),
//                       16.verticalSpace,
//                       if (latestImageData.name != null) ...[
//                         Text(
//                           "Last run number: ${latestImageData.name}",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                         16.verticalSpace,
//                       ],
//                       Center(
//                           child: Container(
//                               // color: Colors.amber,
//                               child: Image.file(
//                         File(widget.imagePath),
//                         fit: BoxFit.contain,
//                         // width: MediaQuery.of(context).size.width,
//                         // height: MediaQuery.of(context).size.height * 0.62,
//                         scale: 1,
//                       ))),
//                       16.verticalSpace,
//                       GestureDetector(
//                         onTap: () {
//                           if (isDBR == true) {
//                             setState(() {
//                               isDBR = false;
//                             });
//                           } else if (isDBR == false) {
//                             setState(() {
//                               isDBR = true;
//                             });
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "DBR",
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Image.asset(
//                               isDBR == true
//                                   ? 'assets/images/ic_tick_square.png'
//                                   : 'assets/images/ic_untick_square.png',
//                               width: 24.w,
//                               height: 24.w,
//                             )
//                           ],
//                         ),
//                       ),
//                       16.verticalSpace,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             onTap: (() {
//                               Navigator.pop(context);
//                             }),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               height: MediaQuery.of(context).size.height * 0.05,
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                                 color: Colors.red,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Delete',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           InkWell(
//                             onTap: (() async {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               // Future.delayed(Duration(seconds: 3));
//                               var compressedImage =
//                                   await FlutterImageCompress.compressWithFile(
//                                 widget.imagePath,
//                                 format: CompressFormat.jpeg,
//                                 quality: Platform.isIOS ? 10 : 30,
//                               );
//                               final file = File(widget.imagePath);
//                               await file
//                                   .writeAsBytes(compressedImage!.toList());
//                               Directory picturesDir =
//                                   await getApplicationDocumentsDirectory();

//                               // await autoCropCenter(widget.imagePath);
//                               // List<int> bytes = await file.readAsBytes();
//                               if (controller.text == null ||
//                                   controller.text == '') {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content: Text(
//                                           'Error: You need to enter the name of the photo')),
//                                 );
//                                 return;
//                               }
//                               String title = '';
//                               if (isDBR == true) {
//                                 title = '${controller.text}.jpg';
//                               } else if (isDBR == false) {
//                                 title = '${controller.text}.jpg';
//                               }
//                               try {
//                                 // final newFolder = await PhotoManager.editor.('Camera App');
//                                 // await PhotoManager.editor.darwin.createAlbum(
//                                 //   "CameraApp",
//                                 //   // parent: parent, // The value should be null, the root path or other accessible folders.
//                                 // );
//                                 AssetEntity? a =
//                                     await PhotoManager.editor.saveImage(
//                                   compressedImage,
//                                   // quality: 40,
//                                   title: title,
//                                   // relativePath: '${picturesDir.path}/$title',
//                                   // isReturnImagePathOfIOS: true,
//                                 );
//                                 // imageDataList = box.get('imageListKey',
//                                 //         defaultValue: [])?.cast<ImageData>() ??
//                                 //     [];
//                                 // imageDataList.add(
//                                 //   ImageData(
//                                 //     createDate: a?.createDateTime,
//                                 //     assetId: a?.id,
//                                 //     name: title,
//                                 //     isDbr: isDBR,
//                                 //   ),
//                                 // );
//                                 // box.put('imageListKey', imageDataList);
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content: Text('Photo saved to gallery')),
//                                 );
//                                 Navigator.pop(context);
//                               } catch (e) {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 print("check $e");
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content: Text(
//                                           'Error: Unable to save photo to gallery')),
//                                 );
//                               }
//                               // print('check $result');
//                               // if (result != null) {
//                               //   setState(() {
//                               //     isLoading = false;
//                               //   });

//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //         content: Text('Photo saved to gallery')),
//                               //   );
//                               //   Navigator.pop(context);
//                               // } else {
//                               //   setState(() {
//                               //     isLoading = false;
//                               //   });
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //         content: Text(
//                               //             'Error: Unable to save photo to gallery')),
//                               //   );
//                               // }
//                             }),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               height: MediaQuery.of(context).size.height * 0.05,
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                                 color: Colors.green,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Save',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       24.verticalSpace,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           isLoading == true
//               ? AbsorbPointer(
//                   absorbing: true, // Ngăn chặn tương tác
//                   child: Opacity(
//                     opacity: 0.5, // Độ mờ (từ 0.0 đến 1.0)
//                     child: Container(
//                       color: Colors.black,
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.grey,
//                         ),
//                       ), // Màu nền của layer mờ
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   // Future<AssetPathEntity> _getOrCreateAlbum(String albumName) async {
//   //   final albums = await PhotoManager.getAssetPathList();

//   //   for (var album in albums) {
//   //     if (album.name == albumName) {
//   //       return album;
//   //     }
//   //   }

//   //   final options = CreateAssetPathOptions(
//   //     name: albumName,
//   //     type: RequestType.image,
//   //   );
//   //   final result = await PhotoManager.createAssetPath(options);
//   //   return result;
//   // }

// //   Future<void> createAlbum(String albumName) async {
// //   // final result = await PhotoManager.requestPermission();
// //   if (result) {
// //     final albums = await PhotoManager.getAssetPathList();
// //     final existingAlbum = albums.firstWhere((album) => album.name == albumName, orElse: () => null);
// //     if (existingAlbum != null) {
// //       print('Album $albumName already exists');
// //       return;
// //     }
// //     await PhotoManager.editor.darwin.createAlbum(
// //       albumName,
// //       // parent: parent, // The value should be null, the root path or other accessible folders.
// //     );
// //     print('Album $albumName created successfully');
// //   } else {
// //     print('Permission denied');
// //   }
// // }

//   // Future<void> autoCropCenter(String imagePath) async {
//   //   final File originalImage = File(imagePath);

//   //   if (!originalImage.existsSync()) {
//   //     // Xử lý khi không tìm thấy ảnh
//   //     return;
//   //   }

//   //   // Đọc và giải mã ảnh
//   //   final img.Image? image = img.decodeImage(originalImage.readAsBytesSync());

//   //   if (image == null) {
//   //     // Xử lý khi không thể đọc ảnh
//   //     return;
//   //   }

//   //   // Kích thước ảnh gốc
//   //   // final int imageWidth = image.width;
//   //   // final int imageHeight = image.height;

//   //   // // Kích thước khung cắt (vd: lấy 50% phần trung tâm của ảnh)
//   //   // final double cropWidthPercent = 0.8;
//   //   // final double cropHeightPercent = 0.35;

//   //   // // Tính toán kích thước và vị trí khung cắt
//   //   // final int cropWidth = (imageWidth * cropWidthPercent).toInt();
//   //   // final int cropHeight = (imageHeight * cropHeightPercent).toInt();
//   //   // final int cropX = (imageWidth - cropWidth) ~/ 2;
//   //   // final int cropY = (imageHeight - cropHeight) ~/ 2;
//   //   final exif = await Exif.fromPath(imagePath);
//   //   print('check path ${imagePath}');
//   //   try {
//   //     if (isDBR == true) {
//   //       await exif.writeAttributes({
//   //         'UserComment': "DBR",
//   //       });
//   //     }
//   //     // Map<String, Object>? attributes;
//   //     // attributes?['usercomment'] = "this file was edited by flutterapp!";
//   //     // final result = await exif.writeAttributes(attributes);
//   //     // await exif!.writeAttributes({
//   //     //   'GPSLatitude': '${cropX.toString()}',
//   //     //   'GPSLatitudeRef': 'N',
//   //     //   'GPSLongitude': '${cropWidth}',
//   //     //   'GPSLongitudeRef': 'W',
//   //     // });
//   //   } catch (e) {
//   //     print('error $e');
//   //   }

//   //   final attribute = await exif.getAttributes();
//   //   print('check feature1 ${attribute}');

//   //   // Cắt ảnh theo khung đã tính toán
//   //   // final img.Image croppedImage = img.copyCrop(image,
//   //   //     x: cropX, y: cropY, height: cropHeight, width: cropWidth);

//   //   // // final String croppedImagePath = path.join(path.dirname(imagePath), 'cropped_image.jpg');
//   //   // File(imagePath).writeAsBytesSync(img.encodeJpg(croppedImage));

//   //   // Lưu ảnh đã cắt
//   //   return;
//   // }

//   Widget textField() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Enter photo name: ',
//             style: TextStyle(
//               fontSize: 14.sp,
//             )),
//         SizedBox(
//           height: 5,
//         ),
//         TextField(
//           controller: controller,
//           focusNode: focusNode,
//           decoration: InputDecoration(
//             hintText: 'Enter photo name',
//             hintStyle: TextStyle(fontSize: 14.sp),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(width: 1, color: Colors.black26),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(width: 1, color: Colors.black26),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
