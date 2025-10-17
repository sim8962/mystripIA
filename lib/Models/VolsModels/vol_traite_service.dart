import 'package:get/get.dart';
import '../../controllers/database_controller.dart';
import '../../services/objectbox_service.dart';
import 'vol.dart';
import 'vol_traite.dart';

/// Service pour gérer les VolTraiteModel
/// Permet de créer, mettre à jour et récupérer les vols traités
class VolTraiteService {
  final DatabaseController _db = DatabaseController.instance;
  ObjectBoxService get _objectBox => Get.find<ObjectBoxService>();

  /// Traite un vol et stocke le résultat dans la base
  /// Calcule tous les cumuls et durées
  VolTraiteModel traiterVol(VolModel volModel) {
    // Récupérer tous les vols pour calculer les cumuls
    final allVols = _db.vols;
    
    // Créer le modèle traité
    final volTraite = VolTraiteModel.fromVolModel(volModel, allVols);
    
    // Stocker dans ObjectBox
    _objectBox.addVolTraite(volTraite);
    
    return volTraite;
  }

  /// Traite tous les vols d'un mois donné
  List<VolTraiteModel> traiterMois(int year, int month) {
    // Récupérer tous les vols
    final allVols = _db.vols;
    
    // Filtrer les vols du mois
    final volsDuMois = allVols.where((v) {
      return v.dtDebut.year == year && v.dtDebut.month == month;
    }).toList();
    
    // Traiter chaque vol
    final volsTraites = <VolTraiteModel>[];
    for (var vol in volsDuMois) {
      volsTraites.add(VolTraiteModel.fromVolModel(vol, allVols));
    }
    
    return volsTraites;
  }

  /// Traite tous les vols
  List<VolTraiteModel> traiterTousLesVols() {
    final allVols = _db.vols;
    
    final volsTraites = <VolTraiteModel>[];
    for (var vol in allVols) {
      volsTraites.add(VolTraiteModel.fromVolModel(vol, allVols));
    }
    
    return volsTraites;
  }

  /// Récupère un vol traité par son ID
  /// Si non trouvé ou obsolète, le recalcule
  VolTraiteModel? getVolTraite(int volModelId) {
    // À implémenter selon votre DatabaseController
    // final volTraite = _db.getVolTraiteById(volModelId);
    
    // Si trouvé et à jour, retourner
    // if (volTraite != null && _isUpToDate(volTraite)) {
    //   return volTraite;
    // }
    
    // Sinon, recalculer
    final volModel = _db.vols.firstWhere((v) => v.id == volModelId);
    return traiterVol(volModel);
  }

  /// Vérifie si un vol traité est à jour (moins de 24h)
  bool isUpToDate(VolTraiteModel volTraite) {
    final now = DateTime.now();
    final diff = now.difference(volTraite.dateTraitement);
    return diff.inHours < 24;
  }

  /// Recalcule tous les vols obsolètes
  void recalculerVolsObsoletes() {
    // À implémenter selon votre DatabaseController
    // final volsTraites = _db.getAllVolsTraites();
    // 
    // for (var volTraite in volsTraites) {
    //   if (!_isUpToDate(volTraite)) {
    //     final volModel = _db.vols.firstWhere((v) => v.id == volTraite.volModelId);
    //     final nouveauVolTraite = traiterVol(volModel);
    //     _db.updateVolTraite(nouveauVolTraite);
    //   }
    // }
  }
}
