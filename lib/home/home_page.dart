import 'package:app_camera/chooseImage/choose_image.dart';
import 'package:app_camera/chooseImage/media_picker.dart';
import 'package:app_camera/list_image/list_image.dart';
import 'package:app_camera/take_picture/take_picture_screen.dart';
import 'package:app_camera/upload_image/upload_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 40, 40, 40),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // color: Colors.black87,
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Welcome to\nOCRCameraApp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 40, 40, 40)),
                ),
                30.verticalSpace,
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(),
                          ),
                        );
                      },
                      child: Container(
                          height: 48.h,
                          width: 200.w,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 3.0)
                            ],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.r),
                            color: Color.fromARGB(255, 75, 75, 75),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "Camera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                          )),
                    ),
                    20.verticalSpace,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadImage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 48.h,
                        width: 200.w,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 3.0)
                          ],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                        child: Center(
                            child: Text(
                          "Upload Image",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                    20.verticalSpace,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListImage(),
                          ),
                        );
                      },
                      child: Container(
                          height: 48.h,
                          width: 200.w,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 3.0)
                            ],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.r),
                            color: Color.fromARGB(255, 75, 75, 75),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "Review Image",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                          )),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
