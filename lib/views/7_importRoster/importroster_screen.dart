import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/volpdfs/chechplatform.dart';

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

  Widget _buildContent(int etape) {
    return switch (etape) {
      0 => _buildStepOne(),
      1 => _buildStepTwo(),
      _ => const SizedBox.shrink(),
    };
  }

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

  Widget _buildStepTwo() {
    return StreamBuilder<List<ChechPlatFormMonth>>(
      stream: controller.getStreamPlatformFile(),
      builder: (context, snapshot) => _buildStreamContent(snapshot),
    );
  }

  Widget _buildStreamContent(AsyncSnapshot<List<ChechPlatFormMonth>> snapshot) {
    return switch (snapshot.connectionState) {
      ConnectionState.none => _buildErrorState('error_null'.tr),
      ConnectionState.waiting => _buildLoadingState(),
      ConnectionState.active => _buildActiveState(snapshot),
      ConnectionState.done => _buildDoneState(snapshot),
    };
  }

  Widget _buildLoadingState() {
    return _ImportContainer(
      header: const SizedBox.shrink(),
      child: Center(
        child: CircularProgressIndicator(backgroundColor: _progressBgColor, color: _progressColor),
      ),
    );
  }

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

  Widget _buildErrorState(String message) {
    return Center(child: MyTextWidget(label: message));
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyButton(
          width: _buttonWidth,
          label: 'button_import pdf'.tr,
          func: () async {
            try {
              controller.saveVolpdfsList();
              controller.etape = 0;
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

  Future<void> _handleFileSelection() async {
    controller.platformFiles = await controller.getPlatformFile();
  }

  void _handleReturn() {
    controller.etape = 0;
  }
}

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
