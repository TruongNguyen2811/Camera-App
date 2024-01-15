import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/widget/gradient_text.dart';
import 'package:app_camera/widget/single_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String title;
  final VoidCallback? onPressed;
  final double? radius;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Widget? child;
  final Color? borderColor;
  final bool disable;
  final String? icon;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double? isAlign;
  final double? borderSize;
  final bool isGradient;
  final bool isIconRight;
  final bool isShadow;
  final Color? disableColor;
  final Color? disableTextColor;

  const ButtonWidget({
    Key? key,
    this.backgroundColor,
    this.textColor,
    required this.title,
    required this.onPressed,
    this.radius,
    this.height,
    this.width,
    this.gradient,
    this.child,
    this.borderColor,
    this.disable = false,
    this.icon,
    this.isAlign,
    this.iconColor,
    this.borderSize,
    this.textStyle,
    this.isGradient = false,
    this.isIconRight = false,
    this.isShadow = true,
    this.disableColor,
    this.disableTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleTapDetector(
      onTap: () {
        if (disable) return;
        onPressed?.call();
      },
      child: Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        height: height ?? 48.h,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(
                    color: borderColor ?? R.color.white,
                    width: borderSize ?? 1.h)
                : null,
            /*color: disable
              ? R.color.dark11
              : onPressed == null
                  ? R.color.lineGray
                  : backgroundColor ?? R.color.blue3,*/
            gradient: disable
                ? LinearGradient(
                    colors: disableColor != null
                        ? [disableColor!, disableColor!]
                        : [R.color.white, R.color.white])
                : onPressed == null
                    ? LinearGradient(
                        colors: [R.color.lineGray, R.color.lineGray])
                    : gradient ??
                        LinearGradient(
                            colors: [
                              backgroundColor ?? R.color.newPrimary,
                              backgroundColor ?? R.color.newPrimary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 16.r)),
            boxShadow: isShadow
                ? const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 4,
                    )
                  ]
                : []),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && isIconRight == false)
                  Image.asset(
                    icon!,
                    height: 24.h,
                    width: 24.w,
                    color: iconColor,
                  ),
                if (icon != null && isIconRight == false) SizedBox(width: 5.w),
                isAlign != null
                    ? SizedBox(
                        width: isAlign,
                        child: GradientText(
                          title,
                          maxLines: 2,
                          style: textStyle ??
                              Theme.of(context).textTheme.buttonNormal.copyWith(
                                    color: disable
                                        ? disableTextColor ??
                                            const Color(0x00c2c3c0)
                                        : textColor ??
                                            (backgroundColor != null
                                                ? R.color.black
                                                : Colors.white),
                                  ),
                          gradient: LinearGradient(
                              colors: [
                                backgroundColor ?? R.color.newPrimary,
                                backgroundColor ?? R.color.newPrimary,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                      )
                    : isGradient
                        ? GradientText(
                            title,
                            maxLines: 2,
                            style: textStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .buttonNormal
                                    .copyWith(
                                      color: disable
                                          ? disableTextColor ??
                                              const Color(0x00c2c3c0)
                                          : textColor ??
                                              (backgroundColor != null
                                                  ? R.color.black
                                                  : Colors.white),
                                    ),
                            gradient: LinearGradient(
                                colors: [
                                  backgroundColor ?? R.color.newPrimary,
                                  backgroundColor ?? R.color.newPrimary,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          )
                        : Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .buttonNormal
                                    .copyWith(
                                      color: disable
                                          ? disableTextColor ?? Colors.grey[400]
                                          : textColor ??
                                              (backgroundColor != null
                                                  ? R.color.black
                                                  : Colors.white),
                                    ),
                          ),
                if (icon != null && isIconRight == true) SizedBox(width: 5.w),
                if (icon != null && isIconRight == true)
                  Image.asset(
                    icon!,
                    height: 24.h,
                    width: 24.w,
                    color: iconColor,
                  ),
              ],
            ),
      ),
    );
  }
}
