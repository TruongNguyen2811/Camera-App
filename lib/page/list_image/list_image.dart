import 'dart:io';

import 'package:app_camera/page/list_image/list_image_cubit.dart';
import 'package:app_camera/page/list_image/list_image_state.dart';
import 'package:app_camera/widget/full_screen_image.dart';
import 'package:app_camera/widget/show_loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

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
    // cubit.getImage();
    getData();
  }

  getData() async {
    await cubit.checkDate();
    await cubit.getImagesFromApp();
  }

  bool _sortNameAsc = true;
  bool _sortAgeAsc = true;
  bool _sortHightAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex = 0;
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
            child: cubit.imageModel.isEmpty
                ? Center(
                    child: Text(
                      'You have no photo today \n Please take a photo and comeback',
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (cubit.imageModel.isEmpty) ...[
                          Center(
                            child: Container(
                              width: 370.w,
                              height: 500.w,
                              child: const Text(
                                  'You have no photo today \n Please take a photo and comeback'),
                            ),
                          ),
                        ],
                        16.verticalSpace,
                        if (cubit.imageModel.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of DBR: ${cubit.countTrue}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Number of no DBR: ${cubit.countFalse}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          imageWidget(),
                        ],
                        16.verticalSpace,
                        if (cubit.files.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text('Number of DBR: ${cubit.listDBR.length}'),
                              // Text('Number of no DBR: ${cubit.listNoneDBR.length}'),
                            ],
                          ),
                          16.verticalSpace,
                          fileWidget(),
                        ],
                      ],
                    )),
                  ),
          );
        },
      ),
      // bottomNavigationBar: cubit.imageModel.isNotEmpty
      //     ? Container(
      //         child: Container(
      //             padding:
      //                 EdgeInsets.only(left: 16.w, right: 16.w, bottom: 28.h),
      //             child: InkWell(
      //               onTap: () {
      //                 // if (controller2.text.isNotEmpty) {
      //                 //   cubit.uploadImageList(controller2.text, controller1.text);
      //                 // } else {
      //                 //   ScaffoldMessenger.of(context).showSnackBar(
      //                 //     SnackBar(
      //                 //       content: Text('You need to fill in Session Id'),
      //                 //       backgroundColor: Colors.red,
      //                 //     ),
      //                 //   );
      //                 // }
      //               },
      //               child: Container(
      //                 width: 343.w,
      //                 height: 42.h,
      //                 decoration: BoxDecoration(
      //                   color: Colors.green,
      //                   borderRadius: BorderRadius.circular(16.r),
      //                 ),
      //                 child: Center(
      //                   child: Text(
      //                     'Upload Image',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 16.sp,
      //                       fontWeight: FontWeight.w600,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             )),
      //       )
      //     : SizedBox(),
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

  // onsortColum(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     if (ascending) {
  //       cubit.imageName.sort((a, b) => a.compareTo(b));
  //     } else {
  //       cubit.imageName.sort((a, b) => b.compareTo(a.name!));
  //     }
  //   }
  // }

  Widget imageWidget() {
    return Container(
      width: double.infinity,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAsc,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFC2C3C0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),

        clipBehavior: Clip.antiAliasWithSaveLayer,
        border: TableBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        dataRowHeight: 80.h,
        columnSpacing: 0,
        horizontalMargin: 12,

        // dataRowColor: MaterialStateColor.resolveWith((states) {
        //   // Mảng màu sắc xen kẽ
        //   final colors = [AppColors.white, AppColors.mainBackground];
        //   // Lấy màu tương ứng dựa trên chỉ số hàng
        //   final colorIndex = 3 % colors.length;
        //   return colors[colorIndex];
        // }
        // ),
        columns: <DataColumn>[
          DataColumn(
              label: Expanded(
                child: Text(
                  'Image Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortNameAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortNameAsc;
                  }
                  cubit.imageModel.sort((a, b) {
                    int aNumber =
                        int.parse(a.name!.replaceAll(RegExp(r'[^\d]+'), ''));
                    int bNumber =
                        int.parse(b.name!.replaceAll(RegExp(r'[^\d]+'), ''));

                    return aNumber.compareTo(bNumber);
                  });
                  // cubit.imageModel.sort((a, b) => a.name!.compareTo(b.name!));
                  if (!_sortAsc) {
                    cubit.imageModel = cubit.imageModel.reversed.toList();
                  }
                });
              }),
          DataColumn(
            label: Expanded(
              child: Text(
                'Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
              label: Expanded(
                child: Text(
                  'Is DBR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    // Nếu cột hiện tại đã được chọn, đảo ngược hướng sắp xếp
                    _sortAsc = !_sortAsc;
                  } else {
                    // Nếu chọn một cột mới, đặt lại các giá trị
                    _sortColumnIndex = columnIndex;
                    _sortAsc = true; // Đặt mặc định là sắp xếp tăng dần
                  }

                  // Sắp xếp danh sách theo trường originName
                  cubit.imageModel.sort((a, b) {
                    if (a.isDbr == b.isDbr) {
                      return 0;
                    } else if (_sortAsc) {
                      // Sắp xếp tăng dần
                      return a.isDbr == null
                          ? 1
                          : b.isDbr == null
                              ? -1
                              : a.isDbr ?? true
                                  ? -1
                                  : 1;
                    } else {
                      // Sắp xếp giảm dần
                      return a.isDbr == null
                          ? 1
                          : b.isDbr == null
                              ? -1
                              : a.isDbr ?? true
                                  ? 1
                                  : -1;
                    }
                  });
                });
              }),
        ],
        rows: List<DataRow>.generate(cubit.imageModel.length, (index) {
          // TextEditingController controllerText = TextEditingController();
          // String name = cubit.imageName[index]
          //     .substring(cubit.imageName[index].lastIndexOf('_') + 1);
          // bool containsDBR = cubit.imageName[index].contains("DBR");
          return DataRow(
            color: MaterialStateColor.resolveWith((states) {
              // Mảng màu sắc xen kẽ
              final colors = [Colors.white, Color(0xFFFAFAFA)];
              // Lấy màu tương ứng dựa trên chỉ số hàng
              final colorIndex = index % colors.length;
              return colors[colorIndex];
            }),
            cells: [
              DataCell(
                Container(
                  width: 100.w,
                  child: Text(
                    // cubit.image[index].titleAsync,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    cubit.imageModel[index].name ?? '',
                    // 'Lọc dầu Vios 2019',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullscreenImagePage(
                                imageUrls: cubit.imageModel
                                    .map((e) => e.assetFile!.path)
                                    .toList(),
                                isNetwork: false,
                                initialPosition: index,
                              )),
                    );
                  },
                  child: Container(
                    width: 140.w,
                    padding: EdgeInsets.all(8.h),
                    child: AssetEntityImage(
                      cubit.imageModel[index].assetEntity,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(50),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              DataCell(Container(
                width: 80.w,
                child: InkWell(
                  onTap: () {
                    if (cubit.imageModel[index].isDbr == true) {
                      cubit.changeDBR(
                          false, cubit.imageModel[index].assetId ?? '');
                    } else if (cubit.imageModel[index].isDbr == false) {
                      cubit.changeDBR(
                          true, cubit.imageModel[index].assetId ?? '');
                    }
                  },
                  child: Image.asset(
                    cubit.imageModel[index].isDbr == true
                        ? 'assets/images/ic_tick_square.png'
                        : 'assets/images/ic_untick_square.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              )),
            ],
          );
        }),
      ),
    );
    // return ListView.builder(
    //     itemCount: cubit.image.length,
    //     padding: EdgeInsets.symmetric(vertical: 12.h),
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     //     crossAxisCount: 3,
    //     //     crossAxisSpacing: 16.h,
    //     //     mainAxisSpacing: 16.w,
    //     //     childAspectRatio: 3 / 4),
    //     itemBuilder: (BuildContext context, int index) {
    //       // print('chekc ${cubit.selectedAssetList[index].}');
    //       // final exif = Exif.fromPath(cubit.files[index].path ?? '');
    //       // print('check name ${cubit.images[index].name}');
    //       // print('check path ${(cubit.image[index].title)}');
    //       // print('check date ${(cubit.files[index].)}');
    //       // print('${exif.getAttribute("key");}');
    //       // String fileName = cubit.image[index].path.split('/').last;
    //       String name = cubit.image[index].title!
    //           .substring(cubit.image[index].title!.lastIndexOf('_') + 1);
    //       bool containsDBR = cubit.image[index].title!.contains("DBR");
    //       // print(name);
    //       return Padding(
    //         padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
    //         child: InkWell(
    //           onTap: () {
    //             // Navigator.push(
    //             //   context,
    //             //   MaterialPageRoute(
    //             //       builder: (context) => FullscreenImagePage(
    //             //             imageUrls: cubit.images.map((e) => e.path).toList(),
    //             //             isNetwork: false,
    //             //             initialPosition: index,
    //             //           )),
    //             // );
    //           },
    //           child: Container(
    //             // color: Color.fromARGB(255, 212, 222, 231),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 4.verticalSpace,
    //                 Container(
    //                   width: 50.w,
    //                   // height: 30.h,
    //                   // color: Colors.amber,
    //                   child: Text(
    //                     '${name}',
    //                     textAlign: TextAlign.left,
    //                   ),
    //                 ),
    //                 // if (containsDBR == true) ...[
    //                 containsDBR == true
    //                     ? Expanded(
    //                         child: Text(
    //                         'DBR',
    //                         textAlign: TextAlign.center,
    //                       ))
    //                     : Expanded(child: Container()),
    //                 AssetEntityImage(
    //                   cubit.image[index],
    //                   isOriginal: false,
    //                   thumbnailSize: const ThumbnailSize.square(50),
    //                   fit: BoxFit.contain,
    //                   errorBuilder: (context, error, stackTrace) {
    //                     return const Center(
    //                       child: Icon(
    //                         Icons.error,
    //                         color: Colors.red,
    //                       ),
    //                     );
    //                   },
    //                 ),
    //                 // ],
    //                 // FadeInImage(
    //                 //   image: FileImage(File(cubit.images[index].path)),
    //                 //   fit: BoxFit.cover,
    //                 //   width: 100.w,
    //                 //   height: 40.h,
    //                 //   placeholder: AssetImage("assets/images/image_hover.png"),
    //                 // ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }

  Widget fileWidget() {
    return Container(
      width: double.infinity,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAsc,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFC2C3C0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),

        clipBehavior: Clip.antiAliasWithSaveLayer,
        border: TableBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        dataRowHeight: 80.h,
        columnSpacing: 0,
        horizontalMargin: 12,

        // dataRowColor: MaterialStateColor.resolveWith((states) {
        //   // Mảng màu sắc xen kẽ
        //   final colors = [AppColors.white, AppColors.mainBackground];
        //   // Lấy màu tương ứng dựa trên chỉ số hàng
        //   final colorIndex = 3 % colors.length;
        //   return colors[colorIndex];
        // }
        // ),
        columns: <DataColumn>[
          DataColumn(
              label: Expanded(
                child: Text(
                  'Image Name',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortNameAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortNameAsc;
                  }
                  cubit.imageModel.sort((a, b) {
                    int aNumber =
                        int.parse(a.name!.replaceAll(RegExp(r'[^\d]+'), ''));
                    int bNumber =
                        int.parse(b.name!.replaceAll(RegExp(r'[^\d]+'), ''));

                    return aNumber.compareTo(bNumber);
                  });
                  // cubit.imageModel.sort((a, b) => a.name!.compareTo(b.name!));
                  if (!_sortAsc) {
                    cubit.imageModel = cubit.imageModel.reversed.toList();
                  }
                });
              }),
          DataColumn(
            label: Expanded(
              child: Text(
                'Image',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
              label: Expanded(
                child: Text(
                  'Is DBR',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  if (columnIndex == _sortColumnIndex) {
                    _sortAsc = _sortNameAsc = sortAscending;
                  } else {
                    _sortColumnIndex = columnIndex;
                    _sortAsc = _sortNameAsc;
                  }
                  cubit.imageModel
                      .sort((a, b) => a.originName!.compareTo(b.originName!));
                  if (!_sortAsc) {
                    cubit.imageModel = cubit.imageModel.reversed.toList();
                  }
                });
              }),
        ],
        rows: List<DataRow>.generate(cubit.imageModel.length, (index) {
          // TextEditingController controllerText = TextEditingController();
          // String name = cubit.imageName[index]
          //     .substring(cubit.imageName[index].lastIndexOf('_') + 1);
          // bool containsDBR = cubit.imageName[index].contains("DBR");
          return DataRow(
            color: MaterialStateColor.resolveWith((states) {
              // Mảng màu sắc xen kẽ
              final colors = [Colors.white, Color(0xFFFAFAFA)];
              // Lấy màu tương ứng dựa trên chỉ số hàng
              final colorIndex = index % colors.length;
              return colors[colorIndex];
            }),
            cells: [
              DataCell(
                Container(
                  width: 100.w,
                  child: Text(
                    // cubit.image[index].titleAsync,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    cubit.imageModel[index].name ?? '',
                    // 'Lọc dầu Vios 2019',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullscreenImagePage(
                                imageUrls: cubit.imageModel
                                    .map((e) => e.file?.path ?? '')
                                    .toList(),
                                isNetwork: false,
                                initialPosition: index,
                              )),
                    );
                  },
                  child: Container(
                    width: 140.w,
                    padding: EdgeInsets.all(8.h),
                    child: FadeInImage(
                      image: FileImage(
                          File(cubit.imageModel[index].file?.path ?? '')),
                      fit: BoxFit.contain,
                      // width: 64.w,
                      // height: 64 * 3 / 3.h,
                      placeholder: AssetImage("assets/images/image_hover.png"),
                    ),
                  ),
                ),
              ),
              DataCell(Container(
                width: 80.w,
                child: InkWell(
                  onTap: () {
                    // cubit.renameImage(
                    //     cubit.image[index].id, 'CameraApp_DBR_1.jpg');
                  },
                  child: Image.asset(
                    cubit.imageModel[index].isDbr == true
                        ? 'assets/images/ic_tick_square.png'
                        : 'assets/images/ic_untick_square.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              )),
            ],
          );
        }),
      ),
    );
    // return ListView.builder(
    //     itemCount: cubit.files.length,
    //     padding: EdgeInsets.symmetric(vertical: 12.h),
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     //     crossAxisCount: 3,
    //     //     crossAxisSpacing: 16.h,
    //     //     mainAxisSpacing: 16.w,
    //     //     childAspectRatio: 3 / 4),
    //     itemBuilder: (BuildContext context, int index) {
    //       // print('chekc ${cubit.selectedAssetList[index].}');
    //       // final exif = Exif.fromPath(cubit.files[index].path ?? '');
    //       print('check name ${cubit.files[index].name}');
    //       print('check path ${(cubit.files[index].path)}');
    //       // print('check date ${(cubit.files[index].)}');
    //       // print('${exif.getAttribute("key");}');
    //       String originalString = cubit.files[index].name;
    //       String name =
    //           originalString.substring(originalString.lastIndexOf('_') + 1);
    //       bool containsDBR = cubit.files[index].name.contains("DBR");
    //       print(name);
    //       return Padding(
    //         padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
    //         child: InkWell(
    //           onTap: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => FullscreenImagePage(
    //                         imageUrls:
    //                             cubit.files.map((e) => e.path ?? '').toList(),
    //                         isNetwork: false,
    //                         initialPosition: index,
    //                       )),
    //             );
    //           },
    //           child: Container(
    //             // color: Color.fromARGB(255, 212, 222, 231),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 4.verticalSpace,
    //                 Container(
    //                   // width: 30.w,
    //                   // height: 30.h,
    //                   // color: Colors.amber,
    //                   child: Text(
    //                     '${name}',
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //                 // if (containsDBR == true) ...[
    //                 containsDBR == true
    //                     ? Expanded(
    //                         child: Text(
    //                         'DBR',
    //                         textAlign: TextAlign.center,
    //                       ))
    //                     : Expanded(child: Container()),
    //                 // ],
    //                 FadeInImage(
    //                   image: FileImage(File(cubit.files[index].path ?? '')),
    //                   fit: BoxFit.cover,
    //                   width: 100.w,
    //                   height: 40.h,
    //                   placeholder: AssetImage("assets/images/image_hover.png"),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}
