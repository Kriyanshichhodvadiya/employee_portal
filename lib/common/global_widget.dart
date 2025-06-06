import 'package:employeeform/common/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../config/color.dart';
import '../config/images.dart';
import 'attendance_components/app_config.dart';

extension Extensions on num {
  EdgeInsets get symmetric =>
      EdgeInsets.symmetric(horizontal: toDouble(), vertical: toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get onlyLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get onlyRight => EdgeInsets.only(right: toDouble());
  EdgeInsets get onlyTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get onlyBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get onlyLeftTop =>
      EdgeInsets.only(left: toDouble(), top: toDouble());
  double widthBox() => this * Get.width / 100;
  double heightBox() => this * Get.height / 100;
}

Future<bool?> primaryToast({required msg}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.black,
    textColor: AppColors.white,
    fontSize: 14.0,
  );
}

Widget labelHeight() {
  return 10.height;
}

Widget fieldBottomHeight() {
  return 2.height;
}

Decoration commonDecoration({Color? color}) {
  return BoxDecoration(
    color: color ?? AppColors.white,
    borderRadius: BorderRadius.circular(11),
    boxShadow: [
      BoxShadow(
        color: AppColors.hinttext.withOpacity(0.2),
        blurRadius: 5,
        spreadRadius: -1,
      ),
    ],
  );
}

Widget selectDateLabel({required label}) {
  return Text(label,
      style: poppinsStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ));
}

AppBar appBar(
    {required title,
    required void Function()? onTap,
    bool showBack = true,
    List<Widget>? actions}) {
  return AppBar(
    leading: showBack == true
        ? GestureDetector(onTap: onTap, child: Icon(Icons.arrow_back_ios))
        : null,
    // shadowColor: AppColors.black.withOpacity(0.2),
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: poppinsStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    automaticallyImplyLeading: false,
    actions: actions,
  );
}

Widget commonLottie() {
  return Center(
    child: Lottie.asset(
      AppLottie.noDataFound,
      alignment: Alignment.center,
      animate: true,
      width: Get.width,
    ),
  );
}

Widget searchLottie() {
  return Center(
    child: Lottie.asset(
      AppLottie.searchEmpty,
      alignment: Alignment.center,
      animate: true,
      width: 50.widthBox(),
    ),
  );
}

Widget commonProfileLabel({required label}) {
  return Text(
    label,
    style: poppinsStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w700,
      fontSize: 13,
    ),
  );
}

Widget allTaskText({
  required label,
  required task,
  required icon,
  int labelFlex = 1,
  int taskFlex = 3,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: 2.onlyTop,
        child: Icon(
          icon,
          color: AppColors.primarycolor,
          size: 2.2.heightBox(),
        ),
      ),
      10.width,
      Expanded(
        flex: labelFlex,
        child: Text(
          label, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: poppinsStyle(
              fontSize: 13,
              color: AppColors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600),
          // overflow: TextOverflow.ellipsis,
        ),
      ),
      5.width,
      Text(
        ":",
        style: poppinsStyle(
            fontSize: 13,
            color: AppColors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600),
      ),
      5.width,
      Expanded(
        flex: taskFlex,
        child: Text(
          task,
          style: poppinsStyle(
              fontSize: 13,
              color: AppColors.hinttext,
              fontWeight: FontWeight.w500),
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget allTaskTimeCont({
  required String date,
  required String time,
  String? start,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
    decoration: BoxDecoration(
      color: AppColors.white,
      boxShadow: [commonShadow()],
      // color: start
      //     ? AppColors.primarycolor.withOpacity(0.1)
      //     : AppColors.green.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Icon for Start or Finish Task
        commonTaskLottie(
          lottie: start == commonString.radioBtnStart
              ? AppLottie.startTask
              : start == commonString.radioBtnFinish
                  ? AppLottie.finishTask
                  : AppLottie.holdtask,
          height: start == commonString.radioBtnHold ? 5.widthBox() : null,
          width: start == commonString.radioBtnHold ? 5.widthBox() : null,
        ),
        /*SvgPicture.asset(
          start == commonString.radioBtnStart
              ? AppSvg.startTask
              : start == commonString.radioBtnFinish
                  ? AppSvg.endTask
                  : AppSvg.holdTask,
          height: 3.widthBox(),
          width: 3.widthBox(),
          color: start == commonString.radioBtnStart
              ? AppColors.primarycolor
              : start == commonString.radioBtnFinish
                  ? AppColors.green
                  : AppColors.red,
        ),*/
        start == commonString.radioBtnHold ? 12.width : 8.width, // Spacing

        // Date with Calendar Icon
        Expanded(
          flex: 3,
          child: Row(
            children: [
              /*  Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primarycolor.withOpacity(0.7),
                size: 16,
              ),
              6.width,*/
              Expanded(
                child: Text(
                  date, // Extracted Date
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: poppinsStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: start == commonString.radioBtnStart
                        ? AppColors.primarycolor
                        : start == commonString.radioBtnFinish
                            ? AppColors.green
                            : AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Time with Clock Icon
        Expanded(
          flex: 2,
          child: Row(
            children: [
              commonTaskLottie(
                lottie: AppLottie.clock,
              ),
              /*  Icon(
                Icons.access_time_rounded,
                color: start == commonString.radioBtnStart
                    ? AppColors.primarycolor.withOpacity(0.7)
                    : start == commonString.radioBtnFinish
                        ? AppColors.green.withOpacity(0.7)
                        : AppColors.red.withOpacity(0.7),
                size: 3.5.widthBox(),
              ),*/
              6.width,
              Expanded(
                child: Text(
                  time, // Extracted Time,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: poppinsStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: start == commonString.radioBtnStart
                        ? AppColors.primarycolor
                        : start == commonString.radioBtnFinish
                            ? AppColors.green
                            : AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget radioBtn(
    {required dynamic groupValue,
    required void Function(dynamic)? onChanged,
    required dynamic value}) {
  return Transform.scale(
    scale: 0.8,
    child: Radio<dynamic>(
        activeColor: AppColors.primarycolor,
        splashRadius: 0,
        value: value,
        groupValue: groupValue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: onChanged),
  );
}

Widget commonTaskHint({required lottie, required label, required color}) {
  return Row(
    children: [
      /* SvgPicture.asset(
        icon,
        height: 3.widthBox(),
        width: 3.widthBox(),
        color: color,
      ),*/
      Container(
        height: 3.widthBox(),
        width: 3.widthBox(),
        decoration: BoxDecoration(color: color),
      ),
      // Lottie.asset(lottie,
      //     height: 5.widthBox(), width: 5.widthBox(), fit: BoxFit.cover),
      5.width,
      Text(
        label,
        style: poppinsStyle(color: AppColors.grey, fontSize: 10),
      ),
    ],
  );
}

Widget radioBtnText({required label}) {
  return Text(
    label,
    style: poppinsStyle(
        color: AppColors.grey, fontWeight: FontWeight.w400, fontSize: 12),
  );
}

Widget commonEditDocName(
    {required void Function()? onPressed, required controller}) {
  return Dialog(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 5,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Text(
          'Edit Document Name',
          style: poppinsStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        commonDivider(),
        Padding(
          padding: 15.symmetric,
          child: Column(
            children: [
              commontextfield(
                controller: controller,
                text: "Enter new document name",
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  alertButton(
                    label: "Cancel",
                    buttonColor: AppColors.bordercolor,
                    onPressed: () => Get.back(),
                  ),
                  alertButton(
                    label: "Save",
                    buttonColor: AppColors.primarycolor,
                    fontColor: AppColors.white,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget editIcon() {
  return Icon(
    Icons.edit,
    color: AppColors.hinttext,
  );
}

Widget alertButton(
    {required label,
    Color? fontColor,
    Color? buttonColor,
    required void Function()? onPressed}) {
  // Colors.grey.shade300
  return Container(
    width: 30.widthBox(),
    child: ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(10.widthBox(), 30)),
        backgroundColor:
            MaterialStateProperty.all(buttonColor ?? AppColors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return buttonColor == null
                  ? AppColors.white.withOpacity(0.2)
                  : AppColors.black.withOpacity(0.2);
            }
            return null;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: commonLogoutButtonRadius(),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: poppinsStyle(color: fontColor ?? blackColor),
      ),
    ),
  );
}

Widget editPopUp({required icon, required label}) {
  return Row(
    children: [
      Icon(
        icon,
        color: AppColors.black.withOpacity(0.4),
      ),
      8.width,
      Text(
        label,
        style: poppinsStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.black.withOpacity(0.4)),
      ),
    ],
  );
}

Widget commonCompanyIcon({required onTap, required image}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primarycolor.withOpacity(0),
              AppColors.primarycolor.withOpacity(0.2)
            ], // Light to normal orange gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: AppColors.white,
          border: Border.all(color: AppColors.primarycolor.withOpacity(0.3))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          image,
          width: 6.wp(Get.context!),
          height: 6.wp(Get.context!),
          color: AppColors.primarycolor,
        ),
      ),
    ),
  );
}

BorderRadius commonLogoutButtonRadius() {
  return BorderRadius.circular(0);
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

Widget commonPendingReason({required reason}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: 2.onlyTop,
        child: Icon(
          Icons.info_outline,
          color: AppColors.primarycolor,
          size: 2.5.heightBox(),
        ),
      ),
      10.width,
      Expanded(
        child: Text(
          "Reason For Pending: ${reason}",
          style: poppinsStyle(
              fontSize: 13,
              color: AppColors.hinttext,
              fontWeight: FontWeight.w500),
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget commonPopupBtn({required lottie, required label}) {
  return Row(
    children: [
      Lottie.asset(lottie, height: 6.widthBox(), width: 6.widthBox()),
      5.width,
      Text(label, style: poppinsStyle()),
    ],
  );
}

Widget commonEditBtnUserSide() {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        border: Border.all(color: AppColors.grey),
        shape: BoxShape.circle),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Icon(Icons.edit, size: 2.heightBox(), color: AppColors.grey),
    ),
  );
}

Widget countrySearchBtn() {
  return Icon(Icons.search);
}
