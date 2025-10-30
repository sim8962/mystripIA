# 🤖 IACODE GENERATION PROMPTS - CHRONOLOGICAL BUILD ORDER

**Rebuild your app step-by-step in the correct order to avoid dependencies issues.**

---

## 📋 BUILD ORDER

```
STEP 1: Models (Data Layer)
  ├─ UserModel
  ├─ AeroportModel
  ├─ ForfaitModel
  ├─ ForfaitListModel
  ├─ MyDownLoad
  ├─ MyDuty
  ├─ MyStrip
  ├─ VolPdf
  ├─ VolPdfList
  ├─ ChechPlatFormMonth
  ├─ VolModel
  ├─ VolTraiteModel
  └─ VolTraiteMoisModel

STEP 2: Services & Controllers (Business Logic)
  ├─ ObjectBoxService
  ├─ DatabaseController
  ├─ WebViewEcreenController
  ├─ AcceuilController
  ├─ RegisterController
  ├─ ImportrosterCtl
  └─ OutilImportController

STEP 3: Screens (UI Layer)
  ├─ AcceuilScreen
  ├─ Webviewscreen
  ├─ RegisterScreen
  └─ ImportRosterScreen
```

---

# STEP 1: MODELS (Data Layer)

## 🔧 Prompt 1: Generate `UserModel`

**File:** `lib/Models/userModel/usermodel.dart`

```
Generate a Flutter ObjectBox entity for user/pilot account management.

FILE: lib/Models/userModel/usermodel.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class UserModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;              // ObjectBox ID
   - int? matricule;                // Pilot ID (unique)
   - String? email;                 // Email address
   - bool? isRam;                   // Airline (true=RAM, false=AMS)
   - bool? isPnt;                   // Pilot type (true=PNC, false=PNT)
   - bool? isMoyenC;                // Sector (true=Long Courrier, false=Moyen Courrier)
   - List<int>? users;              // Additional user data
   - @Backlink() final myDownLoads = ToMany<MyDownLoad>();  // Related downloads

2. Constructor:
   - UserModel({
       this.matricule,
       this.email,
       this.isRam,
       this.isPnt,
       this.isMoyenC,
       this.users
     })

3. Imports needed:
   - package:objectbox/objectbox.dart

4. Code style:
   - Use @Entity() and @Id() annotations
   - Use @Backlink() for relationships
   - Follow Dart naming conventions
   - Add comments for clarity

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 2: Generate `AeroportModel`

**File:** `lib/Models/jsonModels/datas/airport_model.dart`

```
Generate a Flutter ObjectBox entity for airport data management.

FILE: lib/Models/jsonModels/datas/airport_model.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class AeroportModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;              // ObjectBox ID
   - @Property() String icao;       // ICAO code (4 letters)
   - @Property() String iata;       // IATA code (3 letters)
   - @Property() String name;       // Airport name
   - @Property() String city;       // City name
   - @Property() String country;    // Country name
   - @Property() double latitude;   // Geographic latitude
   - @Property() double longitude;  // Geographic longitude
   - @Property() String altitude;   // Altitude in feet

2. Constructor:
   - AeroportModel({
       this.id = 0,
       required this.icao,
       required this.iata,
       required this.name,
       required this.city,
       required this.country,
       required this.latitude,
       required this.longitude,
       required this.altitude,
     })

3. Factory Methods:
   - fromJson(Map<String, dynamic> json) - Parse from JSON
   - fromAeroportJson(Map<String, dynamic> json) - Parse from API format

4. Methods:
   - toJson() - Convert to JSON
   - copyWith() - Create modified copy
   - toString() - String representation
   - operator==() and hashCode - Equality based on ICAO + IATA

5. Static Methods:
   - fillAirportModelsIfEmpty() (async) - Load from JSON asset if empty
   - fetchAirportIcao(String icao) (async) - Fetch from API by ICAO
   - fetchAirportIata(String iata) (async) - Fetch from API by IATA
   - _findAirportInAssetByIcao(String icao) (async, private) - Search JSON asset
   - addAeroportFromFrorfait() (async) - Add airports from forfaits

6. Imports needed:
   - package:flutter/services.dart
   - package:objectbox/objectbox.dart
   - package:http/http.dart as http
   - dart:convert
   - ../../helpers/constants.dart
   - ../../helpers/myerrorinfo.dart
   - ../../controllers/database_controller.dart

7. Code style:
   - Use @Entity() and @Property() annotations
   - Proper error handling with try-catch
   - Log errors via MyErrorInfo.erreurInos()
   - Use async/await for async operations

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 3: Generate `ForfaitModel`

**File:** `lib/Models/jsonModels/datas/forfait_model.dart`

```
Generate a Flutter ObjectBox entity for flight forfait data management.

FILE: lib/Models/jsonModels/datas/forfait_model.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class ForfaitModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;              // ObjectBox ID
   - @Property() String cle;        // Unique key (season+sector+dep+arr)
   - @Property() String saison;     // Season (e.g., "E" for été)
   - @Property() String secteur;    // Sector (e.g., "MC")
   - @Property() String depICAO;    // Departure ICAO code
   - @Property() String arrICAO;    // Arrival ICAO code
   - @Property() String depIATA;    // Departure IATA code
   - @Property() String arrIATA;    // Arrival IATA code
   - @Property() String forfait;    // Duration (format: "XXhYY")
   - @Property() String table;      // Table reference
   - @Property() String dateForfait;// Date (format: "dd/MM/yyyy")

2. Constructor:
   - ForfaitModel({
       this.id = 0,
       required this.cle,
       required this.saison,
       required this.secteur,
       required this.depICAO,
       required this.arrICAO,
       required this.depIATA,
       required this.arrIATA,
       required this.forfait,
       required this.table,
       required this.dateForfait,
     })

3. Factory Methods:
   - fromJson(Map<String, dynamic> json) - Parse from JSON, convert "HH:MM" to "XXhYY"

4. Methods:
   - toJson() - Convert to JSON
   - copyWith() - Create modified copy
   - toString() - String representation
   - operator==() and hashCode - Equality based on cle + dateForfait

5. Static Methods:
   - fetchFromJson() (async) - Load all forfaits from JSON asset
   - fillForfaitModelBoxIfEmpty() (async) - Load from JSON if empty
   - parseExcel(Uint8List bytes) - Parse Excel file with forfaits

6. Imports needed:
   - dart:convert
   - package:intl/intl.dart
   - package:excel/excel.dart
   - package:flutter/services.dart
   - package:objectbox/objectbox.dart
   - ../../../helpers/constants.dart
   - ../../../helpers/myerrorinfo.dart
   - ../../../controllers/database_controller.dart
   - forfaitlist.model.dart

7. Code style:
   - Use @Entity() and @Property() annotations
   - Proper error handling with try-catch
   - Log errors via MyErrorInfo.erreurInos()
   - Convert time format "HH:MM" → "XXhYY" with zero padding

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 4: Generate `ForfaitListModel`

**File:** `lib/Models/jsonModels/datas/forfaitlist.model.dart`

```
Generate a Flutter ObjectBox entity for forfait list management.

FILE: lib/Models/jsonModels/datas/forfaitlist.model.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class ForfaitListModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;                           // ObjectBox ID
   - @Property() String name;                    // List name/identifier
   - @Property(type: PropertyType.date) DateTime date;  // Date of forfait list
   - final forfaits = ToMany<ForfaitModel>();   // Related forfaits

2. Constructor:
   - ForfaitListModel({
       this.id = 0,
       required this.name,
       required this.date
     })

3. Factory Methods:
   - fromJson(Map<String, dynamic> json) - Parse from JSON, recursively parse forfaits
   - fromJsonString(String jsonString) - Parse from JSON string

4. Methods:
   - toJson() - Convert to JSON, include all forfaits
   - toJsonString() - Convert to JSON string
   - copyWith() - Create modified copy, deduplicate forfaits
   - toString() - String representation
   - operator==() and hashCode - Equality based on id, name, forfaits length

5. Static Methods:
   - getForfaitListFromExcel(File excelFile, DateFormat dateFormat) (async) - Parse Excel file
     * Extract filename for date
     * Parse Excel using ForfaitModel.parseExcel()
     * Assign dateForfait to each forfait
     * Return ForfaitListModel or null

6. Imports needed:
   - dart:convert
   - dart:io
   - package:intl/intl.dart
   - package:objectbox/objectbox.dart
   - ../../../helpers/myerrorinfo.dart
   - forfait_model.dart

7. Code style:
   - Use @Entity() and @Property() annotations
   - Use ToMany<ForfaitModel>() for relationships
   - Proper error handling with try-catch
   - Log errors via MyErrorInfo.erreurInos()

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 5: Generate `MyDownLoad`

**File:** `lib/Models/userModel/my_download.dart`

```
Generate a Flutter ObjectBox entity for downloaded roster data.

FILE: lib/Models/userModel/my_download.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class MyDownLoad with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;                           // ObjectBox ID
   - String? jsonContent;                        // Downloaded JSON content
   - String? htmlContent;                        // Downloaded HTML content
   - @Property(type: PropertyType.date) DateTime downloadTime;  // Download timestamp
   - final user = ToOne<UserModel>();           // Related user (one-to-one)

2. Constructor:
   - MyDownLoad({
       this.jsonContent,
       this.htmlContent,
       required this.downloadTime
     })

3. Equality & Hash:
   - operator==() - Compare based on downloadTime (year, month, day, hour, minute)
   - hashCode - Hash based on downloadTime components

4. Imports needed:
   - package:objectbox/objectbox.dart
   - usermodel.dart

5. Code style:
   - Use @Entity() and @Id() annotations
   - Use @Property(type: PropertyType.date) for DateTime
   - Use ToOne<UserModel>() for relationship
   - Implement custom equality based on timestamp

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 6: Generate `MyDuty`

**File:** `lib/Models/ActsModels/myduty.dart`

```
Generate a Flutter ObjectBox entity for duty/activity management.

FILE: lib/Models/ActsModels/myduty.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class MyDuty with @Entity() annotation {

1. Properties:
   - @Id(assignable: true) int id;               // ObjectBox ID (assignable)
   - @Property(type: PropertyType.date) DateTime myMonth;  // Month reference
   - @Property(type: PropertyType.date) DateTime startTime;  // Duty start time
   - @Property(type: PropertyType.date) DateTime endTime;    // Duty end time
   - String dateLabel;                           // Formatted date label
   - String typeLabel;                           // Duty type label
   - String detailLabel;                         // Detail description
   - final typ = ToOne<Typ>();                  // Related duty type
   - final vols = ToMany<VolModel>();           // Related flights
   - @Backlink('myDuty') final crews = ToMany<Crew>();  // Related crew members
   - @Backlink('myDuty') final etapes = ToMany<MyEtape>();  // Related etapes

2. Constructor:
   - MyDuty({
       this.id = 0,
       required this.myMonth,
       required this.startTime,
       required this.endTime,
       required this.dateLabel,
       required this.typeLabel,
       required this.detailLabel,
     })

3. Imports needed:
   - dart:math
   - package:objectbox/objectbox.dart
   - package:get/get.dart
   - ../../helpers/constants.dart
   - ../../helpers/fct.dart
   - ../../helpers/myerrorinfo.dart
   - ../VolsModels/vol.dart
   - ../jsonModels/mystripjson/activity_activity_model.dart
   - ../jsonModels/mystripjson/duty.dart
   - ../jsonModels/mystripjson/mystrip_model.dart
   - crew.dart
   - myetape.dart
   - typ.dart
   - typ_const.dart

4. Code style:
   - Use @Entity() and @Id(assignable: true) annotations
   - Use @Property(type: PropertyType.date) for DateTime
   - Use ToOne<Typ>() and ToMany<VolModel>() for relationships
   - Use @Backlink() for reverse relationships

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 7: Generate `MyStrip`

**File:** `lib/Models/jsonModels/mystripjson/mystrip_model.dart`

```
Generate a Flutter JSON model for roster/strip data.

FILE: lib/Models/jsonModels/mystripjson/mystrip_model.dart
FRAMEWORK: Flutter
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class MyStrip {

1. Properties:
   - DateTime? downloadTime;     // When the strip was downloaded
   - MyEntity? entity;           // Parsed entity data from JSON

2. Constructor:
   - MyStrip({
       required this.downloadTime,
       required this.entity
     })

3. Methods:
   - copyWith({DateTime? downloadTime, MyEntity? entity}) - Create modified copy
   - fromJson(Map<String, dynamic> json) (factory) - Parse from JSON
     * Parse downloadTime using DateTime.tryParse()
     * Parse entity using MyEntity.fromJson()
   - toJson() - Convert to JSON
     * Return map with downloadTime as ISO8601 string
     * Return entity as JSON
   - toString() - String representation

4. Imports needed:
   - my_entity_model.dart

5. Code style:
   - Use factory constructors for JSON parsing
   - Handle nullable values safely
   - Implement copyWith for immutability pattern
   - Proper JSON serialization

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 8: Generate `VolPdf`

**File:** `lib/Models/volpdfs/vol_pdf.dart`

```
Generate a Dart model for PDF-extracted flight data.

FILE: lib/Models/volpdfs/vol_pdf.dart
FRAMEWORK: Flutter
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class VolPdf {

1. Properties:
   - DateTime dateVol;              // Flight date
   - String from;                   // Departure airport (IATA)
   - String to;                     // Arrival airport (IATA)
   - String activity;               // Flight activity code
   - String duty;                   // Duty type (VOL, MEP, TAX, HTL, etc.)
   - String aC;                     // Aircraft registration
   - String cle;                    // Unique key
   - String myArrDate;              // Arrival date/time string

2. Constructor:
   - VolPdf({
       required this.dateVol,
       required this.from,
       required this.to,
       required this.activity,
       required this.duty,
       required this.aC,
       required this.cle,
       required this.myArrDate,
     })

3. Methods:
   - fromVolModel(VolModel) (factory) - Convert from VolModel
   - toJson() - Convert to JSON
   - toString() - String representation

4. Static Methods:
   - parseDateTimeFromString(String, DateTime?) - Parse date/time strings

5. Code style:
   - Handle nullable values safely
   - Proper date/time parsing
   - JSON serialization support

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 9: Generate `VolPdfList`

**File:** `lib/Models/volpdfs/vol_pdf_list.dart`

```
Generate a Dart model for a list of PDF-extracted flights.

FILE: lib/Models/volpdfs/vol_pdf_list.dart
FRAMEWORK: Flutter
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class VolPdfList {

1. Properties:
   - String pdfName;                // Original PDF filename
   - List<VolPdf> vols;             // Extracted flights
   - String tags;                   // BLC tags from PDF

2. Constructor:
   - VolPdfList({
       required this.pdfName,
       required this.vols,
       required this.tags,
     })

3. Methods:
   - fromChechPlatFormMonth(ChechPlatFormMonth) (factory) - Create from ChechPlatFormMonth
   - toVolModels() - Convert all vols to VolModel
   - toJson() - Convert to JSON
   - toString() - String representation

4. Code style:
   - Handle list conversions
   - Proper factory pattern
   - JSON serialization support

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 10: Generate `ChechPlatFormMonth`

**File:** `lib/Models/volpdfs/chechplatform.dart`

```
Generate a Dart model for platform-specific month data from PDF.

FILE: lib/Models/volpdfs/chechplatform.dart
FRAMEWORK: Flutter
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class ChechPlatFormMonth {

1. Properties:
   - String monthName;              // Month name (e.g., "October 2025")
   - String monthReference;         // Month reference (YYYY-MM format)
   - List<VolPdf> vols;             // Extracted flights for month
   - String tags;                   // BLC tags

2. Constructor:
   - ChechPlatFormMonth({
       required this.monthName,
       required this.monthReference,
       required this.vols,
       required this.tags,
     })

3. Methods:
   - toJson() - Convert to JSON
   - toString() - String representation
   - operator==() and hashCode - Equality based on monthReference

4. Code style:
   - Handle list operations
   - Proper equality implementation
   - JSON serialization support

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 11: Generate `VolModel`

**File:** `lib/Models/VolsModels/vol.dart`

```
Generate a Flutter ObjectBox entity for flight data.

FILE: lib/Models/VolsModels/vol.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class VolModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;              // ObjectBox ID
   - String typ;                    // Flight type (VOL, MEP, TAX, HTL)
   - String nVol;                   // Flight number
   - @Property(type: PropertyType.date) DateTime dtDebut;  // Departure date/time
   - @Property(type: PropertyType.date) DateTime dtFin;    // Arrival date/time
   - String depIata;                // Departure IATA
   - String arrIata;                // Arrival IATA
   - String sAvion;                 // Aircraft
   - String cle;                    // Unique key
   - String tsv;                    // Additional data

2. Constructor:
   - VolModel({
       this.id = 0,
       required this.typ,
       required this.nVol,
       required this.dtDebut,
       required this.dtFin,
       required this.depIata,
       required this.arrIata,
       required this.sAvion,
       required this.cle,
       required this.tsv,
     })

3. Factory Methods:
   - fromVolPdf(VolPdf) - Convert from VolPdf

4. Methods:
   - toJson() - Convert to JSON
   - copyWith() - Create modified copy
   - toString() - String representation
   - operator==() and hashCode - Equality based on cle

5. Imports needed:
   - package:objectbox/objectbox.dart
   - ../volpdfs/vol_pdf.dart

6. Code style:
   - Use @Entity() and @Property() annotations
   - Proper date/time handling
   - JSON serialization support

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 12: Generate `VolTraiteModel`

**File:** `lib/Models/VolsModels/vol_traite.dart`

```
Generate a Flutter ObjectBox entity for processed flight data with cumuls.

FILE: lib/Models/VolsModels/vol_traite.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class VolTraiteModel with @Entity() annotation {

1. Properties:
   - @Id(assignable: true) int id;  // ObjectBox ID (assignable)
   - String typ;                    // Flight type
   - String nVol;                   // Flight number
   - @Property(type: PropertyType.date) DateTime dtDebut;  // Departure
   - @Property(type: PropertyType.date) DateTime dtFin;    // Arrival
   - String depIata;                // Departure IATA
   - String arrIata;                // Arrival IATA
   - String moisReference;          // Month reference (YYYY-MM)
   - String sCumulDureeVol;         // Cumulative flight duration
   - String sCumulDureeMep;         // Cumulative MEP duration
   - String sCumulNuitVol;          // Cumulative night flight hours
   - (other cumul fields as needed)

2. Constructor:
   - VolTraiteModel({
       this.id = 0,
       required this.typ,
       required this.nVol,
       required this.dtDebut,
       required this.dtFin,
       required this.depIata,
       required this.arrIata,
       required this.moisReference,
       required this.sCumulDureeVol,
       required this.sCumulDureeMep,
       required this.sCumulNuitVol,
     })

3. Factory Methods:
   - fromVolModel(VolModel, List<VolModel>) - Convert from VolModel with cumul calculations

4. Methods:
   - toJson() - Convert to JSON
   - copyWith() - Create modified copy
   - toString() - String representation

5. Imports needed:
   - package:objectbox/objectbox.dart
   - vol.dart
   - ../../helpers/fct.dart

6. Code style:
   - Use @Entity() and @Property() annotations
   - Calculate cumuls from VolModel list
   - Proper date/time handling

Generate complete, production-ready code with proper formatting.
```

---

## 🔧 Prompt 13: Generate `VolTraiteMoisModel`

**File:** `lib/Models/VolsModels/vol_traite_mois.dart`

```
Generate a Flutter ObjectBox entity for monthly flight summary.

FILE: lib/Models/VolsModels/vol_traite_mois.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: MVC - Data Model

REQUIREMENTS:

Create class VolTraiteMoisModel with @Entity() annotation {

1. Properties:
   - @Id() int id = 0;              // ObjectBox ID
   - String moisAnneeFormate;       // Formatted month (e.g., "October 2025")
   - String moisReference;          // Month reference (YYYY-MM)
   - int nombreVolsTotal;           // Total number of flights
   - String cumulTotalDureeVol;     // Total flight duration
   - String cumulTotalDureeMep;     // Total MEP duration
   - String cumulTotalNuitVol;      // Total night flight hours
   - final volsTraites = ToMany<VolTraiteModel>();  // Related flights

2. Constructor:
   - VolTraiteMoisModel({
       this.id = 0,
       required this.moisAnneeFormate,
       required this.moisReference,
       required this.nombreVolsTotal,
       required this.cumulTotalDureeVol,
       required this.cumulTotalDureeMep,
       required this.cumulTotalNuitVol,
     })

3. Factory Methods:
   - fromVolsTraites(int year, int month, List<VolTraiteModel>) - Create from VolTraiteModel list

4. Methods:
   - toJson() - Convert to JSON
   - copyWith() - Create modified copy
   - toString() - String representation

5. Imports needed:
   - package:objectbox/objectbox.dart
   - vol_traite.dart
   - ../../helpers/fct.dart

6. Code style:
   - Use @Entity() and @Property() annotations
   - Use ToMany<VolTraiteModel>() for relationships
   - Aggregate cumuls from VolTraiteModel list

Generate complete, production-ready code with proper formatting.
```

---

# STEP 2: SERVICES & CONTROLLERS (Business Logic)

## 🔧 Prompt 14: Generate `ObjectBoxService`

**File:** `lib/controllers/objectbox_service.dart`

```
Generate a Flutter ObjectBox database service with CRUD operations for all entities.

FILE: lib/controllers/objectbox_service.dart
FRAMEWORK: Flutter with ObjectBox
ARCHITECTURE: Repository Pattern - Data Access Layer

REQUIREMENTS:

Create class ObjectBoxService {

1. Properties:
   - late final Store store;
   - late final Box<MyDuty> _dutyBox;
   - late final Box<VolTraiteMoisModel> _volTraiteMoisBox;
   - late final Box<VolPdfList> _volPdfListBox;
   - late final Box<UserModel> _userBox;
   - late final Box<MyDownLoad> _downloadBox;
   - late final Box<AeroportModel> _airportBox;
   - late final Box<ForfaitListModel> _forfaitListBox;
   - bool _isClosed = false;

2. Static Methods:
   - static Future<ObjectBoxService> create() - Opens ObjectBox store
   - static Future<ObjectBoxService> initializeNewBoxes() - Safe initialization with error recovery
   - static Future<void> _resetObjectBoxDirectory() - Resets corrupted database

3. Private Methods:
   - void _initializeBoxes() - Initialize all Box instances
   - int _compareNullable<T extends Comparable>(T? a, T? b) - Safe nullable comparison

4. Public Methods:
   - void close() - Close database connection
   - bool get isClosed - Check if closed

5. CRUD Methods for MyDuty:
   - List<MyDuty> replaceAllDuties(List<MyDuty>) - Replace all, sorted by startTime
   - void removeAllDuties() - Delete all
   - List<MyDuty> getAllDuties() - Retrieve all, sorted by startTime

6. CRUD Methods for VolTraiteMoisModel:
   - List<VolTraiteMoisModel> replaceAllVolTraiteMois(List<VolTraiteMoisModel>) - Replace all, sorted by premierJourMois
   - void removeAllVolTraitesParMois() - Delete all
   - List<VolTraiteMoisModel> getAllVolTraitesParMois() - Retrieve all, sorted by premierJourMois

7. CRUD Methods for VolPdfList:
   - List<VolPdfList> replaceAllVolPdfLists(List<VolPdfList>) - Replace all, sorted by month
   - void removeAllVolPdfLists() - Delete all
   - void addAllVolPdfLists(List<VolPdfList>) - Add to database
   - List<VolPdfList> getAllVolPdfLists() - Retrieve all, sorted by month

8. CRUD Methods for UserModel:
   - List<UserModel> replaceAllUsers(List<UserModel>) - Replace all, sorted by matricule
   - void removeAllUsers() - Delete all
   - void addAllUsers(List<UserModel>) - Add to database
   - List<UserModel> getAllUsers() - Retrieve all, sorted by matricule

9. CRUD Methods for MyDownLoad:
   - List<MyDownLoad> replaceAllDownloads(List<MyDownLoad>) - Replace all, sorted by downloadTime
   - void removeAllDownloads() - Delete all
   - void addAllDownloads(List<MyDownLoad>) - Add to database
   - List<MyDownLoad> getAllDownloads() - Retrieve all, sorted by downloadTime

10. CRUD Methods for AeroportModel:
    - List<AeroportModel> replaceAllAirports(List<AeroportModel>) - Replace all, sorted by icao
    - void removeAllAirports() - Delete all
    - void addAllAirports(List<AeroportModel>) - Add to database
    - List<AeroportModel> getAllAirports() - Retrieve all, sorted by icao

11. CRUD Methods for ForfaitListModel:
    - List<ForfaitListModel> replaceAllForfaitLists(List<ForfaitListModel>) - Replace all, sorted by date
    - void removeAllForfaitLists() - Delete all
    - void addAllForfaitLists(List<ForfaitListModel>) - Add to database
    - List<ForfaitListModel> getAllForfaitLists() - Retrieve all, sorted by date

12. Imports needed:
    - dart:io
    - package:path/path.dart as p
    - package:path_provider/path_provider.dart
    - ../Models/ActsModels/myduty.dart
    - ../Models/VolsModels/vol_traite_mois.dart
    - ../Models/volpdfs/vol_pdf_list.dart
    - ../Models/jsonModels/datas/airport_model.dart
    - ../Models/jsonModels/datas/forfaitlist.model.dart
    - ../Models/userModel/my_download.dart
    - ../Models/userModel/usermodel.dart
    - ../objectbox.g.dart

13. Code style:
    - All write operations wrapped in store.runInTransaction(TxMode.write, () { ... })
    - Automatic sorting by relevant field for each entity
    - Proper error handling with try-catch
    - Clear variable names and comments

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 15: Generate `DatabaseController`

**File:** `lib/controllers/database_controller.dart`

```
Generate a Flutter GetxController wrapping ObjectBoxService with reactive state management.

FILE: lib/controllers/database_controller.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - Controller (High-level business logic)

REQUIREMENTS:

Create class DatabaseController extends GetxController {

1. Static Access:
   - static DatabaseController get instance => Get.find();

2. Properties:
   - late final ObjectBoxService objectBox;

3. Lifecycle:
   - void onInit() - Gets ObjectBoxService instance

4. Reactive Lists (7 entity types):
   - final RxList<MyDuty> _duties = <MyDuty>[].obs;
   - final RxList<VolTraiteMoisModel> _volTraitesParMois = <VolTraiteMoisModel>[].obs;
   - final RxList<VolPdfList> _volPdfLists = <VolPdfList>[].obs;
   - final RxList<UserModel> _users = <UserModel>[].obs;
   - final RxList<MyDownLoad> _downloads = <MyDownLoad>[].obs;
   - final RxList<AeroportModel> _airports = <AeroportModel>[].obs;
   - final RxList<ForfaitListModel> _forfaitLists = <ForfaitListModel>[].obs;

5. Getters and Setters for each reactive list

6. VolPdfList Management Methods:
   - void addVolPdfList(VolPdfList) - Add single list
   - void getAllVolPdfLists() - Load all from database
   - void addVolPdfLists(List<VolPdfList>) - Add multiple lists
   - void replaceAllVolPdfLists(List<VolPdfList>) - Replace all
   - void clearAllVolPdfLists() - Delete all

7. VolTraiteMoisModel Management Methods:
   - void getAllVolTraitesParMois() - Load all from database
   - void clearAllVolTraitesParMois() - Delete all
   - void replaceAllVolTraiteMois(List<VolTraiteMoisModel>) - Replace all

8. MyDuty Management Methods:
   - void addDuty(MyDuty) - Add single duty
   - void getAllDuties() - Load all from database
   - void addDuties(List<MyDuty>) - Add multiple duties
   - void replaceAllDuties(List<MyDuty>) - Replace all
   - void clearAllDuties() - Delete all

9. UserModel Management Methods:
   - void addUser(UserModel) - Add single user
   - void getAllUsers() - Load all from database
   - void addUsers(List<UserModel>) - Add multiple users
   - void replaceAllUsers(List<UserModel>) - Replace all
   - void updateUser(UserModel) - Update existing user
   - UserModel? getUserByMatricule(int) - Find user by ID

10. AeroportModel Management Methods:
    - void addAirport(AeroportModel) - Add single airport
    - void getAllAirports() - Load all from database
    - void addAirports(List<AeroportModel>) - Add multiple airports
    - void replaceAllAirports(List<AeroportModel>) - Replace all
    - AeroportModel? getAeroportByOaci(String) - Find by OACI code
    - AeroportModel? getAeroportByIata(String) - Find by IATA code
    - String getAirportCity(String) - Get city name from IATA code

11. ForfaitListModel Management Methods:
    - void getAllForfaitLists() - Load all from database
    - void addForfaitLists(List<ForfaitListModel>) - Add multiple
    - void replaceAllForfaitLists(List<ForfaitListModel>) - Replace all

12. MyDownLoad Management Methods:
    - void getAllDownloads() - Load all from database
    - void addDownloads(List<MyDownLoad>) - Add multiple
    - void replaceAllDownloads(List<MyDownLoad>) - Replace all

13. Global Operations:
    - void getAllDatas() - Load all data from database
    - void clearAllData() - Delete all data and refresh

14. Imports needed:
    - dart:convert
    - dart:io
    - package:get/get.dart
    - package:intl/intl.dart
    - package:path_provider/path_provider.dart
    - ../Models/ActsModels/myduty.dart
    - ../Models/VolsModels/vol.dart
    - ../Models/VolsModels/vol_traite.dart
    - ../Models/VolsModels/vol_traite_mois.dart
    - ../Models/volpdfs/vol_pdf_list.dart
    - ../Models/jsonModels/datas/airport_model.dart
    - ../Models/jsonModels/datas/forfait_model.dart
    - ../Models/jsonModels/datas/forfaitlist.model.dart
    - ../Models/userModel/my_download.dart
    - ../Models/userModel/usermodel.dart
    - objectbox_service.dart

15. Code style:
    - Use reactive lists for automatic UI binding
    - All operations update reactive lists automatically
    - Proper error handling with try-catch
    - Clear method names and comments
    - Follow GetX patterns

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 17: Generate `WebViewEcreenController`

**File:** `lib/views/2_webview/webview_ctl.dart`

```
Generate a Flutter GetxController for webview management and roster data processing.

FILE: lib/views/2_webview/webview_ctl.dart
FRAMEWORK: Flutter with GetX and webview_flutter
ARCHITECTURE: MVC - Controller

REQUIREMENTS:

Create class WebViewEcreenController extends GetxController {

1. Dependencies:
   - final _secureStorage = SecureStorageService();
   - final _encryptionHelper = EncryptionHelper();
   - late final WebViewController _webViewController;
   - final StripProcessor _stripProcessor = StripProcessor();

2. Reactive Variables:
   - _isJson (RxBool, initial: true)
   - _ijson (RxInt, initial: 0) - State counter 0-5
   - _sEtape (RxString, initial: '')
   - _visibleWeb (RxBool, initial: true)
   - _visibleenregistre (RxBool, initial: false)
   - _jsonString (Rxn<String>)
   - _getConnexion (RxBool, initial: false)
   - currentUrl (RxString)
   - pageTitle (RxString)
   - rxUser (RxString)
   - rxPass (RxString)

3. onInit() method:
   - Check connectivity via Fct.checkConnectivity()
   - Set sEtape = 'status_downloading'.tr if connected
   - Call _initializeWebView() if connected
   - Set sEtape = 'no_connection'.tr if not connected

4. _initializeWebView() (async, private):
   - Initialize platform-specific parameters (iOS WebKit, Android)
   - Create WebViewController from platform params
   - Set JavaScriptMode.unrestricted
   - Configure NavigationDelegate with onUrlChange and onPageFinished
   - Load baseUrl

5. onPageFinish() (async):
   - Check ijson state and URL
   - State machine (0-5):
     * ijson=0 + adfsUrl → _performLogin(), ijson=1
     * ijson<2 + access-ui → loadUrl(jsonApiUrl), ijson=2
     * ijson=2 + jsonApiUrl → _fetchAndProcessJsonData()
     * ijson=3 → delay 1s, loadBaseUrl(), ijson=4
   - Error handling with MyErrorInfo.erreurInos()

6. onUrlChange() (async):
   - Check if ijson=4 and on roster page
   - Call _performLogout()
   - Call _clearBrowserCache()
   - Set ijson=5

7. _performLogin() (async, private):
   - Call _getCredentiel()
   - Delay 1s
   - Execute buildLoginScript() with rxUser and rxPass

8. _getCredentiel() (async, private):
   - Read sEmail from secure storage
   - Decrypt and set rxUser
   - Read sPassword from secure storage
   - Decrypt and set rxPass

9. _fetchAndProcessJsonData() (async, private):
   - Check connectivity
   - Call fetchJsonData()
   - Set sEtape = 'status_processing_in_progress'.tr
   - Set ijson=3

10. fetchJsonData() (async):
    - Execute getBodyHtmlJavaScript
    - Handle platform-specific parsing (Android vs iOS)
    - Extract JSON substring
    - Return cleaned JSON string

11. _performLogout() (async, private):
    - Set visibleenregistre=true
    - Set sEtape = 'status_processing_complete'.tr
    - Check device type (iPhone vs iPad)
    - Call _deconnexionClick() or _deconnexionIpadClick()

12. _deconnexionClick() (async, private):
    - Execute logoutJavaScriptFunction
    - Check for menu detection

13. _deconnexionIpadClick() (async, private):
    - Execute logoutIpadJavaScriptFunction

14. _clearBrowserCache() (async, private):
    - Call controller.clearCache()
    - Call controller.clearLocalStorage()

15. loadUrl() (async):
    - Check connectivity
    - Delay 1s
    - Load URL

16. loadBaseUrl() (async):
    - Check connectivity
    - Load baseUrl

17. webReset() (async):
    - Check connectivity
    - Set visibleenregistre=false
    - Set visibleWeb=true
    - Set sEtape = 'status_downloading'.tr
    - Set ijson=0
    - Call loadBaseUrl()

18. enregistrerMjsonString() (sync):
    - Parse jsonString to MyStrip
    - Call _stripProcessor.processMyStripIntoDuties()
    - Sort duties by startTime
    - Get consolidated duties from database
    - Remove old duties
    - Add new duties
    - Create MyDownLoad object
    - Call _genererVolsTraites()
    - Return true

19. remplisVoltraites() (sync):
    - Get volModels from database
    - Call _genererVolsTraites()

20. _genererVolsTraites() (private):
    - Create VolTraiteModel from each VolModel
    - Group by month (YYYY-MM)
    - Create VolTraiteMoisModel for each month
    - Replace all in database

21. Static getter:
    - static WebViewEcreenController instance = Get.find();

22. Imports needed:
    - dart:convert
    - dart:io
    - package:get/get.dart
    - package:webview_flutter/webview_flutter.dart
    - package:webview_flutter_android/webview_flutter_android.dart
    - package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart
    - ../../Models/ActsModels/myduty.dart
    - ../../Models/VolsModels/vol.dart
    - ../../Models/VolsModels/vol_traite.dart
    - ../../Models/VolsModels/vol_traite_mois.dart
    - ../../Models/jsonModels/mystripjson/mystrip_model.dart
    - ../../Models/userModel/my_download.dart
    - ../../controllers/database_controller.dart
    - ../../helpers/fct.dart
    - ../../helpers/constants.dart
    - ../../helpers/myerrorinfo.dart
    - ../../services/strip_processor.dart
    - ../../services/encryption_service.dart
    - ../../services/secure_storage_service.dart

23. Code style:
    - Use async/await for async operations
    - Proper error handling with try-catch
    - State machine pattern for ijson
    - Platform-specific handling (iOS/Android)
    - Comprehensive logging via MyErrorInfo

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 18: Generate `AcceuilController`

**File:** `lib/views/0_acceuil/acceuil_ctl.dart`

```
Generate a Flutter GetxController for app initialization and routing.

FILE: lib/views/0_acceuil/acceuil_ctl.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - Controller

REQUIREMENTS:

Create class AcceuilController extends GetxController {

1. Reactive Variables:
   - _isVisibleAcceuil (RxBool, initial: false)
   - Public getter: isVisibleAcceuil
   - Public setter: isVisibleAcceuil = bool

2. Methods:

   a) checkUsersAndNavigate() - Entry point
      - Set isVisibleAcceuil = true after 15ms delay
      - Use WidgetsBinding.instance.addPostFrameCallback to defer navigation
      - Call _performNavigation()
      - Wrap in try-catch, log errors via MyErrorInfo.erreurInos()
      - On error, fallback to Routes.toRegister()

   b) getMyIdevice() - Device detection
      - Get context from Get.context!
      - Check if context.isLargeTablet
      - Store result in GetStorage (boxGet):
        * Key: getDevice
        * Value: getIpad if tablet, getIphone if phone
      - Remove old value before writing new one

   c) _performNavigation() - async routing logic
      - Get DatabaseController.instance
      - Call dbController.getAllDatas()
      - Fill airports: await AeroportModel.fillAirportModelsIfEmpty()
      - Fill forfaits: await ForfaitModel.fillForfaitModelBoxIfEmpty()
      - Check user count:
        * if (dbController.users.isEmpty) → Routes.toRegister()
        * else if (dbController.currentUser != null):
          - if (dbController.duties.isEmpty) → Routes.toWebview()
          - else → Routes.toImportRosterScreen()
        * else → Routes.toRegister()
      - Wrap in try-catch, log errors via MyErrorInfo.erreurInos()
      - On error, fallback to Routes.toRegister()

3. Static getter:
   - static AcceuilController get instance => Get.find();

4. Imports needed:
   - dart:async
   - package:flutter/widgets.dart
   - package:get/get.dart
   - ../../helpers/constants.dart
   - ../../helpers/myerrorinfo.dart
   - ../../Models/jsonModels/datas/airport_model.dart
   - ../../Models/jsonModels/datas/forfait_model.dart
   - ../../routes/app_routes.dart
   - ../../controllers/database_controller.dart

5. Code style:
   - Use descriptive variable names
   - Add comments for complex logic
   - Follow Dart naming conventions
   - Use async/await for async operations
   - Proper error handling with try-catch

Generate complete, production-ready code with proper formatting and documentation.

---

## 🔧 Prompt 16: Generate `RegisterController`

**File:** `lib/views/1_register/register_ctl.dart`

```
Generate a Flutter GetxController for user registration and authentication.

FILE: lib/views/1_register/register_ctl.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - Controller

REQUIREMENTS:

Create class RegisterController extends GetxController {

1. Dependencies (as class properties):
   - final _secureStorage = SecureStorageService();
   - final _encryptionHelper = EncryptionHelper();

2. TextEditingControllers:
   - matController (matricule/pilot ID)
   - emailController (email address)
   - passController (password)

3. Reactive Variables:
   - _secteur (RxBool, initial: false)
     * getter: secteur
     * getter: sSecteur (returns "Moyen Courrier" if false, "Long Courrier" if true)
     * setter: secteur = bool
   
   - _amsram (RxBool, initial: false)
     * getter: amsram
     * getter: samsram (returns "RAM" if false, "AMS" if true)
     * setter: amsram = bool
   
   - _ispnt (RxBool, initial: false)
     * getter: ispnt
     * getter: spntpnc (returns "PNT" if false, "PNC" if true)
     * setter: ispnt = bool
   
   - _dones (RxBool, initial: true)
     * getter: dones
     * setter: dones = bool

4. Static getter:
   - static RegisterController instance = Get.find();

5. onInit() method:
   - Call DatabaseController.instance.getAllUsers()
   - Call _autoFillFormIfUsersExist()
   - Call rempliChampMoi()

6. _autoFillFormIfUsersExist() - async method:
   - Get DatabaseController.instance
   - Check if dbController.users.isNotEmpty
   - If yes:
     * Get first user: final firstUser = dbController.users.first
     * Fill matController.text = firstUser.matricule.toString()
     * Try to decrypt and fill password:
       - Read from secure storage: key = sPassword
       - Decrypt using _encryptionHelper.decrypt()
       - Set passController.text
     * Try to decrypt and fill email:
       - Read from secure storage: key = sEmail
       - Decrypt using _encryptionHelper.decrypt()
       - Set emailController.text
     * Catch errors and log via MyErrorInfo.erreurInos()

7. registerUser() - async method:
   - Format email: append @royalairmaroc.com if not already present
   - Parse matricule: int.tryParse(matController.text)
   - If matricule is null:
     * Show error snackbar:
       - Title: 'error_matricule_title'.tr
       - Message: 'error_matricule_invalid'.tr
       - Icon: Icons.error_outline
       - Position: TOP
       - Background: Colors.orange
       - Duration: 3 seconds
     * Set dones = true
     * Return
   - Check for existing user: DatabaseController.instance.getUserByMatricule(matricule)
   - If exists:
     * Update user data:
       - existingUser.isPnt = !ispnt
       - if (!ispnt):
         - existingUser.isRam = amsram
         - existingUser.isMoyenC = secteur
     * Call storeCredential()
     * Update in database: DatabaseController.instance.updateUser(existingUser)
   - If new user:
     * Generate random email: generateRandomEmail()
     * Call storeCredential()
     * Create new UserModel:
       - matricule: matricule
       - email: myEmail
       - isRam: !ispnt ? amsram : null
       - isMoyenC: !ispnt ? secteur : null
       - isPnt: !ispnt
     * Add to database: DatabaseController.instance.addUser(userToSave)

8. storeCredential() - async method:
   - Check if passController.text and emailController.text are not empty
   - Try:
     * Encrypt email: final encryptedEmail = await _encryptionHelper.encrypt(emailController.text)
     * Store email: await _secureStorage.write(sEmail, encryptedEmail)
     * Encrypt password: final encryptedPassword = await _encryptionHelper.encrypt(passController.text)
     * Store password: await _secureStorage.write(sPassword, encryptedPassword)
     * Clear controllers: emailController.clear(), passController.clear()
   - Catch errors and log via MyErrorInfo.erreurInos()

9. rempliChampMoi() method:
   - Fill test data:
     * matController.text = myMatricule
     * emailController.text = myUser
     * passController.text = myPass
     * secteur = false
     * amsram = false

10. generateRandomEmail() - static method:
    - Generate random string of 8-20 characters
    - Use only letters (a-z, A-Z)
    - Return: 'randomString@gmail.com'

11. Imports needed:
    - dart:math
    - package:flutter/material.dart
    - package:get/get.dart
    - ../../Models/userModel/usermodel.dart
    - ../../controllers/database_controller.dart
    - ../../services/encryption_service.dart
    - ../../services/secure_storage_service.dart
    - ../../helpers/constants.dart
    - ../../helpers/myerrorinfo.dart

12. Code style:
    - Use async/await for async operations
    - Proper error handling with try-catch
    - Clear variable names
    - Add comments for complex logic
    - Follow Dart naming conventions

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 20: Generate `ImportrosterCtl`

**File:** `lib/views/7_importRoster/importroster_ctl.dart`

```
Generate a Flutter GetxController for PDF roster import and processing.

FILE: lib/views/7_importRoster/importroster_ctl.dart
FRAMEWORK: Flutter with GetX and file_picker
ARCHITECTURE: MVC - Controller

REQUIREMENTS:

Create class ImportrosterCtl extends GetxController {

1. Reactive Variables:
   - _loading (RxBool, initial: false)
   - _etape (RxInt, initial: 0)
   - platformFiles (List<PlatformFile>)
   - myList (List<ChechPlatFormMonth>)
   - volPdfLists (List<VolPdfList>)

2. Constants:
   - _pdfExtension = 'pdf'
   - _rosterFolder = 'rosters'
   - _processingDelay = 400ms
   - _dayThreshold = 22
   - _blockMarker = 'Block'
   - _periodMarker = 'Period:'
   - _defaultBase = 'CMN'
   - _hotelDuty = 'HTL'
   - _activityPrefix = 'AT'

3. Key Methods:

   a) getPlatformFile() (async)
      - Opens file picker for PDF selection
      - Filters for PDF files only
      - Allows multiple selection
      - Sets etape = 1 on success
      - Returns List<PlatformFile>

   b) getStreamPlatformFile() (async*)
      - Stream that processes selected PDFs
      - Extracts months from each PDF
      - Yields updated list after each file
      - Returns Stream<List<ChechPlatFormMonth>>

   c) _createRosterFolder() (async, private)
      - Creates rosters folder in app documents
      - Returns folder path

   d) _processRosterFile() (async, private)
      - Processes single PDF file
      - Extracts volumes and months
      - Stores VolPdfList

   e) getvolTraitesFromVolpdfs() (sync)
      - Converts VolPdf to VolModel
      - Removes duplicates
      - Sorts by date
      - Returns List<VolModel>

   f) getVolTraiteMoisModelsFromVolModels() (sync)
      - Converts VolModel to VolTraiteModel
      - Groups by month
      - Creates VolTraiteMoisModel
      - Returns List<VolTraiteMoisModel>

   g) getStreamVolTraiteMoisModels() (async*)
      - Stream that progressively processes months
      - Emits months as they're calculated
      - Sorts descending (newest first)
      - Returns Stream<List<VolTraiteMoisModel>>

4. Static getter:
   - static ImportrosterCtl instance = Get.find();

5. Imports needed:
   - dart:io
   - package:syncfusion_flutter_pdf/pdf.dart
   - package:get/get.dart
   - package:file_picker/file_picker.dart
   - package:intl/intl.dart
   - package:path_provider/path_provider.dart
   - ../../Models/ActsModels/typ_const.dart
   - ../../Models/VolsModels/vol.dart
   - ../../Models/VolsModels/vol_traite.dart
   - ../../Models/VolsModels/vol_traite_mois.dart
   - ../../Models/volpdfs/chechplatform.dart
   - ../../Models/volpdfs/vol_pdf.dart
   - ../../Models/volpdfs/vol_pdf_list.dart
   - ../../helpers/myerrorinfo.dart

6. Code style:
   - Use async/await for async operations
   - Use streams for progressive processing
   - Proper error handling with try-catch
   - Clear variable names
   - Add comments for complex logic

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 21: Generate `OutilImportController`

**File:** `lib/views/7_importRoster/outil_import.dart`

```
Generate a Flutter utility controller for PDF parsing and volume extraction.

FILE: lib/views/7_importRoster/outil_import.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - Utility Controller

REQUIREMENTS:

Create class OutilImportController extends GetxController {

1. Properties:
   - titres = ['Date', 'Report', 'Tags', 'Pos', 'Activity', 'From', 'To', 'Start', 'End', 'A/C', 'Layover']

2. Key Methods:

   a) getMonth() (sync)
      - Extracts month name from PDF text
      - Matches period markers
      - Returns formatted month string

   b) getVoltraiteOnePdf() (sync)
      - Main entry point for PDF processing
      - Calls getRostersVolsPdfs()
      - Calls correctListVols()
      - Calls getVolPdfDuty()
      - Calls getAllDatesVols()
      - Returns List<VolPdf>

   c) getRostersVolsPdfs() (sync)
      - Parses PDF table structure
      - Extracts volume data
      - Handles BLC tags
      - Returns List<VolPdf>

   d) correctListVols() (sync)
      - Removes volumes with empty activity
      - Merges continuation rows
      - Fixes missing destinations
      - Sets default base

   e) getVolPdfDuty() (sync)
      - Maps activity codes to duty types
      - Handles special cases (CA, RV, CNL, TAX, CM, HTL)
      - Assigns flight activity prefix
      - Detects deadhead positions

   f) getAllDatesVols() (sync)
      - Computes transit dates
      - Handles month transitions
      - Processes layovers as hotel duties
      - Filters volumes within month

3. Static getter:
   - static OutilImportController instance = Get.find();

4. Imports needed:
   - package:get/get.dart
   - package:intl/intl.dart
   - package:syncfusion_flutter_pdf/pdf.dart
   - ../../Models/ActsModels/typ_const.dart
   - ../../Models/volpdfs/chechplatform.dart
   - ../../Models/volpdfs/vol_pdf.dart

5. Code style:
   - Use clear method names
   - Add comments for complex logic
   - Proper error handling
   - Follow Dart naming conventions

Generate complete, production-ready code with proper formatting and documentation.
```

---

# STEP 3: SCREENS (UI Layer)

## 🔧 Prompt 22: Generate `AcceuilScreen`

**File:** `lib/views/0_acceuil/acceuil_screen.dart`

[See QUICK_SUMMARY.md Prompt 2 for full details]

---

## 🔧 Prompt 23: Generate `Webviewscreen`

**File:** `lib/views/2_webview/webview_screen.dart`

```
Generate a Flutter GetView screen for webview roster download.

FILE: lib/views/2_webview/webview_screen.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - View

REQUIREMENTS:

Create class Webviewscreen extends GetView<WebViewEcreenController> {

1. Constructor:
   - const Webviewscreen({super.key});

2. Build method returns:
   - GetBuilder<WebViewEcreenController> wrapper
   - initState callback (empty)
   - BackgroundContainer wrapper
   - Padding: AppTheme.getheight(iphoneSize: 10, ipadsize: 10)

3. Main Layout:
   - Obx wrapper monitoring getConnexion
   - If connected: Column with webview and buttons
   - If not connected: Status container

4. Column (if connected):
   - mainAxisAlignment: spaceAround
   - _buildWebViewContainer()
   - _buildButtonRow()

5. _buildWebViewContainer() method:
   - SizedBox height: iPhone 580px, iPad 560px
   - Obx wrapper
   - If visibleWeb: WebViewWidget(controller: controller.webViewController)
   - Else: _buildStatusContainer()

6. _buildStatusContainer() method:
   - Container with theme colors
   - Rounded corners (radius 6)
   - Border with theme color
   - Center text: controller.sEtape.tr
   - Style: AppStylingConstant.webScreen

7. _buildButtonRow() method:
   - Row with mainAxisAlignment: spaceEvenly
   - Obx wrapper
   - If visibleenregistre: _buildActionButtons()
   - Else: _buildProgressWithRegisterButton()

8. _buildActionButtons() method:
   - Row with reset and save buttons
   - SizedBox spacing: iPhone 10px, iPad 50px
   - _buildResetButton()
   - _buildSaveButton()

9. _buildResetButton() method:
   - MyButton:
     * width: iPhone 100px, iPad 150px
     * label: 'button_reset'.tr
     * func: () => controller.webReset(mycontroller: controller.webViewController)

10. _buildSaveButton() method:
    - MyButton:
      * width: iPhone 160px, iPad 250px
      * label: 'button_save'.tr
      * func: () async {
          try {
            bool isDone = controller.enregistrerMjsonString();
            if (isDone) {
              Routes.toHome();
            }
          } catch (e) {
            MyErrorInfo.erreurInos(label: 'button_save'.tr, content: e.toString());
          }
        }

11. _buildProgressWithRegisterButton() method:
    - Row with:
      * CircularProgressIndicator (color: AppColors.primaryLightColor, strokeWidth: 7)
      * SizedBox spacing: iPhone 10px, iPad 50px
      * MyButton:
        - width: iPhone 160px, iPad 250px
        - label: 'button_to_home'.tr
        - func: () => Routes.toHome()

12. Imports needed:
    - package:flutter/material.dart
    - package:get/get.dart
    - package:webview_flutter/webview_flutter.dart
    - ../../helpers/myerrorinfo.dart
    - ../../routes/app_routes.dart
    - ../../theming/app_color.dart
    - ../../theming/app_theme.dart
    - ../../theming/apptheme_constant.dart
    - ../widgets/background_container.dart
    - ../widgets/mybutton.dart
    - webview_ctl.dart

13. Code style:
    - Use responsive sizing throughout
    - Support dark/light theme
    - Proper error handling
    - Clean widget hierarchy
    - Readable and maintainable code

Generate complete, production-ready code with proper formatting and documentation.
```

---

## 🔧 Prompt 24: Generate `RegisterScreen`

**File:** `lib/views/1_register/register_screen.dart`

[See QUICK_SUMMARY.md Prompt 4 for full details]

---

## 🔧 Prompt 25: Generate `ImportRosterScreen`

**File:** `lib/views/7_importRoster/importroster_screen.dart`

```
Generate a Flutter GetView screen for PDF roster import with multi-step workflow.

FILE: lib/views/7_importRoster/importroster_screen.dart
FRAMEWORK: Flutter with GetX
ARCHITECTURE: MVC - View

REQUIREMENTS:

Create class ImportRosterScreen extends GetView<ImportrosterCtl> {

1. Constructor:
   - const ImportRosterScreen({super.key});

2. Build method returns:
   - Scaffold
   - BackgroundContainer wrapper
   - SingleChildScrollView for scrolling
   - Padding with responsive values
   - Obx wrapper monitoring etape

3. Three-Step Workflow:

   Step 0: File Selection
   - Instructions text
   - Import PDF button
   - Calls _handleFileSelection()

   Step 1: PDF Processing (StreamBuilder)
   - Stream: controller.getStreamPlatformFile()
   - Displays months as they're extracted
   - Shows progress for each file
   - Loading state with spinner
   - Error state with message

   Step 2: Monthly Data Display (StreamBuilder)
   - Stream: controller.getStreamVolTraiteMoisModels()
   - Displays months progressively
   - Shows monthly statistics
   - Lists flights for each month
   - Loading state during processing
   - Error state handling

4. Helper Methods:

   a) _buildContent(int etape) - Switch between steps
   b) _buildStepOne() - File selection UI
   c) _buildStepTwo() - PDF processing UI
   d) _buildStepThree() - Monthly data display UI
   e) _buildStreamContent() - Stream state handling
   f) _buildStepThreeContent() - Step 3 stream states
   g) _buildMonthsProcessing() - Display months
   h) _buildLoadingState() - Loading indicator
   i) _buildErrorState() - Error display
   j) _handleFileSelection() - File picker callback

5. Responsive Constants:
   - _horizontalPadding
   - _verticalPadding
   - _listHeight
   - _borderRadius
   - _shadowBlur
   - _buttonWidth
   - _spacingSmall, _spacingMedium, _spacingLarge

6. Imports needed:
   - package:flutter/material.dart
   - package:get/get.dart
   - ../../Models/VolsModels/vol_traite_mois.dart
   - ../../Models/volpdfs/chechplatform.dart
   - ../../theming/app_color.dart
   - ../../theming/app_theme.dart
   - ../widgets/background_container.dart
   - ../widgets/mybutton.dart
   - ../widgets/mylistfile_widget.dart
   - ../widgets/mytext.dart
   - importroster_ctl.dart

7. Code style:
   - Use responsive sizing throughout
   - Support dark/light theme
   - Proper error handling
   - Clean widget hierarchy
   - Readable and maintainable code
   - Use StreamBuilder for progressive display

Generate complete, production-ready code with proper formatting and documentation.
```

---

## ✅ GENERATION CHECKLIST

### Step 1: Models (Data Layer - 13 prompts)
- [ ] **Prompt 1**: Generate UserModel
- [ ] **Prompt 2**: Generate AeroportModel
- [ ] **Prompt 3**: Generate ForfaitModel
- [ ] **Prompt 4**: Generate ForfaitListModel
- [ ] **Prompt 5**: Generate MyDownLoad
- [ ] **Prompt 6**: Generate MyDuty
- [ ] **Prompt 7**: Generate MyStrip
- [ ] **Prompt 8**: Generate VolPdf
- [ ] **Prompt 9**: Generate VolPdfList
- [ ] **Prompt 10**: Generate ChechPlatFormMonth
- [ ] **Prompt 11**: Generate VolModel
- [ ] **Prompt 12**: Generate VolTraiteModel
- [ ] **Prompt 13**: Generate VolTraiteMoisModel

### Step 2: Services & Controllers (Business Logic - 7 prompts)
- [ ] **Prompt 14**: Generate ObjectBoxService
- [ ] **Prompt 15**: Generate DatabaseController
- [ ] **Prompt 17**: Generate WebViewEcreenController
- [ ] **Prompt 18**: Generate AcceuilController
- [ ] **Prompt 19**: Generate RegisterController
- [ ] **Prompt 20**: Generate ImportrosterCtl
- [ ] **Prompt 21**: Generate OutilImportController

### Step 3: Screens (UI Layer - 4 prompts)
- [ ] **Prompt 22**: Generate AcceuilScreen
- [ ] **Prompt 23**: Generate Webviewscreen
- [ ] **Prompt 24**: Generate RegisterScreen
- [ ] **Prompt 25**: Generate ImportRosterScreen

### Post-Generation
- [ ] Run `flutter pub get`
- [ ] Run `flutter run` on iPhone simulator
- [ ] Test device detection (iPhone vs iPad)
- [ ] Test user routing logic
- [ ] Test webview authentication flow
- [ ] Test JSON data download and processing
- [ ] Test PDF roster import workflow
- [ ] Test PDF processing and month extraction
- [ ] Test monthly data conversion and display
- [ ] Test form validation
- [ ] Test credential encryption and storage
- [ ] Test form auto-fill with existing users
- [ ] Test responsive design on iPhone and iPad
- [ ] Test dark/light theme support
- [ ] Verify complete navigation flow (Acceuil → Webview → Register → ImportRoster → Home)

