import 'package:app_camera/res/R.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomTheme on TextTheme {
  TextStyle get titleLarge => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 36.sp,
      fontWeight: FontWeight.bold,
      height: 44 / 36);

  TextStyle get title1 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        height: 38 / 32);
  }

  TextStyle get titleW300 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 32.sp,
        fontWeight: FontWeight.w300,
        height: 44 / 32);
  }

  TextStyle get title2 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        height: 32 / 28);
  }

  TextStyle get title6 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 28.sp,
        fontWeight: FontWeight.w400,
        height: 32 / 28);
  }

  TextStyle get title3 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        height: 30 / 22);
  }

  TextStyle get title4 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        height: 28 / 20);
  }

  TextStyle get title10 {
    return GoogleFonts.inter(
        color: R.color.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        height: 28 / 20);
  }

  TextStyle get body1 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      height: 22 / 16);

  TextStyle get body1Bold => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      height: 22 / 16);

  TextStyle get body2Bold => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      height: 20 / 14);

  TextStyle get body2 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 22 / 14);

  TextStyle get buttonNormal => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      height: 18 / 14);

  TextStyle get subTitleRegular => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 24 / 14,
      );
  TextStyle get title700 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      );
  TextStyle get tooltip => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 16 / 12);

  TextStyle get labelLargeText => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      height: 16 / 12);

  TextStyle get labelNormalText => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 19 / 14);

  TextStyle get h5Regular {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 25 / 18);
  }

  TextStyle get subTitle {
    return GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get subTitleItalic {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontStyle: FontStyle.italic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w300,
        height: 20 / 14);
  }

  TextStyle get textRegular => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 17 / 12,
      );

  TextStyle get smallNormal => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      );

  TextStyle get labelHighLight {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 22 / 16);
  }

  TextStyle get labelHighLight2 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        height: 32 / 20);
  }

  TextStyle get h5Bold {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        height: 25 / 18);
  }

  TextStyle get subTitle12 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 22 / 12);
  }

  TextStyle get subTitle14 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 22 / 14);
  }

  TextStyle get subTitle16 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 22 / 16);
  }

  TextStyle get text16 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        height: 22 / 16);
  }

  TextStyle get text17 {
    return GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get text18 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 18.sp,
        fontWeight: FontWeight.w300,
        height: 19.36 / 16);
  }

  TextStyle get text20 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 32 / 20);
  }

  TextStyle get text20W700 {
    return GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get text14 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w300,
        height: 20 / 14);
  }

  TextStyle get label14 {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 22 / 14);
  }

  TextStyle get labelDark14 {
    return GoogleFonts.inter(
        color: R.color.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 22 / 14);
  }

  TextStyle get labelDark16 {
    return GoogleFonts.inter(
        color: R.color.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 22 / 16);
  }

  TextStyle get labelDark20 {
    return GoogleFonts.inter(
        color: R.color.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        height: 22 / 20);
  }

  TextStyle get bold14 {
    return GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get h4Bold {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        height: 27 / 20);
  }

  TextStyle get h3Bold {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        height: 27 / 24);
  }

  TextStyle get h6Bold {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        height: 32 / 24);
  }

  TextStyle get text12 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );
  TextStyle get text121 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );
  TextStyle get text12W500 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      );
  TextStyle get text12W600 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      );
  TextStyle get text12W700 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      );
  TextStyle get text10 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      height: 12 / 10);

  TextStyle get textSmall => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12);

  TextStyle get title5 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      height: 24 / 18);

  TextStyle get content1 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 16.sp,
      fontWeight: FontWeight.w300,
      height: 24 / 16);

  TextStyle get smallMedium => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12);

  TextStyle get text28W700 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
      height: 32 / 28);

  TextStyle get subTextNoty {
    return GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        height: 22 / 16);
  }

  TextStyle get text14W600 => GoogleFonts.inter(
        color: R.color.dark1,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      );

  TextStyle get text28W600 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      height: 40 / 28);

  TextStyle get text36W500 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 36.sp,
      fontWeight: FontWeight.w500,
      height: 36 / 32);

  TextStyle get text12W300 => GoogleFonts.inter(
      color: R.color.dark1,
      fontSize: 12.sp,
      fontWeight: FontWeight.w300,
      height: 18 / 12);
  TextStyle get text8W400 => GoogleFonts.inter(
        color: R.color.dark8,
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
      );
  TextStyle get text10W400 => GoogleFonts.inter(
        color: R.color.dark8,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      );
}
