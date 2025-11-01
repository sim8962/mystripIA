import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/ActsModels/myduty.dart';

import '../Models/VolsModels/vol.dart';
import '../Models/VolsModels/vol_traite.dart';
import '../Models/VolsModels/vol_traite_mois.dart';
import '../Models/volpdfs/vol_pdf.dart';
import '../Models/volpdfs/vol_pdf_list.dart';
import '../Models/jsonModels/datas/airport_model.dart';
import '../Models/jsonModels/datas/forfait_model.dart';
import '../Models/jsonModels/datas/forfaitlist.model.dart';
import '../Models/userModel/my_download.dart';
import '../Models/userModel/usermodel.dart';
import 'objectbox_service.dart';

/// Gère l'ensemble des interactions avec la base de données ObjectBox.
///
/// Ce contrôleur centralise la logique métier pour accéder et manipuler les données,
/// tout en exposant des listes réactives (Rx) pour une synchronisation automatique
/// de l'interface utilisateur. Il s'appuie sur [ObjectBoxService] pour les
/// opérations de bas niveau.
class DatabaseController extends GetxController {
  static DatabaseController get instance => Get.find();
  late final ObjectBoxService objectBox;

  @override
  void onInit() {
    super.onInit();
    objectBox = Get.find<ObjectBoxService>();
  }

  // =====================================================================
  // SECTION: AÉROPORTS (AeroportModel)
  // =====================================================================

  final RxList<AeroportModel> _airports = <AeroportModel>[].obs;
  List<AeroportModel> get airports => _airports;
  set airports(List<AeroportModel> val) {
    _airports.value = val;
  }

  /// Ajoute un aéroport à la liste.
  void addAirport(AeroportModel airport) {
    final currentAirports = objectBox.getAllAirports();
    currentAirports.add(airport);
    objectBox.replaceAllAirports(currentAirports);
    getAllAirports();
  }

  /// Met à jour un aéroport existant.
  void updateAirport(AeroportModel airport) {
    final currentAirports = objectBox.getAllAirports();
    final index = currentAirports.indexWhere((a) => a.id == airport.id);
    if (index != -1) {
      currentAirports[index] = airport;
      objectBox.replaceAllAirports(currentAirports);
      getAllAirports();
    }
  }

  /// Récupère tous les aéroports de la base de données.
  void getAllAirports() {
    airports.assignAll(objectBox.getAllAirports());
  }

  /// Ajoute une liste d'aéroports à la base de données.
  void addAirports(List<AeroportModel> airports) {
    objectBox.addAllAirports(airports);
    getAllAirports();
  }

  /// Remplace tous les aéroports de la base de données par une nouvelle liste.
  void replaceAllAirports(List<AeroportModel> airports) {
    objectBox.replaceAllAirports(airports);
    getAllAirports();
  }

  /// Récupère un aéroport par son code OACI.
  AeroportModel? getAeroportByOaci(String icao) {
    int index = airports.indexWhere((a) => a.icao == icao);
    return (index == -1) ? null : airports[index];
  }

  /// Récupère un aéroport par son code IATA.
  AeroportModel? getAeroportByIata(String iata) {
    int index = airports.indexWhere((a) => a.iata == iata);
    return (index == -1) ? null : airports[index];
  }

  /// Retourne la ville d'un aéroport via son code IATA.
  String getAirportCity(String iata) {
    final airport = getAeroportByIata(iata);
    return airport?.city ?? iata;
  }

  /// Récupère le code ICAO à partir du code IATA.
  /// Retourne le code ICAO ou une chaîne vide si non trouvé.
  /// Exemple: getIcaoByIata("CDG") → "LFPG"
  String getIcaoByIata(String iata) {
    try {
      final airport = airports.firstWhere((a) => a.iata.toUpperCase() == iata.toUpperCase());
      return airport.icao;
    } catch (e) {
      return ''; // Return empty string if not found
    }
  }

  /// Récupère le nom de l'aéroport à partir du code IATA.
  /// Retourne le nom de l'aéroport ou le code IATA en fallback.
  String getAirportNameByIata(String iata) {
    try {
      final airport = airports.firstWhere((a) => a.iata.toUpperCase() == iata.toUpperCase());
      return airport.name;
    } catch (e) {
      return iata; // Return IATA if name not found
    }
  }

  /// Exporte la liste complète des aéroports au format JSON.
  Future<String?> exportAeroportToJson({required String fileName}) async {
    try {
      final airports = DatabaseController.instance.airports;

      if (airports.isEmpty) {
        return null;
      }

      final jsonList = airports.map((airport) => airport.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonString);
      return filePath;
    } catch (e) {
      return null;
    }
  }

  // =====================================================================
  // SECTION: FORFAITS (ForfaitModel & ForfaitListModel)
  // =====================================================================

  final RxList<ForfaitModel> _forfaits = <ForfaitModel>[].obs;
  List<ForfaitModel> get forfaits => _forfaits;
  set forfaits(List<ForfaitModel> val) {
    _forfaits.value = val;
  }

  final RxList<ForfaitListModel> _forfaitLists = <ForfaitListModel>[].obs;
  List<ForfaitListModel> get forfaitLists => _forfaitLists;
  set forfaitLists(List<ForfaitListModel> val) {
    _forfaitLists.value = val;
  }

  /// Récupère un forfait par sa clé.
  ForfaitModel? getForfaitByKey(String cle) {
    int index = forfaits.indexWhere((forfait) => forfait.cle == cle);
    if (index == -1) {
      return null;
    }
    return forfaits[index];
  }

  /// Récupère toutes les listes de forfaits et peuple la liste aplatie `forfaits`.
  void getAllForfaitLists() {
    forfaitLists = objectBox.getAllForfaitLists();
    forfaits.clear();
    for (var forfaitList in forfaitLists) {
      forfaits.addAll(forfaitList.forfaits);
    }
    forfaits.sort((a, b) => a.cle.compareTo(b.cle));
  }

  /// Supprime toutes les listes de forfaits.
  void clearAllForfaitLists() {
    objectBox.removeAllForfaitLists();
    forfaits.clear();
    getAllForfaitLists();
  }

  /// Ajoute des listes de forfaits à la base de données.
  void addForfaitLists(List<ForfaitListModel> lists) {
    objectBox.addAllForfaitLists(lists);
    getAllForfaitLists();
  }

  /// Remplace toutes les listes de forfaits par une nouvelle liste.
  void replaceAllForfaitLists(List<ForfaitListModel> lists) {
    objectBox.replaceAllForfaitLists(lists);
    getAllForfaitLists();
  }

  /// Récupère les listes de forfaits à partir d'une liste de forfaits.
  List<ForfaitListModel> getForfaitListsFromForfaits(List<ForfaitModel> myForfaits) {
    List<ForfaitListModel> newForfaitLists = [];
    List sDateForfaits = myForfaits.map((myForfait) => myForfait.dateForfait).toSet().toList();
    for (var sDateForfait in sDateForfaits) {
      List<ForfaitModel> newForfaits = myForfaits
          .where((forfait) => forfait.dateForfait == sDateForfait)
          .toSet()
          .toList();
      ForfaitListModel forfaitListModel = ForfaitListModel(
        name: '',
        date: DateFormat('dd/MM/yyyy').parse(sDateForfait),
      );
      forfaitListModel.forfaits.assignAll(newForfaits);
      newForfaitLists.add(forfaitListModel);
    }
    return newForfaitLists;
  }

  /// Exporte la liste des forfaits au format JSON.
  Future<String?> exportForfaitsToJson({required String fileName}) async {
    try {
      final forfaitsList = DatabaseController.instance.forfaits;

      if (forfaitsList.isEmpty) {
        return null;
      }

      final jsonList = forfaitsList.map((forfait) => forfait.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonString);
      return filePath;
    } catch (e) {
      return null;
    }
  }

  // =====================================================================
  // SECTION: UTILISATEURS (UserModel)
  // =====================================================================

  final RxList<UserModel> _users = <UserModel>[].obs;
  List<UserModel> get users => _users;
  UserModel? get currentUser => users.isEmpty ? null : users.first;

  /// Récupère un utilisateur par son matricule.
  UserModel? getUserByMatricule(int matricule) {
    final allUsers = objectBox.getAllUsers();
    return allUsers.firstWhereOrNull((u) => u.matricule == matricule);
  }

  /// Ajoute un utilisateur à la base de données.
  void addUser(UserModel user) {
    final currentUsers = objectBox.getAllUsers();
    currentUsers.add(user);
    objectBox.replaceAllUsers(currentUsers);
    getAllUsers();
  }

  /// Met à jour un utilisateur existant.
  void updateUser(UserModel user) {
    final currentUsers = objectBox.getAllUsers();
    final index = currentUsers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      currentUsers[index] = user;
      objectBox.replaceAllUsers(currentUsers);
      getAllUsers();
    }
  }

  /// Récupère tous les utilisateurs de la base de données.
  void getAllUsers() {
    users.assignAll(objectBox.getAllUsers());
  }

  /// Remplace tous les utilisateurs de la base de données par une nouvelle liste.
  void replaceAllUsers(List<UserModel> users) {
    objectBox.replaceAllUsers(users);
    getAllUsers();
  }

  // =====================================================================
  // SECTION: TÉLÉCHARGEMENTS (MyDownLoad)
  // =====================================================================

  /// Ajoute un téléchargement à un utilisateur.
  void addDownloadToUser(int userId, MyDownLoad download) {
    final currentUsers = objectBox.getAllUsers();
    final user = currentUsers.firstWhereOrNull((u) => u.id == userId);
    if (user != null) {
      // Évite les doublons en vérifiant si le téléchargement existe déjà.
      final existingDownloads = user.myDownLoads.toList();
      final isDuplicate = existingDownloads.any((existing) => existing == download);
      if (!isDuplicate) {
        user.myDownLoads.add(download);
        objectBox.replaceAllUsers(currentUsers);
        getAllUsers();
      }
    }
  }

  /// Récupère tous les téléchargements d'un utilisateur, triés par date.
  List<MyDownLoad> getDownloadsByUser(int userId) {
    final allUsers = objectBox.getAllUsers();
    final user = allUsers.firstWhereOrNull((u) => u.id == userId);
    final list = user?.myDownLoads.toList() ?? [];
    list.sort((a, b) => (a.downloadTime).compareTo(b.downloadTime));
    return list;
  }

  /// Récupère le téléchargement le plus récent d'un utilisateur.
  MyDownLoad? getMostRecentDownloadByUser(int userId) {
    final userDownloads = getDownloadsByUser(userId);
    if (userDownloads.isEmpty) return null;
    userDownloads.sort((a, b) => b.downloadTime.compareTo(a.downloadTime));
    return userDownloads.first;
  }

  /// Supprime une liste de téléchargements de la base de données.
  void deleteDownloads(List<MyDownLoad> downloadsToDelete) {
    final currentDownloads = objectBox.getAllDownloads();
    final idsToDelete = downloadsToDelete.map((d) => d.id).toSet();
    currentDownloads.removeWhere((d) => idsToDelete.contains(d.id));
    objectBox.replaceAllDownloads(currentDownloads);
  }

  // =====================================================================
  // SECTION: SERVICES (MyDuty)
  // =====================================================================

  final RxList<MyDuty> _duties = <MyDuty>[].obs;
  List<MyDuty> get duties => _duties;
  set duties(List<MyDuty> val) {
    _duties.value = val;
  }

  /// Récupère tous les services de la base de données.
  void getAllDuties() {
    duties.assignAll(objectBox.getAllDuties());
  }

  /// Remplace tous les services de la base de données par une nouvelle liste.
  void replaceAllDuties(List<MyDuty> duties) {
    objectBox.replaceAllDuties(duties);
    getAllDuties();
  }

  // =====================================================================
  // SECTION: VOLS (VolModel)
  // Les `VolModel` ne sont pas stockés directement mais extraits des `MyDuty`.
  // =====================================================================

  final RxList<VolModel> _volModels = <VolModel>[].obs;
  List<VolModel> get volModels => _volModels;
  set volModels(List<VolModel> val) {
    _volModels.value = val;
  }

  /// Charge tous les vols en les extrayant des services (duties).
  void getAllVolModels() {
    volModels.assignAll(getVolFromDuties(duties));
  }

  /// Extrait et retourne une liste aplatie de tous les `VolModel` contenus dans les services.
  List<VolModel> getVolFromDuties(List<MyDuty> myduties) {
    List<VolModel> allVolModels = [];
    for (final duty in myduties) {
      allVolModels.addAll(duty.vols.map((vol) => vol.copyWith(id: 0)).toList());
    }
    allVolModels.sort((a, b) => b.dtDebut.compareTo(a.dtDebut));
    return allVolModels;
  }

  // =====================================================================
  // SECTION: VOLS PDF LIST (VolPdfList)
  // =====================================================================

  final RxList<VolPdfList> _volPdfLists = <VolPdfList>[].obs;
  List<VolPdfList> get volPdfLists => _volPdfLists;
  set volPdfLists(List<VolPdfList> val) {
    _volPdfLists.value = val;
  }

  final RxList<VolPdf> _volPdfs = <VolPdf>[].obs;
  List<VolPdf> get volPdfs => _volPdfs;
  set volPdfs(List<VolPdf> val) {
    _volPdfs.value = val;
  }

  /// Ajoute une liste de PDFs de vol à la base de données.
  // void addVolPdfList(VolPdfList volPdfList) {
  //   final currentLists = objectBox.getAllVolPdfLists();
  //   currentLists.add(volPdfList);
  //   objectBox.replaceAllVolPdfLists(currentLists);
  //   getAllVolPdfLists();
  // }

  /// Récupère toutes les listes de PDFs de vol de la base de données.
  void getAllVolPdfLists() {
    volPdfLists.assignAll(objectBox.getAllVolPdfLists());
    volPdfs.assignAll(volPdfLists.expand((list) => list.volPdfs).toList());
    //print(volPdfLists.length);
  }

  /// Ajoute plusieurs listes de PDFs de vol à la base de données.
  void addVolPdfLists(List<VolPdfList> lists) {
    objectBox.addAllVolPdfLists(lists);
    getAllVolPdfLists();
  }

  /// Remplace toutes les listes de PDFs de vol par une nouvelle liste.
  void replaceAllVolPdfLists(List<VolPdfList> lists) {
    objectBox.replaceAllVolPdfLists(lists);
    getAllVolPdfLists();
  }

  /// Supprime toutes les listes de PDFs de vol.
  void clearAllVolPdfLists() {
    objectBox.removeAllVolPdfLists();
    volPdfs.clear();
    getAllVolPdfLists();
  }

  // =====================================================================
  // SECTION: VOLS TRAITÉS (VolTraiteModel & VolTraiteMoisModel)
  // =====================================================================

  final RxList<VolTraiteModel> _volTraiteModels = <VolTraiteModel>[].obs;
  List<VolTraiteModel> get volTraiteModels => _volTraiteModels;
  set volTraiteModels(List<VolTraiteModel> val) {
    _volTraiteModels.value = val;
  }

  final RxList<VolTraiteMoisModel> _volTraitesParMois = <VolTraiteMoisModel>[].obs;
  List<VolTraiteMoisModel> get volTraitesParMois => _volTraitesParMois;
  set volTraitesParMois(List<VolTraiteMoisModel> val) {
    _volTraitesParMois.value = val;
  }

  /// Charge tous les groupes de vols traités par mois et peuple la liste aplatie `volTraiteModels`.
  void getAllVolTraitesParMois() {
    volTraitesParMois.assignAll(objectBox.getAllVolTraitesParMois());
    volTraiteModels.clear();
    for (var volTraiteMoisItem in volTraitesParMois) {
      volTraiteModels.addAll(volTraiteMoisItem.volsTraites);
    }
    // Trie par date de début (plus récent en premier).
    volTraiteModels.sort((a, b) => b.dtDebut.compareTo(a.dtDebut));
  }

  /// Supprime tous les groupes de vols traités.
  void clearAllVolTraitesParMois() {
    objectBox.removeAllVolTraitesParMois();
    volTraiteModels.clear();
    getAllVolTraitesParMois();
  }

  /// Remplace tous les groupes de vols traités par une nouvelle liste.
  void replaceAllVolTraiteMois(List<VolTraiteMoisModel> lists) {
    objectBox.replaceAllVolTraiteMois(lists);
    getAllVolTraitesParMois();
  }

  // =====================================================================
  // SECTION: OPÉRATIONS GLOBALES
  // =====================================================================

  /// (Ré)initialise toutes les listes de données en mémoire en les rechargeant depuis la base.
  void getAllDatas() {
    getAllUsers();
    getAllAirports();
    getAllForfaitLists();
    getAllVolTraitesParMois();
    getAllDuties();
    getAllVolModels();
    getAllVolPdfLists();
  }

  /// Supprime toutes les données de la base et rafraîchit les listes en mémoire.
  void clearAllData() {
    objectBox.removeAllDuties();
    objectBox.removeAllVolTraitesParMois();
    objectBox.removeAllUsers();
    objectBox.removeAllDownloads();
    objectBox.removeAllAirports();
    objectBox.removeAllForfaitLists();
    objectBox.removeAllVolPdfLists();
    getAllDatas();
  }
}
