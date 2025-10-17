import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/ActsModels/myduty.dart';
import '../Models/VolsModels/vol.dart';

import '../Models/jsonModels/datas/airport_model.dart';
import '../Models/jsonModels/datas/forfait_model.dart';
import '../Models/jsonModels/datas/forfaitlist.model.dart';
import '../Models/userModel/my_download.dart';
import '../Models/userModel/usermodel.dart';
import '../services/objectbox_service.dart';

class DatabaseController extends GetxController {
  static DatabaseController get instance => Get.find();
  late final ObjectBoxService objectBox;

  @override
  void onInit() {
    super.onInit();
    objectBox = Get.find<ObjectBoxService>();
  }

  // Reactive lists for UI updates

  final RxList<AeroportModel> _airports = <AeroportModel>[].obs;
  List<AeroportModel> get airports => _airports;
  set airports(List<AeroportModel> val) {
    _airports.value = val;
  }

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

  // ====== Get all Airports Datas ======
  void addAirport(AeroportModel airport) {
    objectBox.addAirport(airport);
    getAllAirports();
  }

  void updateAirport(AeroportModel airport) {
    objectBox.updateAirport(airport);
    getAllAirports();
  }

  void getAllAirports() {
    airports.assignAll(objectBox.getAllAirports());
  }

  void addAirports(List<AeroportModel> airports) {
    objectBox.addAirports(airports);
    getAllAirports();
  }

  AeroportModel? getAeroportByOaci(String icao) {
    int index = airports.indexWhere((a) => a.icao == icao);
    return (index == -1) ? null : airports[index];
  }

  AeroportModel? getAeroportByIata(String iata) {
    int index = airports.indexWhere((a) => a.iata == iata);
    return (index == -1) ? null : airports[index];
  }

  // // ====== ForfaitModel Methods ======
  ForfaitModel? getForfaitByKey(String cle) {
    int index = forfaits.indexWhere((forfait) => forfait.cle == cle);
    if (index == -1) {
      return null;
    }
    return forfaits[index];
  }

  // ====== ForfaitListModel Methods ======

  void getAllForfaitLists() {
    forfaitLists = objectBox.getAllForfaitLists();
    forfaits.clear();
    for (var forfaitList in forfaitLists) {
      forfaits.addAll(forfaitList.forfaits);
    }
    forfaits.sort((a, b) => a.cle.compareTo(b.cle));
  }

  void clearAllForfaitLists() {
    objectBox.clearAllForfaitLists();
    forfaits.clear();
    getAllForfaitLists();
  }

  void addForfaitLists(List<ForfaitListModel> lists) {
    objectBox.addForfaitLists(lists);
    getAllForfaitLists();
  }

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

  Future<String?> exportForfaitsToJson({required String fileName}) async {
    try {
      // Get the list of forfaits
      final forfaitsList = DatabaseController.instance.forfaits;

      if (forfaitsList.isEmpty) {
        // status.value = 'Aucun forfait à exporter';
        return null;
      }

      // Convert to JSON
      final jsonList = forfaitsList.map((forfait) => forfait.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonString);
      // print('json file.path: ${file.path}');
      //status.value = 'Export réussi: ${forfaitsList.length} forfaits exportés';
      return filePath;
    } catch (e) {
      //status.value = 'Erreur d\'export: $e';
      return null;
    }
  }

  Future<String?> exportAeroportToJson({required String fileName}) async {
    try {
      // Get the list of forfaits
      final airports = DatabaseController.instance.airports;

      if (airports.isEmpty) {
        // status.value = 'Aucun forfait à exporter';
        return null;
      }

      // Convert to JSON
      final jsonList = airports.map((airport) => airport.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonString);
      //print('json file.path: ${file.path}');
      //status.value = 'Export réussi: ${forfaitsList.length} forfaits exportés';
      return filePath;
    } catch (e) {
      //status.value = 'Erreur d\'export: $e';
      return null;
    }
  }

  // Current user session

  UserModel? get currentUser => users.isEmpty ? null : users.first;
  // Reactive lists for UI updates
  final RxList<UserModel> users = <UserModel>[].obs;

  // ====== CRUD Operations for UserModel ======

  UserModel? getUserByMatricule(int matricule) {
    return objectBox.getUserByMatricule(matricule);
  }

  void addUser(UserModel user) {
    objectBox.addUser(user);
    getAllUsers();
  }

  void updateUser(UserModel user) {
    objectBox.updateUser(user);
    getAllUsers();
  }

  void addDownloadToUser(int userId, MyDownLoad download) {
    objectBox.addDownloadToUser(userId, download);
    getAllUsers(); // Refresh to reflect changes
  }

  /// Get all downloads for a specific user
  List<MyDownLoad> getDownloadsByUser(int userId) {
    return objectBox.getDownloadsByUser(userId);
  }

  MyDownLoad? getMostRecentDownloadByUser(int userId) {
    return objectBox.getMostRecentDownloadByUser(userId);
  }

  /// Delete specific MyDownLoad entities from ObjectBox database
  void deleteDownloads(List<MyDownLoad> downloadsToDelete) {
    objectBox.deleteDownloads(downloadsToDelete);
  }

  void getAllUsers() {
    users.assignAll(objectBox.getAllUsers());
  }

  void getAllDuties() {
    duties.assignAll(objectBox.getAllDuties());
  }

  void getAllVolTransits() {
    vols.assignAll(objectBox.getAllVolTransits());
  }

  //final RxList<MyDuty> duties = <MyDuty>[].obs;
  final RxList<MyDuty> _duties = <MyDuty>[].obs;
  List<MyDuty> get duties => _duties;
  set duties(List<MyDuty> val) {
    _duties.value = val;
  }

  void addDuties(List<MyDuty> duties) {
    objectBox.addDuties(duties);
    getAllDuties();
  }

  void addVolTransits(List<VolModel> vols) {
    objectBox.addVolTransits(vols);
    getAllVolTransits();
  }

  final RxList<VolModel> _volTransits = <VolModel>[].obs;
  List<VolModel> get vols => _volTransits;
  set vols(List<VolModel> val) {
    _volTransits.value = val;
  }

  // List<VolTransit> getAllVolTransits() {
  //   getAllDuties(); // This updates the duties property
  //   List<VolTransit> allVolTransits = [];

  //   for (final duty in duties) {
  //     allVolTransits.addAll(duty.vols.toList());
  //   }

  //   // Sort by start time (newest first)
  //   allVolTransits.sort((a, b) => b.dtDebut.compareTo(a.dtDebut));

  //   return allVolTransits;
  // }

  List<VolModel> getVolFromDuties() {
    // This updates the duties property
    List<VolModel> allVolTransits = [];

    for (final duty in duties) {
      allVolTransits.addAll(duty.vols.toList());
    }

    // Sort by start time (newest first)
    allVolTransits.sort((a, b) => b.dtDebut.compareTo(a.dtDebut));

    return allVolTransits;
  }

  void getAllDatas() {
    getAllUsers();
    getAllAirports();

    getAllForfaitLists();
    getAllDuties();
    getAllVolTransits();
  }

  /// Recalculate missing values for all vols in the database
  void recalculateMissingVolValues() {
    for (var vol in vols) {
      bool needsUpdate = false;

      // Check if any required field is missing
      if (vol.sDureevol == null ||
          vol.sDureevol!.isEmpty ||
          vol.sDureeForfait == null ||
          vol.sDureeForfait!.isEmpty ||
          vol.sNuitForfait == null ||
          vol.sNuitForfait!.isEmpty) {
        needsUpdate = true;
      }

      if (needsUpdate) {
        vol.updateMissingValues();
        objectBox.addVolTransit(vol); // put() will update if ID exists
      }
    }

    getAllVolTransits();
  }

  /// Clear all data from database
  void clearAllData() {
    objectBox.clearAllData();
    getAllDatas();
  }
  // void addForfaitList(ForfaitListModel list) {
  //   objectBox.addForfaitList(list);
  //   getAllForfaitLists();
  // }

  // void updateForfaitList(ForfaitListModel list) {
  //   objectBox.updateForfaitList(list);
  //   getAllForfaitLists();
  // }

  // void deleteForfaitList(int id) {
  //   objectBox.deleteForfaitList(id);
  //   getAllForfaitLists();
  // }

  // ForfaitListModel? getForfaitListByName(String name) {
  //   return objectBox.getForfaitListByName(name);
  // }

  // List<ForfaitListModel> searchForfaitListsByName(String searchTerm) {
  //   return objectBox.searchForfaitListsByName(searchTerm);
  // }

  // /// Add forfaits to a specific ForfaitListModel
  // void addForfaitsToList(int listId, List<ForfaitModel> forfaits) {
  //   objectBox.addForfaitsToList(listId, forfaits);
  //   getAllForfaitLists();
  // }

  // /// Remove forfait from a specific ForfaitListModel
  // void removeForfaitFromList(int listId, ForfaitModel forfait) {
  //   objectBox.removeForfaitFromList(listId, forfait);
  //   getAllForfaitLists();
  // }

  // /// Get all forfaits from a specific ForfaitListModel
  // List<ForfaitModel> getForfaitsFromList(int listId) {
  //   return objectBox.getForfaitsFromList(listId);
  // }

  // void getAllForfaits() {
  //   forfaits = objectBox.getAllForfaits();
  // }

  // void addForfaits(List<ForfaitModel> forfaits) {
  //   objectBox.addForfaits(forfaits);
  //   getAllForfaits();
  // }

  // void addForfait(ForfaitModel forfait) {
  //   objectBox.addForfait(forfait);
  //   getAllForfaits();
  // }

  // void updateForfait(ForfaitModel forfait) {
  //   objectBox.updateForfait(forfait);
  //   getAllForfaits();
  // }

  // void deleteForfait(int id) {
  //   objectBox.deleteForfait(id);
  //   getAllForfaits();
  // }

  // void clearAllForfaits() {
  //   objectBox.clearAllForfaits();
  //   getAllForfaits();
  // }
}
