import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/global_widget.dart';

class PaymentRecord extends StatelessWidget {
  const PaymentRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: 'Payment Record',
          onTap: () {
            Get.back();
          },
          showBack: true),
      body: Column(
        children: [],
      ),
    );
  }
}
