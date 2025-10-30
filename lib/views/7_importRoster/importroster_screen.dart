// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/VolsModels/vol_traite_mois.dart';

import '../../Models/volpdfs/chechplatform.dart';
import '../../controllers/database_controller.dart';
import '../../routes/app_routes.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../widgets/background_container.dart';
import '../widgets/mybutton.dart';
import '../widgets/mylistfile_widget.dart';
import '../widgets/mytext.dart';
import 'importroster_ctl.dart';

class ImportRosterScreen extends GetView<ImportrosterCtl> {
  const ImportRosterScreen({super.key});

  // Responsive Constants using AppTheme
  static double get _horizontalPadding => AppTheme.w(x: 10);
  static double get _verticalPadding => AppTheme.w(x: 10);
  static double get _listHeight => AppTheme.h(x: 650);
  static double get _listHeightDone => AppTheme.h(x: 650);
  static double get _borderRadius => AppTheme.r(x: 8);
  static double get _shadowBlur => AppTheme.w(x: 20);
  static double get _shadowOffsetX => AppTheme.w(x: 5);
  static double get _shadowOffsetY => AppTheme.h(x: 5);
  static double get _buttonWidth => AppTheme.w(x: 150);
  static double get _largeButtonWidth => AppTheme.w(x: 170);
  static double get _spacingSmall => AppTheme.w(x: 5);
  static double get _spacingMedium => AppTheme.w(x: 10);
  static double get _spacingLarge => AppTheme.h(x: 20);
  static const Color _progressBgColor = Color.fromARGB(255, 245, 13, 13);
  static const Color _progressColor = Colors.blue;
  static const Color _shadowColor = Color.fromARGB(255, 60, 85, 121);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Obx(() => _buildContent(controller.etape)),
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate content based on the current step
  Widget _buildContent(int etape) {
    return switch (etape) {
      0 => _buildStepOne(),
      1 => _buildStepTwo(),
      2 => _buildStepThree(),
      _ => const SizedBox.shrink(),
    };
  }

  /// Step 1: File selection
  Widget _buildStepOne() {
    return Padding(
      padding: EdgeInsets.all(_verticalPadding),
      child: Column(
        children: [
          SizedBox(height: AppTheme.getheight(iphoneSize: 10, ipadsize: 10)),
          MyTextWidget(label: 'import_instructions'.tr),
          SizedBox(height: _spacingLarge),
          MyButton(width: _largeButtonWidth, label: 'button_import pdf'.tr, func: _handleFileSelection),
        ],
      ),
    );
  }

  /// Step 2: File processing with stream
  Widget _buildStepTwo() {
    return StreamBuilder<List<ChechPlatFormMonth>>(
      stream: controller.getStreamPlatformFile(),
      builder: (context, snapshot) => _buildStreamContent(snapshot),
    );
  }

  /// Step 3: Display monthly data with stream
  Widget _buildStepThree() {
    return StreamBuilder<List<VolTraiteMoisModel>>(
      stream: controller.getStreamVolTraiteMoisModels(),
      builder: (context, snapshot) => _buildStepThreeContent(snapshot),
    );
  }

  /// Builds step 3 content based on stream state
  Widget _buildStepThreeContent(AsyncSnapshot<List<VolTraiteMoisModel>> snapshot) {
    return switch (snapshot.connectionState) {
      ConnectionState.none => _buildErrorState('error_null'.tr),
      ConnectionState.waiting => _buildLoadingState(),
      ConnectionState.active => _buildMonthsProcessing(snapshot),
      ConnectionState.done => _buildMonthsProcessing(snapshot),
    };
  }

  /// Displays months as they are processed
  Widget _buildMonthsProcessing(AsyncSnapshot<List<VolTraiteMoisModel>> snapshot) {
    if (snapshot.hasError) {
      return _buildErrorState('Error ${snapshot.error}');
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildLoadingState();
    }

    final months = snapshot.data!;

    return Padding(
      padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 10, ipadsize: 10)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                MyButton(
                  width: _buttonWidth,
                  label: 'button_save'.tr,
                  func: () {
                    DatabaseController.instance.addVolPdfLists(controller.volPdfLists);
                    controller.etape = 0;
                    Routes.toHome();
                  },
                ),
                MyButton(
                  width: _buttonWidth,
                  label: 'button_return'.tr,
                  func: () {
                    controller.etape = 0;
                    Routes.toHome();
                  },
                ),
              ],
            ),
            ...List.generate(months.length, (index) {
              final volTraiteMois = months[index];
              return _buildMonthSection(volTraiteMois);
            }),
          ],
        ),
      ),
    );
  }

  /// Handles stream states and builds appropriate UI
  Widget _buildStreamContent(AsyncSnapshot<List<ChechPlatFormMonth>> snapshot) {
    return switch (snapshot.connectionState) {
      ConnectionState.none => _buildErrorState('error_null'.tr),
      ConnectionState.waiting => _buildLoadingState(),
      ConnectionState.active => _buildActiveState(snapshot),
      ConnectionState.done => _buildDoneState(snapshot),
    };
  }

  /// Loading state with progress indicator
  Widget _buildLoadingState() {
    return _ImportContainer(
      header: const SizedBox.shrink(),
      child: Center(
        child: CircularProgressIndicator(backgroundColor: _progressBgColor, color: _progressColor),
      ),
    );
  }

  /// Active state showing processing progress
  Widget _buildActiveState(AsyncSnapshot<List<ChechPlatFormMonth>> snapshot) {
    if (snapshot.hasError) {
      return _buildErrorState('Error ${snapshot.error}');
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildErrorState('No Data');
    }

    final processedCount = snapshot.data!.length;
    final totalCount = controller.platformFiles.length;

    return _ImportContainer(
      header: MyTextWidget(label: '$processedCount/$totalCount ${'Fichiers en traitement'.tr}'),
      child: SizedBox(
        height: _listHeight,
        child: MyListFile(typ: 1, myChechPlatFormMonth: snapshot.data!),
      ),
    );
  }

  /// Done state with action buttons
  Widget _buildDoneState(AsyncSnapshot<List<ChechPlatFormMonth>> snapshot) {
    if (snapshot.hasError) {
      return _buildErrorState('Error ${snapshot.error}');
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildErrorState('error_no_data'.tr);
    }

    return _ImportContainer(
      header: _buildActionButtons(),
      child: SizedBox(
        height: _listHeightDone,
        child: MyListFile(typ: 1, myChechPlatFormMonth: snapshot.data!),
      ),
    );
  }

  /// Error state
  Widget _buildErrorState(String message) {
    return Center(child: MyTextWidget(label: message));
  }

  /// Action buttons for import/return
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyButton(
          width: _buttonWidth,
          label: 'button_import pdf'.tr,
          func: () async {
            try {
              // Basculer vers l'étape 3 pour afficher le stream
              controller.etape = 2;
            } catch (e) {
              Get.snackbar('Erreur', 'Erreur lors du traitement: $e');
            }
          },
        ),
        SizedBox(width: _spacingMedium),
        MyButton(width: _buttonWidth, label: 'button_return'.tr, func: _handleReturn),
      ],
    );
  }

  /// Handle file selection
  Future<void> _handleFileSelection() async {
    controller.platformFiles = await controller.getPlatformFile();
  }

  /// Handle return to previous step
  void _handleReturn() {
    controller.etape = 0;
  }

  Widget _buildMonthSection(VolTraiteMoisModel volTraiteMois) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Header
        _buildMonthHeader(volTraiteMois),
        SizedBox(height: AppTheme.h(x: 12)),

        // Month Statistics
        _buildMonthStatistics(volTraiteMois),
        SizedBox(height: AppTheme.h(x: 12)),
      ],
    );
  }

  /// Builds the month header with title and date
  Widget _buildMonthHeader(VolTraiteMoisModel volTraiteMois) {
    // Récupérer les BLC tags pour ce mois
    final blcTags = controller.getBlcTagsForMonth(volTraiteMois.moisReference);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getWidth(iphoneSize: 12, ipadsize: 12),
        vertical: AppTheme.getheight(iphoneSize: 10, ipadsize: 10),
      ),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 8)),
        border: Border(
          left: BorderSide(
            color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volTraiteMois.moisAnneeFormate,
                    style: TextStyle(
                      fontSize: AppTheme.getfontSize(iphoneSize: 18, ipadsize: 20),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
                    ),
                  ),
                  SizedBox(height: AppTheme.h(x: 4)),
                  Text(
                    '${volTraiteMois.nombreVolsTotal} ${'vol_flights'.tr}',
                    style: TextStyle(
                      fontSize: AppTheme.getfontSize(iphoneSize: 12, ipadsize: 13),
                      color: AppTheme.isDark
                          ? AppColors.colorWhite.withAlpha(150)
                          : AppColors.colorblack87.withAlpha(150),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10),
                  vertical: AppTheme.getheight(iphoneSize: 6, ipadsize: 8),
                ),
                decoration: BoxDecoration(
                  color: (AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor).withAlpha(30),
                  borderRadius: BorderRadius.circular(AppTheme.r(x: 6)),
                ),
                child: Text(
                  volTraiteMois.moisReference,
                  style: TextStyle(
                    fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
                  ),
                ),
              ),
            ],
          ),
          // Afficher les BLC tags et cumuls
          SizedBox(height: AppTheme.h(x: 8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BLC Tags section
              if (blcTags.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
                    decoration: BoxDecoration(
                      color: AppTheme.isDark
                          ? AppColors.primaryLightColor.withAlpha(20)
                          : AppColors.primaryLightColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(AppTheme.r(x: 6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'blcTags',
                          style: TextStyle(
                            fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
                            fontWeight: FontWeight.w600,
                            color: AppTheme.isDark ? AppColors.errorColor : AppColors.errorColor,
                          ),
                        ),
                        SizedBox(height: AppTheme.h(x: 4)),
                        ...blcTags.map((tag) {
                          // print(
                          //   """tag.split('/')[0] ${tag.split('/')[0]}. /. volTraiteMois.cumulTotalDureeVol:${volTraiteMois.cumulTotalDureeVol}""",
                          // );
                          // print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tag.split('/')[0],
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: AppTheme.h(x: 2)),
                              Text(
                                tag.split('/')[1],
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),

              if (blcTags.isNotEmpty) SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
              // Cumuls section
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
                  decoration: BoxDecoration(
                    color: AppTheme.isDark
                        ? AppColors.errorColor.withAlpha(20)
                        : AppColors.errorColor.withAlpha(15),
                    borderRadius: BorderRadius.circular(AppTheme.r(x: 6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cumuls:',
                        style: TextStyle(
                          fontSize: AppTheme.getfontSize(iphoneSize: 11, ipadsize: 12),
                          fontWeight: FontWeight.w600,
                          color: AppTheme.isDark ? AppColors.errorColor : AppColors.errorColor,
                        ),
                      ),
                      SizedBox(height: AppTheme.h(x: 4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vol:',
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.isDark
                                      ? AppColors.colorWhite.withAlpha(200)
                                      : AppColors.colorblack87.withAlpha(200),
                                ),
                              ),
                              SizedBox(height: AppTheme.h(x: 2)),
                              Text(
                                'Forfait:',
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.isDark
                                      ? AppColors.colorWhite.withAlpha(200)
                                      : AppColors.colorblack87.withAlpha(200),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                volTraiteMois.cumulTotalDureeVol,
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: AppTheme.h(x: 2)),
                              Text(
                                volTraiteMois.cumulTotalDureeForfait,
                                style: TextStyle(
                                  fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds monthly statistics cards
  Widget _buildMonthStatistics(VolTraiteMoisModel volTraiteMois) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            label: 'vol_duration'.tr,
            value: volTraiteMois.cumulTotalDureeVol,
            icon: Icons.flight_takeoff,
            color: Colors.blue,
          ),
          SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
          _buildStatCard(
            label: 'vol_forfait'.tr,
            value: volTraiteMois.cumulTotalDureeForfait,
            icon: Icons.schedule,
            color: Colors.orange,
          ),
          SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
          _buildStatCard(
            label: 'vol_night'.tr,
            value: volTraiteMois.cumulTotalNuitVol,
            icon: Icons.nights_stay,
            color: Colors.purple,
          ),
          SizedBox(width: AppTheme.getWidth(iphoneSize: 8, ipadsize: 10)),
          _buildStatCard(
            label: 'vol_mep'.tr,
            value: volTraiteMois.cumulTotalDureeMep,
            icon: Icons.directions_car,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  /// Builds a single statistic card
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getWidth(iphoneSize: 12, ipadsize: 14),
        vertical: AppTheme.getheight(iphoneSize: 10, ipadsize: 12),
      ),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppTheme.r(x: 8)),
        border: Border.all(color: color.withAlpha(100), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppTheme.s(x: 20)),
          SizedBox(height: AppTheme.h(x: 4)),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.getfontSize(iphoneSize: 13, ipadsize: 14),
              fontWeight: FontWeight.bold,
              color: AppTheme.isDark ? AppColors.colorWhite : AppColors.colorblack87,
            ),
          ),
          SizedBox(height: AppTheme.h(x: 2)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.getfontSize(iphoneSize: 10, ipadsize: 11),
              color: AppTheme.isDark
                  ? AppColors.colorWhite.withAlpha(150)
                  : AppColors.colorblack87.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable container for import content
class _ImportContainer extends StatelessWidget {
  const _ImportContainer({required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: ImportRosterScreen._spacingSmall,
            vertical: ImportRosterScreen._spacingMedium,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ImportRosterScreen._spacingSmall,
            vertical: ImportRosterScreen._spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppTheme.isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.all(Radius.circular(ImportRosterScreen._borderRadius)),
            boxShadow: [
              BoxShadow(
                color: ImportRosterScreen._shadowColor,
                blurRadius: ImportRosterScreen._shadowBlur,
                offset: Offset(ImportRosterScreen._shadowOffsetX, ImportRosterScreen._shadowOffsetY),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
