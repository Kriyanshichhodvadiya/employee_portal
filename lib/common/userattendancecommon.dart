import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';

Widget total({
  required String text,
  required String no,
}) {
  return Row(
    children: [
      Text(
        text,
        style: poppinsStyle(
            color: AppColors.green, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const Spacer(),
      Text(
        no,
        style: poppinsStyle(
            color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
      )
    ],
  );
}
