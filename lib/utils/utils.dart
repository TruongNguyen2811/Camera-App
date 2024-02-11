import 'dart:io';

import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static bool isEmptyArray(List? list) {
    return list == null || list.isEmpty;
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showToast(BuildContext context, String? text,
      {ToastType? type = ToastType.ERROR, bool? isPrefixIcon = true}) {
    Color backgroundColor = R.color.blue11;
    Color iconColor = R.color.inform1;
    Color textColor = R.color.neutral2;
    if (type == ToastType.WARNING) {
      iconColor = R.color.orange;
      backgroundColor = R.color.bgWarning;
    } else if (type == ToastType.SUCCESS) {
      iconColor = R.color.success1;
      backgroundColor = R.color.bgSuccess;
    } else if (type == ToastType.INFORM) {
      iconColor = R.color.blue;
      backgroundColor = R.color.bgInform;
    } else if (type == ToastType.ERROR) {
      iconColor = R.color.danger1;
      backgroundColor = R.color.bgWarning;
    }
    onWidgetDidBuild(() {
      FToast fToast = FToast();
      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      Widget toast = Container(
        width: 1.sw,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r), color: backgroundColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(text ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .subTitle
                      .copyWith(color: textColor)),
            ),
            // SizedBox(
            //   width: 8.w,
            // ),
            // GestureDetector(
            //   onTap: () => fToast.removeCustomToast(),
            //   child: Icon(
            //     CupertinoIcons.xmark,
            //     size: 16.h,
            //     color: textColor,
            //   ),
            // )
          ],
        ),
      );

      if (!Utils.isEmpty(text)) {
        fToast.showToast(
          child: toast,
          gravity: ToastGravity.TOP,
          positionedToastBuilder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: child,
            );
          },
          toastDuration: const Duration(seconds: 3),
        );
      }
    });
  }

  // Future<void> uint8ListToFile(Uint8List uint8list) async {
  //   // Lấy thư mục ứng dụng tạm thời
  //   Directory appDocDir = await getTemporaryDirectory();
  //   String appDocPath = appDocDir.path;

  //   // Tạo tệp tin với tên ngẫu nhiên
  //   String filePath =
  //       '$appDocPath/file_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   File file = File(filePath);

  //   // Ghi dữ liệu từ Uint8List vào tệp tin
  //   await file.writeAsBytes(uint8list, flush: true);
  // }
}
