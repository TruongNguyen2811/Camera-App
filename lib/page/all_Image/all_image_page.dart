import 'package:app_camera/page/all_Image/all_image_cubit.dart';
import 'package:app_camera/page/all_Image/all_image_state.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:app_camera/widget/button_widget.dart';
import 'package:app_camera/widget/full_screen_image_base64.dart';
import 'package:app_camera/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllImagePage extends StatefulWidget {
  const AllImagePage({super.key});

  @override
  State<AllImagePage> createState() => _AllImagePageState();
}

class _AllImagePageState extends State<AllImagePage> {
  late AllImageCubit _cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = AllImageCubit();
    _cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllImageCubit, AllImageState>(
      bloc: _cubit,
      listener: (context, state) {
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
    return Scaffold(
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              color: R.color.newBackground,
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        textColor: R.color.secondary,
                        radius: 32.r,
                        height: 32.h,
                        width: 100.w,
                        backgroundColor: R.color.newBackground,
                        borderColor: R.color.danger1,
                        title: 'Delete all',
                        textStyle: Theme.of(context)
                            .textTheme
                            .text17
                            .copyWith(color: R.color.danger1),
                        isShadow: false,
                        onPressed: () async {
                          // Navigator.pop(context);
                          _cubit.cleanAllData();
                        },
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  imageWidget()
                ],
              ),
            ),
          ),
        ],
      ),
      //     bottomNavigationBar: Container(
      //         padding:
      //             EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h, top: 12.h),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(16.r),
      //               topRight: Radius.circular(16.r)),
      //           boxShadow: const [
      //             BoxShadow(
      //               offset: Offset(0, -1),
      //               // Dịch chuyển shadow theo chiều ngang và chiều dọc
      //               blurRadius: 5,
      //               // Độ mờ của shadow
      //               color: Color(
      //                   0x26000000), // Màu sắc của shadow (sử dụng alpha để đặt độ trong suốt)
      //             ),
      //           ],
      //         ),
      //         child: ButtonWidget(
      //           radius: 32.r,
      //           height: 48.h,
      //           width: 165.w,
      //           backgroundColor: R.color.success1,
      //           title: 'Confirm',
      //           textStyle: Theme.of(context)
      //               .textTheme
      //               .text17
      //               .copyWith(color: R.color.white),
      //           onPressed: () async {},
      //         )),
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
        rows: List<DataRow>.generate(_cubit.imageModel.length, (index) {
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
                  width: 100.w,
                  child: Text(
                    // cubit.image[index].titleAsync,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    '${_cubit.imageModel[index].name}.jpg',
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
                          builder: (context) => FullScreenImageScreen(
                                base64Strings: [
                                  _cubit.imageModel[index].byte64 ?? ''
                                ],
                                initialIndex: 0,
                              )),
                    );
                  },
                  child: Container(
                      width: 50.w,
                      padding: EdgeInsets.all(8.h),
                      child: !Utils.isEmptyArray(_cubit.imageModel)
                          ? Base64ImageWidget(
                              height: 100,
                              width: 90,
                              base64String:
                                  _cubit.imageModel[index].byte64 ?? '',
                              fit: BoxFit.contain,
                            )
                          : Base64ImageWidget(
                              height: 100,
                              width: 90,
                              base64String: '',
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
                width: 80.w,
                child: Text(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  '${_cubit.imageModel[index].type}',
                  textAlign: TextAlign.center,
                ),
              )),
              DataCell(Container(
                width: 40.w,
                child: InkWell(
                  onTap: () {
                    if (_cubit.imageModel[index].isDbr == true) {
                      _cubit.choose(false, _cubit.imageModel[index].id ?? 0);
                    } else if (_cubit.imageModel[index].isDbr == false) {
                      _cubit.choose(true, _cubit.imageModel[index].id ?? 0);
                    }
                  },
                  child: Image.asset(
                    _cubit.imageModel[index].isDbr == true
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
