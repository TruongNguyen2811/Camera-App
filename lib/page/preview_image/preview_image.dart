import 'dart:io';

import 'package:app_camera/page/list_image/list_image.dart';
import 'package:app_camera/page/preview_image/preview_image_cubit.dart';
import 'package:app_camera/page/preview_image/preview_image_state.dart';
import 'package:app_camera/page/receiveImage/receive_image_page.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/widget/button_widget.dart';
import 'package:app_camera/widget/show_loading.dart';
import 'package:app_camera/widget/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class PreviewImgaePage extends StatefulWidget {
  String imagePath;
  PreviewImgaePage({super.key, required this.imagePath});

  @override
  State<PreviewImgaePage> createState() => _PreviewImgaePageState();
}

class _PreviewImgaePageState extends State<PreviewImgaePage> {
  late PreviewImageCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = PreviewImageCubit();
    cubit.getData();
    print('check path ${widget.imagePath}');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocConsumer<PreviewImageCubit, PreviewImageState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is UploadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is UploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiveImagePage(
                receiveImage: cubit.receiveImage,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return buildAllPage(context, state);
      },
    );
  }

  @override
  Widget buildAllPage(BuildContext context, PreviewImageState state) {
    return KeyboardDismissOnTap(
      child: ShowLoadingWidget(
        isLoading: state is PreviewLoading,
        child: Scaffold(
          backgroundColor: R.color.newBackground,
          appBar: AppBar(
            title: const Text("Preview Image"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: R.color.newPrimary,
          ),
          resizeToAvoidBottomInset: false,
          body: buildPage(context),
          bottomNavigationBar: Container(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, bottom: 24.h, top: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r)),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, -1),
                    // Dịch chuyển shadow theo chiều ngang và chiều dọc
                    blurRadius: 5,
                    // Độ mờ của shadow
                    color: Color(
                        0x26000000), // Màu sắc của shadow (sử dụng alpha để đặt độ trong suốt)
                  ),
                ],
              ),
              child: Row(
                children: [
                  ButtonWidget(
                    textColor: R.color.secondary,
                    radius: 32.r,
                    height: 48.h,
                    width: 165.w,
                    backgroundColor: Colors.white,
                    borderColor: R.color.danger1,
                    title: 'Cancel',
                    textStyle: Theme.of(context)
                        .textTheme
                        .text17
                        .copyWith(color: R.color.danger1),
                    isShadow: false,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  9.horizontalSpace,
                  ButtonWidget(
                    radius: 32.r,
                    height: 48.h,
                    width: 165.w,
                    title: 'Upload Image',
                    backgroundColor: R.color.success1,
                    textStyle: Theme.of(context)
                        .textTheme
                        .text17
                        .copyWith(color: R.color.white),
                    onPressed: () async {
                      cubit.uploadImageList(
                          '12312',
                          'https://liked-dominant-raptor.ngrok-free.app',
                          widget.imagePath);
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              24.verticalSpace,
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  child: TextFieldWidget(
                    titleText: 'Enter photo name: ',
                    hintText: "Enter photo name: ",
                    controller: cubit.controller,
                    focusedColorBorder: R.color.newPrimary,
                  ),
                ),
              ),
              16.verticalSpace,
              if (cubit.latestImageData.name != null) ...[
                Text(
                  "Last picture number: ${cubit.latestImageData.name}",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.left,
                ),
                16.verticalSpace,
              ],
              Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      // color: Colors.amber,
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.contain,
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.62,
                        scale: 1,
                      ))),
              16.verticalSpace,
              // GestureDetector(
              //   onTap: () {
              //     if (cubit.isDBR == true) {
              //       setState(() {
              //         cubit.isDBR = false;
              //       });
              //     } else if (cubit.isDBR == false) {
              //       setState(() {
              //         cubit.isDBR = true;
              //       });
              //     }
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "DBR",
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       ),
              //       Image.asset(
              //         cubit.isDBR == true
              //             ? 'assets/images/ic_tick_square.png'
              //             : 'assets/images/ic_untick_square.png',
              //         width: 24.w,
              //         height: 24.w,
              //       )
              //     ],
              //   ),
              // ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
