import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xffE77711);
const Color linkColor = Color(0xff1020AD);
const Color attachlinkColor = Color(0xff0051BF);
const Color errorColor = Color(0xffFF2633);
const Color lightGrayColor = Color(0xff727272);
const Color whiteColor = Color(0xffffffff);
const Color blackColor = Color(0xff000000);
const Color buttonColor = Color(0xff094A6E);
const Color greyFontColor = Color(0xFF646464);

const Color darkblack = Color(0xff444444);
const Color controllerborder = Color(0xffDDDDDD);
const Color newsecondarycolor = Color(0xff094B6E);

///Analogous Colors:

const Color goldColor = Color(0xffFFD700);
const Color brightorange = Color(0xffFF8717);

//Complementary Colors:
const Color deepskyblue = Color(0xff3B83BD);
//Triadic Colors:
const Color brightgreen = Color(0xff11E777);
const Color deeppurple = Color(0xff7711E7);
//Split Complementary Colors:
const Color ceruleanblue = Color(0xff117AE7);
const Color magenta = Color(0xffE7115F);
const Color green = Color(0xff6ABC45);
//Monochromatic Colors:
const Color lightorange = Color(0xffFFA933);
const Color darkorange = Color(0xffB75000);

const Color timetableBg = Color(0xffFFF2D8);

const Color timetableBgsubheader = Color(0xffA69F9F);

//
const Color subheaderColor = Color(0xff9E9E9E);
const Color pageBglightColor = Color(0xffDDDDDD);
const Color dashmenuBgColor = Color(0xffFBFCFF);
const Color dashmenuBgborderColor = Color(0xffEFEFEF);

const Color pageBgColor = Color(0xffFAFAFA);

const Color orangeStatusfront = Color(0xffF4A261);
const Color orangeStatusbg = Color.fromARGB(8, 255, 162, 1);
const Color timetableColor = Color(0xff524545);
const Color subheaderProfile = Color(0xffAAAAAA);

const Color breakColor = Color(0xffE8E5FB);
const Color breakActiveColor = Color(0xff2B2F64);

const Color presentColor = Color(0xffEAF5EF);
const Color absentColor = Color(0xffFFE2E2);
const Color leaveColor = Color(0xffFBEFD5);

const Color cancebgColor = Color(0xff042954);
const Color placeholderColorNotice = Color(0xffD8D5D3);
const Color shadowColor = Color(0xff7080B0);

const Color otpColor = Color(0xffF6F6F6);

const Color lightorangeColor = Color(0xffFFE79B);
const Color lightgreenColor = Color(0xffAEED91);
const Color lightredColor = Color(0xffF5A6A6);

//font Size
const double tenFont = 10;
const double twelveFont = 12;
const double fourteenFont = 14;
const double sixteenFont = 16;
const double eightteenFont = 18;
const double twentyFont = 20;
const double twentytwoFont = 22;
const double twentyfourFont = 24;
const double twentysixFont = 26;
const double twentyeightFont = 28;
const double thirtyFont = 30;
const double thirtytwoFont = 32;
const double thirtyfourFont = 34;
const double thirtysixFont = 36;

//Image Path
const String imagePath = "Assets/Images/";

//fontfamliy

getBytesImage(String profile) async {
  Uint8List bytes = (await NetworkAssetBundle(Uri.parse(profile)).load(profile))
      .buffer
      .asUint8List();
  //Settings.byteImage = String.fromCharCodes(bytes);
  return bytes;
}

bool isStringNullOrEmptyOrBlank(String value) {
  return value.isEmpty ||
      value == null ||
      value.isEmpty ||
      value.trim().isEmpty;
}

showToast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

SizedBox verticalGap(double gap) {
  return SizedBox(height: gap);
}

SizedBox horizontalGap(double gap) {
  return SizedBox(width: gap);
}

bool isTablet(MediaQueryData query) {
  var size = query.size;
  var diagonal = sqrt((size.width * size.width) + (size.height * size.height));
  var isTablet = diagonal > 1100.0;
  return isTablet;
}

closeShowAlertDialog(BuildContext context) {
  Get.back();
}
