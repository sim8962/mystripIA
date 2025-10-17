import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../helpers/constants.dart';
// import '../../../theming/app_color.dart';
// import '../../../theming/app_theme.dart';

// import '../../../theming/apptheme_constant.dart';

class CardeHeure extends StatelessWidget {
  const CardeHeure({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
// class CardeHeure extends StatelessWidget {
//   const CardeHeure({
//     super.key,
//     required this.volTraite,
//   });

//   final VolTraite volTraite;
//   String get getForfait => '${'card_forfait_prefix'.tr}: ${volTraite.sDureeForfait}';
//   String get getNuit => volTraite.sNuitForfait.isEmpty ? '' : '  ${'card_nuit_prefix'.tr}: ${volTraite.sNuitForfait}';
//   String get getSun => ',${'card_sun_prefix'.tr}: ${volTraite.sSunrise}-${volTraite.sSunset}';

// //'$getForfait  $getSun $getNuit',
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: AppTheme.getWidth(iphoneSize: 340, ipadsize: 400),
//       //height: (boxGet.read(getDevice) == getIphone) ? Theming.h(x: 45) : Theming.h(x: 68),
//       // decoration: BoxDecoration(
//       //   color: Colors.white,
//       //   borderRadius: const BorderRadius.all(Radius.circular(4)),
//       //   border: Border.all(
//       //     color: const Color(0xFF467db8),
//       //   ),
//       // ),

//       child: Column(
//         children: [
//           Container(
//               height: 1,
//               width: AppTheme.getWidth(iphoneSize: 210, ipadsize: 270),
//               color: AppColors.primaryLightColor),
//           SizedBox(
//             height: (boxGet.read(getDevice) == getIphone) ? AppTheme.h(x: 45) : AppTheme.h(x: 68),
//             child: Row(
//               children: [
//                 (volTraite.sSunrise == '')
//                     ? const SizedBox()
//                     : Column(
//                         children: [
//                           SizedBox(
//                             height: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
//                             width: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
//                             child: Image(
//                               color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
//                               image: AssetImage('assets/images/sunrise.png'),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 6)),
//                             child: Text(
//                               volTraite.sSunrise,
//                               maxLines: 1,
//                               style: AppStylingConstant.sunriseStyle,
//                             ),
//                           ),
//                         ],
//                       ),
//                 const VerticalDivider(
//                   // width: 20,
//                   thickness: 1,
//                   indent: 5,
//                   endIndent: 5,
//                   color: AppColors.primaryLightColor,
//                 ),
//                 Expanded(
//                   // padding: const EdgeInsets.only(top: 8, bottom: 15),
//                   //width: MediaQuery.of(context).size.width,
//                   //child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         '$getForfait   $getNuit',
//                         maxLines: 1,
//                         style: AppStylingConstant.forfaitStyle,
//                       ),
//                       Text(
//                         '${'card_total_forfait_prefix'.tr}: ${volTraite.totalByMonth.target?.sDurreMoisForfait} ${'card_total_nuit_prefix'.tr}: ${volTraite.totalByMonth.target?.sNuitMoisForfait ?? ''}',
//                         maxLines: 1,
//                         style: AppStylingConstant.totalStyle,
//                       ),
//                     ],
//                   ),
//                   // ),
//                 ),
//                 const VerticalDivider(
//                   // width: 20,
//                   thickness: 1,
//                   indent: 5,
//                   endIndent: 5,
//                   color: AppColors.primaryLightColor,
//                 ),
//                 (volTraite.sSunset == '')
//                     ? const SizedBox()
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // const Divider(),
//                           SizedBox(
//                             height: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
//                             width: AppTheme.getheight(iphoneSize: 25, ipadsize: 30),
//                             child: Image(
//                               color: AppTheme.isDark ? AppColors.errorColor : AppColors.primaryLightColor,
//                               image: AssetImage('assets/images/sunset.png'),
//                             ),
//                           ),
//                           // const Divider(),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: AppTheme.w(x: 8)),
//                             child: Center(
//                               child:
//                                   Text(volTraite.sSunset, maxLines: 1, style: AppStylingConstant.sunriseStyle
//                                       // style: MyStyling.baseStyle(
//                                       //     fontWeight: FontWeight.w500,
//                                       //     iPhoneSize: 12,
//                                       //     iPadSize: 14,
//                                       //     darkcolor: MyStyling.color04,
//                                       //     lightcolor: MyStyling.color01),
//                                       ),
//                             ),
//                           ),
//                         ],
//                       ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
