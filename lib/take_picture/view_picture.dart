import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';

class ViewPicture extends StatefulWidget {
  // final File image;
  String imagePath;
  ViewPicture({super.key, required this.imagePath});

  @override
  State<ViewPicture> createState() => _ViewPictureState();
}

class _ViewPictureState extends State<ViewPicture> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  late AssetPathEntity _album;

  // Future<void> compressAndSaveImage(File imageFile) async {
  //   var compressedImage = await FlutterImageCompress.compressWithFile(
  //     imageFile.absolute.path,
  //     quality: 65,
  //   );
  //   final file = File(imageFile.path);
  //   await file.writeAsBytes(compressedImage!.toList());
  //   final result = await ImageGallerySaver.saveFile(
  //     file.path,
  //     name: controller.text,
  //   );
  //   if (result['isSuccess']) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đã lưu ảnh vào thư viện ảnh')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Lỗi: Không thể lưu ảnh vào thư viện ảnh')),
  //     );
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // File picture = File(widget.image.path);
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Photo Information'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 40, 40, 40),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      24.verticalSpace,
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: textField(),
                        ),
                      ),
                      16.verticalSpace,
                      Center(
                          child: Container(
                              // color: Colors.amber,
                              child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.62,
                        scale: 1,
                      ))),
                      16.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (() {
                              Navigator.pop(context);
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: (() async {
                              setState(() {
                                isLoading = true;
                              });
                              // Future.delayed(Duration(seconds: 3));
                              var compressedImage =
                                  await FlutterImageCompress.compressWithFile(
                                widget.imagePath,
                                format: CompressFormat.jpeg,
                                quality: Platform.isIOS ? 10 : 30,
                              );
                              final file = File(widget.imagePath);
                              await file
                                  .writeAsBytes(compressedImage!.toList());
                              // List<int> bytes = await file.readAsBytes();
                              try {
                                await PhotoManager.editor.saveImage(
                                  compressedImage,
                                  // quality: 40,
                                  title: '${controller.text}.jpg',
                                  // isReturnImagePathOfIOS: true,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Photo saved to gallery')),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                print("check $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error: Unable to save photo to gallery')),
                                );
                              }
                              // print('check $result');
                              // if (result != null) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });

                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text('Photo saved to gallery')),
                              //   );
                              //   Navigator.pop(context);
                              // } else {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content: Text(
                              //             'Error: Unable to save photo to gallery')),
                              //   );
                              // }
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }

  Widget textField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter photo name: '),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Enter photo name',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: Colors.black26),
            ),
          ),
        )
      ],
    );
  }
}
