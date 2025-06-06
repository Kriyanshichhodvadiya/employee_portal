import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:employeeform/common/attendanceusercommon.dart';
import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/attendance_components/hexagonal.dart';
import '../../common/global_widget.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    initData();
    profileImage();
    loadAttendanceData();
  }

  bool isLoading = false;
  //matchface
  bool isFaceMatched = false;
  List<Map<String, String>> attendanceList = [];
  bool isButtonEnabled = true;

  var faceSdk = FaceSDK.instance;

  var _status = "nil";
  var _similarityStatus = "nil";

  var _livenessStatus = "nil";

  var _uiImage1 = Image.asset(AppImages.attendance);
  var _uiImage2 = Image.asset(AppImages.attendance);

  set status(String val) => setState(() => _status = val);
  set similarityStatus(String val) => setState(() => _similarityStatus = val);
  set livenessStatus(String val) => setState(() => _livenessStatus = val);

  set uiImage1(Image val) => setState(() => _uiImage1 = val);
  set uiImage2(Image val) => setState(() => _uiImage2 = val);

  MatchFacesImage? mfImage1;
  MatchFacesImage? mfImage2;
  bool isSubmitted = false;

  void loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (loggedInUserSrNo != null) {
      String? storedAttendance =
          prefs.getString('attendanceData_$loggedInUserSrNo');
      if (storedAttendance != null) {
        List<dynamic> decodedList = json.decode(storedAttendance);
        attendanceList =
            decodedList.map((e) => Map<String, String>.from(e)).toList();
        setState(() {});
      }
    }
  }

  void submitAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (loggedInUserSrNo == null) {
      log("No logged-in user found.");
      return;
    }

    if (isFaceMatched && isButtonEnabled) {
      String currentDate =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      String currentTime =
          formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]);

      var todayAttendance = attendanceList.firstWhere(
        (entry) =>
            entry['date'] == currentDate && entry['srNo'] == loggedInUserSrNo,
        orElse: () => <String, String>{},
      );

      if (todayAttendance.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white),
                child: Padding(
                  padding: 25.symmetric,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alert",
                        style: poppinsStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      5.height,
                      Text(
                        "Are you sure want to submit attendance?",
                        style: poppinsStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      34.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 70,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.primarycolor,
                                ),
                              ),
                              onPressed: () async {
                                attendanceList.add({
                                  'date': currentDate,
                                  'in': currentTime,
                                  'out': '-',
                                  'srNo': loggedInUserSrNo,
                                });

                                prefs.setString(
                                    'attendanceData_$loggedInUserSrNo',
                                    json.encode(attendanceList));
                                String? attendanceData = prefs.getString(
                                    'attendanceData_$loggedInUserSrNo');
                                log("Attendance Data: $attendanceData");

                                setState(() {
                                  isButtonEnabled = false;
                                });

                                Navigator.pop(context);
                              },
                              child: Text(
                                "ok",
                                style:
                                    poppinsStyle(color: AppColors.primarycolor),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ).then((value) async {
          clearResults();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white),
                child: Padding(
                  padding: 25.symmetric,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alert",
                        style: poppinsStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      5.height,
                      Text(
                        "Are you sure want to submit attendance?",
                        style: poppinsStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      34.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 70,
                            child: primarybutton(
                              onPressed: () async {
                                todayAttendance['out'] = currentTime;

                                prefs.setString(
                                    'attendanceData_$loggedInUserSrNo',
                                    json.encode(attendanceList));
                                log("Updated Attendance Data: ${attendanceList}");

                                setState(() {
                                  isButtonEnabled = false;
                                });

                                Navigator.pop(context);
                              },
                              text: "ok",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },

          //     // TextButton(
          //     //   onPressed: () async {
          //     //     todayAttendance['out'] = currentTime;

          //     //     prefs.setString('attendanceData_$loggedInUserSrNo',
          //     //         json.encode(attendanceList));
          //     //     log("Updated Attendance Data: ${attendanceList}");

          //     //     setState(() {
          //     //       isButtonEnabled = false;
          //     //     });

          //     //     Navigator.pop(context);
          //     //   },
          //     //   child: const Text("OK"),
          //     // ),
          //   ],
          // ),
        ).then((value) async {
          clearResults();
        });
      }
    }
  }

  initData() async {
    // setState(() {
    //   isLoading = true;
    // });
    super.initState();
    if (!await initialize()) return;
    if (mounted) {
      // Check if widget is still in the tree
      setState(() {
        status = "Ready";
      });
    }
  }

  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;

    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  startLiveness() async {
    var result = await faceSdk.startLiveness(
      config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
      notificationCompletion: (notification) {
        print(notification.status);
      },
    );
    if (result.image == null) return;
    setImage(result.image!, ImageType.LIVE, 1);
    livenessStatus = result.liveness.name.toLowerCase();
  }

  Uint8List? profilePhoto;

  Future<void> profileImage() async {
    Uint8List? image = await getProfileImage();
    if (image != null) {
      setState(() {
        profilePhoto = image;
      });
    }
  }

//profileimage
  Future<Uint8List?> getProfileImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedData = prefs.getString('employeeData');
      String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

      if (storedData != null && loggedInUserSrNo != null) {
        List<dynamic> userProfileList = jsonDecode(storedData);

        Map<String, dynamic>? loggedInUser = userProfileList.firstWhere(
          (user) => user['srNo'] == loggedInUserSrNo,
          orElse: () => null,
        );
        if (loggedInUser != null) {
          String? imagePath = loggedInUser['image'];

          if (imagePath != null && File(imagePath).existsSync()) {
            return await File(imagePath).readAsBytes();
          }
        }
      }
      return null;
    } catch (e) {
      log("Error retrieving profile image: $e");
      return null;
    }
  }

  matchFaces() async {
    if (mfImage2 == null) {
      status = "Both images required!";
      return;
    }
    setState(() {
      status = "Processing...";
      isLoading = true;
    });

    Uint8List? profileImageData = await getProfileImage();

    if (profileImageData == null) {
      status = "Profile image not found!";
      isLoading = false;
      return;
    }

    var request = MatchFacesRequest([
      mfImage2!,
      MatchFacesImage(profileImageData, ImageType.LIVE),

      // MatchFacesImage(
      //     convertStringToUint8List(Settings.byteImage), ImageType.LIVE)
    ]);

    var response = await faceSdk.matchFaces(request);
    var split = await faceSdk.splitComparedFaces(response.results, 0.75);
    var match = split.matchedFaces;
    setState(() {
      similarityStatus = "failed";
      isFaceMatched = false;
      isButtonEnabled = false;

      if (match.isNotEmpty) {
        similarityStatus = "${(match[0].similarity * 100).toStringAsFixed(2)}%";
        isFaceMatched = true;
        isButtonEnabled = true;
      }

      status = "Ready";
      isLoading = false;
    });
  }

  clearResults() {
    status = "Ready";
    similarityStatus = "nil";
    uiImage2 = Image.asset(AppImages.attendance);
    mfImage1 = null;
    mfImage2 = null;
  }

  Future<bool> initialize() async {
    status = "Initializing...";
    var license = await loadAssetIfExists(
        "assets/license.txt"); // Make sure the license file is correct
    InitConfig? config = license != null ? InitConfig(license) : null;

    var (success, error) = await faceSdk.initialize(config: config);
    if (!success) {
      status = error!.message;
      print("${error.code}: ${error.message}");
    }
    return success;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  setImage(Uint8List bytes, ImageType type, int number) async {
    similarityStatus = "nil";
    var mfImage = MatchFacesImage(bytes, type);
    if (number == 1) {
      mfImage1 = mfImage;
    }
    if (number == 2) {
      mfImage2 = mfImage;
      uiImage2 = Image.memory(bytes);
      Uint8List imageInUnit8List = bytes;
      final tempDir = await getTemporaryDirectory();

      if (Platform.isAndroid) {
        File file = await File(
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg')
            .create();
        file.writeAsBytesSync(imageInUnit8List);
        // attendanceController.captureImage = file;
        await matchFaces();

        if (_similarityStatus == 'failed') {
          clearResults();

          await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white),
                  child: Padding(
                    padding: 25.symmetric,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alert",
                          style: poppinsStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        5.height,
                        Text(
                          "Face not matched. Please try again.",
                          style: poppinsStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        34.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 70,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                    color: AppColors.primarycolor,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "ok",
                                  style: poppinsStyle(
                                      color: AppColors.primarycolor),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  Widget useGallery(int number) {
    return textButton("Use gallery", () async {
      Navigator.pop(context);
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setImage(File(image.path).readAsBytesSync(), ImageType.PRINTED, number);
      }
    });
  }

  Widget useCamera(int number) {
    return textButton("Use camera", () async {
      Navigator.pop(context);
      var response = await faceSdk.startFaceCapture();
      var image = response.image;
      if (image != null) setImage(image.image, image.imageType, number);
    });
  }

  Widget image(Image image, Function() onTap) {
    HexagonPathBuilder pathBuilder = HexagonPathBuilder(
      HexagonType.FLAT, // or HexagonType.POINTY based on preference
      borderRadius: 20, // Adjust this for rounded corners
    );
    return Transform.flip(
      filterQuality: FilterQuality.high,
      flipX: true,
      child: GestureDetector(
        onTap: onTap,
        child: ClipPath(
            clipper: HexagonClipper(pathBuilder),
            // borderRadius: BorderRadius.circular(100),
            child: Image(
                height: 25.hp(context),
                width: 50.wp(context),
                image: image.image,
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget text(String text) => Text(text, style: poppinsStyle(fontSize: 18));
  Widget textButton(String text, Function() onPressed, {ButtonStyle? style}) =>
      TextButton(
        onPressed: onPressed,
        style: style,
        child: Text(text),
      );
  @override
  void dispose() {
    faceSdk
        .deinitialize(); // or cameraController.dispose() if using camera directly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(showBack: false, onTap: () {}, title: 'Attendance'),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                2.height,
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    image(_uiImage2, () async {
                      var response = await faceSdk.startFaceCapture();
                      var image = response.image;
                      if (image != null) {
                        setImage(image.image, image.imageType, 2);
                      }
                    }),
                    Positioned(
                      bottom: Get.height * 0.015,
                      right: Get.width * 0.09,
                      child: GestureDetector(
                        onTap: () async {
                          var response = await faceSdk.startFaceCapture();
                          // log("RESPONSE ---->> ${response.error.toString()}");
                          var image = response.image;
                          // log("IMAGE: $image");
                          if (image != null) {
                            setImage(image.image, image.imageType, 2);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.grey.withOpacity(0.2),
                                    spreadRadius: -1,
                                    blurRadius: 3)
                              ]),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.black,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                    if (isLoading)
                      Positioned(
                        // bottom: 50,
                        // left: 60,
                        bottom: 0,
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primarycolor,
                          ),
                        ),
                      ),
                  ],
                ),
                10.height,
                ElevatedButton(
                    onPressed: isFaceMatched && isButtonEnabled
                        ? submitAttendance
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(36),
                          ),
                        ),
                        // minimumSize: Size(160, 40),
                        backgroundColor: AppColors.primarycolor),
                    child: Text(
                      "Submit",
                      style: poppinsStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                7.height
              ],
            ),
          ),
          // 20.height,
          Expanded(
            flex: 5,
            child: Container(
              // height: 200,
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 1,
                    // offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: 10.symmetric,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        attendancerow(
                          text: "OnTime IN",
                          color: AppColors.green,
                        ),
                        attendancerow(
                          text: "OnTime OUT",
                          color: AppColors.red,
                        ),
                        attendancerow(
                          text: "Late IN",
                          color: AppColors.blue,
                        ),
                        attendancerow(
                          text: "Early OUT",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                    child: Row(
                      children: [
                        Expanded(
                          child: attendanceTableLabel(
                            label: 'Date',
                          ),
                        ),
                        Expanded(
                          child: attendanceTableLabel(
                            label: 'IN',
                          ),
                        ),
                        Expanded(
                          child: attendanceTableLabel(
                            label: 'OUT',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: attendanceList.isEmpty,
                      child: Expanded(child: commonLottie())),

                  Visibility(
                    visible: attendanceList.isNotEmpty,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                          },
                          children: [
                            /*    TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6)),
                              children: [
                                attendanceTableLabel(
                                  label: 'Date',
                                ),
                                attendanceTableLabel(
                                  label: 'IN',
                                ),
                                attendanceTableLabel(
                                  label: 'OUT',
                                ),
                              ],
                            ),*/

                            for (var attendance in attendanceList)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      attendance['date']!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      attendance['in']!,
                                      style: poppinsStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isBeforeNineAM(attendance['in']!)
                                                  ? AppColors.green
                                                  : AppColors.blue),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      attendance['out']!,
                                      style: poppinsStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isBeforesixPM(attendance['out']!)
                                                  ? AppColors.red
                                                  : Colors.orange),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: attendanceDatalist.length,
                  //     itemBuilder: (context, index) {
                  //       final item = attendanceDatalist[index];
                  //       return Column(
                  //         children: [
                  //           Table(
                  //             columnWidths: const {
                  //               0: FlexColumnWidth(4),
                  //               1: FlexColumnWidth(4),
                  //               2: FlexColumnWidth(3),
                  //             },
                  //             children: [
                  //               TableRow(
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(
                  //                         left: 10, bottom: 8, top: 8),
                  //                     child: Text(
                  //                       item['date'],
                  //                       style: style(
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 14,
                  //                       ),
                  //                       textAlign: TextAlign.center,
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: 8.vertical,
                  //                     child: Text(
                  //                       item['in'],
                  //                       style: style(
                  //                         color: AppColors.green,
                  //                         fontWeight: FontWeight.w400,
                  //                         fontSize: 14,
                  //                       ),
                  //                       textAlign: TextAlign.center,
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: 8.vertical,
                  //                     child: Text(
                  //                       item['out'],
                  //                       style: style(
                  //                         color: AppColors.red,
                  //                         fontWeight: FontWeight.w400,
                  //                         fontSize: 14,
                  //                       ),
                  //                       textAlign: TextAlign.center,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //           Padding(
                  //             padding: 10.horizontal,
                  //             child: Divider(
                  //               height: 5,
                  //               color: Colors.grey.withOpacity(0.5),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isBeforeNineAM(String inTime) {
  try {
    DateTime time = DateTime.now();
    DateTime nineAM = DateTime(time.year, time.month, time.day, 9, 0);
    return time.isBefore(nineAM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}

bool isBeforesixPM(String inTime) {
  try {
    DateTime time = DateTime.now();
    DateTime sixPM = DateTime(time.year, time.month, time.day, 6, 0);
    return time.isBefore(sixPM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}

Widget attendanceTableLabel({required label}) {
  return Padding(
    padding: 5.symmetric,
    child: Text(
      label,
      style: poppinsStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
