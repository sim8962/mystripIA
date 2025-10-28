import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/allduties.dart';
import 'duty_list_controller.dart';

class DutyListScreen extends GetView<DutyListController> {
  const DutyListScreen({super.key});
  //() => Get.toNamed(Routes.downloadsListScreen),
  @override
  Widget build(BuildContext context) {
    // Schedule scroll after widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.duties.isNotEmpty) {
        controller.jumpToDutys();
      }
    });

    return Column(
      children: [
        Expanded(
          child: Obx(
            () => controller.duties.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Allduties(duties: controller.duties, scrollController: controller.myDutyScrollController),
          ),
        ),
      ],
    );
  }
}
