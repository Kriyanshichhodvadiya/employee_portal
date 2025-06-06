import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget logintext({required String text}) {
  return Builder(builder: (context) {
    return Text(
      text,
      style: poppinsStyle(
        color: AppColors.primarycolor,
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  });
}

Widget logintextfiled(
    {required String text,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    void Function(String?)? onSaved,
    int? maxLines = 1,
    List<TextInputFormatter>? inputFormatters}) {
  return Builder(builder: (context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      cursorColor: AppColors.black,
      decoration: InputDecoration(
          filled: true,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: AppColors.textfeild,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: text,
          hintStyle: poppinsStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textcolor,
              fontSize: 1.9.hp(context)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bordercolor)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bordercolor)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bordercolor),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bordercolor),
              borderRadius: BorderRadius.circular(10))),
    );
  });
}

Widget commontextlogin({required String text, Color color = Colors.black}) {
  return Builder(builder: (context) {
    return Text(
      text,
      style: poppinsStyle(
          color: color, fontWeight: FontWeight.w600, fontSize: 1.8.hp(context)),
    );
  });
}

Widget continuecontainer({
  required String text,
  required String image,
  BoxBorder? border,
  Color color = Colors.black,
}) {
  return Builder(builder: (context) {
    return Container(
      height: 40,
      width: 130,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), border: border),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          10.width,
          Text(
            text,
            style: poppinsStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 1.9.hp(context)),
          )
        ],
      ),
    );
  });
}
