// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/constants.dart';
import '../../routes/app_routes.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';
import '../widgets/background_container.dart';
import '../widgets/mybutton.dart';
import '../widgets/myswitch.dart';
import '../widgets/mytextfields.dart';
import 'register_ctl.dart';

class RegisterScreen extends GetView<RegisterController> {
  RegisterScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      initState: (_) async {
        // await RegisterJsonController.instance.addDataToBox(context);
      },
      builder: (_) {
        //return oldSc(_formKey);
        return BackgroundContainer(
          child: Padding(
            // height: MyStyling.myHeight,
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 24, ipadsize: 24)),
            child: Column(
              children: [
                Icon(
                  Icons.flight_takeoff,
                  size: AppTheme.getheight(iphoneSize: 90, ipadsize: 120),
                  color: Colors.white,
                ),
                SizedBox(height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15)),
                Text('register_title'.tr, style: AppStylingConstant.registerScreen),
                SizedBox(height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15)),
                // Form
                Expanded(
                  child: SizedBox(
                    // height: MyStyling.myHeight,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyTextFields(
                            controller: RegisterController.instance.matController,
                            labelText: 'matricule_label'.tr,
                            prefixIcon: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'matricule_error'.tr;
                              }
                              return null;
                            },
                          ),
                          MyTextFields(
                            controller: RegisterController.instance.emailController,
                            labelText: 'email_label'.tr,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'email_error'.tr;
                              }
                              return null;
                            },
                          ),
                          MyTextFields(
                            controller: RegisterController.instance.passController,
                            labelText: 'password_label'.tr,
                            prefixIcon: Icons.lock_outline,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'password_error'.tr;
                              }
                              return null;
                            },
                          ),
                          Obx(
                            () => MySwitch(
                              width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180),
                              height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60),

                              labeltext: 'switch_pnt_pnc'.tr,
                              smalllabeltext: RegisterController.instance.spntpnc,
                              ichoice: 5,
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: !RegisterController.instance.ispnt,
                              child: MySwitch(
                                width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180),
                                height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60),
                                labeltext: 'switch_ram_ams'.tr,
                                smalllabeltext: RegisterController.instance.samsram,
                                ichoice: 1,
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: !RegisterController.instance.ispnt,
                              child: MySwitch(
                                width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180),
                                height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60),

                                labeltext: 'switch_secteur'.tr,
                                smalllabeltext: RegisterController.instance.sSecteur,
                                ichoice: 2,
                              ),
                            ),
                          ),
                          Obx(
                            () => RegisterController.instance.dones
                                ? MyButton(
                                    width: 170,
                                    label: 'button_register'.tr,
                                    func: () async {
                                      if (_formKey.currentState!.validate()) {
                                        RegisterController.instance.registerUser();
                                        Routes.toWebview();
                                      }
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      //value: myProgress,
                                      color: AppColors.primaryLightColor,
                                      strokeWidth: 7,
                                    ),
                                  ),
                          ),
                        ],
                      ),
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
}
