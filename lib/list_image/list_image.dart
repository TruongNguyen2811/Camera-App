import 'dart:io';

import 'package:app_camera/list_image/list_image_cubit.dart';
import 'package:app_camera/list_image/list_image_state.dart';
import 'package:app_camera/widget/full_screen_image.dart';
import 'package:app_camera/widget/show_loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListImage extends StatefulWidget {
  const ListImage({super.key});

  @override
  State<ListImage> createState() => _ListImageState();
}

class _ListImageState extends State<ListImage> {
  late ListImageCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = ListImageCubit();
    cubit.getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Image"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 40, 40, 40),
      ),
      body: BlocConsumer<ListImageCubit, ListImageState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is ListImageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
          // if (state is UpLoadSuccess) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.error),
          //       backgroundColor: Colors.green,
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          return ShowLoadingWidget(
            isLoading: state is ListImageLoading,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (cubit.images.isEmpty) ...[
                    _fieldPickCarServiceWidget(context),
                  ],
                  16.verticalSpace,
                  if (cubit.images.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Number of DBR: ${cubit.imagesDBR.length}'),
                        Text('Number of no DBR: ${cubit.imagesNoDBR.length}'),
                      ],
                    ),
                    imageWidget(),
                  ],
                  16.verticalSpace,
                  if (cubit.files.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Number of DBR: ${cubit.listDBR.length}'),
                        Text('Number of no DBR: ${cubit.listNoneDBR.length}'),
                      ],
                    ),
                    fileWidget(),
                  ],
                ],
              )),
            ),
          );
        },
      ),
    );
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
              'Choose image to review',
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

  Widget imageWidget() {
    return ListView.builder(
        itemCount: cubit.images.length,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //     crossAxisSpacing: 16.h,
        //     mainAxisSpacing: 16.w,
        //     childAspectRatio: 3 / 4),
        itemBuilder: (BuildContext context, int index) {
          // print('chekc ${cubit.selectedAssetList[index].}');
          // final exif = Exif.fromPath(cubit.files[index].path ?? '');
          // print('check name ${cubit.images[index].name}');
          print('check path ${(cubit.images[index].path)}');
          // print('check date ${(cubit.files[index].)}');
          // print('${exif.getAttribute("key");}');
          String fileName = cubit.images[index].path.split('/').last;
          String name = fileName.substring(fileName.lastIndexOf('_') + 1);
          bool containsDBR = cubit.images[index].path.contains("DBR");
          print(name);
          return Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullscreenImagePage(
                            imageUrls: cubit.images.map((e) => e.path).toList(),
                            isNetwork: false,
                            initialPosition: index,
                          )),
                );
              },
              child: Container(
                // color: Color.fromARGB(255, 212, 222, 231),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    4.verticalSpace,
                    Container(
                      // width: 30.w,
                      // height: 30.h,
                      // color: Colors.amber,
                      child: Text(
                        '${name}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // if (containsDBR == true) ...[
                    containsDBR == true
                        ? Expanded(
                            child: Text(
                            'DBR',
                            textAlign: TextAlign.center,
                          ))
                        : Expanded(child: Container()),
                    // ],
                    FadeInImage(
                      image: FileImage(File(cubit.images[index].path)),
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 40.h,
                      placeholder: AssetImage("assets/images/image_hover.png"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget fileWidget() {
    return ListView.builder(
        itemCount: cubit.files.length,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //     crossAxisSpacing: 16.h,
        //     mainAxisSpacing: 16.w,
        //     childAspectRatio: 3 / 4),
        itemBuilder: (BuildContext context, int index) {
          // print('chekc ${cubit.selectedAssetList[index].}');
          // final exif = Exif.fromPath(cubit.files[index].path ?? '');
          print('check name ${cubit.files[index].name}');
          print('check path ${(cubit.files[index].path)}');
          // print('check date ${(cubit.files[index].)}');
          // print('${exif.getAttribute("key");}');
          String originalString = cubit.files[index].name;
          String name =
              originalString.substring(originalString.lastIndexOf('_') + 1);
          bool containsDBR = cubit.files[index].name.contains("DBR");
          print(name);
          return Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullscreenImagePage(
                            imageUrls:
                                cubit.files.map((e) => e.path ?? '').toList(),
                            isNetwork: false,
                            initialPosition: index,
                          )),
                );
              },
              child: Container(
                // color: Color.fromARGB(255, 212, 222, 231),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    4.verticalSpace,
                    Container(
                      // width: 30.w,
                      // height: 30.h,
                      // color: Colors.amber,
                      child: Text(
                        '${name}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // if (containsDBR == true) ...[
                    containsDBR == true
                        ? Expanded(
                            child: Text(
                            'DBR',
                            textAlign: TextAlign.center,
                          ))
                        : Expanded(child: Container()),
                    // ],
                    FadeInImage(
                      image: FileImage(File(cubit.files[index].path ?? '')),
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 40.h,
                      placeholder: AssetImage("assets/images/image_hover.png"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
