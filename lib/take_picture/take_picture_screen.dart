import 'dart:io';
import 'dart:math';
import 'package:app_camera/take_picture/view_picture.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
  //   // When there are not exactly two fingers on screen don't scale
  //   // if (_controller == null || _pointers != 2) {
  //   //   print('check ${_pointers}');
  //   //   return;
  //   // }
  //   // state.sensorConfig.setZoom(1);
  //   // _currentScale = (_baseScale * details.scale)
  //   //     .clamp(_minAvailableZoom, _maxAvailableZoom);
  //   print('checka ${details.scale}');
  //   // print('check ${_currentScale}');
  //   // await _controller.setZoomLevel(_currentScale);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraAwesomeBuilder.custom(
              flashMode: FlashMode.auto,
              aspectRatio: CameraAspectRatios.ratio_16_9,
              zoom: zoom,
              sensor: Sensors.back,
              saveConfig: SaveConfig.photo(
                pathBuilder: () {
                  return _path(CaptureMode.photo);
                },
              ),
              previewFit: CameraPreviewFit.fitWidth,
              onPreviewScaleBuilder: (state) {
                return OnPreviewScale(
                  onScale: (scale) {
                    state.sensorConfig.zoom;
                    // if (Platform.isAndroid) {
                    // state.sensorConfig.setZoom(scale / 2);
                    // }
                    // if (Platform.isIOS) {
                    //   state.sensorConfig.setZoom(scale / 3);
                    // }
                    // Xử lý sự kiện zoom với giá trị tỷ lệ zoom là 'scale'
                    state.sensorConfig.setZoom(0);
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
                          stream: state.sensorConfig.zoom$,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // print('check sensor ${state.sensorConfig.zoom}');
                              return Stack(
                                children: [
                                  Container(
                                      // width:
                                      //     MediaQuery.of(context).size.width,
                                      // height:
                                      //     MediaQuery.of(context).size.height,
                                      // color: Color.fromRGBO(47, 44, 44, 0.0),
                                      ),
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
                                            color:
                                                Color.fromRGBO(47, 44, 44, 0.5),
                                          ),
                                        ),
                                        Positioned(
                                          // alignment: Alignment.topLeft,
                                          left: 16,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.075,
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
                                                  size: 28,
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
                                              0.2,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(47, 44, 44, 0.6),
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
                                              final File imageFile;
                                              try {
                                                String imagePath =
                                                    await state.takePhoto();
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
                                                            .ratio_16_9);
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
