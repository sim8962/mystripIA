import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../Models/ActsModels/myduty.dart';

import '../Models/VolsModels/vol.dart';
import '../Models/VolsModels/vol_traite.dart';
import '../Models/VolsModels/vol_traite_mois.dart';
import '../Models/jsonModels/datas/airport_model.dart';
import '../Models/jsonModels/datas/forfait_model.dart';
import '../Models/jsonModels/datas/forfaitlist.model.dart';
import '../Models/userModel/my_download.dart';
import '../Models/userModel/usermodel.dart';
import '../objectbox.g.dart';

/// ObjectBox CRUD Service
/// Handles all database CRUD operations for the ApplicaTrip 2025 app
/// Follows the repository pattern for data access layer
class ObjectBoxService {
  late final Store store;

  late final Box<MyDuty> _dutyBox;
  late final Box<VolModel> _volBox;
  late final Box<VolTraiteModel> _volTraiteBox;
  late final Box<VolTraiteMoisModel> _volTraiteMoisBox;
  late final Box<UserModel> _userBox;
  late final Box<MyDownLoad> _downloadBox;
  late final Box<AeroportModel> _airportBox;
  // late final Box<ForfaitModel> _forfaitBox;
  late final Box<ForfaitListModel> _forfaitListBox;

  bool _isClosed = false;
  bool get isClosed => _isClosed;
  void close() {
    if (!_isClosed) {
      store.close();
      _isClosed = true;
    }
  }

  int _compareNullable<T extends Comparable>(T? a, T? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }

  void _initializeBoxes() {
    _dutyBox = Box<MyDuty>(store);
    _volBox = Box<VolModel>(store);
    _volTraiteBox = Box<VolTraiteModel>(store);
    _volTraiteMoisBox = Box<VolTraiteMoisModel>(store);
    _userBox = Box<UserModel>(store);
    _downloadBox = Box<MyDownLoad>(store);
    _airportBox = Box<AeroportModel>(store);
    // _forfaitBox = Box<ForfaitModel>(store);
    _forfaitListBox = Box<ForfaitListModel>(store);
  }

  // Private constructor
  ObjectBoxService._create(this.store) {
    _initializeBoxes();
  }
  //initialisation
  static Future<ObjectBoxService> initializeNewBoxes() async {
    try {
      return await create();
    } catch (e) {
      // Reset and retry if initialization fails
      await _resetObjectBoxDirectory();
      return await create();
    }
  }

  static Future<void> _resetObjectBoxDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final objectboxDirectory = Directory(p.join(directory.path, 'objectbox'));

    if (await objectboxDirectory.exists()) {
      await objectboxDirectory.delete(recursive: true);
    }
  }

  //ObjectBoxService._create(this.store);

  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBoxService._create(store);
  }
  // ====== CRUD Operations for MyDuty ======

  void addDuty(MyDuty duty) {
    _dutyBox.put(duty);
  }

  void addDuties(List<MyDuty> duties) {
    store.runInTransaction(TxMode.write, () {
      _dutyBox.removeAll();
      _dutyBox.putMany(duties);
    });
  }

  List<MyDuty> getAllDuties() {
    final list = _dutyBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.startTime, b.startTime));
    return list;
  }

  void clearAllDuties() {
    store.runInTransaction(TxMode.write, () {
      _dutyBox.removeAll();
    });
  }

  // ====== CRUD Operations for volModel ======

  void addVolTransit(VolModel volModel) {
    _volBox.put(volModel);
  }

  void addVolTransits(List<VolModel> volTransits) {
    store.runInTransaction(TxMode.write, () {
      _volBox.removeAll();
      _volBox.putMany(volTransits);
    });
  }

  List<VolModel> getAllVolTransits() {
    final list = _volBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.dtDebut, b.dtDebut));
    return list;
  }

  void clearAllVolTransits() {
    store.runInTransaction(TxMode.write, () {
      _volBox.removeAll();
    });
  }

  // ====== CRUD Operations for VolTraiteModel ======

  void addVolTraite(VolTraiteModel volTraite) {
    _volTraiteBox.put(volTraite);
  }

  void addVolTraites(List<VolTraiteModel> volTraites) {
    store.runInTransaction(TxMode.write, () {
      _volTraiteBox.removeAll();
      _volTraiteBox.putMany(volTraites);
    });
  }

  List<VolTraiteModel> getAllVolTraites() {
    final list = _volTraiteBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.dtDebut, b.dtDebut));
    return list;
  }

  void clearAllVolTraites() {
    store.runInTransaction(TxMode.write, () {
      _volTraiteBox.removeAll();
    });
  }

  VolTraiteModel? getVolTraiteById(int id) {
    return _volTraiteBox.get(id);
  }

  List<VolTraiteModel> getVolTraitesByMonth(int year, int month) {
    final moisRef = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    final query = _volTraiteBox.query(VolTraiteModel_.moisReference.equals(moisRef)).build();
    final list = query.find();
    query.close();
    list.sort((a, b) => _compareNullable<DateTime>(a.dtDebut, b.dtDebut));
    return list;
  }

  void updateVolTraite(VolTraiteModel volTraite) {
    _volTraiteBox.put(volTraite);
  }

  void deleteVolTraite(int id) {
    _volTraiteBox.remove(id);
  }

  int getVolTraitesCount() {
    return _volTraiteBox.count();
  }

  // ====== CRUD Operations for VolTraiteMoisModel ======

  void addVolTraiteMois(VolTraiteMoisModel volTraiteMois) {
    _volTraiteMoisBox.put(volTraiteMois);
  }

  void addVolTraiteMoisList(List<VolTraiteMoisModel> volTraiteMoisList) {
    store.runInTransaction(TxMode.write, () {
      _volTraiteMoisBox.removeAll();
      _volTraiteMoisBox.putMany(volTraiteMoisList);
    });
  }

  List<VolTraiteMoisModel> getAllVolTraiteMois() {
    final list = _volTraiteMoisBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.premierJourMois, b.premierJourMois));
    return list;
  }

  void clearAllVolTraiteMois() {
    store.runInTransaction(TxMode.write, () {
      _volTraiteMoisBox.removeAll();
    });
  }

  VolTraiteMoisModel? getVolTraiteMoisById(int id) {
    return _volTraiteMoisBox.get(id);
  }

  VolTraiteMoisModel? getVolTraiteMoisByDate(int year, int month) {
    final premierJour = DateTime(year, month, 1);
    final query = _volTraiteMoisBox
        .query(VolTraiteMoisModel_.premierJourMois.equals(premierJour.millisecondsSinceEpoch))
        .build();
    final volTraiteMois = query.findFirst();
    query.close();
    return volTraiteMois;
  }

  VolTraiteMoisModel? getVolTraiteMoisByMoisReference(String moisRef) {
    final query = _volTraiteMoisBox.query(VolTraiteMoisModel_.moisReference.equals(moisRef)).build();
    final volTraiteMois = query.findFirst();
    query.close();
    return volTraiteMois;
  }

  List<VolTraiteMoisModel> getVolTraiteMoisByYear(int year) {
    final query = _volTraiteMoisBox.query(VolTraiteMoisModel_.annee.equals(year)).build();
    final list = query.find();
    query.close();
    list.sort((a, b) => a.mois.compareTo(b.mois));
    return list;
  }

  void updateVolTraiteMois(VolTraiteMoisModel volTraiteMois) {
    _volTraiteMoisBox.put(volTraiteMois);
  }

  void deleteVolTraiteMois(int id) {
    _volTraiteMoisBox.remove(id);
  }

  int getVolTraiteMoisCount() {
    return _volTraiteMoisBox.count();
  }

  // ====== CRUD Operations for UserModel ======

  List<UserModel> getAllUsers() {
    final list = _userBox.getAll();
    list.sort((a, b) => _compareNullable<int>(a.matricule, b.matricule));
    return list;
  }

  void clearAllUsers() {
    store.runInTransaction(TxMode.write, () {
      _userBox.removeAll();
    });
  }

  UserModel? getUserByMatricule(int matricule) {
    final query = _userBox.query(UserModel_.matricule.equals(matricule)).build();
    final user = query.findFirst();
    query.close();
    return user;
  }

  void addUser(UserModel user) {
    _userBox.put(user);
  }

  void updateUser(UserModel user) {
    _userBox.put(user);
  }

  // ====== CRUD Operations for MyDownLoad ======

  void addDownload(MyDownLoad download) {
    _downloadBox.put(download);
  }

  void addDownloads(List<MyDownLoad> downloads) {
    store.runInTransaction(TxMode.write, () {
      _downloadBox.putMany(downloads);
    });
  }

  List<MyDownLoad> getAllDownloads() {
    final list = _downloadBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.downloadTime, b.downloadTime));
    return list;
  }

  void clearAllDownloads() {
    store.runInTransaction(TxMode.write, () {
      _downloadBox.removeAll();
    });
  }

  void updateDownload(MyDownLoad download) {
    _downloadBox.put(download);
  }

  void deleteDownloads(List<MyDownLoad> downloadsToDelete) {
    final ids = downloadsToDelete.map((d) => d.id).where((id) => id != 0).toList();
    if (ids.isEmpty) return;
    store.runInTransaction(TxMode.write, () {
      _downloadBox.removeMany(ids);
    });
  }

  void deleteDownload(int id) {
    _downloadBox.remove(id);
  }

  MyDownLoad? getDownload(int id) {
    return _downloadBox.get(id);
  }

  int getDownloadsCount() {
    return _downloadBox.count();
  }

  // ====== CRUD Operations for AirportModel ======
  void addAirport(AeroportModel airport) {
    _airportBox.put(airport);
  }

  void addAirports(List<AeroportModel> airports) {
    store.runInTransaction(TxMode.write, () {
      _airportBox.putMany(airports);
    });
  }

  void clearAllAirports() {
    _airportBox.removeAll();
  }

  List<AeroportModel> getAllAirports() {
    final aeroports = _airportBox.getAll();
    aeroports.sort((a, b) => _compareNullable<String>(a.icao, b.icao));
    return aeroports;
  }

  void updateAirport(AeroportModel airport) {
    _airportBox.put(airport);
  }

  void deleteAirport(int id) {
    _airportBox.remove(id);
  }

  bool airportExistsByIcao(String icao) {
    final query = _airportBox.query(AeroportModel_.icao.equals(icao)).build();
    final exists = query.count() > 0;
    query.close();
    return exists;
  }

  bool airportExistsByIata(String iata) {
    final query = _airportBox.query(AeroportModel_.iata.equals(iata)).build();
    final exists = query.count() > 0;
    query.close();
    return exists;
  }

  // ====== CRUD Operations for ForfaitModel ======

  // ForfaitModel? getForfaitByKey(String cle) {
  //   final q = _forfaitBox.query(ForfaitModel_.cle.equals(cle)).build();
  //   final res = q.findFirst();
  //   q.close();
  //   return res;
  // }

  // ====== CRUD Operations for ForfaitListModel ======

  void addForfaitLists(List<ForfaitListModel> forfaitLists) {
    store.runInTransaction(TxMode.write, () {
      _forfaitListBox.putMany(forfaitLists);
    });
  }

  List<ForfaitListModel> getAllForfaitLists() {
    final list = _forfaitListBox.getAll();
    list.sort((a, b) => _compareNullable<DateTime>(a.date, b.date));
    return list;
  }

  void clearAllForfaitLists() {
    store.runInTransaction(TxMode.write, () {
      _forfaitListBox.removeAll();
    });
  }

  List<ForfaitModel> getForfaitsFromList(int listId) {
    final forfaitList = _forfaitListBox.get(listId);
    return forfaitList?.forfaits.toList() ?? [];
  }

  void addForfaitList(ForfaitListModel forfaitList) {
    _forfaitListBox.put(forfaitList);
  }

  // ====== Relationship Management ======

  void addDownloadToUser(int userId, MyDownLoad download) {
    final user = _userBox.get(userId);
    if (user != null) {
      // Check for duplicates using custom == operator (year/month/day/hour/minute comparison)
      final existingDownloads = user.myDownLoads.toList();
      final isDuplicate = existingDownloads.any((existing) => existing == download);

      if (isDuplicate) {
        return; // Don't add duplicate
      }

      // No duplicate found, safe to add
      user.myDownLoads.add(download);
      _userBox.put(user);
    }
  }

  /// Get all downloads for a specific user
  List<MyDownLoad> getDownloadsByUser(int userId) {
    final user = _userBox.get(userId);
    final list = user?.myDownLoads.toList() ?? [];
    list.sort((a, b) => _compareNullable<DateTime>(a.downloadTime, b.downloadTime));
    return list;
  }

  MyDownLoad? getMostRecentDownloadByUser(int userId) {
    final userDownloads = getDownloadsByUser(userId);
    if (userDownloads.isEmpty) return null;

    userDownloads.sort((a, b) {
      return b.downloadTime.compareTo(a.downloadTime); // Most recent first
    });

    return userDownloads.first;
  }

  // ====== Utility Methods ======

  /// Clear all data from all boxes
  void clearAllData() {
    store.runInTransaction(TxMode.write, () {
      _dutyBox.removeAll();
      _volBox.removeAll();
      _volTraiteBox.removeAll();
      _volTraiteMoisBox.removeAll();
      _userBox.removeAll();
      _downloadBox.removeAll();
      _forfaitListBox.removeAll();
      _airportBox.removeAll();
    });
  }
}
