import 'package:flutter/material.dart';

import '../../../Models/ActsModels/myetape.dart';
import '../../../Models/ActsModels/typ_const.dart';
import 'carde_etape.dart';

import 'carde_tsv.dart';

class CardeTyp extends StatelessWidget {
  const CardeTyp({super.key, required this.etape});

  final MyEtape etape;

  @override
  Widget build(BuildContext context) {
    // print(etape.typ.target?.typ ?? 'ici');
    return (etape.typ.target != tTsv) ? CardeEtape(etape: etape) : CardeTsv(etape: etape);
  }
}
