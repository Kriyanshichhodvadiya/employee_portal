// import 'package:employeeform/common/comman_widget.dart';
// import 'package:employeeform/common/global_widget.dart';
// import 'package:employeeform/config/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../controller/leavecontroller.dart';
// import '../../controller/userdashboard_controller.dart';
//
// class AddLeaveScreen extends StatelessWidget {
//   const AddLeaveScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     UserDashBoardController userDashBoardController = Get.find();
//     LeaveController leaveController = Get.put(LeaveController());
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: appBar(
//           title: 'Apply for Leave',
//           onTap: () {
//             Get.back();
//           },
//           showBack: true),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: 10.symmetric,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         addLeaveLabel(
//                           label: "From Date",
//                         ),
//                         Obx(
//                           () => commonDateCon(
//                             label: leaveController.startDate.value.isEmpty
//                                 ? 'Select Date'
//                                 : leaveController.startDate.value,
//                             onTap: () {
//                               leaveController.selectDate(context, true);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   10.width,
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         addLeaveLabel(
//                           label: "To Date",
//                         ),
//                         Obx(
//                           () => commonDateCon(
//                             label: leaveController.endDate.value.isEmpty
//                                 ? 'Select Date'
//                                 : leaveController.endDate.value,
//                             onTap: () {
//                               leaveController.selectDate(context, false);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               addLeaveLabelHeight(),
//               addLeaveLabel(
//                 label: "Reason for Leave",
//               ),
//               commontextfield(
//                 onChanged: (value) => leaveController.reason.value = value,
//                 controller: leaveController.reasonController.value,
//                 maxLines: 3,
//                 text: "Enter reason...",
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your Reason for Leave';
//                   }
//
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               primarybutton(
//                 onPressed: () => leaveController.addLeaveRequest(),
//                 text: "Submit Leave",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
