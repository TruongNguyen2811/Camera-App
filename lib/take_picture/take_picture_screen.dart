import 'dart:io';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraAwesomeBuilder.custom(
              flashMode: FlashMode.auto,
              saveConfig: SaveConfig.photo(
                pathBuilder: () {
                  return _path(CaptureMode.photo);
                },
              ),
              progressIndicator: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
              builder: (CameraState state, previewSize, previewRect) {
                return state.when(
                    onPreparingCamera: (state) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey,
                          backgroundColor: Colors.black,
                        )),
                    onPhotoMode: (state) => Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                // decoration: const BoxDecoration(
                                //   color: Color.fromRGBO(47, 44, 44, 0.5),
                                // ),
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
                                              builder: (context) => ViewPicture(
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: GestureDetector(
                                        onTap: () {
                                          state.switchCameraSensor();
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
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ));
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
