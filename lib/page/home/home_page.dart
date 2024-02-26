import 'package:app_camera/page/all_Image/all_image_page.dart';
import 'package:app_camera/page/chooseImage/choose_image.dart';
import 'package:app_camera/page/chooseImage/media_picker.dart';
import 'package:app_camera/page/home/home_cubit.dart';
import 'package:app_camera/page/home/home_state.dart';
import 'package:app_camera/page/list_image/list_image.dart';
import 'package:app_camera/model/image_data.dart';
import 'package:app_camera/page/scanQr/scan_qr_code_page.dart';
import 'package:app_camera/page/take_picture/take_picture_screen.dart';
import 'package:app_camera/page/upload_image/upload_image_screen.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_gradient.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Khởi tạo Animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 3.0,
    ).animate(_controller);

    // Khởi động animation khi widget được xây dựng
    _controller.forward();
    cubit = HomeCubit();
    cubit.voidGetSessionId();
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is HomeGetSessionIdSucess) {
          Utils.showToast(context, state.error, type: ToastType.SUCCESS);
        }
      },
      builder: (context, state) {
        return buildPage(context, state);
      },
    );
  }

  Widget buildPage(BuildContext context, HomeState state) {
    return Scaffold(
      backgroundColor: R.color.newBackground,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 375.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  100.verticalSpace,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text("Welcome to DEFENDER OCR!",
                        style: Theme.of(context).textTheme.text20W700),
                    transform: Matrix4.translationValues(
                      0.0, // Điều chỉnh giá trị để căn giữa
                      (_animation.value * 100.w - 300.w),
                      0.0,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                      height: 200.w,
                      width: 200.w,
                      child: SfCircularChart(
                          legend: Legend(
                              isVisible: true, position: LegendPosition.bottom),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                widget: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    child: PhysicalModel(
                                        child: Container(),
                                        shape: BoxShape.circle,
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        color: const Color.fromRGBO(
                                            230, 230, 230, 1)))),
                            CircularChartAnnotation(
                                widget: Container(
                                    child: Text(
                                        cubit.imageDataList.isNotEmpty
                                            ? '${cubit.countUnConfirm / cubit.imageDataList.length * 100}%'
                                            : '0%',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            fontSize: 25))))
                          ],
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                                dataSource: cubit.chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                animationDuration: 20,

                                // Radius of doughnut
                                radius: '100%')
                          ])),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRViewExample(),
                            ),
                          ).then((value) => cubit.voidGetSessionId());
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 160.w,
                          height: 72.h,
                          curve: Curves.linear,
                          decoration: BoxDecoration(
                            // color: R.color.blueTextLight,
                            color: R.color.white,
                            border: Border.all(
                                width: 1.w, color: R.color.blueTextLight),
                            // gradient: LinnearGradientDarkBlue(),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, -1),
                                blurRadius: 5,
                                color: Color(0x26000000),
                              ),
                            ],
                          ),
                          transform: Matrix4.translationValues(
                            (_animation.value * 100.w -
                                300.w), // Điều chỉnh giá trị để căn giữa
                            0.0,
                            0.0,
                          ),
                          transformAlignment: Alignment.center,
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cubit.sessionId == null
                                            ? 'Start New Session'
                                            : "Update Session",
                                        style:
                                            Theme.of(context).textTheme.bold14,
                                      ),
                                      Text(
                                        cubit.sessionId == null
                                            ? 'You have no session'
                                            : "You are in session Id: ${cubit.sessionId}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.text10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned(
                              //     right: 16.w,
                              //     bottom: 0.w,
                              //     child: Image.asset(
                              //         height: 40.w,
                              //         width: 40.w,
                              //         "assets/icon/icon_right.png",
                              //         // color: R.color.grey400,
                              //         color: R.color.blueTextLight))
                            ],
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraPage(),
                            ),
                          ).then((value) => cubit.getData());
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 160.w,
                          height: 72.h,
                          curve: Curves.linear,
                          decoration: BoxDecoration(
                            // color: R.color.blueTextLight,
                            color: R.color.white,
                            border: Border.all(
                                width: 1.w, color: R.color.blueTextLight),
                            // gradient: LinnearGradientDarkBlue(),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, -1),
                                blurRadius: 5,
                                color: Color(0x26000000),
                              ),
                            ],
                          ),
                          transform: Matrix4.translationValues(
                            -(_animation.value * 100.w -
                                300.w), // Điều chỉnh giá trị để căn giữa
                            0.0,
                            0.0,
                          ),
                          transformAlignment: Alignment.center,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Take Photo ',
                                      style: Theme.of(context).textTheme.bold14,
                                    ),
                                    Text(
                                      'Take photo now',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.text10,
                                    ),
                                  ],
                                ),
                              ),
                              // Positioned(
                              //     right: 16.w,
                              //     bottom: 0.w,
                              //     child: Image.asset(
                              //         height: 40.w,
                              //         width: 40.w,
                              //         "assets/icon/icon_right.png",
                              //         // color: R.color.grey400,
                              //         color: R.color.blueTextLight))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllImagePage(
                            type: 1,
                          ),
                        ),
                      ).then((value) => cubit.getData());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 160.w,
                      height: 72.h,
                      curve: Curves.linear,
                      decoration: BoxDecoration(
                        // color: R.color.blueTextLight,
                        color: R.color.white,
                        border: Border.all(
                            width: 1.w, color: R.color.blueTextLight),
                        // gradient: LinnearGradientDarkBlue(),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, -1),
                            blurRadius: 5,
                            color: Color(0x26000000),
                          ),
                        ],
                      ),
                      transform: Matrix4.translationValues(
                        (_animation.value * 100.w -
                            300.w), // Điều chỉnh giá trị để căn giữa
                        0.0,
                        0.0,
                      ),
                      transformAlignment: Alignment.center,
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Confirm Image',
                                  style: Theme.of(context).textTheme.body1Bold,
                                ),
                                Text(
                                  'You have ${cubit.countUnConfirm} unconfirmed photos',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.text12,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              right: 16.w,
                              bottom: 0.w,
                              child: Image.asset(
                                  height: 40.w,
                                  width: 40.w,
                                  "assets/icon/icon_right.png",
                                  // color: R.color.grey400,
                                  color: R.color.blueTextLight))
                        ],
                      ),
                    ),
                  ),
                  // 16.verticalSpace,
                  // AnimatedContainer(
                  //   duration: const Duration(milliseconds: 500),
                  //   width: 300.w,
                  //   height: 100.h,
                  //   curve: Curves.linear,
                  //   decoration: BoxDecoration(
                  //     // color: R.color.blueTextLight,
                  //     color: R.color.white,
                  //     border:
                  //         Border.all(width: 1.w, color: R.color.blueTextLight),
                  //     // gradient: LinnearGradientDarkBlue(),
                  //     borderRadius: BorderRadius.circular(20.r),
                  //     boxShadow: const [
                  //       BoxShadow(
                  //         offset: Offset(0, -1),
                  //         blurRadius: 5,
                  //         color: Color(0x26000000),
                  //       ),
                  //     ],
                  //   ),
                  //   transform: Matrix4.translationValues(
                  //     -(_animation.value * 100.w -
                  //         300.w), // Điều chỉnh giá trị để căn giữa
                  //     0.0,
                  //     0.0,
                  //   ),
                  //   transformAlignment: Alignment.center,
                  //   child: Stack(
                  //     children: [
                  //       Center(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               'View Image',
                  //               style: Theme.of(context).textTheme.text20W700,
                  //             ),
                  //             Text(
                  //               "You haven't run ${cubit.countUnRunNumber} images yet",
                  //               textAlign: TextAlign.center,
                  //               style: Theme.of(context).textTheme.text12,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Positioned(
                  //           right: 16.w,
                  //           bottom: 0.w,
                  //           child: Image.asset(
                  //               height: 40.w,
                  //               width: 40.w,
                  //               "assets/icon/icon_right.png",
                  //               // color: R.color.grey400,
                  //               color: R.color.blueTextLight)),
                  //     ],
                  //   ),
                  // ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      cubit.clearSessionId();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 300.w,
                      height: 100.h,
                      curve: Curves.linear,
                      decoration: BoxDecoration(
                        // color: R.color.blueTextLight,
                        color: R.color.white,
                        border: Border.all(width: 1.w, color: R.color.danger1),
                        // gradient: LinnearGradientDarkBlue(),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, -1),
                            blurRadius: 5,
                            color: Color(0x26000000),
                          ),
                        ],
                      ),
                      transform: Matrix4.translationValues(
                        (_animation.value * 100.w -
                            300.w), // Điều chỉnh giá trị để căn giữa
                        0.0,
                        0.0,
                      ),
                      transformAlignment: Alignment.center,
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Clear Session ID',
                                  style: Theme.of(context).textTheme.body1Bold,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              right: 16.w,
                              bottom: 0.w,
                              child: Image.asset(
                                  height: 40.w,
                                  width: 40.w,
                                  "assets/icon/icon_right.png",
                                  // color: R.color.grey400,
                                  color: R.color.danger1))
                        ],
                      ),
                    ),
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget buildAnimatedContainer(int index) {
  //   double beginValue = index.isEven ? -200.0 : 0.0; // Đổi giá trị ban đầu
  //   double endValue = 0.0;

  //   // Tính toán giá trị margin dựa trên animation
  //   double marginLeft = beginValue + (endValue - beginValue) * _animation.value;
  //   marginLeft = marginLeft < 0 ? 0 : marginLeft; // Đảm bảo không có giá trị âm
  //   print('Animation value: ${_animation.value}');
  //   print('margin value: ${marginLeft}');
  //   return AnimatedContainer(
  //     duration: const Duration(seconds: 2),
  //     width: 100,
  //     height: 100.0,
  //     margin: EdgeInsets.only(left: marginLeft),
  //     color: Colors.blue,
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// import 'package:app_camera/page/chooseImage/choose_image.dart';
// import 'package:app_camera/page/chooseImage/media_picker.dart';
// import 'package:app_camera/page/list_image/list_image.dart';
// import 'package:app_camera/model/image_data.dart';
// import 'package:app_camera/page/take_picture/take_picture_screen.dart';
// import 'package:app_camera/page/upload_image/upload_image_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/adapters.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   var box = Hive.box<List>('imageBox');
//   // List<ImageData> imageDataList = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // imageDataList = box.get('imageListKey', defaultValue: []) ?? [];
//     // DateTime today = DateTime.now();
//     // // Chuyển định dạng để so sánh chỉ theo ngày, không tính giờ phút giây
//     // DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
//     // List<ImageData> imagesToKeep = imageDataList.where((imageData) {
//     //   DateTime? imageDataDate = imageData.createDate;
//     //   return imageDataDate != null &&
//     //       imageDataDate.year == todayWithoutTime.year &&
//     //       imageDataDate.month == todayWithoutTime.month &&
//     //       imageDataDate.day == todayWithoutTime.day;
//     // }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color.fromARGB(255, 40, 40, 40),
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           // color: Colors.black87,
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   "Welcome to\nOCRCameraApp",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 40.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 40, 40, 40)),
//                 ),
//                 30.verticalSpace,
//                 Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CameraPage(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                           height: 48.h,
//                           width: 200.w,
//                           padding: EdgeInsets.symmetric(
//                               vertical: 10.h, horizontal: 16.w),
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(color: Colors.black, blurRadius: 3.0)
//                             ],
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(16.r),
//                             color: Color.fromARGB(255, 75, 75, 75),
//                           ),
//                           child: Center(
//                             child: RichText(
//                               text: TextSpan(children: [
//                                 TextSpan(
//                                   text: "Take Picture",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ]),
//                             ),
//                           )),
//                     ),
//                     // 20.verticalSpace,
//                     // InkWell(
//                     //   onTap: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) => UploadImage(),
//                     //       ),
//                     //     );
//                     //   },
//                     //   child: Container(
//                     //     height: 48.h,
//                     //     width: 200.w,
//                     //     padding: EdgeInsets.symmetric(
//                     //         vertical: 10.h, horizontal: 16.w),
//                     //     decoration: BoxDecoration(
//                     //       boxShadow: [
//                     //         BoxShadow(color: Colors.black, blurRadius: 3.0)
//                     //       ],
//                     //       shape: BoxShape.rectangle,
//                     //       borderRadius: BorderRadius.circular(16.r),
//                     //       color: Color.fromARGB(255, 75, 75, 75),
//                     //     ),
//                     //     child: Center(
//                     //         child: Text(
//                     //       "Upload Image",
//                     //       style: TextStyle(
//                     //           color: Colors.white,
//                     //           fontSize: 16.sp,
//                     //           fontWeight: FontWeight.w600),
//                     //     )),
//                     //   ),
//                     // ),
//                     // 20.verticalSpace,
//                     // InkWell(
//                     //   onTap: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) => ListImage(),
//                     //       ),
//                     //     );
//                     //   },
//                     //   child: Container(
//                     //       height: 48.h,
//                     //       width: 200.w,
//                     //       padding: EdgeInsets.symmetric(
//                     //           vertical: 10.h, horizontal: 16.w),
//                     //       decoration: BoxDecoration(
//                     //         boxShadow: [
//                     //           BoxShadow(color: Colors.black, blurRadius: 3.0)
//                     //         ],
//                     //         shape: BoxShape.rectangle,
//                     //         borderRadius: BorderRadius.circular(16.r),
//                     //         color: Color.fromARGB(255, 75, 75, 75),
//                     //       ),
//                     //       child: Center(
//                     //         child: RichText(
//                     //           text: TextSpan(children: [
//                     //             TextSpan(
//                     //               text: "Review Image",
//                     //               style: TextStyle(
//                     //                   color: Colors.white,
//                     //                   fontSize: 16.sp,
//                     //                   fontWeight: FontWeight.w600),
//                     //             ),
//                     //           ]),
//                     //         ),
//                     //       )),
//                     // ),
//                   ],
//                 )
//               ]),
//         ),
//       ),
//     );
//   }
// }
