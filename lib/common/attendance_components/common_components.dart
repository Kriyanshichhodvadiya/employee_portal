import 'package:employeeform/common/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_config.dart';

class CommanPopinsText extends StatelessWidget {
  final String title;
  final double fontsize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  const CommanPopinsText({
    super.key,
    required this.title,
    required this.fontsize,
    required this.color,
    required this.fontWeight,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      title,
      style: poppinsStyle(
        color: color,
        fontSize: fontsize,
        fontWeight: fontWeight,
      ),
    );
  }
}

Future<Object?> showServicePopup(context, String content, String title) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    barrierDismissible: true,
    barrierLabel: '',
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: ShowAleartComman(
          content: content,
          title: title,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class ShowAleartComman extends StatefulWidget {
  final String title;
  final String content;
  const ShowAleartComman(
      {super.key, required this.title, required this.content});

  @override
  State<ShowAleartComman> createState() => _ShowAleartCommanState();
}

class _ShowAleartCommanState extends State<ShowAleartComman> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
      ),
      contentPadding: EdgeInsets.zero, // Remove default content padding
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          /*Transform.translate(
            offset: const Offset(10, -15),
            child: CircleAvatar(
              backgroundColor: whiteColor,
              child: SvgPicture.asset(
                'Assets/Images/backsvg.svg',
                semanticsLabel: 'back',
                color: primaryColor,
                height: 20,
              ),
            ).onInkTap(() {
              Get.back();
            }),
          ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Ensure the content takes minimum space
            children: [
              verticalGap(10),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommanPopinsText(
                      title: widget.title,
                      fontsize: twentyfourFont,
                      color: blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                    verticalGap(15),
                    CommanPopinsText(
                      title: widget.content,
                      fontsize: fourteenFont,
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                    verticalGap(15),
                  ],
                ).paddingSymmetric(horizontal: 10),
              ),
              MaterialButton(
                color: whiteColor,
                onPressed: () async {
                  Get.back(result: "Ok");
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    side: const BorderSide(color: green, width: 2)),
                child: Text(
                  "Ok",
                  style: poppinsStyle(
                    color: green,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 10),
        ],
      ),
    );
  }
}
