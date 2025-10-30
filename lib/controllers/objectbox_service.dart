import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../Models/ActsModels/myduty.dart';
import '../Models/VolsModels/vol_traite_mois.dart';
import '../Models/volpdfs/vol_pdf_list.dart';
import '../Models/jsonModels/datas/airport_model.dart';
import '../Models/jsonModels/datas/forfaitlist.model.dart';
import '../Models/userModel/my_download.dart';
import '../Models/userModel/usermodel.dart';
import '../objectbox.g.dart';

/// Service d'accès aux données ObjectBox.
///
/// Centralise toutes les opérations CRUD (Create, Read, Update, Delete) pour
/// chaque entité de la base de données. Suit le pattern repository pour
/// l'accès aux données et gère les transactions de manière sécurisée.
class ObjectBoxService {
  late final Store store;

  late final Box<MyDuty> _dutyBox;
  late final Box<VolTraiteMoisModel> _volTraiteMoisBox;
  late final Box<UserModel> _userBox;
  late final Box<MyDownLoad> _downloadBox;
  late final Box<AeroportModel> _airportBox;
  late final Box<ForfaitListModel> _forfaitListBox;
  late final Box<VolPdfList> _volPdfListBox;

  bool _isClosed = false;
  bool get isClosed => _isClosed;

  /// Ferme la connexion à la base de données.
  void close() {
    if (!_isClosed) {
      store.close();
      _isClosed = true;
    }
  }

  /// Compare deux valeurs nullables de manière sécurisée.
  int _compareNullable<T extends Comparable>(T? a, T? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }

  /// Initialise tous les Box ObjectBox pour chaque modèle.
  void _initializeBoxes() {
    _dutyBox = Box<MyDuty>(store);
    _volTraiteMoisBox = Box<VolTraiteMoisModel>(store);
    _userBox = Box<UserModel>(store);
    _downloadBox = Box<MyDownLoad>(store);
    _airportBox = Box<AeroportModel>(store);
    _forfaitListBox = Box<ForfaitListModel>(store);
    _volPdfListBox = Box<VolPdfList>(store);
  }

  /// Constructeur privé pour l'initialisation.
  ObjectBoxService._create(this.store) {
    _initializeBoxes();
  }

  /// Initialise une nouvelle instance de ObjectBoxService avec gestion des erreurs.
  static Future<ObjectBoxService> initializeNewBoxes() async {
    try {
      return await create();
    } catch (e) {
      await _resetObjectBoxDirectory();
      return await create();
    }
  }

  /// Réinitialise le répertoire ObjectBox en cas d'erreur.
  static Future<void> _resetObjectBoxDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final objectboxDirectory = Directory(p.join(directory.path, 'objectbox'));

    if (await objectboxDirectory.exists()) {
      await objectboxDirectory.delete(recursive: true);
    }
  }

  /// Crée et retourne une instance de ObjectBoxService.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBoxService._create(store);
  }
  // =====================================================================
  // SECTION: SERVICES (MyDuty)
  // =====================================================================

  /// Remplace tous les services par une nouvelle liste triée.
  List<MyDuty> replaceAllDuties(List<MyDuty> duties) {
    List<MyDuty> newDuties = duties.map((duty) => duty).toList();
    newDuties.sort((a, b) => _compareNullable<DateTime>(a.startTime, b.startTime));
    removeAllDuties();
    store.runInTransaction(TxMode.write, () {
      _dutyBox.putMany(newDuties);
    });

    return newDuties;
  }

  /// Supprime tous les services de la base de données.
  void removeAllDuties() {
    store.runInTransaction(TxMode.write, () {
      _dutyBox.removeAll();
    });
  }

  /// Récupère tous les services triés par date de début.
  List<MyDuty> getAllDuties() {
    final list = _dutyBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.startTime, b.startTime));
    return list;
  }

  // =====================================================================
  // SECTION: VOLS PDF LIST (VolPdfList)
  // =====================================================================

  /// Remplace toutes les listes de PDFs de vols par une nouvelle liste triée.
  List<VolPdfList> replaceAllVolPdfLists(List<VolPdfList> volPdfLists) {
    List<VolPdfList> newVolPdfLists = volPdfLists.map((list) => list).toList();
    newVolPdfLists.sort((a, b) => _compareNullable<DateTime>(a.month, b.month));
    removeAllVolPdfLists();
    addAllVolPdfLists(newVolPdfLists);
    return newVolPdfLists;
  }

  /// Supprime toutes les listes de PDFs de vols de la base de données.
  void removeAllVolPdfLists() {
    store.runInTransaction(TxMode.write, () {
      _volPdfListBox.removeAll();
    });
  }

  /// Ajoute une liste de listes de PDFs de vols à la base de données.
  void addAllVolPdfLists(List<VolPdfList> volPdfLists) {
    store.runInTransaction(TxMode.write, () {
      _volPdfListBox.putMany(volPdfLists);
    });
  }

  /// Récupère toutes les listes de PDFs de vols triées par mois.
  List<VolPdfList> getAllVolPdfLists() {
    final list = _volPdfListBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.month, b.month));
    return list;
  }

  // =====================================================================
  // SECTION: VOLS TRAITÉS PAR MOIS (VolTraiteMoisModel)
  // =====================================================================

  /// Remplace tous les groupes de vols traités par une nouvelle liste triée.
  List<VolTraiteMoisModel> replaceAllVolTraiteMois(List<VolTraiteMoisModel> volTraiteMoisList) {
    List<VolTraiteMoisModel> newVolTraiteMois = volTraiteMoisList.map((vol) => vol).toList();
    newVolTraiteMois.sort((a, b) => _compareNullable<DateTime>(a.premierJourMois, b.premierJourMois));
    removeAllVolTraitesParMois();
    store.runInTransaction(TxMode.write, () {
      _volTraiteMoisBox.putMany(newVolTraiteMois);
    });

    return newVolTraiteMois;
  }

  /// Supprime tous les groupes de vols traités de la base de données.
  void removeAllVolTraitesParMois() {
    store.runInTransaction(TxMode.write, () {
      _volTraiteMoisBox.removeAll();
    });
  }

  /// Récupère tous les groupes de vols traités triés par date.
  List<VolTraiteMoisModel> getAllVolTraitesParMois() {
    final list = _volTraiteMoisBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.premierJourMois, b.premierJourMois));
    return list;
  }

  // =====================================================================
  // SECTION: UTILISATEURS (UserModel)
  // =====================================================================

  /// Remplace tous les utilisateurs par une nouvelle liste triée.
  List<UserModel> replaceAllUsers(List<UserModel> users) {
    List<UserModel> newUsers = users.map((user) => user).toList();
    newUsers.sort((a, b) => _compareNullable<int>(a.matricule, b.matricule));
    removeAllUsers();
    addAllUsers(newUsers);
    return newUsers;
  }

  /// Supprime tous les utilisateurs de la base de données.
  void removeAllUsers() {
    store.runInTransaction(TxMode.write, () {
      _userBox.removeAll();
    });
  }

  /// Ajoute une liste d'utilisateurs à la base de données.
  void addAllUsers(List<UserModel> users) {
    store.runInTransaction(TxMode.write, () {
      _userBox.putMany(users);
    });
  }

  /// Récupère tous les utilisateurs triés par matricule.
  List<UserModel> getAllUsers() {
    final list = _userBox.getAll();
    list.sort((a, b) => _compareNullable<int>(a.matricule, b.matricule));
    return list;
  }

  // =====================================================================
  // SECTION: TÉLÉCHARGEMENTS (MyDownLoad)
  // =====================================================================

  /// Remplace tous les téléchargements par une nouvelle liste triée.
  List<MyDownLoad> replaceAllDownloads(List<MyDownLoad> downloads) {
    List<MyDownLoad> newDownloads = downloads.map((download) => download).toList();
    newDownloads.sort((a, b) => _compareNullable<DateTime>(a.downloadTime, b.downloadTime));
    removeAllDownloads();
    addAllDownloads(newDownloads);
    return newDownloads;
  }

  /// Supprime tous les téléchargements de la base de données.
  void removeAllDownloads() {
    store.runInTransaction(TxMode.write, () {
      _downloadBox.removeAll();
    });
  }

  /// Ajoute une liste de téléchargements à la base de données.
  void addAllDownloads(List<MyDownLoad> downloads) {
    store.runInTransaction(TxMode.write, () {
      _downloadBox.putMany(downloads);
    });
  }

  /// Récupère tous les téléchargements triés par date.
  List<MyDownLoad> getAllDownloads() {
    final list = _downloadBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.downloadTime, b.downloadTime));
    return list;
  }

  // =====================================================================
  // SECTION: AÉROPORTS (AeroportModel)
  // =====================================================================

  /// Remplace tous les aéroports par une nouvelle liste triée.
  List<AeroportModel> replaceAllAirports(List<AeroportModel> airports) {
    List<AeroportModel> newAirports = airports.map((airport) => airport.copyWith(id: 0)).toList();
    newAirports.sort((a, b) => _compareNullable<String>(a.icao, b.icao));
    removeAllAirports();
    addAllAirports(newAirports);
    return newAirports;
  }

  /// Supprime tous les aéroports de la base de données.
  void removeAllAirports() {
    store.runInTransaction(TxMode.write, () {
      _airportBox.removeAll();
    });
  }

  /// Ajoute une liste d'aéroports à la base de données.
  void addAllAirports(List<AeroportModel> airports) {
    store.runInTransaction(TxMode.write, () {
      _airportBox.putMany(airports);
    });
  }

  /// Récupère tous les aéroports triés par code ICAO.
  List<AeroportModel> getAllAirports() {
    final airports = _airportBox.getAll();
    airports.sort((a, b) => _compareNullable<String>(a.icao, b.icao));
    return airports;
  }

  // =====================================================================
  // SECTION: FORFAITS (ForfaitListModel)
  // =====================================================================

  /// Remplace tous les forfaits par une nouvelle liste triée.
  List<ForfaitListModel> replaceAllForfaitLists(List<ForfaitListModel> forfaitLists) {
    List<ForfaitListModel> newForfaitLists = forfaitLists.map((forfait) => forfait).toList();
    newForfaitLists.sort((a, b) => _compareNullable<DateTime>(a.date, b.date));
    removeAllForfaitLists();
    addAllForfaitLists(newForfaitLists);
    return newForfaitLists;
  }

  /// Supprime tous les forfaits de la base de données.
  void removeAllForfaitLists() {
    store.runInTransaction(TxMode.write, () {
      _forfaitListBox.removeAll();
    });
  }

  /// Ajoute une liste de forfaits à la base de données.
  void addAllForfaitLists(List<ForfaitListModel> forfaitLists) {
    store.runInTransaction(TxMode.write, () {
      _forfaitListBox.putMany(forfaitLists);
    });
  }

  /// Récupère tous les forfaits triés par date.
  List<ForfaitListModel> getAllForfaitLists() {
    final list = _forfaitListBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.date, b.date));
    return list;
  }
}
