import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/constants.dart';
import '../../../routes/app_routes.dart';
import '../../../theming/app_color.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';
import '../../widgets/background_container.dart';
import '../../widgets/mybutton.dart';
import '../../widgets/mydialogue.dart';
import '../../widgets/myswitch.dart';
import '../../widgets/mytext.dart';
import '../../widgets/mytextfields.dart';

import 'forfait_controller.dart';

class ForfaitScreen extends GetView<ForfaitController> {
  const ForfaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForfaitController>(
      builder: (_) {
        return BackgroundContainer(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 24, ipadsize: 24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  SizedBox(height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15)),
                Padding(
                  padding: EdgeInsets.all(AppTheme.w(x: 10)),
                  child: MyTextWidget(label: 'crud_forfait_title'.tr),
                ),
                (boxGet.read(getDevice) == getIphone)
                    ? Column(
                        children: [
                          Obx(
                            () => ForfaitController.instance.isLoading
                                ? const SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryLightColor,
                                        strokeWidth: 7,
                                      ),
                                    ),
                                  )
                                : MyButton(
                                    width: AppTheme.getWidth(iphoneSize: 200, ipadsize: 180),
                                    label: 'button_import'.tr,
                                    func: () async {
                                      MyDialogue.dialogue(
                                        title: 'import excels',
                                        action1: 'button_import'.tr,
                                        smiddleText: 'les noms des fichiers doivent etre MoisAnne.xlsx',
                                        func: () async {
                                          //await ForfaitController.instance.getForfaitFromAllExcel();
                                          await ForfaitController.instance.getForfaitFromAllExcelOptimized();
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      )
                    : MyButton(
                        width: AppTheme.getWidth(iphoneSize: 140, ipadsize: 180),
                        label: 'button_import'.tr,
                        func: () async {
                          MyDialogue.dialogue(
                            title: 'import excels',
                            action1: 'button_import'.tr,
                            smiddleText: 'les noms des fichiers doivent etre MoisAnne.xlsx',
                            func: () async {
                              await ForfaitController.instance.getForfaitFromAllExcelOptimized();

                              //   await ForfaitController.instance.getForfaitFromAllExcel();
                            },
                          );
                        },
                      ),

                Expanded(
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: AppTheme.getheight(iphoneSize: 300, ipadsize: 360),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Obx(
                                  //   () => SizedBox(
                                  //     // width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 180),
                                  //     child: MySwitch(
                                  //       smalllabeltext: '',
                                  //       labeltext: ForfaitController.instance.sSaison,
                                  //       ichoice: 3,
                                  //     ),
                                  //   ),
                                  // ),
                                  Obx(
                                    () => MySwitch(
                                      width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 120),
                                      height: AppTheme.getheight(iphoneSize: 55, ipadsize: 60),
                                      smalllabeltext: '',
                                      labeltext: ForfaitController.instance.sSaison,
                                      ichoice: 3,
                                    ),
                                  ),
                                  Obx(
                                    () => MySwitch(
                                      width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 120),
                                      height: AppTheme.getheight(iphoneSize: 55, ipadsize: 60),
                                      smalllabeltext: '',
                                      labeltext: ForfaitController.instance.sSecteur,
                                      ichoice: 4,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 180),
                                    child: MyTextFields(
                                      controller: ForfaitController.instance.depController,
                                      labelText: 'label_dep'.tr,
                                      prefixIcon: Icons.flight_takeoff,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppTheme.getWidth(iphoneSize: 160, ipadsize: 180),
                                    child: MyTextFields(
                                      controller: ForfaitController.instance.arrController,
                                      labelText: 'label_arr'.tr,
                                      prefixIcon: Icons.flight_land,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyButton(
                                    label: 'button_search'.tr,
                                    width: AppTheme.getWidth(iphoneSize: 150, ipadsize: 180),
                                    func: () {
                                      ForfaitController.instance.getmyLists();
                                    },
                                  ),
                                  MyButton(
                                    label: 'button_quit'.tr,
                                    width: AppTheme.getWidth(iphoneSize: 150, ipadsize: 180),
                                    func: () {
                                      Routes.toHome();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Obx(
                            () => ForfaitController.instance.forfaits.isEmpty
                                ? SizedBox()
                                : ListView.builder(
                                    itemCount: ForfaitController.instance.forfaits.length,
                                    itemBuilder: (context, index) {
                                      final forfait = ForfaitController.instance.forfaits[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppTheme.isDark
                                              ? Colors.white.withAlpha(40)
                                              : Colors.white.withAlpha(100),
                                          borderRadius: BorderRadius.circular(AppTheme.r(x: 10)),
                                        ),
                                        child: ListTile(
                                          title: Text('${forfait.dateForfait} '),
                                          subtitle: Text(
                                            '${forfait.depICAO} - ${forfait.arrICAO} :Forfait: ${forfait.forfait}',
                                            style: AppStylingConstant.nextDutyDateStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: ForfaitController.instance.startDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2030),
  //     initialDatePickerMode: DatePickerMode.year,
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: (AppTheme.isDark ? AppTheme.appDarkTheme : AppTheme.appLightTheme).copyWith(
  //           datePickerTheme: DatePickerThemeData(
  //             dayStyle: TextStyle(fontSize: 0), // Hide days
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (pickedDate != null) {
  //     // Set to first day of the selected month
  //     ForfaitController.instance.startDate = DateTime(pickedDate.year, pickedDate.month, 1);
  //     ForfaitController.instance.update();
  //   }
  // }
}
