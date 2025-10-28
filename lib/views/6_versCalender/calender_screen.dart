import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../helpers/myerrorinfo.dart';
import '../../routes/app_routes.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import '../widgets/background_container.dart';
import '../widgets/mybutton.dart';
import '../widgets/mytext.dart';
import '../widgets/selected_date.dart';
import 'calender_controller.dart';

class CalenderScreen extends GetView<VersCalenderCtl> {
  const CalenderScreen({super.key});

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{WidgetState.selected};
    if (states.any(interactiveStates.contains)) {
      return Color(VersCalenderCtl.instance.calendars[VersCalenderCtl.instance.intChoice].color!);
      // return Colors.red;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return GetBuilder<VersCalenderCtl>(
      initState: (_) async {
        // HomeJsonController.instance.volTraiteLists.addAll(DataController.instance.volTraiteLists);
      },
      builder: (_) {
        return BackgroundContainer(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.w(x: 5)),

            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: AppTheme.h(x: 30)),
                MyTextWidget(label: 'calendar_create_sync'.tr),
                SizedBox(height: AppTheme.h(x: 15)),
                _buildDateSelectionRow(context),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: (boxGet.read(getDevice) == getIphone)
                      ? const BtnExportCalender()
                      : const BtnExportIpadCalender(),
                ),
                Padding(
                  padding: EdgeInsets.all(AppTheme.w(x: 40)),
                  child: MyTextWidget(
                    label:
                        '${'calendar_export_date'.tr}: ${dateFormatDD.format(VersCalenderCtl.instance.startDate)} ${'calendar_and_before'.tr} ${dateFormatDD.format(VersCalenderCtl.instance.endDate)}',
                  ),
                ),
                Obx(
                  () =>
                      !VersCalenderCtl.instance.permissionGranted
                      ? Padding(
                          padding: EdgeInsets.all(AppTheme.w(x: 10)),
                          child: MyTextWidget(label: VersCalenderCtl.instance.permissionError.isNotEmpty 
                              ? VersCalenderCtl.instance.permissionError 
                              : 'error_calendar_permission_denied'.tr),
                        )
                      : (VersCalenderCtl.instance.calendars.isEmpty ||
                          VersCalenderCtl.instance.addCalender == true)
                      ? Padding(
                          padding: EdgeInsets.all(AppTheme.w(x: 10)),
                          child: MyTextWidget(label: 'calendar_none_found'.tr),
                        )
                      : (boxGet.read(getDevice) == getIphone)
                      ? SizedBox(
                          height: h - 400,
                          child: ListView.builder(
                            itemCount: VersCalenderCtl.instance.intLenght,
                            itemBuilder: (BuildContext context, int index) {
                              return myBoxCheck(i: index);
                            },
                          ),
                        )
                      : SizedBox(
                          height: h * 0.35,
                          child: GridView.builder(
                            //padding:  EdgeInsets.all(MyStyling.h(x:5)),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 3,
                              childAspectRatio: 8,
                            ),
                            itemCount: VersCalenderCtl.instance.intLenght,
                            itemBuilder: (BuildContext context, int index) {
                              return myBoxCheck(i: index);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ), // This closes the SingleChildScrollView
        );
      },
    );
  }

  Widget _buildDateSelectionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Obx(
            () => SelectedDate(
              label: '${'date_from'.tr}: ${dateFormatDD.format(VersCalenderCtl.instance.startDate)}',
              func: () => _selectStartDate(context),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => SelectedDate(
              label: '${'date_to'.tr}: ${dateFormatDD.format(VersCalenderCtl.instance.endDate)}',
              func: () => _selectEndDate(context),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: VersCalenderCtl.instance.startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: AppTheme.isDark ? AppTheme.appDarkTheme : AppTheme.appLightTheme, child: child!);
      },
    );
    if (pickedDate != null) {
      VersCalenderCtl.instance.startDate = pickedDate;
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: VersCalenderCtl.instance.endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: AppTheme.isDark ? AppTheme.appDarkTheme : AppTheme.appLightTheme, child: child!);
      },
    );
    if (pickedDate != null) {
      VersCalenderCtl.instance.endDate = pickedDate;
      // HomeController.instance.getvols();
    }
  }

  Widget myBoxCheck({required int i}) => Obx(
    () => Container(
      height: (boxGet.read(getDevice) == getIphone) ? AppTheme.h(x: 60) : AppTheme.h(x: 10),
      width: AppTheme.myWidthiphone,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBackground : AppColors.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
          color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
        ),
      ),
      child: CheckboxListTile(
        fillColor: WidgetStateProperty.resolveWith(getColor),
        checkColor: Colors.white,
        activeColor: Color(VersCalenderCtl.instance.calendars[i].color!),
        value: VersCalenderCtl.instance.intChoice == i ? true : false,
        // VersCalenderCtl.instance.idCalendar == VersCalenderCtl.instance.calendars[i].id! ? true : false,
        title: Row(
          children: [
            Container(
              width: AppTheme.w(x: 15),
              height: AppTheme.h(x: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(VersCalenderCtl.instance.calendars[i].color!),
              ),
            ),
            SizedBox(width: AppTheme.w(x: 10)),
            Expanded(
              flex: 1,
              child: Text(
                VersCalenderCtl.instance.calendars[i].name!.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: AppStylingConstant.nomcalender,
              ),
            ),
            SizedBox(width: AppTheme.w(x: 10)),
          ],
        ),
        onChanged: (newValue) {
          VersCalenderCtl.instance.intChoice = i;
          //VersCalenderCtl.instance.idCalendar = VersCalenderCtl.instance.calendars[i].id!;
          // VersCalenderCtl.instance.checkUpdate();
        },
      ),
    ),
  );
}

class BtnExportCalender extends StatelessWidget {
  const BtnExportCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MyButton(
              width: AppTheme.w(x: 150),
              label: 'calendar_with_hotel'.tr,
              //btn: 0,
              func: () async {
                VersCalenderCtl.instance.isHtl = true;

                await VersCalenderCtl.instance.addSelectedEvents();
                Get.defaultDialog(
                  title: 'calendar_export_complete'.tr,
                  middleText: '',
                  titleStyle: AppStylingConstant.calendarDialogTitleStyle,
                  //  titleStyle: MyStyling.labelMedium(),
                  titlePadding: EdgeInsets.symmetric(
                    vertical: AppTheme.s(x: 15),
                    horizontal: AppTheme.s(x: 4),
                  ),
                  // middleTextStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color.fromARGB(255, 235, 244, 249),
                  actions: [
                    Column(
                      children: [
                        MyButton(
                          label: 'button_close'.tr,
                          func: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ],
                  barrierDismissible: false,
                  radius: AppTheme.r(x: 20),
                );
              },
            ),
            MyButton(
              width: AppTheme.w(x: 150),
              label: 'calendar_without_hotel'.tr,
              //btn: 0,
              func: () async {
                VersCalenderCtl.instance.isHtl = false;
                await VersCalenderCtl.instance.addSelectedEvents();
                Get.defaultDialog(
                  title: 'calendar_export_complete'.tr,
                  middleText: '',
                  titleStyle: AppStylingConstant.calendarDialogTitleStyle,
                  //  titleStyle: MyStyling.labelMedium(),
                  titlePadding: EdgeInsets.symmetric(
                    vertical: AppTheme.s(x: 15),
                    horizontal: AppTheme.s(x: 4),
                  ),
                  // middleTextStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color.fromARGB(255, 235, 244, 249),
                  actions: [
                    Column(
                      children: [
                        MyButton(
                          label: 'button_close'.tr,
                          func: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ],
                  barrierDismissible: false,
                  radius: AppTheme.r(x: 20),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            MyButton(
              width: AppTheme.w(x: 150),
              label: 'button_quit'.tr,
              // btn: 0,
              func: () {
                VersCalenderCtl.instance.addCalender = false;
                boxGet.read(getDevice) == getIphone
                    ? Routes.toHome()
                    : VersCalenderCtl.instance.isExportCalender = !VersCalenderCtl.instance.isExportCalender;
              },
            ),
          ],
        ),
      ],
    );
  }
}

class BtnExportIpadCalender extends StatelessWidget {
  const BtnExportIpadCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyButton(
          label: 'calendar_export_with_hotel'.tr,
          //btn: 0,
          func: () async {
            VersCalenderCtl.instance.isHtl = true;

            await VersCalenderCtl.instance.addSelectedEvents();
            MyErrorInfo.erreurInos(
              label: 'calendar_export_with_hotel'.tr,
              content: 'calendar_export_done'.tr,
            );
            Routes.toHome();
          },
        ),
        MyButton(
          label: 'calendar_export_without_hotel'.tr,
          //btn: 0,
          func: () async {
            VersCalenderCtl.instance.isHtl = false;
            await VersCalenderCtl.instance.addSelectedEvents();
            MyErrorInfo.erreurInos(
              label: 'calendar_export_without_hotel'.tr,
              content: 'calendar_export_done'.tr,
            );
            Routes.toHome();
          },
        ),
        MyButton(
          label: 'calendar_add_calendar'.tr,
          // btn: 0,
          func: () {
            VersCalenderCtl.instance.addCalender = true;
          },
        ),
        MyButton(
          label: 'button_quit'.tr,
          // btn: 0,
          func: () {
            VersCalenderCtl.instance.addCalender = false;
            Routes.toHome();
          },
        ),
      ],
    );
  }
}
