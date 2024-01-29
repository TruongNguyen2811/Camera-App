import 'package:app_camera/page/scanQr/widget/subit_session_state.dart';
import 'package:app_camera/page/scanQr/widget/submit_session_cubit.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:app_camera/widget/button_widget.dart';
import 'package:app_camera/widget/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitSession extends StatefulWidget {
  String? sessionId;
  SubmitSession({super.key, this.sessionId});

  @override
  State<SubmitSession> createState() => _SubmitSessionState();
}

class _SubmitSessionState extends State<SubmitSession> {
  late SubmitSessionCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    cubit = SubmitSessionCubit();
    super.initState();
    if (widget.sessionId != null) {
      cubit.controller.text = widget.sessionId ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmitSessionCubit, SubmitSessionState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is SubmitSessionSucess) {
          Utils.showToast(context, state.success, type: ToastType.SUCCESS);
          Navigator.pop(context);
        }
        if (state is SubmitSessionFailure) {
          Utils.showToast(context, state.error, type: ToastType.ERROR);
        }
      },
      builder: (context, state) {
        return buildDialog(context, state);
      },
    );
  }

  Widget buildDialog(BuildContext context, SubmitSessionState state) {
    return KeyboardDismissOnTap(
        child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: 327.w,
        height: 230.h,
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
            if (widget.sessionId == null) ...[
              Text(
                'Enter Session Id',
                style: Theme.of(context).textTheme.title5.copyWith(),
              )
            ],
            if (widget.sessionId != null) ...[
              Text(
                'Verify Session Id',
                style: Theme.of(context).textTheme.title5.copyWith(),
              )
            ],
            16.verticalSpace,
            TextFieldWidget(
              isBorder: false,
              maxLines: 1,
              controller: cubit.controller,
              titleText: 'Session Id: ',
              hintText: "Enter Session Id",
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
                      title: 'Confirm',
                      textStyle: Theme.of(context)
                          .textTheme
                          .text14W600
                          .copyWith(color: Colors.white, height: 0),
                      onPressed: () {
                        // print('Check name brand ${cubit.carBrand?.title}');
                        cubit.voidSubmitSessionId();
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
