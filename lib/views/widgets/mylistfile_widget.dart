import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../Models/volpdfs/chechplatform.dart';
import '../../helpers/constants.dart';
import '../../theming/app_color.dart';
import '../../theming/app_theme.dart';
import '../../theming/apptheme_constant.dart';

class MyListFile extends StatelessWidget {
  final int typ;

  final List<ChechPlatFormMonth> myChechPlatFormMonth;

  const MyListFile({super.key, required this.myChechPlatFormMonth, required this.typ});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      //height: height,
      child: (myChechPlatFormMonth.isNotEmpty)
          ? GridView.builder(
              //padding:  EdgeInsets.all(MyStyling.h(x:5)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: typ == 0
                    ? 1
                    : (boxGet.read(getDevice) == getIphone)
                    ? 3
                    : 6,
                mainAxisSpacing: 2,
                crossAxisSpacing: 3,
                childAspectRatio: (boxGet.read(getDevice) == getIphone)
                    ? (typ == 1)
                          ? 1
                          : 3
                    : (typ == 0)
                    ? 6
                    : 1,
              ),
              itemCount: myChechPlatFormMonth.length,
              itemBuilder: ((context, index) {
                final filePlat = myChechPlatFormMonth[index].filePlat;
                final ch = myChechPlatFormMonth[index].title;
                return buildFile(file: filePlat, nom: ch);
              }),
            )
          : const SizedBox(),
    );
  }

  Widget buildFile({required PlatformFile file, required String nom}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(AppTheme.h(x: 5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: (boxGet.read(getDevice) == getIphone) ? AppTheme.h(x: 80) : AppTheme.h(x: 100),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(AppTheme.r(x: 8)),
              ),
              child: Text(
                nom,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppStylingConstant.listFileNameStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: AppTheme.h(x: 5)),
          ],
        ),
      ),
    );
  }
}
