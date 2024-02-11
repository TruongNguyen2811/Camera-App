import 'package:app_camera/page/all_Image/all_image_cubit.dart';
import 'package:app_camera/page/all_Image/all_image_state.dart';
import 'package:app_camera/page/check_internet/check_internet_cubit.dart';
import 'package:app_camera/page/receiveImage/receive_image_page.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:app_camera/widget/button_widget.dart';
import 'package:app_camera/widget/full_screen_image_base64.dart';
import 'package:app_camera/widget/full_screen_image_uint8list.dart';
import 'package:app_camera/widget/image_widget.dart';
import 'package:app_camera/widget/image_widget_uint8.dart';
import 'package:app_camera/widget/show_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllImagePage extends StatefulWidget {
  int? type;
  AllImagePage({super.key, this.type});

  @override
  State<AllImagePage> createState() => _AllImagePageState();
}

class _AllImagePageState extends State<AllImagePage> {
  late AllImageCubit _cubit;
  @override
  void initState() {
    // TODO: implement initState
    _cubit = AllImageCubit();
    getData();
    super.initState();
  }

  getData() async {
    await _cubit.getData(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllImageCubit, AllImageState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is DeleteImage) {
          Utils.showToast(context, state.message, type: ToastType.SUCCESS);
        }
        if (state is UploadImageSuccess) {
          Utils.showToast(context, state.message, type: ToastType.SUCCESS);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiveImagePage(
                receiveImage: _cubit.receiveImage,
                imageData: _cubit.imageDataListChoose,
              ),
            ),
          );
        }
        if (state is AllImageFailure) {
          Utils.showToast(context, state.error, type: ToastType.ERROR);
        }
        // if (state is SubmitSessionSucess) {
        //   Utils.showToast(context, state.success, type: ToastType.SUCCESS);
        // }
      },
      builder: (context, state) {
        return buildPage(context, state);
      },
    );
  }

  Widget buildPage(BuildContext context, AllImageState state) {
    return ShowLoadingWidget(
      isLoading: state is AllImageLoading,
      child: Scaffold(
        backgroundColor: R.color.newBackground,
        appBar: AppBar(
          title: const Text("All Images"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: R.color.dark3,
        ),
        body: Stack(
          children: [
            Container(
              height: 100.w,
              color: R.color.dark3,
            ),
            Container(
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                color: R.color.newBackground,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: !Utils.isEmptyArray(_cubit.imageDataShow)
                    ? Column(
                        children: [
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select the first 10 images:',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(height: 0),
                              ),
                              InkWell(
                                onTap: () {
                                  _cubit.selectAllData();
                                },
                                child: Image.asset(
                                  _cubit.selectAll == true
                                      ? 'assets/images/ic_tick_square.png'
                                      : 'assets/images/ic_untick_square.png',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonWidget(
                                textColor: R.color.secondary,
                                radius: 8.r,
                                height: 32.h,
                                width: 100.w,
                                backgroundColor: R.color.newBackground,
                                borderColor: R.color.danger1,
                                title: 'Delete',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .label14
                                    .copyWith(
                                        color: R.color.danger1, height: 0),
                                isShadow: false,
                                onPressed: () async {
                                  // Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return popupDelete();
                                      });
                                  // _cubit.cleanAllData();
                                },
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          imageWidget(),
                          16.verticalSpace,
                          buildPaging(),
                          36.verticalSpace,
                        ],
                      )
                    : Column(
                        children: [
                          150.verticalSpace,
                          buildEmptyWidget(),
                        ],
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            (widget.type != null && !Utils.isEmptyArray(_cubit.imageDataShow))
                ? Container(
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
                    child: ButtonWidget(
                      radius: 16.r,
                      height: 44.h,
                      width: 165.w,
                      backgroundColor:
                          context.watch<InternetCubit>().isConnect == true
                              ? R.color.success1
                              : R.color.greyText,
                      title: 'Confirm',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text17
                          .copyWith(color: R.color.white),
                      onPressed: () async {
                        if (context.read<InternetCubit>().isConnect == false) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return connectInternet();
                              });
                        }
                        if (context.read<InternetCubit>().isConnect == true) {
                          // print('check internet');
                          _cubit.uploadImageList();
                        }
                      },
                    ))
                : null,
      ),
    );
  }

  Widget buildPaging() {
    return Container(
      height: 30.h,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 0.h,
          left: 10.w,
          right: 10.w,
          bottom: 5.h,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _cubit.page,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _cubit.pagingImage(index);
            },
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.subTitle.copyWith(
                      color: index == _cubit.pageChoose
                          ? R.color.dark3
                          : R.color.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildEmptyWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 24.r),
      width: 343.w,
      decoration: BoxDecoration(
        // color: R.color.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/empty_document.png',
            height: 140.w,
            width: 140.w,
          ),
          8.verticalSpace,
          Text(
            'No photos available',
            style: Theme.of(context).textTheme.h6Bold,
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            "You haven't taken any photos yet",
            style: Theme.of(context).textTheme.body2,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace
        ],
      ),
    );
  }

  Widget popupDelete() {
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
              !Utils.isEmptyArray(_cubit.imageDataShow)
                  ? 'Do you want to delete photos'
                  : 'Do you want to delete all photos',
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
                      title: 'Cancle',
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
                      backgroundColor: R.color.blueTextLight,
                      height: 40.h,
                      textColor: Colors.white,
                      radius: 8.r,
                      title: 'Delete photos',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text14W600
                          .copyWith(color: Colors.white, height: 0),
                      onPressed: () {
                        if (!Utils.isEmptyArray(_cubit.imageDataListChoose)) {
                          _cubit.cleanChoosedData();
                        } else {
                          _cubit.cleanAllData();
                        }
                        // print('Check name brand ${cubit.carBrand?.title}');
                        // _cubit.cleanChoosedData();
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

  Widget connectInternet() {
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
              'Notice!',
              style: Theme.of(context).textTheme.title5.copyWith(),
            ),
            16.verticalSpace,
            Text(
              'You need access to the internet to use this function',
              style: Theme.of(context).textTheme.body2.copyWith(),
            ),
            16.verticalSpace,
            ButtonWidget(
                backgroundColor: R.color.blueTextLight,
                height: 40.h,
                textColor: Colors.white,
                radius: 8.r,
                title: 'Got it!',
                textStyle: Theme.of(context)
                    .textTheme
                    .text14W600
                    .copyWith(color: Colors.white, height: 0),
                onPressed: () {
                  // print('Check name brand ${cubit.carBrand?.title}');
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Container(
      width: double.infinity,
      child: DataTable(
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
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Name',
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
                'Type',
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
                'Choosed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        rows: List<DataRow>.generate(_cubit.imageDataShow.length, (index) {
          // TextEditingController controllerText = TextEditingController();
          // String name = cubit.imageName[index]
          //     .substring(cubit.imageName[index].lastIndexOf('_') + 1);
          // bool containsDBR = cubit.imageName[index].contains("DBR");
          // TextEditingController textControl = TextEditingController();
          // textControl.text = widget.receiveImage?.texts?[index];
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
                  width: 70.w,
                  child: Center(
                    child: Text(
                      // cubit.image[index].titleAsync,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      '${_cubit.imageDataShow[index].name}.jpg',
                      // 'Lọc dầu Vios 2019',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreenImageScreenUint8(
                                imageBytes: [
                                  _cubit.imageDataShow[index].uint8list ??
                                      Uint8List(0)
                                ],
                                initialIndex: 0,
                              )),
                    );
                  },
                  child: Container(
                      width: 80.w,
                      padding: EdgeInsets.all(8.h),
                      child: !Utils.isEmptyArray(_cubit.imageDataShow)
                          ? Uint8ListImageWidget(
                              height: 100,
                              width: 90,
                              imageBytes: _cubit.imageDataShow[index].uint8list,
                              fit: BoxFit.contain,
                            )
                          : Uint8ListImageWidget(
                              height: 100,
                              width: 90,
                              imageBytes: null,
                              fit: BoxFit.contain,
                            )
                      // child: AssetEntityImage(
                      //   cubit.imageModel[index].assetEntity,
                      //   isOriginal: false,
                      //   thumbnailSize: const ThumbnailSize.square(50),
                      //   fit: BoxFit.contain,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return const Center(
                      //       child: Icon(
                      //         Icons.error,
                      //         color: Colors.red,
                      //       ),
                      //     );
                      //   },
                      // ),
                      ),
                ),
              ),
              DataCell(Container(
                width: 90.w,
                child: Text(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  // '${_cubit.imageModel[index].type}',
                  getType(_cubit.imageDataShow[index].type),
                  textAlign: TextAlign.center,
                ),
              )),
              DataCell(Container(
                width: 100.w,
                child: InkWell(
                  onTap: () {
                    if (_cubit.isChoose[index + _cubit.pageChoose * 10] ==
                        true) {
                      _cubit.choose(
                          false,
                          _cubit.imageDataList[index + _cubit.pageChoose * 10]
                                  .id ??
                              0,
                          index + _cubit.pageChoose * 10);
                    } else if (_cubit
                            .isChoose[index + _cubit.pageChoose * 10] ==
                        false) {
                      _cubit.choose(
                          true,
                          _cubit.imageDataList[index + _cubit.pageChoose * 10]
                                  .id ??
                              0,
                          index + _cubit.pageChoose * 10);
                    }
                  },
                  child: Image.asset(
                    _cubit.isChoose[index + _cubit.pageChoose * 10] == true
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
  }
}

String getType(int? type) {
  switch (type) {
    case 1:
      return 'Unconfirm';
    case 2:
      return 'Confirmed';
    default:
      return 'Unconfirm';
  }
}
