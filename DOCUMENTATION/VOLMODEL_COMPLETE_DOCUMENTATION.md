# VolModel - Complete Nested Functions Documentation

**File:** `lib/Models/VolsModels/vol.dart` | **Class:** `VolModel` (ObjectBox Entity)

**Note:** Airport lookup and prayer time functions have been moved to `AeroportModel` class for better code organization.

---

## Table of Contents

1. [Helper Methods](#helper-methods) - 1 function
2. [Calculation Methods](#calculation-methods) - 5 functions
3. [Factory Methods](#factory-methods) - 1 function
4. [Instance Methods](#instance-methods) - 3 functions
5. [Getter Methods](#getter-methods) - 3 categories
6. [Cumulative Methods](#cumulative-methods) - 7 functions
7. [Moved to AeroportModel](#moved-to-aeroportmodel) - 4 functions
8. [Summary Table](#summary-table)

---

# Helper Methods

## 1. `_requiresFlightCalculations(String typ)` | Line 135

Checks if type requires flight calculations (Vol, MEP, TAX).

```dart
static bool _requiresFlightCalculations(String typ)
```

---

# Calculation Methods

## 2. `_calculateDuration(String typ, DateTime dtDebut, DateTime dtFin)` | Line 142

Calculates actual flight duration ("XXhYY" format).

- **Returns:** Duration string or empty if not flight type
- **Used for:** `sDureevol` (Vol), `sDureeMep` (MEP/TAX)

## 3. `_getForfaitValue(String typ, String depIcao, String arrIcao, DateTime dtDebut, DateTime dtFin)` | Line 150

Retrieves forfait from database based on season & airport pair.

- **Key format:** `[SAISON]MACHMC[DEP_ICAO][ARR_ICAO]`
- **Seasons:** ETE (May-Oct), HIVER (Nov-Apr)
- **Fallback:** Uses actual duration if not found
- **Used for:** `sDureeForfait` (Vol), `sMepForfait` (MEP/TAX)

## 4. `_calculateArrForfait(String typ, DateTime dtDebut, String forfait)` | Line 180

Calculates arrival time: `dtDebut + forfait`.

- **Returns:** DateTime or null
- **Used for:** `arrForfait` (Vol), `arrMepForfait` (MEP/TAX)

## 5. `_calculateNightFlightTime(String typ, DateTime? sunrise, DateTime? sunset, DateTime dtDebut, DateTime? dtFin)` | Line 195

Calculates flight duration during night (sunset to sunrise).

- **Returns:** Duration string "XXhYY" or "00h00"
- **Logic:** Calculates overlap between flight and night periods
- **Used for:** `sNuitVol`, `sNuitForfait` (Vol type only)

## 6. `_determineTsvStatus(DateTime dtDebut, DateTime dtFin, String myChInDate)` | Line 236

Determines TSV (Time-Sensitive Visit) status.

- **Returns:**
  - `"debut tsv"` - Flight starts at/after check-in
  - `"fin tsv"` - Flight ends at/before check-in
  - `"dans tsv"` - Flight crosses check-in date
  - `""` - No check-in or parsing fails

---

# Factory Methods

## 7. `VolModel.fromVolPdf(VolPdf volPdf)` | Line 297

Creates VolModel from PDF-extracted data (VolPdf).

### Field Mapping

| VolPdf     | VolModel | Transform                |
| ---------- | -------- | ------------------------ |
| dateVol    | dtDebut  | Direct                   |
| myArrDate  | dtFin    | Parse "dd/MM/yyyy HH:mm" |
| from       | depIata  | Uppercase, allow empty   |
| to         | arrIata  | Uppercase, allow empty   |
| duty       | typ      | Direct, allow empty      |
| activity   | nVol     | Direct, allow empty      |
| aC         | sAvion   | Direct, allow empty      |
| cle        | cle      | Direct (unique key)      |
| myChInDate | tsv      | Determine TSV status     |

### Features

- ✅ Accepts empty fields (no crashes)
- ✅ Auto-calculates ICAO codes
- ✅ Determines TSV status
- ✅ Triggers all calculations

---

# Instance Methods

## 8. `updateIcaoCodes()` | Line 308

Creates new VolModel with recalculated ICAO codes.

- **Returns:** New VolModel instance

## 9. `updateMissingValues()` | Line 338

Recalculates missing duration/forfait values in-place.

- **For Vol:** Calculates sDureevol, sDureeForfait, sunrise, sunset, night flights
- **For MEP/TAX:** Calculates sDureeMep, sMepForfait

## 10. `copyWith({...})` | Line 568

Creates modified copy with optional field overrides.

- **Features:** Immutable pattern, copies crews independently
- **Returns:** New VolModel instance

---

# Getter Methods

## 11. `isFlightType` | Line 128

Checks if type is Vol, MEP, or TAX.

```dart
bool get isFlightType
```

## 12. Airport Name Getters | Line 379, 382

```dart
String get depAirportName  // Uses AeroportModel.getAirportNameByIata()
String get arrAirportName  // Uses AeroportModel.getAirportNameByIata()
```

## 13. Duration Getters | Line 395-430

| Getter                | Returns  | For                               |
| --------------------- | -------- | --------------------------------- |
| `dureeBrute`          | Duration | Raw flight time (dtFin - dtDebut) |
| `dureeVol`            | Duration | Vol actual duration               |
| `dureeMep`            | Duration | MEP/TAX actual duration           |
| `dureeForfait`        | Duration | Vol forfait duration              |
| `mepForfait`          | Duration | MEP/TAX forfait duration          |
| `nuitVol`             | Duration | Vol night flight time             |
| `nuitForfait`         | Duration | Vol night flight forfait          |
| `nightFlightDuration` | Duration | Alias for nuitVol                 |

---

# Cumulative Methods

## 14. `calculateMonthlyCumul(List<VolModel> vols, VolModel referenceVol, String? Function(VolModel) fieldExtractor)` | Line 500

Generic cumulative calculation from month start to reference flight.

- **Returns:** Cumulative duration string "XXhYY"

## 15. Specific Cumul Methods | Line 528-563

| Method                         | Cumulates     | For             |
| ------------------------------ | ------------- | --------------- |
| `calculateCumulDureeVol()`     | sDureevol     | Vol flights     |
| `calculateCumulDureeForfait()` | sDureeForfait | Vol flights     |
| `calculateCumulNuitVol()`      | sNuitVol      | Vol flights     |
| `calculateCumulNuitForfait()`  | sNuitForfait  | Vol flights     |
| `calculateCumulDureeMep()`     | sDureeMep     | MEP/TAX flights |
| `calculateCumulMepForfait()`   | sMepForfait   | MEP/TAX flights |

## 16. `getCrews(List<Crew> crews)` | Line 543

Converts Crew objects to Map format.

- **Returns:** `List<Map<String, String>>` with keys: 'Mat', 'pos', 'name'

---

# Helper Conversion Methods

## 17. `_stringToDuration(String? durationString)` | Line 389

Converts duration string to Duration object.

- **Delegates to:** `Fct.stringToDuration()`

## 18. `_durationToString(Duration duration)` | Line 392

Converts Duration object to string format.

- **Delegates to:** `Fct.durationToString()`

---

# Moved to AeroportModel

The following functions have been moved to `AeroportModel` class for better code organization and reusability:

## 1. `AeroportModel.getIcaoByIata(String iata)` | `airport_model.dart` Line 122

Converts IATA to ICAO code via database lookup.

- **Returns:** ICAO code or empty string
- **Example:** `AeroportModel.getIcaoByIata("CDG")` → `"LFPG"`

## 2. `AeroportModel.getAirportNameByIata(String iata)` | `airport_model.dart` Line 134

Retrieves airport name by IATA code.

- **Returns:** Airport name or IATA code as fallback
- **Used by:** `depAirportName`, `arrAirportName` getters in VolModel

## 3. `AeroportModel.getPrayerTimes(String icao, DateTime date)` | `airport_model.dart` Line 152

Gets prayer times for airport (sunrise/sunset).

- **Method:** Muslim World League (Fajr 18°, Isha 17°)
- **Returns:** PrayerTimes object or null
- **Used by:** `calculateSunrise()`, `calculateSunset()`

## 4. `AeroportModel.calculateSunrise(String typ, String depIcao, String arrIcao, DateTime date)` | `airport_model.dart` Line 176

Calculates earliest sunrise between dep/arr airports.

- **Returns:** DateTime or null (Vol type only)
- **Why earliest:** Conservative calculation for night flight end

## 5. `AeroportModel.calculateSunset(String typ, String depIcao, String arrIcao, DateTime date)` | `airport_model.dart` Line 202

Calculates latest sunset between dep/arr airports.

- **Returns:** DateTime or null (Vol type only)
- **Why latest:** Conservative calculation for night flight start

---

# Summary Table

**VolModel Methods:**

| #   | Method                          | Type     | Scope   | Purpose              |
| --- | ------------------------------- | -------- | ------- | -------------------- |
| 1   | `_requiresFlightCalculations()` | Static   | Private | Type validation      |
| 2   | `_calculateDuration()`          | Static   | Private | Duration calculation |
| 3   | `_getForfaitValue()`            | Static   | Private | Forfait lookup       |
| 4   | `_calculateArrForfait()`        | Static   | Private | Arrival time calc    |
| 5   | `_calculateNightFlightTime()`   | Static   | Private | Night flight calc    |
| 6   | `_determineTsvStatus()`         | Static   | Private | TSV status           |
| 7   | `fromVolPdf()`                  | Factory  | Public  | Create from VolPdf   |
| 8   | `updateIcaoCodes()`             | Instance | Public  | Refresh ICAO codes   |
| 9   | `updateMissingValues()`         | Instance | Public  | Recalculate missing  |
| 10  | `copyWith()`                    | Instance | Public  | Create modified copy |
| 11  | `isFlightType`                  | Getter   | Public  | Type checker         |
| 12  | `depAirportName`                | Getter   | Public  | Uses AeroportModel   |
| 13  | `arrAirportName`                | Getter   | Public  | Uses AeroportModel   |
| 14  | Duration getters (8)            | Getter   | Public  | Duration conversions |
| 15  | `calculateMonthlyCumul()`       | Static   | Public  | Generic cumul        |
| 16  | Specific cumul (6)              | Static   | Public  | Specific cumuls      |
| 17  | `getCrews()`                    | Static   | Public  | Crew conversion      |
| 18  | `_stringToDuration()`           | Static   | Private | String→Duration      |
| 19  | `_durationToString()`           | Static   | Private | Duration→String      |

**Moved to AeroportModel:**

| #   | Method                   | Location      | Purpose             |
| --- | ------------------------ | ------------- | ------------------- |
| 1   | `getIcaoByIata()`        | AeroportModel | IATA→ICAO lookup    |
| 2   | `getAirportNameByIata()` | AeroportModel | Airport name lookup |
| 3   | `getPrayerTimes()`       | AeroportModel | Prayer times lookup |
| 4   | `calculateSunrise()`     | AeroportModel | Sunrise calculation |
| 5   | `calculateSunset()`      | AeroportModel | Sunset calculation  |

---

## Key Features

✅ **Type-Aware Calculations:** Different logic for Vol vs MEP/TAX vs other types  
✅ **Automatic ICAO Lookup:** From IATA codes using database  
✅ **Forfait Lookup:** Season-based (ETE/HIVER) with fallback  
✅ **Prayer Times:** Islamic calendar calculations for night flights  
✅ **TSV Status:** Automatic determination from check-in dates  
✅ **Error Handling:** Graceful fallbacks, no exceptions thrown  
✅ **Immutable Pattern:** copyWith() creates new instances  
✅ **Cumulative Calculations:** Monthly summaries from month start

---

## Dependencies

- `Fct` - Helper functions (duration conversion, date parsing)
- `DatabaseController` - Airport and forfait lookups
- `adhan_dart` - Islamic prayer time calculations
- `AeroportModel` - Airport data
- `ForfaitModel` - Forfait data
- `Crew` - Crew relationships

voila une liste d'instruction a excuter pas a pas avec un plan bien detaille revoit d'abord le dossier DOCUMENTATION pour bien comprendre le context ..voila les instructions:
pour bien structure mon projet j'aimerais reecrir volModel et refaire VolTraiteModel en class StringVolModel et VolTraiteMoisModel
cet class est utilisé pour calculer et stocker les données de volModes dans un format string dans objectbox
Factory StringVolModel From VolModel:
directement du VolModel: final String typ;
directement du VolModel: final String nVol;
directement du VolModel: final String sAvion;
directement du VolModel: final String tsv;
directement du VolModel: final String crews;
directement du VolModel: final String sDebut; format dateFormatMMMm
directement du VolModel: final String depIata;
directement du VolModel: final String arrIata;
directement du VolModel: final String stFin; format dateFormatMMMm
/ En calcul du VolModel:
/ (on evitera multiple appel a des fonctions:comme DatabaseController.instance.getAeroportByOaci....)
avec DatabaseController.instance.getAeroportByOaci(depIata) : final String depIcao;
avec DatabaseController.instance.getAeroportByOaci(arrIata) : final String arrIcao;
avec: (typ == tMEP.typ || typ == tTAX.typ)? Fct.durationToString(dtFin.difference(dtDebut)): Fct.durationToString(Duration.zero): final String sMepvol;
avec:pour (typ == tVol.typ)
avec: (typ == tVol.typ)? Fct.durationToString(dtFin.difference(dtDebut)): Fct.durationToString(Duration.zero): final String sDureevol;
sunrise ?? AeroportModel.calculateSunrise(typ, DatabaseController.instance.getAeroportByOaci(depIata), DatabaseController.instance.getAeroportByOaci(depIata), dtDebut);
sunset ?? AeroportModel.calculateSunset(typ, DatabaseController.instance.getAeroportByOaci(depIata), DatabaseController.instance.getAeroportByOaci(depIata), dtDebut);
sNuitVol ?? \_calculateNightFlightTime(typ, sunrise, sunset, dtDebut, dtFin) :sNuitVol
(note bien :AeroportModel.calculateSunrise calcul le lever du jour le plus tard entre le aeroport de depart et d'arrivee) )
(note bien :AeroportModel.calculateSet calcul le coucher du jour le plus tot entre le aeroport de depart et d'arrivee) )

si UserModel.isPnt == true et pour (typ == tVol.typ) :
avec:\_getForfaitValue(typ, DatabaseController.instance.getAeroportByOaci(depIata), DatabaseController.instance.getAeroportByOaci(depIata), dtDebut,dtFin): final String sDureeForfait;
avec:\_calculateArrForfait(typ, DatabaseController.instance.getAeroportByOaci(depIata), DatabaseController.instance.getAeroportByOaci(depIata), dtDebut,dtFin): final arrForfait;
avec: (typ == tVol.typ)? Fct.durationToString(arrForfait.difference(dtDebut)): Fct.durationToString(Duration.zero): final String sDureevol;
avec: (typ == tMEP.typ || typ == tTAX.typ)? Fct.durationToString(arrForfait.difference(dtDebut)): Fct.durationToString(Duration.zero): final String sMepvol;
sNuitVol ?? \_calculateNightFlightTime(typ, sunrise, sunset, dtDebut, arrForfait) :sNuitForfait
(note bien :\_calculateNightFlightTime doit calculer la duree du vol qui s'ecoule entre sunset et sunrise calculer pour le depart et l'arrivee).
Calcul cumul duree VolModel depuis debut du mois dtDebut.mois jusqu'a dtDebut inclue des VolModels dont qui debut ou se termine dans dtDebut.mois :
cumulDuree sDureevol : sCumulDureeVol,
cumulDuree sDureeMep sCumulDureeMep,
cumulDuree sDureeForfait: sCumulDureeForfait,
cumulDuree sMepForfait: sCumulMepForfait,
cumulDuree sNuitVol : sCumulNuitVol,
cumulDuree sNuitForfait: sCumulNuitForfait,
(note bien : le cumuls dessi un volModel est a cheval entre deux mois en comptabilise seulement la duree inclus dans ce mois )
