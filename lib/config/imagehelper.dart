import 'dart:io';

import 'package:employeeform/config/color.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropperHelper {
  static Future<File?> cropImage(File fileImage) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: fileImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.black,
          toolbarWidgetColor: AppColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          // cropFrameColor: Colors.pink,
          // backgroundColor: Colors.green,
          // statusBarColor: AppColor.red,

          activeControlsWidgetColor: AppColors.primarycolor.withOpacity(0.7),
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }
}
