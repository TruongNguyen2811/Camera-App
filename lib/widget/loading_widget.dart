import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.3),
        ),
        Align(
          alignment: Alignment.center,
          child: SpinKitRipple(
            color: Colors.white,
            size: 80.h,
          ),
        ),
      ],
    );
  }
}
