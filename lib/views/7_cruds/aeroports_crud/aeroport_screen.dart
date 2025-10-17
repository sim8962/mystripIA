import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/jsonModels/datas/airport_model.dart';
import '../../../helpers/myerrorinfo.dart';
import '../../widgets/mydialogue.dart';
import 'aeroport_controller.dart';

import '../../../routes/app_routes.dart';
import '../../../theming/app_theme.dart';
import '../../widgets/background_container.dart';
import '../../widgets/mybutton.dart';
import '../../widgets/mytext.dart';
import '../../widgets/mytextfields.dart';

class AeroportScreen extends GetView<AerportService> {
  AeroportScreen({super.key});
  final _airPsrv = AerportService.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _icaoController = TextEditingController();
  final TextEditingController _iataController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _altitudeController = TextEditingController();
  final mywiddth = 165.0;
  final mywidth = 200.0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AerportService>(
      builder: (_) {
        return BackgroundContainer(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.getheight(iphoneSize: 24, ipadsize: 24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(height: AppTheme.getheight(iphoneSize: 20, ipadsize: 5)),
                Padding(
                  padding: EdgeInsets.all(AppTheme.w(x: 10)),
                  child: MyTextWidget(label: 'crud_airport_title'.tr),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // MyButton(
                    //   width: AppTheme.getWidth(iphoneSize: 140, ipadsize: 180),
                    //   label: 'button_import'.tr,
                    //   func: () async {
                    //     try {
                    //       //await JsonController.instance.addAeroportsToBox();
                    //       Get.snackbar('success'.tr, 'success_airport_imported'.tr);
                    //     } catch (e) {
                    //       //print('Error importing forfaits: $e');
                    //       Get.snackbar('error'.tr, 'error_import_failed'.tr);
                    //     }
                    //   },
                    // ),
                    MyButton(
                      width: AppTheme.getWidth(iphoneSize: 140, ipadsize: 180),
                      label: 'button_return'.tr,
                      func: () {
                        Routes.toHome();
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
                Expanded(
                  child: SizedBox(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _icaoController,
                                  labelText: 'label_icao'.tr,
                                  prefixIcon: Icons.flight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_icao'.tr;
                                    }
                                    if (value.length < 3 || value.length > 4) {
                                      return 'error_icao_length'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _iataController,
                                  labelText: 'label_iata'.tr,
                                  prefixIcon: Icons.flight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_iata'.tr;
                                    }
                                    if (value.length < 3 || value.length > 4) {
                                      return 'error_iata_length'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          MyButton(
                            width: AppTheme.getWidth(iphoneSize: 140, ipadsize: 180),
                            label: 'button_search'.tr,
                            func: () async {
                              try {
                                if (_icaoController.text.isEmpty && _iataController.text.isEmpty) {
                                  MyErrorInfo.erreurInos(
                                    label: 'AeroportScreen',
                                    content: 'Veuillez entrer un code ICAO ou IATA pour rechercher',
                                  );
                                  return;
                                }
                                AeroportModel? aeroportModel = _icaoController.text.isNotEmpty
                                    ? _airPsrv.getAeroportByIata(
                                        search: _icaoController.text.trim().toUpperCase(),
                                      )
                                    : _airPsrv.getAeroportByIata(
                                        search: _iataController.text.trim().toUpperCase(),
                                      );

                                if (aeroportModel != null) {
                                  updateTextFields(aeroportModel);
                                  // Get.snackbar('Succès', 'Aéroport trouvé avec succès');
                                  return;
                                }
                                Get.snackbar('Erreur', 'Aéroport non trouvé');
                                clearTextFields();
                                MyDialogue.dialogue(
                                  title: 'telecharger',
                                  action1: 'button_import'.tr,
                                  smiddleText: """on recupere les infos de l'aeroport""",
                                  func: () async {
                                    AeroportModel? aeroportModel = _icaoController.text.isNotEmpty
                                        ? await _airPsrv.fetchAirportFromApiByIcao(
                                            icao: _icaoController.text.trim().toUpperCase(),
                                          )
                                        : await _airPsrv.fetchAirportFromApiByIata(
                                            iata: _icaoController.text.trim().toUpperCase(),
                                          );
                                    if (aeroportModel != null) {
                                      updateTextFields(aeroportModel);
                                      // Get.snackbar('Succès', 'Aéroport trouvé avec succès');
                                      return;
                                    } else {
                                      MyErrorInfo.erreurInos(
                                        label: 'AeroportScreen',
                                        content: 'Aucun aeroport trouve avec  code ICAO ou IATA ',
                                      );
                                    }
                                  },
                                );
                              } catch (e) {
                                MyErrorInfo.erreurInos(
                                  label: 'AeroportScreen',
                                  content: 'Échec de la recherche d\'aéroport ',
                                );
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _nameController,
                                  labelText: 'label_name'.tr,
                                  prefixIcon: Icons.location_city,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_name'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _altitudeController,
                                  labelText: 'label_altitude'.tr,
                                  prefixIcon: Icons.height,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_altitude'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _cityController,
                                  labelText: 'label_city'.tr,
                                  prefixIcon: Icons.location_city,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_city'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _countryController,
                                  labelText: 'label_country'.tr,
                                  prefixIcon: Icons.map,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_country'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _latitudeController,
                                  labelText: 'label_latitude'.tr,
                                  prefixIcon: Icons.map,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_latitude'.tr;
                                    }
                                    final latitude = double.tryParse(value);
                                    if (latitude == null) {
                                      return 'error_invalid_latitude'.tr;
                                    }
                                    if (latitude < -90 || latitude > 90) {
                                      return 'error_latitude_range'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: AppTheme.getWidth(iphoneSize: mywiddth, ipadsize: mywidth),
                                child: MyTextFields(
                                  controller: _longitudeController,
                                  labelText: 'label_longitude'.tr,
                                  prefixIcon: Icons.map,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'error_enter_longitude'.tr;
                                    }
                                    final longitude = double.tryParse(value);
                                    if (longitude == null) {
                                      return 'error_invalid_longitude'.tr;
                                    }
                                    if (longitude < -180 || longitude > 180) {
                                      return 'error_longitude_range'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          MyButton(
                            width: AppTheme.getWidth(iphoneSize: 140, ipadsize: 180),
                            label: 'button_add'.tr,
                            func: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  AerportService.instance.saveOrUpdateAirportFromForm(
                                    icaoCtl: _icaoController,
                                    iataCtl: _iataController,
                                    nameCtl: _nameController,
                                    cityCtl: _cityController,
                                    countryCtl: _countryController,
                                    latCtl: _latitudeController,
                                    lngCtl: _longitudeController,
                                    altCtl: _altitudeController,
                                  );
                                } catch (e) {
                                  Get.snackbar('error'.tr, 'error_add_failed'.tr);
                                }
                              }
                            },
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

  //function for clear textfields after successfull search
  void clearTextFields() {
    _icaoController.clear();
    _iataController.clear();
    _nameController.clear();
    _cityController.clear();
    _countryController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _altitudeController.clear();
  }

  // function to update all the fields
  void updateTextFields(AeroportModel aeroport) {
    _icaoController.text = aeroport.icao;
    _iataController.text = aeroport.iata;
    _nameController.text = aeroport.name;
    _cityController.text = aeroport.city;
    _countryController.text = aeroport.country;
    _latitudeController.text = aeroport.latitude.toString();
    _longitudeController.text = aeroport.longitude.toString();
    _altitudeController.text = aeroport.altitude;
  }
}
