import 'package:objectbox/objectbox.dart';
import 'my_download.dart';

@Entity()
class UserModel {
  @Id()
  int id = 0;

  int? matricule;
  String? email;
  bool? isRam;
  bool? isPnt;

  bool? isMoyenC;
  List<int>? users;

  @Backlink()
  final myDownLoads = ToMany<MyDownLoad>();

  UserModel({this.matricule, this.email, this.isRam, this.isPnt, this.isMoyenC, this.users});
}
