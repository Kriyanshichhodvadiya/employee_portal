import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/leavecontroller.dart';
import '../view/admin_side/company_profile/co_profile_form.dart';

List<Map<String, dynamic>> employeeList = [];

extension NumExtensions on num {
  //sixedbox
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
  //mediaquery
  double wp(BuildContext context) =>
      this * MediaQuery.of(context).size.width / 100;
  double hp(BuildContext context) =>
      this * MediaQuery.of(context).size.height / 100;
}

Widget primarybutton(
    {required String text,
    double height = 45,
    required void Function()? onPressed,
    Color? color,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(36))}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(double.infinity, height)),
        backgroundColor: MaterialStateProperty.all(AppColors.primarycolor),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.white.withOpacity(0.2);
            }
            return null;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: poppinsStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ));
}

TextStyle poppinsStyle(
    {Color color = Colors.black,
    double fontSize = 14,
    Color? decorationColor,
    TextDecoration? decoration,
    FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(
      color: color,
      fontSize: fontSize,
      decorationColor: decorationColor,
      decoration: decoration,
      fontWeight: fontWeight,
      fontFamily: 'Poppins');
}

Widget commontextfield(
    {required String text,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    void Function(String)? onChanged,
    void Function()? onTap,
    final FocusNode? focusNode,
    bool readOnly = false,
    bool obscureText = false,
    Color? focusColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType? keyboardType}) {
  return TextFormField(
    style: poppinsStyle(
      color: AppColors.hinttext,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    focusNode: focusNode,
    obscureText: obscureText,
    textCapitalization: textCapitalization,
    readOnly: readOnly,
    onTap: onTap,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    controller: controller,
    cursorColor: AppColors.black,
    onChanged: onChanged,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: fieldBorder(),
        hintText: text,
        hintStyle: poppinsStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.hinttext),
        contentPadding: EdgeInsets.symmetric(
            vertical: maxLines == 3 ? 5 : 2, horizontal: 10),
        errorBorder: enableBorder(),
        focusedErrorBorder: focusBorder(focusColor: focusColor),
        enabledBorder: enableBorder(),
        focusedBorder: focusBorder(focusColor: focusColor)),
  );
}

OutlineInputBorder fieldBorder({Color? focusColor}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  );
}

OutlineInputBorder focusBorder({Color? focusColor}) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: focusColor ?? AppColors.black),
      borderRadius: BorderRadius.circular(5));
}

OutlineInputBorder enableBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(5));
}

Widget commonDivider({Color? color}) {
  return Divider(
    color: color ?? AppColors.hinttext.withOpacity(0.1),
    height: 20,
  );
}

Widget commonappbar({required String text, void Function()? onTap}) {
  return AppBar(
    leading: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.arrow_back_ios),
    ),
    shadowColor: AppColors.black.withOpacity(0.5),
    backgroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      text,
      style: poppinsStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    automaticallyImplyLeading: false,
  );
}

Widget cameraBtn({required String text, required String image}) {
  return Builder(builder: (context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primarycolor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            color: AppColors.white,
            height: 25,
            width: 25,
          ),
          10.height,
          Text(
            text,
            textAlign: TextAlign.center,
            style: poppinsStyle(
                color: AppColors.white,
                fontSize: 1.8.hp(context),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  });
}

Widget commontext({
  required String text,
  int maxLines = 2,
}) {
  return Text(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
          color: AppColors.black.withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins'));
}

Widget textprofilelist({required String label}) {
  return Text(
    label,
    style: poppinsStyle(
        fontSize: 12, color: AppColors.hinttext, fontWeight: FontWeight.w500),
  );
}

Widget commonrowprofile({
  required String labeltext,
  String? fetchname = "",
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: textprofilelist(label: labeltext),
      ),
      const Expanded(
        child: Text(":"),
      ),
      Expanded(
        flex: 5,
        child: Text(
          fetchname ?? "",
          style: poppinsStyle(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500),
        ),
      )
    ],
  );
}

Widget timerbutton(
    {required String text,
    Color? backgroundColor,
    Color? color,
    double height = 45,
    required void Function()? onPressed,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(36))}) {
  return Builder(builder: (context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            minimumSize: Size(double.maxFinite, height),
            backgroundColor: backgroundColor),
        child: Text(
          text,
          style: poppinsStyle(
            color: color ?? AppColors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ));
  });
}

Widget profileDetailHeight() {
  return 10.height;
}

Widget profileDetailLabelHeight() {
  return 5.height;
}

Widget profileDetailConHeight() {
  return 15.height;
}

Widget commonDateCon({required label, required void Function()? onTap}) {
  return Container(
    width: double.maxFinite,
    padding: 10.symmetric,
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.black.withOpacity(0.2),
      ),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Text(
          label,
          style: poppinsStyle(
            color: AppColors.hinttext,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.calendar_month,
          ),
        ),
      ],
    ),
  );
}

Widget commonDateConForLeave(
    {required String label, required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.maxFinite,
      height: 6.hp(Get.context!),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primarycolor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.05),
            spreadRadius: -1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: poppinsStyle(
                color: label == "Select Date"
                    ? AppColors.hinttext.withOpacity(0.6)
                    : AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primarycolor,
          ),
        ],
      ),
    ),
  );
}

FloatingActionButton commonFloatingBtn({required void Function()? onPressed}) {
  return FloatingActionButton(
    backgroundColor: AppColors.primarycolor,
    onPressed: onPressed,
    child: Icon(
      Icons.add,
      color: AppColors.white,
      size: 30,
    ),
  );
}

Widget commonThemeBuilder(BuildContext context, Widget? child) {
  return Theme(
    data: ThemeData(
      primaryColor: AppColors.primarycolor, // Primary color
      colorScheme: ColorScheme.light(
        primary: AppColors.primarycolor, // Header & buttons color
        onPrimary: Colors.white, // Text color on header
        onSurface: Colors.black, // Text color inside picker
      ),
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
    ),
    child: child!,
  );
}

Widget commonLogOutDialog({
  required void Function()? cancelOnPressed,
  required void Function()? logOutOnPressed,
  required title,
  required subTitle,
  required cancelText,
  required confirmText,
  IconData? icon,
  Color? iconColor,
  required deleteButtonColor,
  bool showIcon = true,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 5,
    backgroundColor: Colors.white,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // showIcon == false
          //     ? Container()
          //     : Icon(
          //         icon,
          //         size: 50,
          //         color: iconColor,
          //       ),
          // showIcon == false ? Container() : 15.height,
          15.height,
          dialogTitleText(
            label: title,
          ),
          commonDivider(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              children: [
                dialogSubTitleText(
                  subTitle: subTitle,
                ),
                10.height,
                Padding(
                  padding: 5.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: alertButton(
                          buttonColor: AppColors.bordercolor,
                          label: cancelText,
                          onPressed: cancelOnPressed,
                        ),
                      ),
                      15.width,
                      Expanded(
                          child: alertButton(
                        label: confirmText,
                        onPressed: logOutOnPressed,
                        fontColor: AppColors.white,
                        buttonColor: deleteButtonColor,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget showExitConfirmationDialog(
    {required void Function()? noOnTap, required void Function()? yesOnTap}) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          15.height,
          dialogTitleText(label: "Exit App?"),
          commonDivider(),
          Padding(
            padding: 10.symmetric,
            child: Column(
              children: [
                dialogSubTitleText(subTitle: "Are you sure you want to exit?"),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    alertButton(
                      label: 'No',
                      onPressed: noOnTap,
                      buttonColor: AppColors.bordercolor,
                    ),
                    15.width,
                    alertButton(
                        label: 'Yes',
                        fontColor: AppColors.white,
                        buttonColor: AppColors.primarycolor,
                        onPressed: yesOnTap),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget dialogTitleText({required label}) {
  return Text(
    label,
    style: poppinsStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
  );
}

Widget dialogSubTitleText({required subTitle}) {
  return Text(
    subTitle,
    textAlign: TextAlign.center,
    style: poppinsStyle(
      fontSize: 13,
      color: AppColors.grey,
    ),
  );
}

class commonString {
  static const String statusRejected = "Rejected";
  static const String statusApproved = "Approved";
  static const String statusPending = "Pending";
  static const String statusHold = "Hold";
  static const String radioBtnFinish = "Finish";
  static const String radioBtnHold = "Hold";
  static const String radioBtnStart = "Start";
  static const String radioBtnPending = "Pending";
  static const String female = "female";
  static const String male = "male";
  static const String other = "other";
  static const String office = "office";
  static const String mfgdept = "mfgdept";
  static const String showLogOutBtn = "showLogOut";
  static const String hideLogOutBtn = "hideLogOut";
  static const String aadhar = "Aadhar";
  static const String passbook = "Bank Passbook";
  static const String otherDoc = "Other Documents";
}

BoxShadow commonShadow() {
  return BoxShadow(
      color: AppColors.grey.withOpacity(0.2), blurRadius: 3, spreadRadius: -1);
}

Border commonBorder() {
  return Border.all(width: 2, color: AppColors.primarycolor.withOpacity(0.7));
}

Widget leaveDetailRow(
    {required label,
    required value,
    int maxLines = 1,
    int labelFlex = 1,
    int flex = 2}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: labelFlex,
              child: Text(label,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
            ),
            Text(
              ":",
              style: poppinsStyle(),
            ),
            10.width,
            Expanded(
              flex: flex,
              child: Text(value,
                  // overflow: TextOverflow.ellipsis,
                  style: poppinsStyle(
                    fontSize: 13,
                  )),
            )
          ]));
}

Widget commonMenuFilter(
    {required void Function(String)? onSelected, required String label}) {
  return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: Theme(
          data: Theme.of(Get.context!).copyWith(
            splashColor: Colors.transparent, // Remove splash effect
            highlightColor: Colors.transparent, // Remove highlight effect
          ),
          child: PopupMenuButton<String>(
              onSelected: onSelected,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              color: AppColors.white,
              elevation: 5,
              itemBuilder: (BuildContext context) => [
                    adminLeaveFilterPopup('All'),
                    adminLeaveFilterPopup('Pending'),
                    adminLeaveFilterPopup('Approved'),
                    adminLeaveFilterPopup('Rejected'),
                  ],
              child: Container(
                  height: 6.hp(Get.context!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: AppColors.primarycolor.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.05),
                          spreadRadius: -1,
                          blurRadius: 3,
                        )
                      ]),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsStyle(color: AppColors.primarycolor),
                      ),
                    ),
                    fieldSuffixIcon(color: AppColors.primarycolor),
                  ])))));
}

PopupMenuItem<String> adminLeaveFilterPopup(String text) {
  return PopupMenuItem(
      value: text,
      child: Text(
        text,
        style: poppinsStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ));
}

Widget leaveFilterClearBtn({required void Function()? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.primarycolor.withOpacity(0.2),
              shape: BoxShape.circle),
          child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.close,
                color: AppColors.red,
                size: 15,
              ))));
}

Widget rejectionLeaveDialog({
  required void Function()? cancelOnTap,
  required void Function()? submitOnTap,
  String? title,
  String? hintText,
  TextEditingController? controller,
  void Function(String)? onChanged,
}) {
  LeaveController leaveController = Get.put(LeaveController());
  return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Title**
              Center(
                  child: Text(title ?? "Rejection Reason",
                      style: poppinsStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ))),
              10.height,

              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          spreadRadius: 1,
                          offset: Offset(0, 1),
                        )
                      ]),
                  child: TextField(
                    controller:
                        controller ?? leaveController.rejectionController.value,
                    maxLines: 3,
                    cursorColor: AppColors.grey,
                    style: poppinsStyle(),
                    decoration: InputDecoration(
                      hintText: hintText ?? 'Enter reason...',
                      hintStyle:
                          poppinsStyle(color: AppColors.grey, fontSize: 13),
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                    ),
                    onChanged: onChanged ??
                        (value) {
                          leaveController.rejection.value = value;
                        },
                  )),
              20.height,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                alertButton(
                  label: 'Cancel',
                  buttonColor: AppColors.bordercolor,
                  onPressed: cancelOnTap,
                ),
                alertButton(
                  label: 'Submit',
                  onPressed: submitOnTap,
                  buttonColor: AppColors.primarycolor,
                  fontColor: AppColors.white,
                )
              ])
            ],
          )));
}

Widget commonTaskLottie({required lottie, double? height, double? width}) {
  return Lottie.asset(lottie,
      height: height ?? 7.widthBox(),
      width: width ?? 7.widthBox(),
      fit: BoxFit.cover);
}

Widget dropdownHintTextStyle({required label, double fontSize = 14}) {
  return Text(
    label,
    style: poppinsStyle(
      color: AppColors.hinttext,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget searchDialog({
  required title,
  final FocusNode? focusNode,
  required Widget? listView,
  required Widget? searchField,
}) {
  return Dialog(
    insetPadding: 20.horizontal,
    child: Container(
      height: 63.heightBox(),
      padding: 16.horizontal,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.height,
          Text(title,
              style: poppinsStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          5.height,
          commonDivider(),
          10.height,
          searchField!,
          10.height,

          // Service List (Filtered by Search)
          listView!,
        ],
      ),
    ),
  );
}

Widget searchDialogItem({required title, required void Function()? onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: 3.vertical,
          child: Row(
            children: [
              Text(
                title,
                style: poppinsStyle(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    ),
  );
}

InputDecoration commonDropdownDeco() {
  return InputDecoration(
    errorBorder: enableBorder(),
    focusedErrorBorder: focusBorder(),
    enabledBorder: enableBorder(),
    focusedBorder: focusBorder(),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}

Widget addBtn({required void Function()? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.add_circle_outline,
        color: AppColors.grey,
        size: 4.heightBox(),
      ));
}
