# 🎮 CONTROLLERS DESCRIPTION (GetX Controllers)

Complete breakdown of all GetX controllers used in the application.

---

## 🚀 CONTROLLER: AcceuilController

### Location
`lib/views/0_acceuil/acceuil_ctl.dart`

### Purpose
Handles app initialization logic, device detection, data loading, and smart routing based on database state. This is the **first controller** that runs when the app starts.

### Reactive Variables
```dart
_isVisibleAcceuil (RxBool)  // Controls splash fade-in animation
  └─ getter: isVisibleAcceuil
  └─ setter: isVisibleAcceuil = bool
```

### Key Methods

**`checkUsersAndNavigate()` (entry point)**
- Called from AcceuilScreen.initState()
- Sets isVisibleAcceuil = true after 15ms delay
- Defers navigation until after build completes using WidgetsBinding.addPostFrameCallback()
- Calls _performNavigation()
- Wraps in try-catch, logs errors via MyErrorInfo.erreurInos()
- On error, fallback to Routes.toRegister()

**`getMyIdevice()` (device detection)**
- Gets context from Get.context!
- Checks if context.isLargeTablet
- Stores result in GetStorage with key: `getDevice`
- Values: `getIpad` (tablet) or `getIphone` (phone)
- Removes old value before writing new one

**`_performNavigation()` (async, routing logic)**
- Gets DatabaseController.instance
- Calls dbController.getAllDatas()
- Fills airports: await AeroportModel.fillAirportModelsIfEmpty()
- Fills forfaits: await ForfaitModel.fillForfaitModelBoxIfEmpty()
- Checks user count and routes accordingly:
  - No users → Routes.toRegister()
  - User exists + no duties → Routes.toWebview()
  - User exists + duties → Routes.toImportRosterScreen()
- Wraps in try-catch, logs errors via MyErrorInfo.erreurInos()
- On error, fallback to Routes.toRegister()

### Dependencies
- `DatabaseController` - Access user/duty data
- `AeroportModel` - Load airports from JSON
- `ForfaitModel` - Load forfaits from JSON
- `GetStorage` - Store device type
- `MyErrorInfo` - Error logging

### Data Flow
```
App Start
  ↓
AcceuilScreen
  ↓
AcceuilController.checkUsersAndNavigate()
  ├─ Detect device type (iPhone vs iPad)
  ├─ Load airports from JSON
  ├─ Load forfaits from JSON
  ├─ Check database for users
  └─ Route to appropriate screen
```

### Static Access
```dart
static AcceuilController get instance => Get.find();
```

---

## 📝 CONTROLLER: RegisterController

### Location
`lib/views/1_register/register_ctl.dart`

### Purpose
Manages user registration, authentication, form auto-fill, and secure credential storage.

### TextEditingControllers
```dart
matController       // Matricule (pilot ID)
emailController     // Email address
passController      // Password
```

### Reactive Variables
```dart
_secteur (RxBool)           // Flight sector
  └─ getter: secteur
  └─ getter: sSecteur (formatted: "Moyen Courrier" or "Long Courrier")
  └─ setter: secteur = bool

_amsram (RxBool)            // Airline type
  └─ getter: amsram
  └─ getter: samsram (formatted: "RAM" or "AMS")
  └─ setter: amsram = bool

_ispnt (RxBool)             // Pilot type
  └─ getter: ispnt
  └─ getter: spntpnc (formatted: "PNT" or "PNC")
  └─ setter: ispnt = bool

_dones (RxBool)             // Button state (true=enabled, false=loading)
  └─ getter: dones
  └─ setter: dones = bool
```

### Dependencies
```dart
final _secureStorage = SecureStorageService();
final _encryptionHelper = EncryptionHelper();
```

### Key Methods

**`onInit()` (lifecycle)**
- Calls DatabaseController.instance.getAllUsers()
- Calls _autoFillFormIfUsersExist()
- Calls rempliChampMoi()

**`_autoFillFormIfUsersExist()` (async)**
- Gets DatabaseController.instance
- Checks if dbController.users.isNotEmpty
- If yes:
  - Gets first user: final firstUser = dbController.users.first
  - Fills matController.text = firstUser.matricule.toString()
  - Decrypts password from secure storage (key: sPassword)
  - Decrypts email from secure storage (key: sEmail)
- Catches errors and logs via MyErrorInfo.erreurInos()

**`registerUser()` (async)**
- Formats email to @royalairmaroc.com domain
- Parses matricule: int.tryParse(matController.text)
- If matricule is null:
  - Shows error snackbar with orange background
  - Sets dones = true
  - Returns
- Checks for existing user: DatabaseController.instance.getUserByMatricule(matricule)
- If exists: Updates user data (isPnt, isRam, isMoyenC)
- If new: Creates new UserModel with generated email
- Calls storeCredential()
- Saves to ObjectBox via DatabaseController

**`storeCredential()` (async)**
- Checks if passController.text and emailController.text are not empty
- Encrypts email: final encryptedEmail = await _encryptionHelper.encrypt(emailController.text)
- Stores email: await _secureStorage.write(sEmail, encryptedEmail)
- Encrypts password: final encryptedPassword = await _encryptionHelper.encrypt(passController.text)
- Stores password: await _secureStorage.write(sPassword, encryptedPassword)
- Clears controllers: emailController.clear(), passController.clear()
- Catches errors and logs via MyErrorInfo.erreurInos()

**`rempliChampMoi()` (dev helper)**
- Auto-fills test data:
  - matController.text = myMatricule
  - emailController.text = myUser
  - passController.text = myPass
  - secteur = false
  - amsram = false

**`generateRandomEmail()` (static)**
- Generates random string of 8-20 characters
- Uses only letters (a-z, A-Z)
- Returns: 'randomString@gmail.com'

### Data Flow
```
RegisterScreen (User Input)
  ↓
User fills form and clicks Register
  ↓
Form validation
  ├─ Matricule: numeric
  ├─ Email: non-empty
  └─ Password: non-empty
  ↓
RegisterController.registerUser()
  ├─ Format email to @royalairmaroc.com
  ├─ Check for existing user
  ├─ Create/Update UserModel
  ├─ Encrypt credentials
  ├─ Store in secure storage
  └─ Save to ObjectBox
  ↓
Routes.toWebview() (Next screen)
```

### Security Features
- Passwords encrypted with EncryptionHelper
- Credentials stored in iOS Keychain
- Email auto-formatted to @royalairmaroc.com domain
- Secure storage keys: sPassword, sEmail

### Static Access
```dart
static RegisterController instance = Get.find();
```

---

## 🗄️ CONTROLLER: DatabaseController

### Location
`lib/controllers/database_controller.dart`

### Purpose
Manages all ObjectBox database operations including CRUD operations for users, airports, forfaits, and other entities.

### Key Responsibilities
1. **User Management** - Create, read, update, delete users
2. **Airport Management** - Manage airport data
3. **Forfait Management** - Manage forfait packages
4. **Data Persistence** - Save/load from ObjectBox
5. **Data Querying** - Query and filter data

### Main Properties
- `users` - List of all users
- `currentUser` - Currently logged-in user
- `airports` - List of all airports
- `forfaits` - List of all forfaits
- `duties` - List of user duties

### Key Methods
- `getAllDatas()` - Load all data from database
- `getAllUsers()` - Get all users
- `getUserByMatricule(int matricule)` - Find user by ID
- `addUser(UserModel user)` - Create new user
- `updateUser(UserModel user)` - Update existing user
- `addAirports(List<AeroportModel> airports)` - Bulk insert airports
- `addForfaitLists(List<ForfaitListModel> forfaits)` - Bulk insert forfaits
- `getAeroportByOaci(String oaci)` - Find airport by ICAO code

### Static Access
```dart
static DatabaseController get instance => Get.find();
```

---

## 🌐 CONTROLLER: WebViewEcreenController

### Location
`lib/views/2_webview/webview_ctl.dart`

### Purpose
Manages webview interactions, authentication, JSON data fetching, and processing of downloaded roster data into duties and flights.

### Reactive Variables
```dart
_isJson (RxBool)                    // JSON parsing flag
_ijson (RxInt)                      // State counter (0-5)
_sEtape (RxString)                  // Current step/status message
_visibleWeb (RxBool)                // Show/hide webview
_visibleenregistre (RxBool)         // Show save buttons
_jsonString (Rxn<String>)           // Downloaded JSON data
_getConnexion (RxBool)              // Internet connection status

currentUrl (RxString)               // Current page URL
pageTitle (RxString)                // Page title
rxUser (RxString)                   // Decrypted username
rxPass (RxString)                   // Decrypted password
```

### Key Methods

**`onInit()` (lifecycle)**
- Checks internet connectivity via Fct.checkConnectivity()
- Initializes webview if connected
- Sets initial status message

**`_initializeWebView()` (async, private)**
- Initializes platform-specific webview parameters
- Sets JavaScript mode to unrestricted
- Configures navigation delegates
- Loads base URL
- Configures platform-specific settings (Android/iOS)

**`onPageFinish()` (async)**
- Handles page load completion based on ijson state
- State machine with 5 states (0-5):
  - State 0: ADFS login page → perform login
  - State 1: Access UI page → load JSON API
  - State 2: JSON API page → fetch JSON data
  - State 3: Processing → delay then load base URL
  - State 4: Ready → process logout
  - State 5: Complete → ready for save

**`onUrlChange()` (async)**
- Monitors URL changes
- Triggers logout and cache clearing when on roster page
- Updates UI state to "processing"

**`_performLogin()` (async, private)**
- Retrieves encrypted credentials from secure storage
- Decrypts username and password
- Auto-fills login form via JavaScript

**`_fetchAndProcessJsonData()` (async, private)**
- Fetches JSON data from webview
- Validates connectivity
- Sets processing state

**`fetchJsonData()` (async)**
- Executes JavaScript to extract JSON from page
- Handles platform-specific string parsing (Android vs iOS)
- Extracts JSON substring from HTML
- Returns cleaned JSON string

**`_performLogout()` (async, private)**
- Shows save buttons
- Executes logout JavaScript
- Handles device-specific logout (iPhone vs iPad)

**`_deconnexionClick()` (async, private)**
- Executes logout JavaScript for iPhone
- Detects menu in page

**`_deconnexionIpadClick()` (async, private)**
- Executes logout JavaScript for iPad

**`_clearBrowserCache()` (async, private)**
- Clears webview cache and local storage

**`loadUrl()` (async)**
- Loads specified URL in webview
- Checks connectivity first

**`loadBaseUrl()` (async)**
- Loads base URL
- Checks connectivity first

**`webReset()` (async)**
- Resets webview state to initial
- Clears processing flags
- Reloads base URL

**`enregistrerMjsonString()` (sync)**
- Saves downloaded JSON to database
- Parses JSON into MyStrip object
- Processes into MyDuty objects via StripProcessor
- Generates VolModel from duties
- Generates VolTraiteModel from vols
- Stores all data in ObjectBox
- Returns success flag

**`remplisVoltraites()` (sync)**
- Regenerates VolTraiteModel from existing VolModels
- Used when reprocessing data

**`_genererVolsTraites()` (private)**
- Converts VolModel list to VolTraiteModel
- Groups by month
- Creates VolTraiteMoisModel
- Stores in database

### Dependencies
- `SecureStorageService` - Retrieve encrypted credentials
- `EncryptionHelper` - Decrypt credentials
- `StripProcessor` - Convert MyStrip to MyDuty
- `DatabaseController` - Store data
- `WebViewController` - Manage webview
- `MyErrorInfo` - Error logging

### State Machine (ijson values)
```
0: ADFS Login Page
  ↓
1: Access UI Page
  ↓
2: JSON API Page
  ↓
3: Processing
  ↓
4: Ready for Logout
  ↓
5: Complete
```

### Data Flow
```
User Login
  ↓
WebView loads ADFS
  ↓
Auto-fill credentials (ijson=0→1)
  ↓
Navigate to Access UI (ijson=1→2)
  ↓
Load JSON API (ijson=2)
  ↓
Fetch JSON data (ijson=2→3)
  ↓
Process data (ijson=3→4)
  ↓
Logout & clear cache (ijson=4→5)
  ↓
Show Save/Reset buttons
  ↓
User clicks Save
  ↓
enregistrerMjsonString()
  ├─ Parse JSON
  ├─ Generate duties
  ├─ Generate vols
  ├─ Generate vol traites
  └─ Store in database
```

### Static Access
```dart
static WebViewEcreenController instance = Get.find();
```

---

## 📥 CONTROLLER: ImportrosterCtl

### Location
`lib/views/7_importRoster/importroster_ctl.dart`

### Purpose
Manages PDF roster file selection, extraction, processing, and conversion to flight data.

### Reactive Variables
```dart
_loading (RxBool)           // Loading state
_etape (RxInt)              // Current step (0-2)
  └─ getter: etape
  └─ setter: etape = int
```

### Key Methods

**`getPlatformFile()` (async)**
- Opens file picker for PDF selection
- Filters for PDF files only
- Allows multiple file selection
- Sets etape = 1 on success
- Returns List<PlatformFile>

**`getStreamPlatformFile()` (async*)**
- Stream that processes selected PDF files
- Extracts months from each PDF
- Yields updated list after each file
- Returns Stream<List<ChechPlatFormMonth>>

**`_createRosterFolder()` (async, private)**
- Creates rosters folder in app documents
- Returns folder path

**`_processRosterFile()` (async, private)**
- Processes single PDF file
- Extracts volumes and months
- Stores VolPdfList

**`getvolTraitesFromVolpdfs()` (sync)**
- Converts VolPdf to VolModel
- Removes duplicates
- Sorts by date
- Returns List<VolModel>

**`getVolTraiteMoisModelsFromVolModels()` (sync)**
- Converts VolModel to VolTraiteModel
- Groups by month
- Creates VolTraiteMoisModel
- Returns List<VolTraiteMoisModel>

**`getStreamVolTraiteMoisModels()` (async*)**
- Stream that progressively processes months
- Emits months as they're calculated
- Sorts descending (newest first)
- Returns Stream<List<VolTraiteMoisModel>>

### Constants
```dart
_pdfExtension = 'pdf'
_rosterFolder = 'rosters'
_processingDelay = 400ms
_dayThreshold = 22
_blockMarker = 'Block'
_periodMarker = 'Period:'
_dateFormat = 'MMMM yyyy'
_defaultBase = 'CMN'
_hotelDuty = 'HTL'
_activityPrefix = 'AT'
```

### Data Flow
```
Step 0: File Selection
  ↓
getPlatformFile()
  ├─ Open file picker
  └─ Return selected PDFs
  ↓
Step 1: PDF Processing
  ↓
getStreamPlatformFile()
  ├─ Process each PDF
  ├─ Extract volumes
  ├─ Extract months
  └─ Yield ChechPlatFormMonth
  ↓
Step 2: Data Conversion
  ↓
getStreamVolTraiteMoisModels()
  ├─ Convert to VolModel
  ├─ Convert to VolTraiteModel
  ├─ Group by month
  ├─ Create VolTraiteMoisModel
  └─ Yield monthly data
```

### Static Access
```dart
static ImportrosterCtl instance = Get.find();
```

---

## 🔧 CONTROLLER: OutilImportController

### Location
`lib/views/7_importRoster/outil_import.dart`

### Purpose
Utility controller for PDF parsing and volume extraction with helper methods.

### Key Properties
```dart
titres = [
  'Date', 'Report', 'Tags', 'Pos', 'Activity',
  'From', 'To', 'Start', 'End', 'A/C', 'Layover'
]
```

### Key Methods

**`getMonth()` (sync)**
- Extracts month name from PDF text
- Matches period markers
- Returns formatted month string

**`getVoltraiteOnePdf()` (sync)**
- Main entry point for PDF processing
- Calls getRostersVolsPdfs()
- Calls correctListVols()
- Calls getVolPdfDuty()
- Calls getAllDatesVols()
- Returns List<VolPdf>

**`getRostersVolsPdfs()` (sync)**
- Parses PDF table structure
- Extracts volume data
- Handles BLC tags
- Returns List<VolPdf>

**`correctListVols()` (sync)**
- Removes volumes with empty activity
- Merges continuation rows
- Fixes missing destinations
- Sets default base

**`getVolPdfDuty()` (sync)**
- Maps activity codes to duty types
- Handles special cases (CA, RV, CNL, TAX, CM, HTL)
- Assigns flight activity prefix
- Detects deadhead positions

**`getAllDatesVols()` (sync)**
- Computes transit dates
- Handles month transitions
- Processes layovers as hotel duties
- Filters volumes within month

### Static Access
```dart
static OutilImportController instance = Get.find();
```

---

## 🗄️ SERVICE: ObjectBoxService

### Location
`lib/controllers/objectbox_service.dart`

### Purpose
Low-level database service that centralizes all CRUD (Create, Read, Update, Delete) operations for ObjectBox entities. Implements the **Repository Pattern** for data access with transaction safety and automatic sorting.

### Architecture
- **Singleton Pattern**: Single instance manages all database operations
- **Transaction Safety**: All write operations wrapped in `store.runInTransaction(TxMode.write)`
- **Automatic Sorting**: Each entity type sorted by relevant field
- **Box Management**: Separate Box for each entity type
- **Error Handling**: Graceful recovery with database reset on initialization failure

### Initialization

**`static Future<ObjectBoxService> create()`**
- Creates and returns ObjectBoxService instance
- Opens ObjectBox store in app documents directory
- Returns: `ObjectBoxService` instance

**`static Future<ObjectBoxService> initializeNewBoxes()`**
- Safe initialization with error recovery
- Calls `create()` and catches exceptions
- On error: calls `_resetObjectBoxDirectory()` and retries
- Returns: `ObjectBoxService` instance

**`static Future<void> _resetObjectBoxDirectory()`**
- Deletes corrupted ObjectBox directory
- Allows fresh database initialization on next attempt

### Box Declarations
```dart
late final Box<MyDuty> _dutyBox;
late final Box<VolTraiteMoisModel> _volTraiteMoisBox;
late final Box<VolPdfList> _volPdfListBox;
late final Box<UserModel> _userBox;
late final Box<MyDownLoad> _downloadBox;
late final Box<AeroportModel> _airportBox;
late final Box<ForfaitListModel> _forfaitListBox;
```

### Helper Methods

**`int _compareNullable<T extends Comparable>(T? a, T? b)`**
- Safe comparison for nullable values
- Returns: -1 (a < b), 0 (equal), 1 (a > b)
- Used for sorting operations

**`void _initializeBoxes()`**
- Initializes all Box instances from store
- Called during construction
- Sets up database access for each entity type

**`void close()`**
- Closes database connection
- Sets `_isClosed = true`
- Should be called during app shutdown

### CRUD Operations by Entity

#### 1. MyDuty (Services/Activities)
- `replaceAllDuties(List<MyDuty>)` - Replace all, sorted by startTime
- `removeAllDuties()` - Delete all
- `getAllDuties()` - Retrieve all, sorted by startTime

#### 2. VolTraiteMoisModel (Monthly Flight Summaries)
- `replaceAllVolTraiteMois(List<VolTraiteMoisModel>)` - Replace all, sorted by premierJourMois
- `removeAllVolTraitesParMois()` - Delete all
- `getAllVolTraitesParMois()` - Retrieve all, sorted by premierJourMois

#### 3. VolPdfList (PDF Roster Lists with nested VolPdf)
- `replaceAllVolPdfLists(List<VolPdfList>)` - Replace all, sorted by month
- `removeAllVolPdfLists()` - Delete all
- `addAllVolPdfLists(List<VolPdfList>)` - Add to database
- `getAllVolPdfLists()` - Retrieve all, sorted by month
- **Note**: VolPdf items are nested via `ToMany<VolPdf>()` relationship

#### 4. UserModel (User Accounts)
- `replaceAllUsers(List<UserModel>)` - Replace all, sorted by matricule
- `removeAllUsers()` - Delete all
- `addAllUsers(List<UserModel>)` - Add to database
- `getAllUsers()` - Retrieve all, sorted by matricule

#### 5. MyDownLoad (Downloaded Data)
- `replaceAllDownloads(List<MyDownLoad>)` - Replace all, sorted by downloadTime
- `removeAllDownloads()` - Delete all
- `addAllDownloads(List<MyDownLoad>)` - Add to database
- `getAllDownloads()` - Retrieve all, sorted by downloadTime

#### 6. AeroportModel (Airports)
- `replaceAllAirports(List<AeroportModel>)` - Replace all, sorted by icao
- `removeAllAirports()` - Delete all
- `addAllAirports(List<AeroportModel>)` - Add to database
- `getAllAirports()` - Retrieve all, sorted by icao

#### 7. ForfaitListModel (Forfait Lists)
- `replaceAllForfaitLists(List<ForfaitListModel>)` - Replace all, sorted by date
- `removeAllForfaitLists()` - Delete all
- `addAllForfaitLists(List<ForfaitListModel>)` - Add to database
- `getAllForfaitLists()` - Retrieve all, sorted by date

### Transaction Pattern

All write operations follow this pattern:
```dart
store.runInTransaction(TxMode.write, () {
  _box.putMany(items);  // or removeAll(), put(), etc.
});
```

### Sorting Strategy

Each entity type automatically sorted by relevant field:
- **MyDuty**: `startTime` (DateTime)
- **VolTraiteMoisModel**: `premierJourMois` (DateTime)
- **VolPdfList**: `month` (DateTime)
- **UserModel**: `matricule` (int)
- **MyDownLoad**: `downloadTime` (DateTime)
- **AeroportModel**: `icao` (String)
- **ForfaitListModel**: `date` (DateTime)

### Usage Example

```dart
// Get instance
final objectBox = Get.find<ObjectBoxService>();

// Store data
final duties = [...];
objectBox.replaceAllDuties(duties);

// Retrieve data
final allDuties = objectBox.getAllDuties();

// Close on app shutdown
objectBox.close();
```

### Integration with DatabaseController

ObjectBoxService is used by **DatabaseController** which provides:
- High-level business logic
- Reactive lists (RxList) for UI binding
- Automatic list updates after database operations

---

## 🎮 CONTROLLER: DatabaseController

### Location
`lib/controllers/database_controller.dart`

### Purpose
High-level database controller that wraps ObjectBoxService with GetX reactive state management. Provides reactive lists (RxList) that automatically update the UI when data changes.

### Architecture
- **Wrapper Pattern**: Wraps ObjectBoxService for reactive updates
- **Reactive Lists**: All data exposed as RxList for automatic UI binding
- **Business Logic**: Handles data transformations and aggregations
- **Singleton Pattern**: Accessed via `DatabaseController.instance`

### Initialization

**`void onInit()`**
- Gets ObjectBoxService instance via `Get.find<ObjectBoxService>()`
- Called automatically by GetX when controller is initialized

### Reactive Lists

Each entity type has a reactive list:
```dart
final RxList<MyDuty> _duties = <MyDuty>[].obs;
final RxList<VolTraiteMoisModel> _volTraitesParMois = <VolTraiteMoisModel>[].obs;
final RxList<VolPdfList> _volPdfLists = <VolPdfList>[].obs;
final RxList<UserModel> _users = <UserModel>[].obs;
final RxList<MyDownLoad> _downloads = <MyDownLoad>[].obs;
final RxList<AeroportModel> _airports = <AeroportModel>[].obs;
final RxList<ForfaitListModel> _forfaitLists = <ForfaitListModel>[].obs;
```

### High-Level Methods

#### VolPdfList Management
- `addVolPdfList(VolPdfList)` - Add single list
- `getAllVolPdfLists()` - Load all from database
- `addVolPdfLists(List<VolPdfList>)` - Add multiple lists
- `replaceAllVolPdfLists(List<VolPdfList>)` - Replace all
- `clearAllVolPdfLists()` - Delete all

#### VolTraiteMoisModel Management
- `getAllVolTraitesParMois()` - Load all from database
- `clearAllVolTraitesParMois()` - Delete all
- `replaceAllVolTraiteMois(List<VolTraiteMoisModel>)` - Replace all

#### Duty Management
- `addDuty(MyDuty)` - Add single duty
- `getAllDuties()` - Load all from database
- `addDuties(List<MyDuty>)` - Add multiple duties
- `replaceAllDuties(List<MyDuty>)` - Replace all
- `clearAllDuties()` - Delete all

#### User Management
- `addUser(UserModel)` - Add single user
- `getAllUsers()` - Load all from database
- `addUsers(List<UserModel>)` - Add multiple users
- `replaceAllUsers(List<UserModel>)` - Replace all
- `updateUser(UserModel)` - Update existing user
- `getUserByMatricule(int)` - Find user by ID

#### Airport Management
- `addAirport(AeroportModel)` - Add single airport
- `getAllAirports()` - Load all from database
- `addAirports(List<AeroportModel>)` - Add multiple airports
- `replaceAllAirports(List<AeroportModel>)` - Replace all
- `getAeroportByOaci(String)` - Find by OACI code
- `getAeroportByIata(String)` - Find by IATA code
- `getAirportCity(String)` - Get city name from IATA code

#### Forfait Management
- `getAllForfaitLists()` - Load all from database
- `addForfaitLists(List<ForfaitListModel>)` - Add multiple
- `replaceAllForfaitLists(List<ForfaitListModel>)` - Replace all

#### Download Management
- `getAllDownloads()` - Load all from database
- `addDownloads(List<MyDownLoad>)` - Add multiple
- `replaceAllDownloads(List<MyDownLoad>)` - Replace all

### Global Operations

**`void getAllDatas()`**
- Loads all data from database into reactive lists
- Calls: getAllUsers(), getAllAirports(), getAllForfaitLists(), getAllVolTraitesParMois(), getAllDuties(), getAllVolModels()
- Used during app initialization

**`void clearAllData()`**
- Deletes all data from database
- Calls: removeAllDuties(), removeAllVolTraitesParMois(), removeAllUsers(), removeAllDownloads(), removeAllAirports(), removeAllForfaitLists()
- Refreshes all lists by calling getAllDatas()

### Usage Example

```dart
// Get instance
final dbController = DatabaseController.instance;

// Load data
dbController.getAllVolPdfLists();

// Access reactive list
final volPdfLists = dbController.volPdfLists;

// Store data
dbController.replaceAllVolPdfLists(newLists);

// Reactive UI binding
Obx(() => ListView(
  children: dbController.volPdfLists.map((list) => ListTile(
    title: Text('${list.month}'),
  )).toList(),
))
```

### Static Access
```dart
static DatabaseController get instance => Get.find();
```

