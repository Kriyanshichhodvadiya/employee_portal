import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Decoration commonGridConDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: AppColors.businesscborder,
    ),
  );
}

Widget dashboarddata({
  required String label,
  required String img,
}) {
  return Container(
    decoration: commonGridConDecoration(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: 7.onlyTop,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowcolor.withOpacity(0.22),
                  // offset: const Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: -2,
                ),
              ],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.textfield,
              ),
            ),
            child: Padding(
              padding: 8.symmetric,
              child: SvgPicture.asset(img),
            ),
          ),
        ),
        5.height,
        Text(
          textAlign: TextAlign.center,
          label,
          style: poppinsStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
        2.height,
      ],
    ),
  );
}

Widget commonSaveButton({required void Function()? onPressed}) {
  return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.check,
        color: AppColors.primarycolor,
      ));
}
