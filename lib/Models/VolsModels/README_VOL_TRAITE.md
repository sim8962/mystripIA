# VolTraiteModel - Documentation

## 📋 Vue d'ensemble

`VolTraiteModel` est un modèle ObjectBox optimisé qui stocke **toutes les données calculées** d'un vol, incluant les cumuls mensuels. Cela permet d'éviter de recalculer les mêmes données à chaque affichage.

## 🎯 Objectifs

1. **Performance** : Calcul une seule fois, lecture multiple
2. **Cache** : Stockage des cumuls mensuels pré-calculés
3. **Simplicité** : Accès direct aux données sans calcul
4. **Traçabilité** : Date de traitement pour invalidation du cache

## 📊 Architecture

```
VolModel (données brutes)
    ↓
    ↓ Traitement (calculs + cumuls)
    ↓
VolTraiteModel (données calculées)
    ↓
    ↓ Stockage ObjectBox
    ↓
Affichage UI (lecture directe)
```

## 🔧 Utilisation

### 1. Traiter un vol unique

```dart
import 'package:mystrip25/Models/VolsModels/vol_traite_service.dart';

final service = VolTraiteService();
final volModel = /* récupérer depuis la base */;

// Traiter et obtenir le résultat
final volTraite = service.traiterVol(volModel);

// Accéder aux données
print('Durée vol: ${volTraite.sDureeVol}');
print('Cumul mensuel: ${volTraite.sCumulDureeVol}');
```

### 2. Traiter tous les vols d'un mois

```dart
final service = VolTraiteService();

// Traiter octobre 2025
final volsTraites = service.traiterMois(2025, 10);

// Afficher les cumuls
for (var vol in volsTraites) {
  print('${vol.nVol}: Cumul = ${vol.sCumulDureeVol}');
}
```

### 3. Utilisation dans un contrôleur GetX

```dart
class VolController extends GetxController {
  final VolTraiteService _service = VolTraiteService();
  final RxList<VolTraiteModel> volsTraites = <VolTraiteModel>[].obs;

  void loadVolsTraites() {
    volsTraites.value = _service.traiterTousLesVols();
  }
}
```

### 4. Affichage dans l'UI

```dart
// Avant (avec calculs)
Text(controller.getCumulDureeVol(vol))

// Après (lecture directe)
Text(volTraite.sCumulDureeVol)
```

## 📦 Champs disponibles

### Informations de base
- `volModelId` : Référence au VolModel d'origine
- `typ`, `nVol`, `dtDebut`, `dtFin`
- `depIata`, `arrIata`, `sAvion`

### Durées (format "XXhYY")
- `sDureeBrute` : Durée totale (dtFin - dtDebut)
- `sDureeVol` : Durée pour type Vol
- `sDureeMep` : Durée pour types MEP/TAX
- `sDureeForfait` : Forfait Vol
- `sMepForfait` : Forfait MEP
- `sNuitVol` : Nuit Vol
- `sNuitForfait` : Nuit forfait Vol

### Cumuls mensuels (format "XXhYY")
- `sCumulDureeVol` : Cumul mensuel durée Vol
- `sCumulDureeMep` : Cumul mensuel durée MEP
- `sCumulDureeForfait` : Cumul mensuel forfait Vol
- `sCumulMepForfait` : Cumul mensuel forfait MEP
- `sCumulNuitVol` : Cumul mensuel nuit Vol
- `sCumulNuitForfait` : Cumul mensuel nuit forfait Vol

### Métadonnées
- `dateTraitement` : Date du calcul
- `moisReference` : Mois des cumuls (format "YYYY-MM")

## 🚀 Avantages

### Performance
```dart
// ❌ Avant : Calcul à chaque affichage
String cumul = VolModel.calculateCumulDureeVol(allVols, vol); // ~100ms

// ✅ Après : Lecture directe
String cumul = volTraite.sCumulDureeVol; // ~1ms
```

### Simplicité du code
```dart
// ❌ Avant : 6 méthodes de calcul dans le contrôleur
controller.getCumulDureeVol(vol)
controller.getCumulDureeMep(vol)
controller.getCumulDureeForfait(vol)
// ...

// ✅ Après : Accès direct
volTraite.sCumulDureeVol
volTraite.sCumulDureeMep
volTraite.sCumulDureeForfait
```

### Cache intelligent
```dart
// Vérifier si le cache est valide
if (service._isUpToDate(volTraite)) {
  // Utiliser le cache
  return volTraite;
} else {
  // Recalculer
  return service.traiterVol(volModel);
}
```

## 🔄 Stratégies de mise à jour

### 1. Mise à jour en temps réel
```dart
// Quand un vol est modifié
void onVolUpdated(VolModel vol) {
  final volTraite = service.traiterVol(vol);
  // Sauvegarder dans la base
}
```

### 2. Mise à jour par batch
```dart
// Tous les soirs à minuit
void updateAllVolsTraites() {
  final volsTraites = service.traiterTousLesVols();
  // Sauvegarder tous les vols traités
}
```

### 3. Mise à jour à la demande
```dart
// Quand l'utilisateur ouvre l'écran
void onScreenOpened() {
  service.recalculerVolsObsoletes();
}
```

## 📈 Cas d'usage

### 1. Tableau de bord mensuel
```dart
final volsTraites = service.traiterMois(2025, 10);
final totalVol = volsTraites.last.sCumulDureeVol;
final totalMep = volsTraites.last.sCumulDureeMep;
```

### 2. Historique des vols
```dart
// Affichage rapide sans calcul
ListView.builder(
  itemCount: volsTraites.length,
  itemBuilder: (context, index) {
    final vol = volsTraites[index];
    return ListTile(
      title: Text(vol.nVol),
      subtitle: Text('Cumul: ${vol.sCumulDureeVol}'),
    );
  },
)
```

### 3. Export de données
```dart
// Export CSV avec cumuls
for (var vol in volsTraites) {
  csv.add([
    vol.nVol,
    vol.sDureeVol,
    vol.sCumulDureeVol,
    vol.sCumulNuitVol,
  ]);
}
```

## ⚠️ Considérations

### Espace disque
- Chaque `VolTraiteModel` occupe ~500 bytes
- 1000 vols = ~500 KB
- Acceptable pour la plupart des applications

### Cohérence des données
- Recalculer quand un vol est modifié
- Recalculer quand un nouveau vol est ajouté dans le mois
- Utiliser `dateTraitement` pour invalider le cache

### Migration
- Facile à ajouter sans casser l'existant
- `VolModel` reste la source de vérité
- `VolTraiteModel` est un cache calculé

## 🎯 Recommandations

1. **Utiliser pour l'affichage** : Toujours afficher depuis `VolTraiteModel`
2. **Calculer en arrière-plan** : Traiter les vols de manière asynchrone
3. **Invalider intelligemment** : Ne recalculer que ce qui a changé
4. **Monitorer les performances** : Mesurer le gain de performance

## 📝 TODO

- [ ] Ajouter les méthodes dans `DatabaseController`
- [ ] Implémenter la sauvegarde dans ObjectBox
- [ ] Créer un worker pour le traitement en arrière-plan
- [ ] Ajouter des tests unitaires
- [ ] Implémenter l'invalidation du cache
