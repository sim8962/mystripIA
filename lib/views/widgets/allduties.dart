import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../Models/ActsModels/myduty.dart';
import 'Cardes/carde_dutys.dart';

class Allduties extends StatelessWidget {
  const Allduties({super.key, required this.duties, required this.scrollController});

  final ItemScrollController scrollController;
  final List<MyDuty> duties;
  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: duties.length,
      itemScrollController: scrollController,
      itemBuilder: (context, index) {
        final duty = duties[index];
        return _buildDutyCard(myDuty: duty);
      },
    );
  }

  Widget _buildDutyCard({required MyDuty myDuty}) {
    return CardDutys(duty: myDuty);
  }
}
