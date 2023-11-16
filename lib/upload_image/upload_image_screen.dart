import 'dart:io';
import 'package:app_camera/chooseImage/media_picker.dart';
import 'package:app_camera/upload_image/upload_image_cubit.dart';
import 'package:app_camera/upload_image/upload_image_state.dart';
import 'package:app_camera/widget/show_loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final FocusNode focusNode1 = FocusNode();
  final TextEditingController controller1 = TextEditingController();
  final FocusNode focusNode2 = FocusNode();
  final TextEditingController controller2 = TextEditingController();
  late UploadImageCubit cubit;
  // List<AssetEntity> selectedAssetList = [];
  @override
  void initState() {
    // TODO: implement initState
    cubit = UploadImageCubit();
    super.initState();
    controller1.text = "https://014f-42-114-89-6.ngrok-free.app";
  }

  // Future pickAssets({
  //   required int maxCount,
  //   required RequestType requestType,
  // }) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return MediaPicker(maxCount, requestType, cubit.selectedAssetList);
  //       },
  //     ),
  //   ).then((value) {
  //     print(value);
  //     if (value?.isNotEmpty ?? false) {
  //       // setState(() {
  //       print('check 1');
  //       // cubit.selectedAssetList.addAll(value);
  //       cubit.convertAssetsToFiles();
  //       // });
  //     }
  //   });
  //   ;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode1.unfocus();
        focusNode2.unfocus();
      },
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 40, 40, 40),
        appBar: AppBar(
          title: Text("Upload Image"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 40, 40, 40),
        ),
        body: BlocConsumer<UploadImageCubit, UploadImageState>(
          bloc: cubit,
          listener: (context, state) {
            if (state is UpLoadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is UpLoadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            return ShowLoadingWidget(
              isLoading: state is UploadLoading,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textField(),
                    16.verticalSpace,
                    sessionIdField(),
                    16.verticalSpace,
                    if (cubit.files.isNotEmpty) ...[
                      imageWidget(),
                      16.verticalSpace,
                    ],
                    _fieldPickCarServiceWidget(context),
                    16.verticalSpace,
                    button(),
                  ],
                )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        if (controller2.text.isNotEmpty) {
          cubit.uploadImageList(controller2.text, controller1.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You need to fill in Session Id'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: 343.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            'Upload Image',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget imageWidget() {
    return GridView.builder(
        itemCount: cubit.files.length,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.h,
            mainAxisSpacing: 16.w,
            childAspectRatio: 3 / 4),
        itemBuilder: (BuildContext context, int index) {
          // print('chekc ${cubit.selectedAssetList[index].}');
          print('check name ${cubit.files[index].name}');
          print('check path ${(cubit.files[index].path)}');

          return Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  FadeInImage(
                    image: FileImage(File(cubit.files[index].path ?? '')),
                    fit: BoxFit.cover,
                    width: 100.w,
                    height: 100.h,
                    placeholder: AssetImage("assets/images/image_hover.png"),
                  ),
                  4.verticalSpace,
                  Text('${cubit.files[index].name}'),
                ],
              ),
              Visibility(
                child: InkWell(
                  onTap: () {
                    cubit.onDeleteImagePicked(cubit.files[index]);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 20.w,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _fieldPickCarServiceWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        // cubit.selectImages();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChooseImage(),
        //   ),
        // );
        cubit.selectImages();
      },
      child: Container(
        width: 343.w,
        height: 42.h,
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: [4, 2],
          radius: Radius.circular(16.r),
          strokeWidth: 1.75,
          color: Color.fromARGB(255, 40, 40, 40),
          strokeCap: StrokeCap.butt,
          // padding: EdgeInsets.all(6),
          child: Center(
            child: Text(
              'Choose new image +',
              style: TextStyle(
                color: Color.fromARGB(255, 40, 40, 40),
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Domain name: '),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller1,
          focusNode: focusNode1,
          decoration: InputDecoration(
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

  Widget sessionIdField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Session Id',
                style: TextStyle(
                  color: Colors.black,
                )),
            TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                )),
          ]),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller2,
          focusNode: focusNode2,
          decoration: InputDecoration(
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
