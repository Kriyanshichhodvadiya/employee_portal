import 'package:employeeform/common/comman_widget.dart';
import 'package:flutter/material.dart';

Widget attendancerow({
  Color color = Colors.green,
  required String text,
}) {
  return Row(
    children: [
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: color,
        ),
      ),
      5.width,
      Text(
        text,
        style: poppinsStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    ],
  );
}
