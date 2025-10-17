import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Models/ActsModels/myduty.dart';
import '../../../Models/ActsModels/typ_const.dart';
import '../../../helpers/constants.dart';
import '../../../theming/app_theme.dart';
import '../../../theming/apptheme_constant.dart';
import '../../3_Home/home_ctl.dart';

class CardeNextduty extends GetView<HomeController> {
  const CardeNextduty({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) async {
        HomeController.instance.sEtapes = HomeController.instance.getNextDutyText();
      },
      builder: (_) {
        MyDuty duty = HomeController.instance.myNextDuty;
        return Row(
          children: [
            if (duty.typ.target!.icon.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppTheme.getWidth(iphoneSize: 5, ipadsize: 5)),
                height: AppTheme.getheight(iphoneSize: 50, ipadsize: 50),
                width: AppTheme.getheight(iphoneSize: 40, ipadsize: 55),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    // (MyStylingController.instance.isDarkMode.value != true)
                    //     ? Colors.black
                    //     : Colors.red.shade200,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(AppTheme.r(x: 25.0))),
                ),
                child: CircleAvatar(backgroundImage: AssetImage('$cheminImage${duty.typ.target!.icon}.jpg')),
              ),
            if (duty.typ.target!.color.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: AppTheme.w(x: 5), right: AppTheme.w(x: 10)),
                width: 5,
                color: HexColor(duty.typ.target!.color),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duty.dateLabel.toUpperCase(),
                    style: AppStylingConstant.nextDutyDateStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (duty.typ.target != tVols && duty.typ.target != tRotation)
                    Text(
                      duty.typeLabel.toUpperCase(),
                      style: AppStylingConstant.nextDutyTypeStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(
                    width: AppTheme.w(x: 186),
                    child: Text(
                      duty.typ.target != tRotation
                          ? duty.detailLabel.toUpperCase()
                          : '${'card_hotel'.tr}: ${duty.detailLabel.toUpperCase()}',
                      style: AppStylingConstant.nextDutyDetailStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (duty.typ.target == tVols || duty.typ.target == tRotation)
                    Obx(
                      () => (HomeController.instance.sEtapes.isNotEmpty)
                          ? SizedBox(
                              child: Obx(
                                () => Text(
                                  HomeController.instance.sEtapes[0],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppStylingConstant.nextDutyDetailStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                ],
              ),
            ),
            if (duty.typ.target!.color.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: AppTheme.w(x: 5), right: AppTheme.w(x: 10)),
                width: 5,
                color: HexColor(duty.typ.target!.color),
              ),
            Obx(
              () => (HomeController.instance.sEtapes.isNotEmpty)
                  ? SizedBox(
                      height: AppTheme.getheight(iphoneSize: 50, ipadsize: 50),
                      width: AppTheme.getheight(iphoneSize: 45, ipadsize: 60),
                      child: Center(
                        child: Text(
                          HomeController.instance.sEtapes[1],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppStylingConstant.nextDutyStepStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
