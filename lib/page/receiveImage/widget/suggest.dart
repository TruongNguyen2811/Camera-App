import 'package:app_camera/page/receiveImage/widget/suggest_cubit.dart';
import 'package:app_camera/page/receiveImage/widget/suggets_state.dart';
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

class SuggestText extends StatefulWidget {
  TextEditingController controller;
  List<dynamic>? suggestText;
  dynamic text;
  SuggestText(
      {super.key,
      required this.controller,
      required this.suggestText,
      required this.text});

  @override
  State<SuggestText> createState() => _SuggestTextState();
}

class _SuggestTextState extends State<SuggestText> {
  late SuggestTextCubit _cubit;
  @override
  void initState() {
    // TODO: implement initState
    _cubit = SuggestTextCubit();
    super.initState();
    convertData();
  }

  convertData() {
    print('check control ${widget.controller.text}');
    print('check c ${widget.text}');
    _cubit.listText.add(widget.text);
    _cubit.listText.addAll(widget.suggestText ?? []);
    _cubit.textChoose = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestTextCubit, SuggestTextState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is SuggestTextSubmit) {
          Utils.showToast(context, state.success, type: ToastType.SUCCESS);
          // Navigator.popUntil(context, (route) => route.isFirst);
        }
        if (state is SuggestTextFailure) {
          Utils.showToast(context, state.error, type: ToastType.ERROR);
        }
      },
      builder: (context, state) {
        return buildDialog(context, state);
      },
    );
  }

  Widget buildDialog(BuildContext context, SuggestTextState state) {
    return KeyboardDismissOnTap(
        child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        width: 327.w,
        height: 400.h,
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
            Text(
              'List Suggestions',
              style: Theme.of(context).textTheme.title5.copyWith(),
            ),
            16.verticalSpace,
            Expanded(
                child: SingleChildScrollView(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _cubit.listText.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _cubit.textChoose = _cubit.listText[index];
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          '${_cubit.listText[index]}',
                          style: Theme.of(context)
                              .textTheme
                              .text14
                              .copyWith(height: 0),
                        )),
                        16.verticalSpace,
                        Image.asset(
                          _cubit.textChoose == _cubit.listText[index]
                              ? 'assets/images/ic_tick_square.png'
                              : 'assets/images/ic_untick_square.png',
                          width: 24.w,
                          height: 24.w,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
            Row(
              children: [
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
                        widget.controller.text = _cubit.textChoose;
                        Navigator.pop(context);
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
