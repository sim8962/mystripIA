import 'package:objectbox/objectbox.dart';
import 'usermodel.dart';

@Entity()
class MyDownLoad {
  @Id()
  int id = 0;

  String? jsonContent;
  String? htmlContent;
  @Property(type: PropertyType.date)
  DateTime downloadTime;

  final user = ToOne<UserModel>();

  MyDownLoad({this.jsonContent, this.htmlContent, required this.downloadTime});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyDownLoad &&
        downloadTime.year == other.downloadTime.year &&
        downloadTime.month == other.downloadTime.month &&
        downloadTime.day == other.downloadTime.day &&
        downloadTime.hour == other.downloadTime.hour &&
        downloadTime.minute == other.downloadTime.minute;
  }

  @override
  int get hashCode => Object.hash(
    downloadTime.year,
    downloadTime.month,
    downloadTime.day,
    downloadTime.hour,
    downloadTime.minute,
  );
}
