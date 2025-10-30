# ⚡ Quick Summary: 0_acceuil & 1_register

## 📁 Folder 0_acceuil (Splash/Welcome Screen)

### Purpose
App initialization, device detection, and smart routing based on database state.

### Files
- **acceuil_ctl.dart** - Controller with initialization logic
- **acceuil_screen.dart** - Simple splash screen UI

### Key Flow
```
App Start
  ↓
AcceuilScreen (Splash with animated logo)
  ↓
AcceuilController.checkUsersAndNavigate()
  ├─ Detect device (iPhone vs iPad)
  ├─ Load airports from JSON
  ├─ Load forfaits from JSON
  ├─ Check database for users
  └─ Route to appropriate screen
```

### Controller Responsibilities
1. **Device Detection** - iPhone or iPad?
2. **Data Loading** - Load airports & forfaits from JSON
3. **User Check** - Are there users in database?
4. **Smart Routing**:
   - No users → RegisterScreen
   - User exists + no duties → WebviewScreen
   - User exists + duties → ImportRosterScreen

### UI
- Animated logo with fade-in effect (1200ms)
- Responsive sizing: iPhone 300x300, iPad 500x500
- Dark/Light theme support

---

## 📁 Folder 1_register (User Registration)

### Purpose
User registration, profile setup, and credential storage with encryption.

### Files
- **register_ctl.dart** - Controller with registration logic
- **register_screen.dart** - Registration form UI

### Key Flow
```
RegisterScreen (Form)
  ↓
User fills form:
  ├─ Matricule (pilot ID)
  ├─ Email
  ├─ Password
  ├─ PNT/PNC (pilot type)
  ├─ RAM/AMS (airline - if PNT)
  └─ Sector (if PNT)
  ↓
RegisterController.registerUser()
  ├─ Validate matricule (numeric)
  ├─ Check for existing user
  ├─ Create/Update UserModel
  ├─ Encrypt credentials
  ├─ Store in iOS Keychain
  └─ Save to ObjectBox
  ↓
Routes.toWebview() (Next screen)
```

### Controller Responsibilities
1. **Form Management** - TextEditingControllers for inputs
2. **Validation** - Matricule must be numeric
3. **Registration** - Create or update user
4. **Security** - Encrypt and store credentials
5. **Auto-fill** - Pre-populate form with existing user data

### Reactive Variables
- `secteur` - Flight sector (Moyen Courrier vs Long Courrier)
- `amsram` - Airline type (RAM vs AMS)
- `ispnt` - Pilot type (PNT vs PNC)
- `dones` - Button state (enabled vs loading)

### UI
- 7 form fields with validation
- Conditional fields (RAM/AMS and Sector only show if PNT)
- Loading state on button
- Responsive design: iPhone & iPad
- Dark/Light theme support

---

## 🔐 Security Features

### Credential Storage
- Passwords encrypted with `EncryptionHelper`
- Stored in iOS Keychain via `SecureStorageService`
- Email also encrypted and stored securely
- Cleared from memory after storage

### Email Formatting
- Auto-formatted to @royalairmaroc.com domain
- Example: "john" → "john@royalairmaroc.com"

### Validation
- Matricule must be numeric
- Email and password required
- Prevents duplicate matricules

---

## 📊 Data Models

### UserModel
```dart
UserModel {
  matricule: int,           // Pilot ID (required)
  email: String,            // Generated email
  isRam: bool?,             // Airline (only if PNT)
  isMoyenC: bool?,          // Sector (only if PNT)
  isPnt: bool               // Pilot type (true=PNC, false=PNT)
}
```

---

## 🎯 Constants & Keys

### GetStorage Keys
- `getDevice` - Stores device type (getIphone or getIpad)

### Secure Storage Keys
- `sPassword` - Encrypted password
- `sEmail` - Encrypted email

### String Constants (from constants.dart)
- `myMatricule` - Test matricule
- `myUser` - Test email
- `myPass` - Test password
- `mSecteur` - "Moyen Courrier"
- `lSecteur` - "Long Courrier"
- `ram` - "RAM"
- `ams` - "AMS"
- `pnt` - "PNT"
- `pnc` - "PNC"

---

## 🔄 Navigation Methods

### From AcceuilController
- `Routes.toRegister()` - Go to registration
- `Routes.toWebview()` - Go to webview
- `Routes.toImportRosterScreen()` - Go to import roster

### From RegisterController
- `Routes.toWebview()` - Go to webview after registration

---

## 📦 Key Dependencies

### State Management
- **GetX** - State management, routing, DI

### Storage
- **GetStorage** - Key-value storage
- **flutter_secure_storage** - iOS Keychain
- **ObjectBox** - Database

### Security
- **cryptography** - Password encryption

### UI
- **flutter_screenutil** - Responsive sizing
- **AppTheme** - Styling

### Custom Widgets
- `BackgroundContainer` - Background wrapper
- `MyTextFields` - Text input fields
- `MySwitch` - Toggle switches
- `MyButton` - Action buttons

---

## ✅ Testing Checklist

### AcceuilScreen
- [ ] Splash screen displays on app start
- [ ] Logo fades in smoothly (1200ms)
- [ ] Device type detected correctly (iPhone vs iPad)
- [ ] Responsive sizing correct on both devices
- [ ] Dark/Light theme works
- [ ] Navigation happens after routing logic

### RegisterScreen
- [ ] Form displays all 7 fields
- [ ] Matricule validation works (numeric only)
- [ ] Email and password required
- [ ] PNT/PNC switch visible always
- [ ] RAM/AMS switch visible only if PNT
- [ ] Sector switch visible only if PNT
- [ ] Form validation on submit
- [ ] Loading spinner shows during registration
- [ ] Credentials encrypted and stored
- [ ] Form auto-fills with existing user data
- [ ] Navigation to webview on success
- [ ] Responsive design on iPhone and iPad
- [ ] Dark/Light theme works

---

## 🚀 Next Steps

1. **Generate Code** - Use IAcode prompts to generate all 4 files
2. **Replace Files** - Replace old files with generated code
3. **Test** - Run on iPhone simulator
4. **Test iPad** - Run on iPad simulator
5. **Verify Flow** - Test entire navigation flow
6. **Debug** - Check console for any errors

---

## 📖 Documentation Files

- **REBUILD_0_ACCEUIL_1_REGISTER.md** - Detailed breakdown of each file
- **IACODE_PROMPTS.md** - Ready-to-use prompts for IAcode generation
- **QUICK_SUMMARY.md** - This file (quick reference)

---

## 💡 Pro Tips

1. **Test Device Detection** - Check GetStorage for device type after first run
2. **Test Encryption** - Verify credentials are encrypted in iOS Keychain
3. **Test Auto-fill** - Register a user, then check if form auto-fills on next visit
4. **Test Routing** - Verify correct screen appears based on database state
5. **Test Responsive** - Run on both iPhone and iPad simulators
6. **Check Logs** - Use Flutter console to debug any issues

---

## 🔗 Related Files (Dependencies)

### Models
- `UserModel` - User data structure
- `AeroportModel` - Airport data
- `ForfaitModel` - Forfait/package data

### Controllers
- `DatabaseController` - Database operations
- `EncryptionHelper` - Password encryption
- `SecureStorageService` - Secure storage

### Helpers
- `constants.dart` - Global constants
- `MyErrorInfo` - Error logging

### Theming
- `AppTheme` - Theme configuration
- `AppColors` - Color palette
- `AppStylingConstant` - Text styles

### Routes
- `app_routes.dart` - Route definitions
- `app_pages.dart` - Page bindings

### Widgets
- `BackgroundContainer` - Background wrapper
- `MyTextFields` - Text inputs
- `MySwitch` - Toggle switches
- `MyButton` - Action buttons

---

# 📊 MODEL: AeroportModel

## Location
`lib/Models/jsonModels/datas/airport_model.dart`

## Purpose
ObjectBox entity for storing airport data with ICAO/IATA codes, geographic coordinates, and metadata. Provides methods to load airports from JSON assets and fetch from external API.

## Properties
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

## Key Methods

### Constructors
- **`AeroportModel()`** - Standard constructor with all required fields
- **`fromJson(Map<String, dynamic>)`** - Parse from JSON (internal format)
- **`fromAeroportJson(Map<String, dynamic>)`** - Parse from external API format

### Data Conversion
- **`toJson()`** - Convert to JSON for storage/export
- **`copyWith()`** - Create modified copy with optional field overrides
- **`toString()`** - String representation for logging
- **`operator==()` & `hashCode`** - Equality based on ICAO + IATA codes

### Static Methods

**`fillAirportModelsIfEmpty()` (async)**
- Loads airports from JSON asset if database is empty
- Prevents duplicate ICAO/IATA codes
- Bulk inserts into ObjectBox
- Error handling per airport (skips invalid entries)
- Called from AcceuilController on app startup

**`fetchAirportIcao(String icao)` (async)**
- Fetches airport data from airportdb.io API
- Uses API token for authentication
- Returns single AeroportModel
- Throws exception on failure

**`fetchAirportIata(String iata)` (async)**
- Fetches airport data from airportdb.io API by IATA code
- Same as fetchAirportIcao but uses IATA instead

**`_findAirportInAssetByIcao(String icao)` (async, private)**
- Searches JSON asset for airport by ICAO code
- Case-insensitive matching
- Returns null if not found
- Used before making API calls

**`addAeroportFromFrorfait()` (async)**
- Extracts unique airport codes from forfaits
- Checks if airports exist in database
- Searches JSON asset first (faster)
- Falls back to API if not in asset
- Bulk updates database with new airports

## Data Flow

### App Startup
```
AcceuilController._performNavigation()
  ↓
AeroportModel.fillAirportModelsIfEmpty()
  ├─ Check if airports box is empty
  ├─ Load from JSON asset (pathAeroportJson)
  ├─ Remove duplicates by ICAO/IATA
  └─ Bulk insert into ObjectBox
```

### Forfait Processing
```
ForfaitModel.fillForfaitModelBoxIfEmpty()
  ↓
AeroportModel.addAeroportFromFrorfait()
  ├─ Extract unique ICAO codes from forfaits
  ├─ Check if airports exist
  ├─ Search JSON asset first
  ├─ Fetch from API if needed
  └─ Bulk update database
```

## Constants
- **API Token**: `a224d07081b781ad66de60659a9d0e8b7756e9b781d9b33e213cb1fc31d8d43bf3651ac525c6319d46fc9c7797a531b1`
- **API URL**: `https://airportdb.io/api/v1/airport/{code}?apiToken={token}`
- **JSON Asset**: `pathAeroportJson` (from constants.dart)

## Error Handling
- Try-catch wraps JSON parsing
- Logs errors via `MyErrorInfo.erreurInos()`
- Skips invalid entries (doesn't stop processing)
- API failures logged but don't block app

## Performance Considerations
- Deduplication using Set<String> for ICAO/IATA codes
- Bulk insert (not individual inserts)
- JSON asset search before API calls
- Lazy loading (only loads if database empty)

---

# 📦 MODEL: ForfaitModel

## Location
`lib/Models/jsonModels/datas/forfait_model.dart`

## Purpose
ObjectBox entity for storing flight forfait (package) data including route, season, sector, and duration. Provides methods to load from JSON assets and parse Excel files.

## Properties
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

## Key Methods

### Constructors
- **`ForfaitModel()`** - Standard constructor with all required fields
- **`fromJson(Map<String, dynamic>)`** - Parse from JSON asset
  - Converts "HH:MM" format to "XXhYY" format
  - Pads with zeros: "5h30" → "05h30"

### Data Conversion
- **`toJson()`** - Convert to JSON for storage/export
- **`copyWith()`** - Create modified copy with optional field overrides
- **`toString()`** - String representation for logging
- **`operator==()` & `hashCode`** - Equality based on cle + dateForfait

### Static Methods

**`fetchFromJson()` (async)**
- Loads all forfaits from JSON asset
- Parses each entry using `fromJson()`
- Returns List<ForfaitModel>
- Skips invalid entries with error logging
- Called from `fillForfaitModelBoxIfEmpty()`

**`fillForfaitModelBoxIfEmpty()` (async)**
- Checks if forfaits box is empty
- Loads from JSON via `fetchFromJson()`
- Converts to ForfaitListModel objects
- Bulk inserts into ObjectBox
- Triggers airport addition from forfaits
- Exports airports to JSON file
- Error handling with logging

**`parseExcel(Uint8List bytes)` (static)**
- Parses Excel file (.xlsx) with forfait data
- Extracts columns: Clé, Saison, Secteur, Escale_dep, Escale_arr, Forfait, Table
- Looks up IATA codes from airports database
- Constructs unique key if not in Excel
- Converts time format "HH:MM" → "XXhYY"
- Returns List<ForfaitModel>
- Error handling with logging

## Data Flow

### App Startup
```
AcceuilController._performNavigation()
  ↓
ForfaitModel.fillForfaitModelBoxIfEmpty()
  ├─ Check if forfaits box is empty
  ├─ Load from JSON asset (pathForfaitJson)
  ├─ Parse each entry
  ├─ Convert to ForfaitListModel
  ├─ Bulk insert into ObjectBox
  ├─ Trigger AeroportModel.addAeroportFromFrorfait()
  └─ Export airports to JSON
```

### Excel Import
```
User selects Excel file
  ↓
ForfaitModel.parseExcel(bytes)
  ├─ Decode Excel file
  ├─ Extract header row
  ├─ Parse each data row
  ├─ Look up IATA codes from airports
  ├─ Construct unique key
  ├─ Convert time format
  └─ Return List<ForfaitModel>
```

## Key Features
- **Unique Key Generation**: Combines season + sector + departure + arrival
- **Time Format Conversion**: "HH:MM" → "XXhYY" with zero padding
- **IATA Lookup**: Automatically finds IATA codes from ICAO codes
- **Excel Support**: Parses Excel files with flexible column mapping
- **Duplicate Prevention**: Equality based on cle + dateForfait

## Constants
- **JSON Asset**: `pathForfaitJson` (from constants.dart)
- **Time Format**: "XXhYY" (hours + "h" + minutes)
- **Date Format**: "dd/MM/yyyy"

## Error Handling
- Try-catch wraps JSON parsing
- Try-catch wraps Excel parsing
- Logs errors via `MyErrorInfo.erreurInos()`
- Skips invalid entries (doesn't stop processing)
- Returns empty list on complete failure

## Performance Considerations
- Bulk insert (not individual inserts)
- Lazy loading (only loads if database empty)
- Excel parsing with error recovery
- IATA lookup from cached airports

---

# 🚨 HELPER: MyErrorInfo

## Location
`lib/helpers/myerrorinfo.dart`

## Purpose
Centralized error logging and display utility. Shows user-friendly error messages via snackbars while logging to console for debugging.

## Class Structure
```dart
class MyErrorInfo {
  static SnackbarController erreurInos({
    required String label,
    required String content
  })
}
```

## Method: `erreurInos()`

### Parameters
- **`label`** (String) - Error title/heading
- **`content`** (String) - Detailed error message

### Returns
- **`SnackbarController`** - Can be used to control snackbar programmatically

### Behavior

**Console Output:**
```
label: {label}, content: {content}
======================================================
```

**UI Display (Snackbar):**
- **Icon**: Warning amber icon (white)
- **Position**: Top of screen
- **Background**: Red
- **Text Color**: White
- **Border Radius**: 20px
- **Margin**: 15px all sides
- **Duration**: 10 seconds
- **Dismissible**: Yes (swipe down to dismiss)
- **Animation**: Ease out back curve

### Usage Examples

```dart
// Basic error logging
MyErrorInfo.erreurInos(
  label: 'Database Error',
  content: 'Failed to load users from database'
);

// API error
MyErrorInfo.erreurInos(
  label: 'Network Error',
  content: 'Failed to fetch airport data: Connection timeout'
);

// Validation error
MyErrorInfo.erreurInos(
  label: 'Invalid Input',
  content: 'Matricule must be numeric'
);

// File parsing error
MyErrorInfo.erreurInos(
  label: 'Parse Error',
  content: 'Error parsing airport: Invalid JSON format'
);
```

## Used Throughout Project

### In AeroportModel
```dart
MyErrorInfo.erreurInos(
  label: 'AeroportModel.fillAirportsIfEmpty',
  content: 'Error parsing airport: $e',
);
```

### In ForfaitModel
```dart
MyErrorInfo.erreurInos(
  label: 'ForfaitModel.fillForfaitModelBoxIfEmpty',
  content: 'Error parsing forfait: $e',
);
```

### In Controllers
```dart
MyErrorInfo.erreurInos(
  label: 'AcceuilController._performNavigation',
  content: 'Error during navigation: $e',
);
```

## Snackbar Features
- **Non-blocking**: Doesn't interrupt user workflow
- **Visible**: Appears at top of screen
- **Persistent**: 10-second duration (long enough to read)
- **Dismissible**: User can swipe down to close
- **Styled**: Red background with white text for error visibility
- **Animated**: Smooth entrance animation

## Best Practices

### ✅ Good Usage
```dart
// Specific, actionable error messages
MyErrorInfo.erreurInos(
  label: 'Registration Failed',
  content: 'Email already registered with another account'
);

// Include context in error
MyErrorInfo.erreurInos(
  label: 'PDF Import Error',
  content: 'Failed to parse PDF: Missing required fields'
);
```

### ❌ Avoid
```dart
// Too vague
MyErrorInfo.erreurInos(
  label: 'Error',
  content: 'Something went wrong'
);

// No context
MyErrorInfo.erreurInos(
  label: 'Exception',
  content: '$e'
);
```

## Integration Points
- Used in all model loading methods
- Used in all API calls
- Used in form validation
- Used in file parsing
- Used in database operations
- Used in navigation logic

## Customization Options
To modify snackbar appearance, edit these properties in `erreurInos()`:
- `icon` - Change warning icon
- `backgroundColor` - Change color (currently red)
- `duration` - Change display time
- `snackPosition` - Change position (TOP, BOTTOM, etc.)
- `borderRadius` - Change corner radius
- `forwardAnimationCurve` - Change animation style
