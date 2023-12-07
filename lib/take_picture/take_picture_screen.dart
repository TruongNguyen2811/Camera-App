import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:app_camera/take_picture/custom_paint.dart';
import 'package:app_camera/take_picture/overlay.dart';
import 'package:app_camera/take_picture/view_picture.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import '../model/image_data.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isLoading = false;
  double choose = 1;
  double zoom = 0;
  // int _pointers = 0;
  bool isFlash = true;
  Box<List> box = Hive.box<List>('imageBox');
  List<ImageData> imageDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // String autoCropCenter(String imagePath) {
  //   final File originalImage = File(imagePath);

  //   if (!originalImage.existsSync()) {
  //     // Xử lý khi không tìm thấy ảnh
  //     return imagePath;
  //   }

  //   // Đọc và giải mã ảnh
  //   final img.Image? image = img.decodeImage(originalImage.readAsBytesSync());

  //   if (image == null) {
  //     // Xử lý khi không thể đọc ảnh
  //     return imagePath;
  //   }

  //   // Kích thước ảnh gốc
  //   final int imageWidth = image.width;
  //   final int imageHeight = image.height;

  //   // Kích thước khung cắt (vd: lấy 50% phần trung tâm của ảnh)
  //   final double cropWidthPercent = 0.8;
  //   final double cropHeightPercent = 0.35;

  //   // Tính toán kích thước và vị trí khung cắt
  //   final int cropWidth = (imageWidth * cropWidthPercent).toInt();
  //   final int cropHeight = (imageHeight * cropHeightPercent).toInt();
  //   final int cropX = (imageWidth - cropWidth) ~/ 2;
  //   final int cropY = (imageHeight - cropHeight) ~/ 2;

  //   // Cắt ảnh theo khung đã tính toán
  //   final img.Image croppedImage = img.copyCrop(image,
  //       x: cropX, y: cropY, height: cropHeight, width: cropWidth);

  //   // final String croppedImagePath = path.join(path.dirname(imagePath), 'cropped_image.jpg');
  //   File(imagePath).writeAsBytesSync(img.encodeJpg(croppedImage));

  //   // Lưu ảnh đã cắt
  //   return imagePath;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraAwesomeBuilder.custom(
              flashMode: FlashMode.auto,
              aspectRatio: CameraAspectRatios.ratio_4_3,
              zoom: zoom,
              sensor: Sensors.back,
              saveConfig: SaveConfig.photo(
                pathBuilder: () {
                  return _path(CaptureMode.photo);
                },
              ),
              previewFit: CameraPreviewFit.contain,
              onPreviewScaleBuilder: (state) {
                return OnPreviewScale(
                  onScale: (scale) {
                    // state.sensorConfig.zoom;
                    // if (Platform.isAndroid) {
                    // state.sensorConfig.setZoom(scale / 2);
                    // }
                    // if (Platform.isIOS) {
                    //   state.sensorConfig.setZoom(scale / 3);
                    // }
                    // Xử lý sự kiện zoom với giá trị tỷ lệ zoom là 'scale'
                    // state.sensorConfig.setZoom(0);
                    // print('Zoom scale: $scale');
                  },
                );
              },
              progressIndicator: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
              builder: (CameraState state, previewSize, previewRect) {
                double a = 0;
                return state.when(
                    onPreparingCamera: (state) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey,
                          backgroundColor: Colors.black,
                        )),
                    onPhotoMode: (state) {
                      return StreamBuilder(
                          stream: state.sensorConfig$,
                          // stream: state.sensorConfig.aspectRatio$,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // print('check sensor ${state.sensorConfig.zoom}');
                              return Stack(
                                children: [
                                  IgnorePointer(
                                    ignoring: true,
                                    child: QRScannerOverlay(
                                        overlayColour:
                                            Colors.black.withOpacity(0.5)),
                                  ),
                                  // IgnorePointer(
                                  //   ignoring: true,
                                  //   child: Positioned(
                                  //     child: Align(
                                  //         alignment: Alignment.center,
                                  //         child: ClipRect(
                                  //           child: Container(
                                  //             padding: EdgeInsets.only(
                                  //                 // top: 30.w,
                                  //                 // right: 60.w,
                                  //                 // left: 60.w,
                                  //                 // bottom: 30.w
                                  //                 // horizontal: 50.w
                                  //                 ),
                                  //             child: CustomPaint(
                                  //               painter: MyCustomPainter(
                                  //                   frameSFactor: .1,
                                  //                   padding: 0),
                                  //               child: Container(
                                  //                 width: 300.w,
                                  //                 height: 170.h,
                                  //                 color: Colors.transparent,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         )),
                                  //   ),
                                  // ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          decoration: BoxDecoration(
                                              // color:
                                              //     Color.fromRGBO(47, 44, 44, 0.5),
                                              ),
                                        ),
                                        Positioned(
                                          // alignment: Alignment.topLeft,
                                          right: 16,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.065,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isFlash == true) {
                                                state.sensorConfig.setFlashMode(
                                                    FlashMode.none);
                                                setState(() {
                                                  isFlash = false;
                                                });
                                              } else {
                                                state.sensorConfig.setFlashMode(
                                                    FlashMode.auto);
                                                setState(() {
                                                  isFlash = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.r),
                                              // margin:
                                              //     EdgeInsets.only(left: 0),
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     0.32,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black26,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  isFlash == true
                                                      ? Icons.flash_on_outlined
                                                      : Icons
                                                          .flash_off_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // alignment: Alignment.topLeft,
                                          left: 16,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.065,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.r),
                                              // margin:
                                              //     EdgeInsets.only(left: 0),
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     0.32,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black26,
                                              ),
                                              child: Center(
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Align(
                                  //     alignment: Alignment.bottomCenter,
                                  //     child: Container(
                                  //         width: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //             0.32,
                                  //         height: MediaQuery.of(context)
                                  //                 .size
                                  //                 .height *
                                  //             0.06,
                                  //         margin: EdgeInsets.only(
                                  //             bottom: MediaQuery.of(context)
                                  //                     .size
                                  //                     .height *
                                  //                 0.21),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(30)),
                                  //           color:
                                  //               Color.fromRGBO(47, 44, 44, 0.5),
                                  //         ),
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             GestureDetector(
                                  //               onTap: () {
                                  //                 setState(() {
                                  //                   state.sensorConfig
                                  //                       .setZoom(0);
                                  //                 });
                                  //                 // state.sensorConfig.setZoom(0);
                                  //               },
                                  //               child: Container(
                                  //                 width:
                                  //                     state.sensorConfig.zoom >=
                                  //                                 0 &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.125)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 height:
                                  //                     // ignore: unrelated_type_equality_checks
                                  //                     state.sensorConfig.zoom >=
                                  //                                 0 &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.125)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: Color.fromRGBO(
                                  //                       47, 44, 44, 0.7),
                                  //                 ),
                                  //                 child: Center(
                                  //                     child: Text(
                                  //                   state.sensorConfig.zoom >=
                                  //                               0 &&
                                  //                           state.sensorConfig
                                  //                                   .zoom <
                                  //                               sqrt(0.125)
                                  //                       ? '${(4 * (state.sensorConfig.zoom) * (state.sensorConfig.zoom) + 1).toStringAsFixed(1)}x'
                                  //                       : '1',
                                  //                   style: TextStyle(
                                  //                     fontSize: 14,
                                  //                     color: state.sensorConfig
                                  //                                     .zoom >=
                                  //                                 0 &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.125)
                                  //                         ? Colors.yellow
                                  //                         : Colors.white,
                                  //                   ),
                                  //                 )),
                                  //               ),
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: () {
                                  //                 setState(() {
                                  //                   state.sensorConfig
                                  //                       .setZoom(sqrt(0.125));
                                  //                 });
                                  //               },
                                  //               child: Container(
                                  //                 width:
                                  //                     state.sensorConfig.zoom >=
                                  //                                 sqrt(0.125) &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.5)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 height:
                                  //                     state.sensorConfig.zoom >=
                                  //                                 sqrt(0.125) &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.5)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: Color.fromRGBO(
                                  //                       47, 44, 44, 0.7),
                                  //                 ),
                                  //                 child: Center(
                                  //                     child: Text(
                                  //                   state.sensorConfig.zoom >=
                                  //                               sqrt(0.125) &&
                                  //                           state.sensorConfig
                                  //                                   .zoom <
                                  //                               sqrt(0.5)
                                  //                       ? '${(4 * (state.sensorConfig.zoom) * (state.sensorConfig.zoom) + 1).toStringAsFixed(1)}x'
                                  //                       : '1.5',
                                  //                   style: TextStyle(
                                  //                     fontSize: 14,
                                  //                     color: state.sensorConfig
                                  //                                     .zoom >=
                                  //                                 sqrt(0.125) &&
                                  //                             state.sensorConfig
                                  //                                     .zoom <
                                  //                                 sqrt(0.5)
                                  //                         ? Colors.yellow
                                  //                         : Colors.white,
                                  //                   ),
                                  //                 )),
                                  //               ),
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: () {
                                  //                 setState(() {
                                  //                   state.sensorConfig
                                  //                       .setZoom(sqrt(0.5));
                                  //                 });
                                  //               },
                                  //               child: Container(
                                  //                 width:
                                  //                     state.sensorConfig.zoom >=
                                  //                             sqrt(0.5)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 height:
                                  //                     state.sensorConfig.zoom >=
                                  //                             sqrt(0.5)
                                  //                         ? 40
                                  //                         : 30,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: Color.fromRGBO(
                                  //                       47, 44, 44, 0.7),
                                  //                 ),
                                  //                 child: Center(
                                  //                   child: Text(
                                  //                     state.sensorConfig.zoom >=
                                  //                             sqrt(0.5)
                                  //                         ? '${(4 * (state.sensorConfig.zoom) * (state.sensorConfig.zoom) + 1).toStringAsFixed(1)}x'
                                  //                         : '3',
                                  //                     style: TextStyle(
                                  //                       fontSize: 14,
                                  //                       color:
                                  //                           state.sensorConfig
                                  //                                       .zoom >=
                                  //                                   sqrt(0.5)
                                  //                               ? Colors.yellow
                                  //                               : Colors.white,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ))),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      decoration: const BoxDecoration(
                                          // color: Color.fromRGBO(47, 44, 44, 0.6),
                                          ),
                                      child: Stack(children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () async {
                                              // state.takePhoto();
                                              setState(() {
                                                isLoading = true;
                                              });
                                              // final File imageFile;
                                              try {
                                                state.sensorConfig.setZoom(0);
                                                print(
                                                    'Check ast ${state.sensorConfig}');
                                                String imagePath =
                                                    await state.takePhoto();
                                                imageDataList = box.get(
                                                        'imageListKey',
                                                        defaultValue: [])?.cast<ImageData>() ??
                                                    [];
                                                // imageDataList = box.get('imageListKey', defaultValue: <ImageData>[]) ??
                                                //     [] as List<ImageData>;
                                                DateTime today = DateTime.now();
                                                // Chuyển định dạng để so sánh chỉ theo ngày, không tính giờ phút giây
                                                DateTime todayWithoutTime =
                                                    DateTime(today.year,
                                                        today.month, today.day);
                                                var imagesToKeep = imageDataList
                                                    .where((imageData) {
                                                  DateTime? imageDataDate =
                                                      imageData.createDate;
                                                  return imageDataDate !=
                                                          null &&
                                                      imageDataDate.year ==
                                                          todayWithoutTime
                                                              .year &&
                                                      imageDataDate.month ==
                                                          todayWithoutTime
                                                              .month &&
                                                      imageDataDate.day ==
                                                          todayWithoutTime.day;
                                                }).toList();
                                                box.put('imageListKey',
                                                    imagesToKeep);
                                                // imagePath =
                                                //     autoCropCenter(imagePath);

                                                // controller.croppedImage();
                                                // imageFile = File(await state.takePhoto());
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPicture(
                                                      // image: imageFile,
                                                      imagePath: imagePath,
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                print('check fault $e');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Error: Unable to save photo to gallery')),
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              // height: MediaQuery.of(context).size.height * 0.18,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black26,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.16,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Text(
                                              "PHOTO",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                // setState(() {
                                                state.switchCameraSensor();
                                                state.sensorConfig
                                                    .setAspectRatio(
                                                        CameraAspectRatios
                                                            .ratio_4_3);
                                                if (isFlash == true) {
                                                  state.sensorConfig
                                                      .setFlashMode(
                                                          FlashMode.auto);
                                                }
                                                if (isFlash == false) {
                                                  state.sensorConfig
                                                      .setFlashMode(
                                                          FlashMode.none);
                                                }
                                                // });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.14,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black26,
                                                ),
                                                child: const Icon(
                                                  Icons.autorenew,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(); // Return an empty container or a placeholder widget
                            }
                          });
                    });
              },
            ),
            isLoading == true
                ? AbsorbPointer(
                    absorbing: true, // Ngăn chặn tương tác
                    child: Opacity(
                      opacity: 0.5, // Độ mờ (từ 0.0 đến 1.0)
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ), // Màu nền của layer mờ
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  Future<String> _path(CaptureMode captureMode) async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String fileExtension =
        captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    final String filePath =
        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    return filePath;
  }
}
