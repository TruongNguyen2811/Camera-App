import 'dart:io';

import 'package:app_camera/page/check_internet/check_internet_cubit.dart';
import 'package:app_camera/page/list_image/list_image.dart';
import 'package:app_camera/page/preview_image/preview_image_cubit.dart';
import 'package:app_camera/page/preview_image/preview_image_state.dart';
import 'package:app_camera/page/receiveImage/receive_image_page.dart';
import 'package:app_camera/page/receiveImage/widget/suggest.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_gradient.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
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
    print('check internet a ${context.read<InternetCubit>().isConnect}');
    // TODO: implement build
    return BlocConsumer<PreviewImageCubit, PreviewImageState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is UploadFailure) {
          Utils.showToast(context, state.error, type: ToastType.ERROR);
        }
        if (state is UploadInternetFailure) {
          Utils.showToast(context, state.error, type: ToastType.ERROR);
          showDialog(
              context: context,
              builder: (_) {
                return showError();
              });
        }
        if (state is UploadSuccess) {
          Utils.showToast(context, state.error, type: ToastType.SUCCESS);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.error),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiveImagePage(
                receiveImage: cubit.receiveImage,
                imageData: [cubit.imageData],
              ),
            ),
          );
        }
        if (state is SaveSuccess) {
          Utils.showToast(context, state.error, type: ToastType.SUCCESS);
          Navigator.pop(context);
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
            backgroundColor: R.color.dark3,
          ),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                height: 100.w,
                color: R.color.dark3,
              ),
              buildPage(context),
            ],
          ),
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
                  Expanded(
                    child: ButtonWidget(
                      textColor: R.color.secondary,
                      radius: 16.r,
                      height: 44.h,
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
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: ButtonWidget(
                      radius: 16.r,
                      height: 44.h,
                      title: context.watch<InternetCubit>().isConnect == true
                          ? 'Upload Image'
                          : 'Save Image',
                      backgroundColor: R.color.success1,
                      // gradient: LinnearGradientDarkGreen(),
                      textStyle: Theme.of(context)
                          .textTheme
                          .text17
                          .copyWith(color: R.color.white),
                      onPressed: () async {
                        if (context.read<InternetCubit>().isConnect == true) {
                          cubit.uploadImageList(
                              // '',
                              // 'https://liked-dominant-raptor.ngrok-free.app',
                              widget.imagePath);
                        } else {
                          cubit.saveImage(widget.imagePath);
                        }
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget showError() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: 327.w,
        height: 180.h,
        decoration: ShapeDecoration(
          color: R.color.newBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16.verticalSpace,
            Text(
              'Warning!',
              style: Theme.of(context).textTheme.title5.copyWith(),
            ),
            16.verticalSpace,
            Text(
              'There are some errors at the moment. Please save this image or try again',
              style: Theme.of(context).textTheme.body2.copyWith(),
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                      backgroundColor: R.color.white,
                      borderColor: R.color.blueTextLight,
                      height: 40.h,
                      textColor: Colors.white,
                      radius: 8.r,
                      title: 'Try again',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text14W600
                          .copyWith(color: R.color.blueTextLight, height: 0),
                      onPressed: () {
                        // // cubit.sharedPref.removeFilterConfig();
                        // NavigationUtils.popDialog(context);
                        Navigator.pop(context);
                      }),
                ),
                16.horizontalSpace,
                Expanded(
                  child: ButtonWidget(
                      backgroundColor: R.color.dark3,
                      height: 40.h,
                      textColor: Colors.white,
                      radius: 8.r,
                      title: 'Save Image',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text14W600
                          .copyWith(color: Colors.white, height: 0),
                      onPressed: () {
                        // print('Check name brand ${cubit.carBrand?.title}');
                        cubit.saveImage(widget.imagePath);
                        Navigator.pop(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            color: R.color.newBackground),
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
                    titleText: 'Enter runner number: ',
                    hintText: "Ex: 1, 2, 3, ...",
                    controller: cubit.controller,
                    focusedColorBorder: R.color.newPrimary,
                  ),
                ),
              ),
              16.verticalSpace,
              if (cubit.latestImageData.name != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Last picture number: ${cubit.latestImageData.name}",
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.left,
                  ),
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
              if (context.watch<InternetCubit>().isConnect == true) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ButtonWidget(
                      backgroundColor: R.color.dark3,
                      height: 44.h,
                      textColor: Colors.white,
                      radius: 16.r,
                      title: 'Save Image',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text14W600
                          .copyWith(color: Colors.white, height: 0),
                      onPressed: () {
                        // print('Check name brand ${cubit.carBrand?.title}');
                        cubit.saveImage(widget.imagePath);
                        // Navigator.pop(context);
                      }),
                ),
              ],
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
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
