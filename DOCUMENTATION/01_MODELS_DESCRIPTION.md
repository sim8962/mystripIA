# 📊 MODELS DESCRIPTION

Complete breakdown of all data models used in the application.

---

## 🏢 MODEL: UserModel

### Location
`lib/Models/userModel/usermodel.dart`

### Purpose
ObjectBox entity representing a pilot/user account with authentication and profile information.

### Properties
```dart
@Entity()
class UserModel {
  @Id() int id = 0;                    // ObjectBox ID
  int? matricule;                      // Pilot ID (unique identifier)
  String? email;                       // Email address
  bool? isRam;                         // Airline (true=RAM, false=AMS)
  bool? isPnt;                         // Pilot type (true=PNC, false=PNT)
  bool? isMoyenC;                      // Sector (true=Long Courrier, false=Moyen Courrier)
  List<int>? users;                    // Additional user data
  @Backlink() final myDownLoads = ToMany<MyDownLoad>();  // Related downloads
}
```

### Key Characteristics
- **Matricule**: Unique pilot ID (numeric)
- **Email**: Auto-formatted to @royalairmaroc.com domain
- **isRam**: Airline selection (RAM or AMS)
- **isPnt**: Pilot type (PNT or PNC)
- **isMoyenC**: Flight sector preference
- **Relationships**: One-to-many with MyDownLoad entities

### Constructor
```dart
UserModel({
  this.matricule,
  this.email,
  this.isRam,
  this.isPnt,
  this.isMoyenC,
  this.users
})
```

### Usage Flow
```
User Registration
  ↓
RegisterController.registerUser()
  ├─ Create new UserModel or update existing
  ├─ Set matricule, email, isRam, isPnt, isMoyenC
  ├─ Encrypt credentials
  └─ Save to ObjectBox
  ↓
Later: AcceuilController checks for users
  ├─ Get all users from database
  ├─ Check if current user exists
  └─ Route accordingly
```

---

## 📦 MODEL: ForfaitListModel

### Location
`lib/Models/jsonModels/datas/forfaitlist.model.dart`

### Purpose
ObjectBox entity representing a collection of forfaits (flight packages) with metadata. Acts as a container for multiple ForfaitModel objects.

### Properties
```dart
@Entity()
class ForfaitListModel {
  @Id() int id = 0;                           // ObjectBox ID
  @Property() String name;                    // List name/identifier
  @Property(type: PropertyType.date) DateTime date;  // Date of forfait list
  final forfaits = ToMany<ForfaitModel>();   // Related forfaits
}
```

### Key Methods

**`fromJson(Map<String, dynamic>)` (factory)**
- Parse from JSON object
- Recursively parses nested forfaits
- Returns ForfaitListModel

**`fromJsonString(String jsonString)` (factory)**
- Parse from JSON string
- Decodes string and calls fromJson()

**`toJson()` (method)**
- Convert to JSON object
- Includes all forfaits
- Returns Map<String, dynamic>

**`toJsonString()` (method)**
- Convert to JSON string
- Calls toJson() and encodes
- Returns String

**`copyWith()` (method)**
- Create modified copy
- Optional field overrides
- Deduplicates forfaits

**`getForfaitListFromExcel()` (static, async)**
- Parse Excel file with forfaits
- Extracts filename for date
- Assigns dateForfait to each forfait
- Returns ForfaitListModel or null
- Error handling with logging

### Data Flow
```
App Startup
  ↓
ForfaitModel.fillForfaitModelBoxIfEmpty()
  ├─ Load forfaits from JSON
  ├─ Convert to ForfaitListModel
  ├─ Bulk insert into ObjectBox
  └─ Trigger airport addition
  ↓
Later: User imports Excel file
  ↓
ForfaitListModel.getForfaitListFromExcel()
  ├─ Parse Excel file
  ├─ Extract date from filename
  ├─ Create ForfaitListModel
  └─ Return for storage
```

### Relationships
- **One-to-Many**: ForfaitListModel → ForfaitModel (via `forfaits`)
- **One-to-Many**: ForfaitModel → AeroportModel (via ICAO/IATA codes)

---

## ✈️ MODEL: AeroportModel

### Location
`lib/Models/jsonModels/datas/airport_model.dart`

### Purpose
ObjectBox entity for storing and managing airport data with ICAO/IATA codes, geographic coordinates, and metadata.

### Properties
```dart
@Entity()
class AeroportModel {
  @Id() int id = 0;              // ObjectBox ID
  @Property() String icao;       // ICAO code (4 letters)
  @Property() String iata;       // IATA code (3 letters)
  @Property() String name;       // Airport name
  @Property() String city;       // City name
  @Property() String country;    // Country name
  @Property() double latitude;   // Geographic latitude
  @Property() double longitude;  // Geographic longitude
  @Property() String altitude;   // Altitude in feet
}
```

### Key Methods

**`fillAirportModelsIfEmpty()` (static, async)**
- Entry point called from AcceuilController
- Loads airports from JSON asset if database is empty
- Prevents duplicates using Set<String> for ICAO/IATA codes
- Bulk inserts into ObjectBox
- Skips invalid entries with error logging

**`fetchAirportIcao(String icao)` (static, async)**
- Fetches single airport from airportdb.io API by ICAO code
- Uses API token for authentication
- Returns AeroportModel or throws exception

**`fetchAirportIata(String iata)` (static, async)**
- Fetches single airport from airportdb.io API by IATA code
- Same as fetchAirportIcao but uses IATA instead

**`addAeroportFromFrorfait()` (static, async)**
- Extracts unique airport codes from forfaits
- Checks if airports exist in database
- Searches JSON asset first (faster)
- Falls back to API if not in asset
- Bulk updates database with new airports

---

## 🛫 MODEL: ForfaitModel

### Location
`lib/Models/jsonModels/datas/forfait_model.dart`

### Purpose
ObjectBox entity for storing flight forfait (package) data including route, season, sector, and duration.

### Properties
```dart
@Entity()
class ForfaitModel {
  @Id() int id = 0;              // ObjectBox ID
  @Property() String cle;        // Unique key (season+sector+dep+arr)
  @Property() String saison;     // Season (e.g., "E" for été)
  @Property() String secteur;    // Sector (e.g., "MC" for Moyen Courrier)
  @Property() String depICAO;    // Departure ICAO code
  @Property() String arrICAO;    // Arrival ICAO code
  @Property() String depIATA;    // Departure IATA code
  @Property() String arrIATA;    // Arrival IATA code
  @Property() String forfait;    // Duration (format: "XXhYY")
  @Property() String table;      // Table reference
  @Property() String dateForfait;// Date (format: "dd/MM/yyyy")
}
```

### Key Methods

**`fillForfaitModelBoxIfEmpty()` (static, async)**
- Entry point called from AcceuilController
- Loads forfaits from JSON asset if database is empty
- Converts to ForfaitListModel objects
- Bulk inserts into ObjectBox
- Triggers airport addition from forfaits

**`fetchFromJson()` (static, async)**
- Loads all forfaits from JSON asset
- Parses each entry using fromJson()
- Returns List<ForfaitModel>
- Skips invalid entries with error logging

**`parseExcel(Uint8List bytes)` (static)**
- Parses Excel file (.xlsx) with forfait data
- Extracts columns: Clé, Saison, Secteur, Escale_dep, Escale_arr, Forfait, Table
- Looks up IATA codes from airports database
- Constructs unique key if not in Excel
- Converts time format "HH:MM" → "XXhYY"
- Returns List<ForfaitModel>

---

## 📥 MODEL: MyDownLoad

### Location
`lib/Models/userModel/my_download.dart`

### Purpose
ObjectBox entity representing a downloaded JSON/HTML content from the webview with timestamp and user relationship.

### Properties
```dart
@Entity()
class MyDownLoad {
  @Id() int id = 0;                           // ObjectBox ID
  String? jsonContent;                        // Downloaded JSON content
  String? htmlContent;                        // Downloaded HTML content
  @Property(type: PropertyType.date) DateTime downloadTime;  // Download timestamp
  final user = ToOne<UserModel>();           // Related user (one-to-one)
}
```

### Key Characteristics
- **Timestamp-based Equality**: Compares year, month, day, hour, minute
- **User Relationship**: One-to-one with UserModel
- **Dual Content**: Can store both JSON and HTML

### Constructor
```dart
MyDownLoad({
  this.jsonContent,
  this.htmlContent,
  required this.downloadTime
})
```

### Equality & Hash
- Based on download timestamp (year, month, day, hour, minute)
- Prevents duplicate downloads at same time

---

## 🎭 MODEL: MyDuty

### Location
`lib/Models/ActsModels/myduty.dart`

### Purpose
ObjectBox entity representing a duty/activity with time range, type, and related vols, crews, and etapes.

### Properties
```dart
@Entity()
class MyDuty {
  @Id(assignable: true) int id;               // ObjectBox ID (assignable)
  @Property(type: PropertyType.date) DateTime myMonth;  // Month reference
  @Property(type: PropertyType.date) DateTime startTime;  // Duty start time
  @Property(type: PropertyType.date) DateTime endTime;    // Duty end time
  String dateLabel;                           // Formatted date label
  String typeLabel;                           // Duty type label
  String detailLabel;                         // Detail description
  final typ = ToOne<Typ>();                  // Related duty type
  final vols = ToMany<VolModel>();           // Related flights
  @Backlink('myDuty') final crews = ToMany<Crew>();  // Related crew members
  @Backlink('myDuty') final etapes = ToMany<MyEtape>();  // Related etapes
}
```

### Key Characteristics
- **Time Range**: startTime and endTime for duty duration
- **Relationships**: One-to-many with VolModel, Crew, MyEtape
- **Type Reference**: Links to Typ for duty classification
- **Labels**: Pre-formatted strings for display

### Relationships
- **One-to-One**: MyDuty → Typ (duty type)
- **One-to-Many**: MyDuty → VolModel (flights)
- **One-to-Many**: MyDuty → Crew (crew members)
- **One-to-Many**: MyDuty → MyEtape (etapes/legs)

---

## 📄 MODEL: MyStrip

### Location
`lib/Models/jsonModels/mystripjson/mystrip_model.dart`

### Purpose
JSON model representing the downloaded roster/strip data with entity information and download timestamp.

### Properties
```dart
class MyStrip {
  DateTime? downloadTime;     // When the strip was downloaded
  MyEntity? entity;           // Parsed entity data from JSON
}
```

### Key Methods
- **`fromJson(Map<String, dynamic>)`** - Parse from JSON response
- **`toJson()`** - Convert to JSON
- **`copyWith()`** - Create modified copy

### Data Flow
```
WebView JSON API
  ↓
MyStrip.fromJson()
  ├─ Parse downloadTime
  └─ Parse entity (MyEntity)
  ↓
StripProcessor.processMyStripIntoDuties()
  ├─ Convert to MyDuty objects
  └─ Store in database
```

---

## 📄 MODEL: VolPdf

### Location
`lib/Models/volpdfs/vol_pdf.dart`

### Purpose
Represents a single flight extracted from PDF roster with all relevant information.

### Key Properties
- `dateVol` - Flight date
- `from` - Departure airport (IATA)
- `to` - Arrival airport (IATA)
- `activity` - Flight activity code
- `duty` - Duty type (VOL, MEP, TAX, HTL, etc.)
- `aC` - Aircraft registration
- `cle` - Unique key
- `myArrDate` - Arrival date/time

### Key Methods
- **`fromVolModel()`** - Convert from VolModel
- **`parseDateTimeFromString()`** - Parse date/time strings

---

## 📋 MODEL: VolPdfList

### Location
`lib/Models/volpdfs/vol_pdf_list.dart`

### Purpose
Container for a list of VolPdf objects extracted from a single PDF roster file.

### Key Properties
- `pdfName` - Original PDF filename
- `vols` - List<VolPdf> extracted from PDF
- `tags` - BLC tags extracted from PDF

### Key Methods
- **`fromChechPlatFormMonth()`** - Create from ChechPlatFormMonth
- **`toVolModels()`** - Convert all vols to VolModel

---

## 🗓️ MODEL: ChechPlatFormMonth

### Location
`lib/Models/volpdfs/chechplatform.dart`

### Purpose
Represents a month extracted from PDF with platform-specific data.

### Key Properties
- `monthName` - Month name (e.g., "October 2025")
- `monthReference` - Month reference (YYYY-MM format)
- `vols` - List of VolPdf objects
- `tags` - BLC tags

---

## ✈️ MODEL: VolModel

### Location
`lib/Models/VolsModels/vol.dart`

### Purpose
ObjectBox entity representing a single flight with all details.

### Key Properties
- `id` - ObjectBox ID
- `typ` - Flight type (VOL, MEP, TAX, HTL)
- `nVol` - Flight number
- `dtDebut` - Departure date/time
- `dtFin` - Arrival date/time
- `depIata` - Departure IATA
- `arrIata` - Arrival IATA
- `sAvion` - Aircraft
- `cle` - Unique key
- `tsv` - Additional data

### Key Methods
- **`fromVolPdf()`** - Convert from VolPdf
- **`copyWith()`** - Create modified copy

---

## 📊 MODEL: VolTraiteModel

### Location
`lib/Models/VolsModels/vol_traite.dart`

### Purpose
Processed flight model with all calculated cumuls and statistics.

### Key Properties
- `id` - ObjectBox ID
- `typ` - Flight type
- `nVol` - Flight number
- `dtDebut` - Departure date/time
- `dtFin` - Arrival date/time
- `depIata` - Departure IATA
- `arrIata` - Arrival IATA
- `moisReference` - Month reference (YYYY-MM)
- `sCumulDureeVol` - Cumulative flight duration
- `sCumulDureeMep` - Cumulative MEP duration
- `sCumulNuitVol` - Cumulative night flight hours

### Key Methods
- **`fromVolModel()`** - Convert from VolModel with cumul calculations
- **`copyWith()`** - Create modified copy

---

## 📈 MODEL: VolTraiteMoisModel

### Location
`lib/Models/VolsModels/vol_traite_mois.dart`

### Purpose
Monthly summary of processed flights with aggregated statistics.

### Key Properties
- `id` - ObjectBox ID
- `moisAnneeFormate` - Formatted month (e.g., "October 2025")
- `moisReference` - Month reference (YYYY-MM)
- `nombreVolsTotal` - Total number of flights
- `cumulTotalDureeVol` - Total flight duration
- `cumulTotalDureeMep` - Total MEP duration
- `cumulTotalNuitVol` - Total night flight hours
- `volsTraites` - List of VolTraiteModel

### Key Methods
- **`fromVolsTraites()`** - Create from list of VolTraiteModel
- **`copyWith()`** - Create modified copy

---

## 🚨 HELPER: MyErrorInfo

### Location
`lib/helpers/myerrorinfo.dart`

### Purpose
Centralized error logging and display utility. Shows user-friendly error messages via snackbars while logging to console.

### Method: `erreurInos()`

**Parameters:**
- `label` (String) - Error title/heading
- `content` (String) - Detailed error message

**Returns:**
- `SnackbarController` - Can be used to control snackbar programmatically

**Behavior:**
- Prints to console: `label: {label}, content: {content}`
- Shows red snackbar at top of screen
- 10-second duration, dismissible
- Warning amber icon
- White text on red background

