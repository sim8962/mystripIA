import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Models/VolsModels/vol_traite.dart';
import '../../../Models/ActsModels/typ_const.dart';
import '../../../theming/app_color.dart';
import 'vot_controller.dart';

class VolScreen extends GetView<VolController> {
  const VolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          //padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.all(16.w),

          decoration: BoxDecoration(
            color: AppColors.primaryLightColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Rechercher par départ, arrivée, type ou numéro de vol...',
              hintStyle: TextStyle(fontSize: 14.sp),
              prefixIcon: Icon(Icons.search, size: 20.sp),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        onPressed: controller.clearSearch,
                        icon: Icon(Icons.clear, size: 20.sp),
                      )
                    : const SizedBox.shrink(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF1976D2)),
              ),
              filled: true,
              fillColor: Colors.black54,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ),

        // Activities List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1976D2)));
            }

            final vols = controller.filteredVolsTraites;

            if (vols.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff, size: 64.sp, color: Colors.grey[400]),
                    SizedBox(height: 16.h),
                    Text(
                      controller.searchQuery.value.isNotEmpty
                          ? 'Aucune activité trouvée'
                          : 'Aucune activité disponible',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    if (controller.searchQuery.value.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Essayez avec d\'autres mots-clés',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => controller.refreshVolTransits(),
              color: const Color(0xFF1976D2),
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: vols.length,
                itemBuilder: (context, index) {
                  final activity = vols[index];
                  //print('activity.dtDebut :${activity.dtDebut}');
                  return _buildVolTransitCard(activity, controller);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildVolTransitCard(VolTraiteModel vol, VolController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Header with flight number and type
            // Date information
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
                  SizedBox(width: 8.w),
                  Text(
                    controller.getFormattedDate(vol.dtDebut),
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),

                  if (vol.sAvion.isNotEmpty) ...[
                    SizedBox(width: 16.w),
                    Icon(Icons.airplanemode_active, size: 16.sp, color: Colors.grey[600]),
                    SizedBox(width: 8.w),
                    Text(
                      vol.sAvion,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      vol.nVol.isNotEmpty ? vol.nVol : 'N/A',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Route information
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        vol.depIcao.isNotEmpty ? vol.depIcao : 'N/A',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        vol.depIata.isNotEmpty ? vol.depIata : 'N/A',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        controller.getFormattedTime(vol.dtDebut),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Flight path icon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Icon(Icons.flight_takeoff, color: const Color(0xFF1976D2), size: 24.sp),
                      SizedBox(height: 4.h),
                      Text(
                        controller.getDuration(vol.dtDebut, vol.dtFin),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        vol.arrIcao.isNotEmpty ? vol.arrIcao : 'N/A',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        vol.arrIata.isNotEmpty ? vol.arrIata : 'N/A',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        controller.getFormattedTime(vol.dtFin),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Duration and Forfait information (only for Vol, MEP and TAX types)
            if (_isFlightType(vol) &&
                ((vol.sDureevol.isNotEmpty) ||
                    (vol.sDureeForfait.isNotEmpty) ||
                    (vol.sDureeMep.isNotEmpty) ||
                    (vol.sMepForfait.isNotEmpty))) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Afficher sDureevol ou sDureeMep selon le type
                    if (vol.sDureevol.isNotEmpty) ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF1976D2)),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Durée Vol',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sDureevol,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF1976D2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (vol.sDureeMep.isNotEmpty) ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, size: 16.sp, color: Colors.purple[700]),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Durée MEP',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sDureeMep,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (((vol.sDureevol.isNotEmpty) && (vol.sDureeForfait.isNotEmpty)) ||
                        ((vol.sDureeMep.isNotEmpty) && (vol.sMepForfait.isNotEmpty)))
                      Container(height: 30.h, width: 1, color: Colors.grey[300]),
                    if (vol.sDureeForfait.isNotEmpty) ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 16.sp, color: Colors.green[700]),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forfait Vol',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sDureeForfait,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (vol.sMepForfait.isNotEmpty) ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 16.sp, color: Colors.amber[700]),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forfait MEP',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sMepForfait,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Night flight information (sNuitVol and sNuitForfait)
            if (((vol.sNuitVol.isNotEmpty) && vol.sNuitVol != '00h00') ||
                ((vol.sNuitForfait.isNotEmpty) && vol.sNuitForfait != '00h00')) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if ((vol.sNuitVol.isNotEmpty) && vol.sNuitVol != '00h00') ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.nightlight_round, size: 16.sp, color: Colors.indigo[700]),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuit Vol',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sNuitVol,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.indigo[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if ((vol.sNuitVol.isNotEmpty) &&
                        vol.sNuitVol != '00h00' &&
                        (vol.sNuitForfait.isNotEmpty) &&
                        vol.sNuitForfait != '00h00')
                      Container(height: 30.h, width: 1, color: Colors.grey[300]),
                    if ((vol.sNuitForfait.isNotEmpty) && vol.sNuitForfait != '00h00') ...[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dark_mode, size: 16.sp, color: Colors.deepPurple[700]),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuit Forfait',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sNuitForfait,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.deepPurple[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Monthly cumulative totals (only for Vol, MEP and TAX types)
            if (_isFlightType(vol)) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, size: 16.sp, color: Colors.orange[700]),
                        SizedBox(width: 8.w),
                        Text(
                          'Cumuls du mois',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        // Cumul Durée Vol ou MEP
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (vol.sDureevol.isNotEmpty) ? 'Vol' : 'MEP',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                (vol.sDureevol.isNotEmpty) ? vol.sCumulDureeVol : vol.sCumulDureeMep,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: (vol.sDureevol.isNotEmpty)
                                      ? const Color(0xFF1976D2)
                                      : Colors.purple[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Cumul Durée Forfait Vol ou MEP
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (vol.sDureeForfait.isNotEmpty) ? 'Forfait Vol' : 'Forfait MEP',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                (vol.sDureeForfait.isNotEmpty)
                                    ? vol.sCumulDureeForfait
                                    : vol.sCumulMepForfait,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: (vol.sDureeForfait.isNotEmpty)
                                      ? Colors.green[700]
                                      : Colors.amber[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Cumul Nuit Vol (seulement pour Vol)
                        if (vol.sDureevol.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuit Vol',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sCumulNuitVol,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.indigo[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Cumul Nuit Forfait (seulement pour Vol)
                        if (vol.sDureevol.isNotEmpty)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuit Forfait',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vol.sCumulNuitForfait,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.deepPurple[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Vérifie si le vol est de type Vol, MEP ou TAX
  bool _isFlightType(VolTraiteModel vol) {
    return vol.typ == tVol.typ || vol.typ == tMEP.typ || vol.typ == tTAX.typ;
  }
}
