import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String fontFamily = 'Al Jazeera Arabic';
  //bold
  static TextStyle bold24 = TextStyle(
    //displaylarge
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    height: 1,
  );
  static TextStyle bold20 = TextStyle(
    //displaymedium
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle bold18 = TextStyle(
    //displaysmall
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    height: 1,
    fontFamily: fontFamily,
  );

  //semi bold
  static TextStyle semiBold18 = TextStyle(
    //headlinelarge
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle semiBold16 = TextStyle(
    //headlinemedium
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle semiBold14 = TextStyle(
    //headlinesmall
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1,
    fontFamily: fontFamily,
  );

  //medium
  static TextStyle medium20 = TextStyle(
    //titlelarge
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle medium18 = TextStyle(
    //titlemedium
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle medium14 = TextStyle(
    //bodymedium
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle medium12 = TextStyle(
    //bodysmall
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    fontFamily: fontFamily,
  );

  //regular
  static TextStyle regular16 = TextStyle(
    //titlesmall
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle regular14 = TextStyle(
    //labellarge
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle regular12 = TextStyle(
    //labelmedium
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    height: 1,
    fontFamily: fontFamily,
  );
  static TextStyle regular10 = TextStyle(
    //labelsmall
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    height: 1,
    fontFamily: fontFamily,
  );
}
