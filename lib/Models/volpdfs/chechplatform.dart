import 'dart:io';

import 'package:file_picker/file_picker.dart';

class ChechPlatFormMonth {
  final String title;
  final DateTime datefile;
  final File file;
  final PlatformFile filePlat;
  bool value;
  ChechPlatFormMonth({
    required this.title,
    required this.datefile,
    required this.file,
    required this.filePlat,
    this.value = true,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChechPlatFormMonth && other.datefile == datefile && other.title == title;
  }

  @override
  int get hashCode => title.hashCode ^ datefile.hashCode;
}
