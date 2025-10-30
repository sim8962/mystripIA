# 🎨 UI DESCRIPTION (Screens & Widgets)

Complete breakdown of all UI screens and widgets used in the application.

---

## 🎬 SCREEN: AcceuilScreen (Splash Screen)

### Location
`lib/views/0_acceuil/acceuil_screen.dart`

### Purpose
Simple splash screen UI that displays an animated logo during app startup and initialization.

### Controller
```dart
extends GetView<AcceuilController>
```

### Constructor
```dart
const AcceuilScreen({super.key});
```

### Build Method Structure

**GetBuilder Wrapper:**
- Wraps entire screen for controller initialization
- initState callback:
  - Checks if device type is stored in GetStorage
  - If not: Calls AcceuilController.instance.getMyIdevice()
  - Calls AcceuilController.instance.checkUsersAndNavigate()

**UI Hierarchy:**
```
BackgroundContainer
  └─ Obx (reactive wrapper)
      └─ AnimatedOpacity
          └─ Center
              └─ Container (circular)
                  └─ CircleAvatar (logo)
```

### UI Components

**BackgroundContainer:**
- Theme-aware background wrapper
- Provides consistent background across app

**AnimatedOpacity:**
- Controls splash fade-in animation
- opacity: AcceuilController.instance.isVisibleAcceuil ? 1.0 : 0
- duration: 1200ms (1.2 seconds)
- Smooth entrance animation

**Container (Circular):**
- Responsive sizing:
  - iPhone: 300x300 px
  - iPad: 500x500 px
- Circular shape: BoxShape.circle
- White background color
- BoxShadow:
  - color: Colors.black.withValues()
  - blurRadius: 2.0
  - offset: Offset(5.0, 3.0)
  - spreadRadius: 2.0

**CircleAvatar (Logo):**
- backgroundImage: AssetImage
  - Dark theme: urlImage1
  - Light theme: urlImage2
  - Check AppTheme.isDark
- radius: AppTheme.getRadius(iphoneSize: 190, ipadsize: 500)

### Responsive Sizing
- Uses `AppTheme.getRadius()` for responsive dimensions
- iPhone: 300x300 container, 190px avatar
- iPad: 500x500 container, 500px avatar

### Theme Support
- Dark theme: Uses urlImage1
- Light theme: Uses urlImage2
- Responsive based on AppTheme.isDark

### Lifecycle
1. `initState` - Detects device type, calls checkUsersAndNavigate()
2. `build` - Renders animated logo
3. Auto-navigates after routing logic completes

### Imports
```dart
package:flutter/material.dart
package:get/get.dart
../../helpers/constants.dart
../../theming/app_theme.dart
../widgets/background_container.dart
acceuil_ctl.dart
```

---

## 📋 SCREEN: RegisterScreen (Registration Form)

### Location
`lib/views/1_register/register_screen.dart`

### Purpose
Registration form UI with conditional fields based on pilot type selection. Allows users to create/update their account.

### Controller
```dart
extends GetView<RegisterController>
```

### Constructor
```dart
RegisterScreen({super.key});
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
```

### Build Method Structure

**GetBuilder Wrapper:**
- Wraps entire screen for controller initialization
- initState callback (can be empty)

**BackgroundContainer:**
- Theme-aware background wrapper
- Padding: AppTheme.getheight(iphoneSize: 24, ipadsize: 24)

**Column (Main Layout):**
- mainAxisAlignment: spaceEvenly
- Two sections: Header + Form

### UI Layout

**Header Section:**
```
Icon (Flight Takeoff)
  ├─ Icons.flight_takeoff
  ├─ Size: AppTheme.getheight(iphoneSize: 90, ipadsize: 120)
  └─ Color: Colors.white
  
SizedBox (height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15))

Text (Title)
  ├─ 'register_title'.tr
  └─ Style: AppStylingConstant.registerScreen
  
SizedBox (height: AppTheme.getheight(iphoneSize: 20, ipadsize: 15))
```

**Form Section (Expanded):**
```
Form (with _formKey)
  └─ Column (mainAxisAlignment: spaceEvenly)
      ├─ 1. Matricule TextInput
      ├─ 2. Email TextInput
      ├─ 3. Password TextInput
      ├─ 4. PNT/PNC Switch (always visible)
      ├─ 5. RAM/AMS Switch (conditional)
      ├─ 6. Sector Switch (conditional)
      └─ 7. Register Button (with loading state)
```

### Form Fields

**1. Matricule TextInput:**
- Controller: RegisterController.instance.matController
- Label: 'matricule_label'.tr
- Icon: Icons.person_outline
- Keyboard: TextInputType.text
- Validator: Check if empty, return 'matricule_error'.tr

**2. Email TextInput:**
- Controller: RegisterController.instance.emailController
- Label: 'email_label'.tr
- Icon: Icons.email_outlined
- Keyboard: TextInputType.text
- Validator: Check if empty, return 'email_error'.tr

**3. Password TextInput:**
- Controller: RegisterController.instance.passController
- Label: 'password_label'.tr
- Icon: Icons.lock_outline
- Keyboard: TextInputType.text
- obscureText: false
- Validator: Check if empty, return 'password_error'.tr

**4. PNT/PNC Switch (Always Visible):**
- Wrap in Obx()
- Use MySwitch widget:
  - width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180)
  - height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60)
  - labeltext: 'switch_pnt_pnc'.tr
  - smalllabeltext: RegisterController.instance.spntpnc
  - ichoice: 5

**5. RAM/AMS Switch (Visible Only if PNT):**
- Wrap in Obx()
- Wrap in Visibility with visible: !RegisterController.instance.ispnt
- Use MySwitch widget:
  - width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180)
  - height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60)
  - labeltext: 'switch_ram_ams'.tr
  - smalllabeltext: RegisterController.instance.samsram
  - ichoice: 1

**6. Sector Switch (Visible Only if PNT):**
- Wrap in Obx()
- Wrap in Visibility with visible: !RegisterController.instance.ispnt
- Use MySwitch widget:
  - width: AppTheme.getWidth(iphoneSize: deviceWidth, ipadsize: 180)
  - height: AppTheme.getheight(iphoneSize: 60, ipadsize: 60)
  - labeltext: 'switch_secteur'.tr
  - smalllabeltext: RegisterController.instance.sSecteur
  - ichoice: 2

**7. Register Button (with Loading State):**
- Wrap in Obx()
- If RegisterController.instance.dones == true:
  - Show MyButton:
    - width: 170
    - label: 'button_register'.tr
    - func: () async {
        if (_formKey.currentState!.validate()) {
          RegisterController.instance.registerUser();
          Routes.toWebview();
        }
      }
- Else:
  - Show CircularProgressIndicator:
    - color: AppColors.primaryLightColor
    - strokeWidth: 7

### Responsive Design
- Uses `AppTheme.getWidth()` and `AppTheme.getheight()`
- iPhone: Padding 24px, full-width switches
- iPad: Padding 24px, 180px switches
- Switch height: 60px (both devices)

### Theme Support
- Dark/Light theme aware
- Uses AppColors for theming
- BackgroundContainer for background

### Form Validation
- Uses GlobalKey<FormState> for form validation
- Validates on button click
- Shows error snackbar if matricule invalid

### Navigation
- On success → Routes.toWebview()

### Imports
```dart
package:flutter/material.dart
package:get/get.dart
../../helpers/constants.dart
../../routes/app_routes.dart
../../theming/app_color.dart
../../theming/app_theme.dart
../../theming/apptheme_constant.dart
../widgets/background_container.dart
../widgets/mybutton.dart
../widgets/myswitch.dart
../widgets/mytextfields.dart
register_ctl.dart
```

---

## 🧩 CUSTOM WIDGETS

### BackgroundContainer
- **Purpose**: Theme-aware background wrapper
- **Usage**: Wraps entire screen for consistent background
- **Features**: Supports dark/light theme

### MyTextFields
- **Purpose**: Custom text input field
- **Features**: 
  - Icon support
  - Label support
  - Validation support
  - Keyboard type selection
  - Responsive sizing

### MySwitch
- **Purpose**: Custom toggle switch
- **Features**:
  - Label support
  - Small label (formatted value)
  - ichoice parameter for styling
  - Reactive state management
  - Responsive sizing

### MyButton
- **Purpose**: Custom action button
- **Features**:
  - Label support
  - Callback function
  - Width customization
  - Responsive sizing
  - Loading state support

---

## 🎨 THEMING

### AppTheme
- **Purpose**: Centralized theme configuration
- **Methods**:
  - `getWidth()` - Responsive width calculation
  - `getheight()` - Responsive height calculation
  - `getRadius()` - Responsive radius calculation
  - `isDark` - Current theme mode

### AppColors
- **Purpose**: Color palette
- **Key Colors**:
  - `primaryLightColor` - Primary color for light theme
  - `primaryDarkColor` - Primary color for dark theme
  - Background colors
  - Text colors

### AppStylingConstant
- **Purpose**: Text styles
- **Key Styles**:
  - `registerScreen` - Register screen title style
  - `webScreen` - Webview status text style
  - Other text styles for consistency

---

## 🌐 SCREEN: Webviewscreen (2_webview)

### Location
`lib/views/2_webview/webview_screen.dart`

### Purpose
Displays webview for authentication and roster data download, with status messages and action buttons.

### Controller
```dart
extends GetView<WebViewEcreenController>
```

### Constructor
```dart
const Webviewscreen({super.key});
```

### Build Method Structure

**GetBuilder Wrapper:**
- Wraps entire screen for controller initialization
- initState callback (empty)

**BackgroundContainer:**
- Theme-aware background wrapper
- Padding: AppTheme.getheight(iphoneSize: 10, ipadsize: 10)

**Obx (Reactive):**
- Monitors getConnexion status
- Shows webview if connected
- Shows status container if no connection

### UI Layout

**Main Column (if connected):**
```
Column (mainAxisAlignment: spaceAround)
  ├─ _buildWebViewContainer()
  └─ _buildButtonRow()
```

**WebView Container:**
- Height: iPhone 580px, iPad 560px
- Shows WebViewWidget if visibleWeb = true
- Shows status container if visibleWeb = false
- Obx wrapper for reactive updates

**Status Container:**
- Displays current step message (sEtape)
- Styled with theme colors
- Rounded corners with border
- Centered text

**Button Row:**
- mainAxisAlignment: spaceEvenly
- Shows either:
  - Action buttons (if visibleenregistre = true)
  - Progress indicator + home button (if visibleenregistre = false)

### Action Buttons

**Reset Button:**
- Width: iPhone 100px, iPad 150px
- Label: 'button_reset'.tr
- Function: Calls controller.webReset()

**Save Button:**
- Width: iPhone 160px, iPad 250px
- Label: 'button_save'.tr
- Function: Calls controller.enregistrerMjsonString()
  - On success: Routes.toHome()
  - On error: Shows error snackbar

**Home Button (during processing):**
- Width: iPhone 160px, iPad 250px
- Label: 'button_to_home'.tr
- Function: Routes.toHome()

**Progress Indicator (during processing):**
- Color: AppColors.primaryLightColor
- StrokeWidth: 7

### Responsive Design
- Uses `AppTheme.getheight()` and `AppTheme.getWidth()`
- iPhone: Smaller dimensions
- iPad: Larger dimensions
- Adaptive padding and spacing

### Theme Support
- Dark/Light theme aware
- Uses AppColors for theming
- BackgroundContainer for background

### Reactive States
- **getConnexion**: Shows/hides webview based on internet
- **visibleWeb**: Shows/hides webview during processing
- **visibleenregistre**: Shows/hides save buttons

### Imports
```dart
package:flutter/material.dart
package:get/get.dart
package:webview_flutter/webview_flutter.dart
../../helpers/myerrorinfo.dart
../../routes/app_routes.dart
../../theming/app_color.dart
../../theming/app_theme.dart
../../theming/apptheme_constant.dart
../widgets/background_container.dart
../widgets/mybutton.dart
webview_ctl.dart
```

### Navigation
- On save success → Routes.toHome()
- On home button → Routes.toHome()

---

## 📥 SCREEN: ImportRosterScreen (7_importRoster)

### Location
`lib/views/7_importRoster/importroster_screen.dart`

### Purpose
Multi-step screen for PDF roster import, processing, and monthly data display.

### Controller
```dart
extends GetView<ImportrosterCtl>
```

### Constructor
```dart
const ImportRosterScreen({super.key});
```

### Build Method Structure

**Scaffold:**
- BackgroundContainer wrapper
- SingleChildScrollView for scrolling
- Padding with responsive values
- Obx wrapper monitoring etape

### Three-Step Workflow

**Step 0: File Selection**
- Instructions text
- Import PDF button
- Calls _handleFileSelection()

**Step 1: PDF Processing (StreamBuilder)**
- Stream: controller.getStreamPlatformFile()
- Displays months as they're extracted
- Shows progress for each file
- Loading state with spinner
- Error state with message

**Step 2: Monthly Data Display (StreamBuilder)**
- Stream: controller.getStreamVolTraiteMoisModels()
- Displays months progressively
- Shows monthly statistics
- Lists flights for each month
- Loading state during processing
- Error state handling

### UI Components

**Step 1 Content:**
- List of extracted months
- Progress indicators
- File processing status
- "Process Data" button

**Step 2 Content:**
- Month headers with statistics
- Flight cards (FlightCard, HtlCard, DutyCard)
- Monthly cumuls display
- "Save" button

### Responsive Design
- Uses AppTheme for all dimensions
- Adaptive padding and spacing
- iPhone/iPad support
- Horizontal scroll for cards

### Theme Support
- Dark/Light theme aware
- Uses AppColors for theming
- BackgroundContainer for background

### Reactive States
- **etape**: Controls which step is displayed (0, 1, 2)
- **loading**: Shows/hides loading indicators
- **Stream states**: Waiting, active, done, error

### Imports
```dart
package:flutter/material.dart
package:get/get.dart
../../Models/VolsModels/vol_traite_mois.dart
../../Models/volpdfs/chechplatform.dart
../../theming/app_color.dart
../../theming/app_theme.dart
../widgets/background_container.dart
../widgets/mybutton.dart
../widgets/mylistfile_widget.dart
../widgets/mytext.dart
importroster_ctl.dart
```

### Navigation Flow
```
Step 0: Select PDFs
  ↓
Step 1: Process PDFs (Stream)
  ├─ Extract volumes
  ├─ Extract months
  └─ Display ChechPlatFormMonth
  ↓
Step 2: Convert Data (Stream)
  ├─ Convert to VolModel
  ├─ Convert to VolTraiteModel
  ├─ Group by month
  └─ Display VolTraiteMoisModel
  ↓
Save to Database
  ↓
Routes.toHome()
```

