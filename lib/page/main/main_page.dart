import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_camera/page/all_Image/all_image_page.dart';
import 'package:app_camera/page/check_internet/check_internet_cubit.dart';
import 'package:app_camera/page/home/home_page.dart';
import 'package:app_camera/page/take_picture/take_picture_screen.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _bottomNavIndex = 0;
  final PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkconnection();
  }

  checkconnection() async {
    await context.read<InternetCubit>().checkInternetConnectivity();
    print('check internet ${context.read<InternetCubit>().isConnect}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.newBackground,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildScreens(),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinnearGradientDarkBlue(),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 5,
              color: Color(0x26000000),
            ),
          ],
        ),
        child: FloatingActionButton(
            // backgroundColor: R.color.accentColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(),
                ),
              );
            },
            child: Container(
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                gradient: LinnearGradientDarkBlue(),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 5,
                    color: Color(0x26000000),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Image.asset(
                  'assets/icon/icon_ocr.png',
                  color: R.color.white,
                  fit: BoxFit.cover,
                  width: 32.w,
                  height: 32.w,
                ),
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: 2,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? R.color.blueTextLight : R.color.dark8;
          return iconBottomNavigationBar(color)[index];
        },
        height: 70.h,
        backgroundColor: R.color.white,
        activeIndex: _bottomNavIndex,
        splashColor: R.color.white,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 16.r,
        rightCornerRadius: 16.r,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          pageController.jumpToPage(index);
        },
        shadow: const BoxShadow(
          offset: Offset(0, -1),
          blurRadius: 5,
          color: Color(0x26000000),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [HomePage(), AllImagePage()];
  }

  List<Widget> iconBottomNavigationBar(Color color) {
    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon_home.png',
            height: 26.w,
            width: 26.w,
            color: color,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Home",
              maxLines: 1,
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon_list.png',
            height: 26.w,
            width: 26.w,
            color: color,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "All Images",
              maxLines: 1,
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
    ];
  }
}
