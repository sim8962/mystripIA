import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../helpers/constants.dart';
// import '../../../theming/app_theme.dart';
// import '../../../theming/apptheme_constant.dart';

class CardeForfait extends StatelessWidget {
  const CardeForfait({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

// class CardeForfait extends StatelessWidget {
//   const CardeForfait({super.key, required this.volTraite});

//   final VolTraite volTraite;
//   String get getForfait => '${'card_forfait_prefix'.tr}: ${volTraite.sDureeForfait}';
//   String get getNuit =>
//       volTraite.sNuitForfait.isEmpty ? '' : ',${'card_nuit_prefix'.tr}: ${volTraite.sNuitForfait}';
//   String get getSun => ',${'card_sun_prefix'.tr}: ${volTraite.sSunrise}-${volTraite.sSunset}';
//   //'$getForfait  $getSun $getNuit',
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: AppTheme.w(x: 330),
//       //height: (boxGet.read(getDevice) == getIphone) ? Theming.h(x: 45) : Theming.h(x: 68),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(4)),
//         border: Border.all(color: const Color(0xFF467db8)),
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             height: (boxGet.read(getDevice) == getIphone) ? AppTheme.h(x: 45) : AppTheme.h(x: 68),
//             child: Row(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text('$getForfait $getNuit', maxLines: 1, style: AppStylingConstant.forfaitLabelStyle),
//                     Center(
//                       child: Text(
//                         '${'card_total_forfait_prefix'.tr}: ${volTraite.totalByMonth.target?.sDurreMoisForfait} ${'card_total_nuit_prefix'.tr}: ${volTraite.totalByMonth.target?.sNuitMoisForfait ?? ''}',
//                         maxLines: 1,
//                         style: AppStylingConstant.forfaitTotalStyle,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
